Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaL2PAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:00:31 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:40808 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaL2PA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:00:27 -0500
From: Joe Howse <josephhowse@nummist.com>
To: Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Howse <josephhowse@nummist.com>
Subject: [PATCH 1/1] gspca: Add high-speed modes for PS3 Eye camera
Date: Mon, 29 Dec 2014 11:00:03 -0400
Message-Id: <1419865203-3967-1-git-send-email-josephhowse@nummist.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support in the PS3 Eye driver for QVGA capture at higher
frame rates: 187, 150, and 137 FPS. This functionality is valuable
because the PS3 Eye is popular for computer vision projects and no
other camera in its price range supports such high frame rates.

Correct a QVGA mode that was listed as 40 FPS. It is really 37 FPS
(half of 75 FPS).

Tests confirm that the nominal frame rates are achieved.

Signed-off-by: Joe Howse <josephhowse@nummist.com>
---
 drivers/media/usb/gspca/ov534.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 90f0d63..a9c866d 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -12,6 +12,8 @@
  * PS3 Eye camera enhanced by Richard Kaswy http://kaswy.free.fr
  * PS3 Eye camera - brightness, contrast, awb, agc, aec controls
  *                  added by Max Thrun <bear24rw@gmail.com>
+ * PS3 Eye camera - FPS range extended by Joseph Howse
+ *                  <josephhowse@nummist.com> http://nummist.com
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -116,7 +118,7 @@ static const struct v4l2_pix_format ov767x_mode[] = {
 		.colorspace = V4L2_COLORSPACE_JPEG},
 };
 
-static const u8 qvga_rates[] = {125, 100, 75, 60, 50, 40, 30};
+static const u8 qvga_rates[] = {187, 150, 137, 125, 100, 75, 60, 50, 37, 30};
 static const u8 vga_rates[] = {60, 50, 40, 30, 15};
 
 static const struct framerates ov772x_framerates[] = {
@@ -769,12 +771,16 @@ static void set_frame_rate(struct gspca_dev *gspca_dev)
 		{15, 0x03, 0x41, 0x04},
 	};
 	static const struct rate_s rate_1[] = {	/* 320x240 */
+/*		{205, 0x01, 0xc1, 0x02},  * 205 FPS: video is partly corrupt */
+		{187, 0x01, 0x81, 0x02}, /* 187 FPS or below: video is valid */
+		{150, 0x01, 0xc1, 0x04},
+		{137, 0x02, 0xc1, 0x02},
 		{125, 0x02, 0x81, 0x02},
 		{100, 0x02, 0xc1, 0x04},
 		{75, 0x03, 0xc1, 0x04},
 		{60, 0x04, 0xc1, 0x04},
 		{50, 0x02, 0x41, 0x04},
-		{40, 0x03, 0x41, 0x04},
+		{37, 0x03, 0x41, 0x04},
 		{30, 0x04, 0x41, 0x04},
 	};
 
-- 
1.9.1

