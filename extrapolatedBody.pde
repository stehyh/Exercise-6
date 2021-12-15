import gab.opencv.*;
import processing.video.*;
import java.awt.*;

PImage glaases;
Capture video;
OpenCV opencv;
Boolean eyeWidthSet = false;
int glassNum = 1;
int glassWidth;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2, "pipeline:autovideosrc");
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_EYE);  
  
  video.start();
  
  while (!eyeWidthSet) {
    opencv.loadImage(video);
    Rectangle[] eyes = opencv.detect();
    if (eyes.length == 2 ) {
      //println(eyes);
      int eyeWidth = eyes[1].x - eyes[0].x + eyes[1].width;
      if (eyeWidth > 0){
        glassWidth = eyeWidth+20;
        glaases = loadImage(String.format("g%d.png",glassNum));
        glaases.resize(glassWidth, 0);
        eyeWidthSet = true;
      }
    }
  }
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  image(video, 0, 0 );
  Rectangle[] eyes = opencv.detect();
  
  if (eyes.length == 2 ) {
     image(glaases, eyes[0].x-10, eyes[0].y-25);
  }
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  switch(keyCode) {
    case UP:
      glassNum += 1;
      if (glassNum == 7) { glassNum = 1; };
      glaases = loadImage(String.format("g%d.png",glassNum));
      glaases.resize(glassWidth, 0);
      break;
    case DOWN:
      glassNum -= 1;
      if (glassNum == 0) { glassNum = 6; };
      glaases = loadImage(String.format("g%d.png",glassNum));
      glaases.resize(glassWidth, 0);
      break;
  }
}
