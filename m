Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbbAJFmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:42:13 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45745 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbAJFgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:41 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 08/25] staging: line6: Remove idVendor and idProduct macros
Date: Fri,  9 Jan 2015 23:35:54 -0600
Message-Id: <1420868171-2031-9-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now only used to build the device table.  Each entry in this
table is already clearly documented as to what device it maps to so the
macros become unnecessary indirection.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c  | 56 ++++++++++++++---------------------------
 drivers/staging/line6/usbdefs.h | 24 ------------------
 2 files changed, 19 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 81d5a27..6dc8a0d 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -30,46 +30,28 @@
 #define DRIVER_DESC    "Line6 USB Driver"
 #define DRIVER_VERSION "0.9.1beta" DRIVER_REVISION
 
-#define LINE6_DEVICE(prod) USB_DEVICE(LINE6_VENDOR_ID, prod)
+#define LINE6_DEVICE(prod) USB_DEVICE(0x0e41, prod)
 
 /* table of devices that work with this driver */
 static const struct usb_device_id line6_id_table[] = {
-	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXT),
-		.driver_info = LINE6_BASSPODXT },
-	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTLIVE),
-		.driver_info = LINE6_BASSPODXTLIVE },
-	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTPRO),
-		.driver_info = LINE6_BASSPODXTPRO },
-	{ LINE6_DEVICE(LINE6_DEVID_GUITARPORT),
-		.driver_info = LINE6_GUITARPORT },
-	{ LINE6_DEVICE(LINE6_DEVID_POCKETPOD),
-		.driver_info = LINE6_POCKETPOD },
-	{ LINE6_DEVICE(LINE6_DEVID_PODHD300),
-		.driver_info = LINE6_PODHD300 },
-	{ LINE6_DEVICE(LINE6_DEVID_PODHD400),
-		.driver_info = LINE6_PODHD400 },
-	{ LINE6_DEVICE(LINE6_DEVID_PODHD500),
-		.driver_info = LINE6_PODHD500 },
-	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_GX),
-		.driver_info = LINE6_PODSTUDIO_GX },
-	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX1),
-		.driver_info = LINE6_PODSTUDIO_UX1 },
-	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX2),
-		.driver_info = LINE6_PODSTUDIO_UX2 },
-	{ LINE6_DEVICE(LINE6_DEVID_PODXT),
-		.driver_info = LINE6_PODXT },
-	{ LINE6_DEVICE(LINE6_DEVID_PODXTLIVE),
-		.driver_info = LINE6_PODXTLIVE },
-	{ LINE6_DEVICE(LINE6_DEVID_PODXTPRO),
-		.driver_info = LINE6_PODXTPRO },
-	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_GX),
-		.driver_info = LINE6_TONEPORT_GX },
-	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX1),
-		.driver_info = LINE6_TONEPORT_UX1 },
-	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX2),
-		.driver_info = LINE6_TONEPORT_UX2 },
-	{ LINE6_DEVICE(LINE6_DEVID_VARIAX),
-		.driver_info = LINE6_VARIAX },
+	{ LINE6_DEVICE(0x4250),    .driver_info = LINE6_BASSPODXT },
+	{ LINE6_DEVICE(0x4642),    .driver_info = LINE6_BASSPODXTLIVE },
+	{ LINE6_DEVICE(0x4252),    .driver_info = LINE6_BASSPODXTPRO },
+	{ LINE6_DEVICE(0x4750),    .driver_info = LINE6_GUITARPORT },
+	{ LINE6_DEVICE(0x5051),    .driver_info = LINE6_POCKETPOD },
+	{ LINE6_DEVICE(0x5057),    .driver_info = LINE6_PODHD300 },
+	{ LINE6_DEVICE(0x5058),    .driver_info = LINE6_PODHD400 },
+	{ LINE6_DEVICE(0x414D),    .driver_info = LINE6_PODHD500 },
+	{ LINE6_DEVICE(0x4153),    .driver_info = LINE6_PODSTUDIO_GX },
+	{ LINE6_DEVICE(0x4150),    .driver_info = LINE6_PODSTUDIO_UX1 },
+	{ LINE6_DEVICE(0x4151),    .driver_info = LINE6_PODSTUDIO_UX2 },
+	{ LINE6_DEVICE(0x5044),    .driver_info = LINE6_PODXT },
+	{ LINE6_DEVICE(0x4650),    .driver_info = LINE6_PODXTLIVE },
+	{ LINE6_DEVICE(0x5050),    .driver_info = LINE6_PODXTPRO },
+	{ LINE6_DEVICE(0x4147),    .driver_info = LINE6_TONEPORT_GX },
+	{ LINE6_DEVICE(0x4141),    .driver_info = LINE6_TONEPORT_UX1 },
+	{ LINE6_DEVICE(0x4142),    .driver_info = LINE6_TONEPORT_UX2 },
+	{ LINE6_DEVICE(0x534d),    .driver_info = LINE6_VARIAX },
 	{}
 };
 
diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index 06bf909..c897dba 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -12,32 +12,8 @@
 #ifndef USBDEFS_H
 #define USBDEFS_H
 
-#define LINE6_VENDOR_ID  0x0e41
-
 #define USB_INTERVALS_PER_SECOND 1000
 
-/*
-	Device ids.
-*/
-#define LINE6_DEVID_BASSPODXT     0x4250
-#define LINE6_DEVID_BASSPODXTLIVE 0x4642
-#define LINE6_DEVID_BASSPODXTPRO  0x4252
-#define LINE6_DEVID_GUITARPORT    0x4750
-#define LINE6_DEVID_POCKETPOD     0x5051
-#define LINE6_DEVID_PODHD300      0x5057
-#define LINE6_DEVID_PODHD400      0x5058
-#define LINE6_DEVID_PODHD500      0x414D
-#define LINE6_DEVID_PODSTUDIO_GX  0x4153
-#define LINE6_DEVID_PODSTUDIO_UX1 0x4150
-#define LINE6_DEVID_PODSTUDIO_UX2 0x4151
-#define LINE6_DEVID_PODXT         0x5044
-#define LINE6_DEVID_PODXTLIVE     0x4650
-#define LINE6_DEVID_PODXTPRO      0x5050
-#define LINE6_DEVID_TONEPORT_GX   0x4147
-#define LINE6_DEVID_TONEPORT_UX1  0x4141
-#define LINE6_DEVID_TONEPORT_UX2  0x4142
-#define LINE6_DEVID_VARIAX        0x534d
-
 /* device supports settings parameter via USB */
 #define LINE6_BIT_CONTROL (1 << 0)
 /* device supports PCM input/output via USB */
-- 
2.1.0

