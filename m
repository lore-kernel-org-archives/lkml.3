Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3GTSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 14:25:27 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42051 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3GTSZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 14:25:25 -0400
Message-ID: <1374344603.1192.12.camel@laptop>
Subject: [PATCH] dvb-usb: add another product id for "Elgato EyeTV SAT"
From: Manuel =?ISO-8859-1?Q?Sch=F6nlaub?= <manuel.schoenlaub@gmail.com>
Reply-To: manuel.schoenlaub@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Date: Sat, 20 Jul 2013 20:23:23 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schönlaub <manuel.schoenlaub@gmail.com>

There is another revision of "Elgato EyeTV SAT" working with this driver
but using a previously unknown product id.

Signed-off-by: Manuel Schönlaub <manuel.schoenlaub@gmail.com>
---
drivers/media/dvb-core/dvb-usb-ids.h |    1 +
drivers/media/usb/dvb-usb/az6027.c   |    7 ++++++-
2 files changed, 7 insertions(+), 1 deletion(-)

diff -upNr linux-3.10/drivers/media/dvb-core/dvb-usb-ids.h
linux-3.10-patched/drivers/media/dvb-core/dvb-usb-ids.h
--- linux-3.10/drivers/media/dvb-core/dvb-usb-ids.h	2013-07-01
00:13:29.000000000 +0200
+++ linux-3.10-patched/drivers/media/dvb-core/dvb-usb-ids.h	2013-07-20
18:01:23.573035824 +0200
@@ -353,6 +353,7 @@
 #define USB_PID_ELGATO_EYETV_DTT_2			0x003f
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
 #define USB_PID_ELGATO_EYETV_SAT			0x002a
+#define USB_PID_ELGATO_EYETV_SAT_CI			0x0025
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
 #define USB_PID_FRIIO_WHITE				0x0001
diff -upNr linux-3.10/drivers/media/usb/dvb-usb/az6027.c
linux-3.10-patched/drivers/media/usb/dvb-usb/az6027.c
--- linux-3.10/drivers/media/usb/dvb-usb/az6027.c	2013-07-01
00:13:29.000000000 +0200
+++ linux-3.10-patched/drivers/media/usb/dvb-usb/az6027.c	2013-07-20
18:31:47.622924602 +0200
@@ -1088,6 +1088,7 @@ static struct usb_device_id az6027_usb_t
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V1) },
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
 	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT) },
+	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT_CI) },
 	{ },
 };
 
@@ -1136,7 +1137,7 @@ static struct dvb_usb_device_properties
 
 	.i2c_algo         = &az6027_i2c_algo,
 
-	.num_device_descs = 6,
+	.num_device_descs = 7,
 	.devices = {
 		{
 			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
@@ -1162,6 +1163,10 @@ static struct dvb_usb_device_properties
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

