Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab3CGNgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:36:52 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:63519 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab3CGNgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:36:48 -0500
From: Andrey Pavlenko <andrey.a.pavlenko@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andrey Pavlenko <andrey.a.pavlenko@gmail.com>
Subject: [PATCH 1/1] [dvb-usb] GOTVIEW SatelliteHD card support.
Date: Thu,  7 Mar 2013 17:36:22 +0400
Message-Id: <1362663382-8094-1-git-send-email-andrey.a.pavlenko@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for the GOTVIEW SatelliteHD card which is based on
Montage M88DS3000 and works very well with this driver.

Signed-off-by: Andrey Pavlenko <andrey.a.pavlenko@gmail.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 9578a67..4132130 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -79,6 +79,10 @@
 #define USB_PID_TEVII_S632 0xd632
 #endif
 
+#ifndef USB_PID_GOTVIEW_SAT_HD
+#define USB_PID_GOTVIEW_SAT_HD 0x5456
+#endif
+
 #define DW210X_READ_MSG 0
 #define DW210X_WRITE_MSG 1
 
@@ -1548,6 +1552,7 @@ enum dw2102_table_entry {
 	X3M_SPC1400HD,
 	TEVII_S421,
 	TEVII_S632,
+	GOTVIEW_SAT_HD,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1568,6 +1573,7 @@ static struct usb_device_id dw2102_table[] = {
 	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
 	[TEVII_S421] = {USB_DEVICE(0x9022, USB_PID_TEVII_S421)},
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
+	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
 	{ }
 };
 
@@ -1968,7 +1974,7 @@ static struct dvb_usb_device_properties su3000_properties = {
 		}},
 		}
 	},
-	.num_device_descs = 3,
+	.num_device_descs = 4,
 	.devices = {
 		{ "SU3000HD DVB-S USB2.0",
 			{ &dw2102_table[GENIATECH_SU3000], NULL },
@@ -1982,6 +1988,10 @@ static struct dvb_usb_device_properties su3000_properties = {
 			{ &dw2102_table[X3M_SPC1400HD], NULL },
 			{ NULL },
 		},
+		{ "GOTVIEW Satellite HD",
+			{ &dw2102_table[GOTVIEW_SAT_HD], NULL },
+			{ NULL },
+		},
 	}
 };
 
-- 
1.8.1.5

