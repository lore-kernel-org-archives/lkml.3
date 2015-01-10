Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbbAJFgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:44 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45035 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbbAJFgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:32 -0500
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
Subject: [PATCH 04/25] staging: line6: Cleanup device table
Date: Fri,  9 Jan 2015 23:35:50 -0600
Message-Id: <1420868171-2031-5-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap USB_DEVICE to avoid repeating the Line 6 vendor ID.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index e40400b..a263bce 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -30,27 +30,29 @@
 #define DRIVER_DESC    "Line6 USB Driver"
 #define DRIVER_VERSION "0.9.1beta" DRIVER_REVISION
 
+#define LINE6_DEVICE(prod) USB_DEVICE(LINE6_VENDOR_ID, prod)
+
 /* table of devices that work with this driver */
 static const struct usb_device_id line6_id_table[] = {
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXT)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTLIVE)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_BASSPODXTPRO)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_GUITARPORT)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_POCKETPOD)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD300)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD400)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODHD500)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX2)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXT)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTLIVE)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTPRO)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_GX)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_UX1)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_TONEPORT_UX2)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_VARIAX)},
-	{},
+	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXT) },
+	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTLIVE) },
+	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTPRO) },
+	{ LINE6_DEVICE(LINE6_DEVID_GUITARPORT) },
+	{ LINE6_DEVICE(LINE6_DEVID_POCKETPOD) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODHD300) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODHD400) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODHD500) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_GX) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX1) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX2) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODXT) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODXTLIVE) },
+	{ LINE6_DEVICE(LINE6_DEVID_PODXTPRO) },
+	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_GX) },
+	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX1) },
+	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX2) },
+	{ LINE6_DEVICE(LINE6_DEVID_VARIAX) },
+	{}
 };
 
 MODULE_DEVICE_TABLE(usb, line6_id_table);
-- 
2.1.0

