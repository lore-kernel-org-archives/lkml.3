Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaDRRug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:50:36 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63461 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaDRRue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:50:34 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6nlaub?= <manuel.schoenlaub@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Manuel=20Sch=C3=B6nlaub?= <manuel.schoenlaub@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] az6027: Added the PID for a new revision of the Elgato EyeTV Sat DVB-S Tuner.
Date: Fri, 18 Apr 2014 19:43:35 +0200
Message-Id: <1397843015-15848-1-git-send-email-manuel.schoenlaub@gmail.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is another clone of AZ6027. This patch adds the relevant PID.

Signed-off-by: Manuel Schönlaub <manuel.schoenlaub@gmail.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h | 1 +
 drivers/media/usb/dvb-usb/az6027.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 1bdc0e7..a2530fe 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -356,6 +356,7 @@
 #define USB_PID_ELGATO_EYETV_DTT_2			0x003f
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
 #define USB_PID_ELGATO_EYETV_SAT			0x002a
+#define USB_PID_ELGATO_EYETV_SAT_V2			0x0025
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
 #define USB_PID_FRIIO_WHITE				0x0001
diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index c11138e..0df52ab 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -1088,6 +1088,7 @@ static struct usb_device_id az6027_usb_table[] = {
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V1) },
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
 	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT) },
+	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT_V2) },
 	{ },
 };
 
@@ -1136,7 +1137,7 @@ static struct dvb_usb_device_properties az6027_properties = {
 
 	.i2c_algo         = &az6027_i2c_algo,
 
-	.num_device_descs = 6,
+	.num_device_descs = 7,
 	.devices = {
 		{
 			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
@@ -1162,6 +1163,10 @@ static struct dvb_usb_device_properties az6027_properties = {
 			.name = "Elgato EyeTV Sat",
 			.cold_ids = { &az6027_usb_table[5], NULL },
 			.warm_ids = { NULL },
+		}, {
+			.name = "Elgato EyeTV Sat",
+			.cold_ids = { &az6027_usb_table[6], NULL },
+			.warm_ids = { NULL },
 		},
 		{ NULL },
 	}
-- 
1.9.2

