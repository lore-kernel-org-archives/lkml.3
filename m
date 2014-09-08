Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaIHPEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:04:35 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:51765 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaIHPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:04:34 -0400
From: Morgan Phillips <winter2718@gmail.com>
To: brijohn@gmail.com
Cc: hdegoede@redhat.com, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Morgan Phillips <winter2718@gmail.com>
Subject: [PATCH v2] [media]: sn9c20x: centralize repeated error/info messages with macros
Date: Mon,  8 Sep 2014 10:01:36 -0500
Message-Id: <1410188496-6689-1-git-send-email-winter2718@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410183549-4966-1-git-send-email-winter2718@gmail.com>
References: <1410183549-4966-1-git-send-email-winter2718@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create inline functions to print info/error messages: "sensor detected"
and "sensor initialization failed" which are used identically in many
places.  This makes it easier to change the message formats en masse and
frees up some memory by centralizing repeated strings.

Signed-off-by: Morgan Phillips <winter2718@gmail.com>
---
 Changes since v2:
    * Fixed checkpatch.pl errors introduced from tabs being converted to spaces.

 drivers/media/usb/gspca/sn9c20x.c | 60 ++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 41a9a89..339f7b0 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -65,6 +65,14 @@ MODULE_LICENSE("GPL");
 #define LED_REVERSE	0x2 /* some cameras unset gpio to turn on leds */
 #define FLIP_DETECT	0x4
 
+/* info messages */
+#define pr_sensor_detected_info(sensor_name)\
+		pr_info("%s sensor detected\n", sensor_name)
+
+/* error messages */
+#define pr_sensor_init_err(sensor_name)\
+		pr_err("%s sensor initialization failed\n", sensor_name)
+
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;
@@ -1098,7 +1106,7 @@ static void ov9650_init_sensor(struct gspca_dev *gspca_dev)
 	msleep(200);
 	i2c_w1_buf(gspca_dev, ov9650_init, ARRAY_SIZE(ov9650_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("OV9650 sensor initialization failed\n");
+		pr_sensor_init_err("OV9650");
 	sd->hstart = 1;
 	sd->vstart = 7;
 }
@@ -1111,7 +1119,7 @@ static void ov9655_init_sensor(struct gspca_dev *gspca_dev)
 	msleep(200);
 	i2c_w1_buf(gspca_dev, ov9655_init, ARRAY_SIZE(ov9655_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("OV9655 sensor initialization failed\n");
+		pr_sensor_init_err("OV9655");
 
 	sd->hstart = 1;
 	sd->vstart = 2;
@@ -1125,7 +1133,7 @@ static void soi968_init_sensor(struct gspca_dev *gspca_dev)
 	msleep(200);
 	i2c_w1_buf(gspca_dev, soi968_init, ARRAY_SIZE(soi968_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("SOI968 sensor initialization failed\n");
+		pr_sensor_init_err("SOI968");
 
 	sd->hstart = 60;
 	sd->vstart = 11;
@@ -1139,7 +1147,7 @@ static void ov7660_init_sensor(struct gspca_dev *gspca_dev)
 	msleep(200);
 	i2c_w1_buf(gspca_dev, ov7660_init, ARRAY_SIZE(ov7660_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("OV7660 sensor initialization failed\n");
+		pr_sensor_init_err("OV7660");
 	sd->hstart = 3;
 	sd->vstart = 3;
 }
@@ -1152,7 +1160,7 @@ static void ov7670_init_sensor(struct gspca_dev *gspca_dev)
 	msleep(200);
 	i2c_w1_buf(gspca_dev, ov7670_init, ARRAY_SIZE(ov7670_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("OV7670 sensor initialization failed\n");
+		pr_sensor_init_err("OV7670");
 
 	sd->hstart = 0;
 	sd->vstart = 1;
@@ -1169,13 +1177,13 @@ static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 	 && value == 0x8243) {
 		i2c_w2_buf(gspca_dev, mt9v011_init, ARRAY_SIZE(mt9v011_init));
 		if (gspca_dev->usb_err < 0) {
-			pr_err("MT9V011 sensor initialization failed\n");
+			pr_sensor_init_err("MT9V011");
 			return;
 		}
 		sd->hstart = 2;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V011;
-		pr_info("MT9V011 sensor detected\n");
+		pr_sensor_detected_info("MT9V011");
 		return;
 	}
 
@@ -1187,13 +1195,13 @@ static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 	 && value == 0x823a) {
 		i2c_w2_buf(gspca_dev, mt9v111_init, ARRAY_SIZE(mt9v111_init));
 		if (gspca_dev->usb_err < 0) {
-			pr_err("MT9V111 sensor initialization failed\n");
+			pr_sensor_init_err("MT9V111");
 			return;
 		}
 		sd->hstart = 2;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V111;
-		pr_info("MT9V111 sensor detected\n");
+		pr_sensor_detected_info("MT9V111");
 		return;
 	}
 
@@ -1210,13 +1218,13 @@ static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 	 && value == 0x1229) {
 		i2c_w2_buf(gspca_dev, mt9v112_init, ARRAY_SIZE(mt9v112_init));
 		if (gspca_dev->usb_err < 0) {
-			pr_err("MT9V112 sensor initialization failed\n");
+			pr_sensor_init_err("MT9V112");
 			return;
 		}
 		sd->hstart = 6;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V112;
-		pr_info("MT9V112 sensor detected\n");
+		pr_sensor_detected_info("MT9V112");
 		return;
 	}
 
@@ -1229,7 +1237,7 @@ static void mt9m112_init_sensor(struct gspca_dev *gspca_dev)
 
 	i2c_w2_buf(gspca_dev, mt9m112_init, ARRAY_SIZE(mt9m112_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("MT9M112 sensor initialization failed\n");
+		pr_sensor_init_err("MT9M112");
 
 	sd->hstart = 0;
 	sd->vstart = 2;
@@ -1241,7 +1249,7 @@ static void mt9m111_init_sensor(struct gspca_dev *gspca_dev)
 
 	i2c_w2_buf(gspca_dev, mt9m111_init, ARRAY_SIZE(mt9m111_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("MT9M111 sensor initialization failed\n");
+		pr_sensor_init_err("MT9M111");
 
 	sd->hstart = 0;
 	sd->vstart = 2;
@@ -1260,10 +1268,10 @@ static void mt9m001_init_sensor(struct gspca_dev *gspca_dev)
 	switch (id) {
 	case 0x8411:
 	case 0x8421:
-		pr_info("MT9M001 color sensor detected\n");
+		pr_sensor_detected_info("MT9M001 color");
 		break;
 	case 0x8431:
-		pr_info("MT9M001 mono sensor detected\n");
+		pr_sensor_detected_info("MT9M001 mono");
 		break;
 	default:
 		pr_err("No MT9M001 chip detected, ID = %x\n\n", id);
@@ -1273,7 +1281,7 @@ static void mt9m001_init_sensor(struct gspca_dev *gspca_dev)
 
 	i2c_w2_buf(gspca_dev, mt9m001_init, ARRAY_SIZE(mt9m001_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("MT9M001 sensor initialization failed\n");
+		pr_sensor_init_err("MT9M001");
 
 	sd->hstart = 1;
 	sd->vstart = 1;
@@ -1285,7 +1293,7 @@ static void hv7131r_init_sensor(struct gspca_dev *gspca_dev)
 
 	i2c_w1_buf(gspca_dev, hv7131r_init, ARRAY_SIZE(hv7131r_init));
 	if (gspca_dev->usb_err < 0)
-		pr_err("HV7131R Sensor initialization failed\n");
+		pr_sensor_init_err("HV7131R");
 
 	sd->hstart = 0;
 	sd->vstart = 1;
@@ -1815,49 +1823,49 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		ov9650_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV9650 sensor detected\n");
+		pr_sensor_detected_info("OV9650");
 		break;
 	case SENSOR_OV9655:
 		ov9655_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV9655 sensor detected\n");
+		pr_sensor_detected_info("OV9655");
 		break;
 	case SENSOR_SOI968:
 		soi968_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("SOI968 sensor detected\n");
+		pr_sensor_detected_info("SOI968");
 		break;
 	case SENSOR_OV7660:
 		ov7660_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV7660 sensor detected\n");
+		pr_sensor_detected_info("OV7660");
 		break;
 	case SENSOR_OV7670:
 		ov7670_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("OV7670 sensor detected\n");
+		pr_sensor_detected_info("OV7670");
 		break;
 	case SENSOR_MT9VPRB:
 		mt9v_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("MT9VPRB sensor detected\n");
+		pr_sensor_detected_info("MT9VPRB");
 		break;
 	case SENSOR_MT9M111:
 		mt9m111_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("MT9M111 sensor detected\n");
+		pr_sensor_detected_info("MT9M111");
 		break;
 	case SENSOR_MT9M112:
 		mt9m112_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("MT9M112 sensor detected\n");
+		pr_sensor_detected_info("MT9M112");
 		break;
 	case SENSOR_MT9M001:
 		mt9m001_init_sensor(gspca_dev);
@@ -1868,7 +1876,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		hv7131r_init_sensor(gspca_dev);
 		if (gspca_dev->usb_err < 0)
 			break;
-		pr_info("HV7131R sensor detected\n");
+		pr_sensor_detected_info("HV7131R");
 		break;
 	default:
 		pr_err("Unsupported sensor\n");
-- 
1.9.1

