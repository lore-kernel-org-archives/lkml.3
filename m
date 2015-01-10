Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbbAJFmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:42:55 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59901 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbAJFga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:30 -0500
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
Subject: [PATCH 03/25] staging: line6: Remove unsupported X3 devices
Date: Fri,  9 Jan 2015 23:35:49 -0600
Message-Id: <1420868171-2031-4-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for these devices appears to have never been completed.  Remove
them from the device table along with a minimal amount of supporting
code.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c  | 26 --------------------------
 drivers/staging/line6/pcm.c     |  2 --
 drivers/staging/line6/usbdefs.h |  2 --
 3 files changed, 30 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 15f3bc4..e40400b 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -43,8 +43,6 @@ static const struct usb_device_id line6_id_table[] = {
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_GX)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX1)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODSTUDIO_UX2)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODX3)},
-	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODX3LIVE)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXT)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTLIVE)},
 	{USB_DEVICE(LINE6_VENDOR_ID, LINE6_DEVID_PODXTPRO)},
@@ -74,8 +72,6 @@ static const struct line6_properties line6_properties_table[] = {
 	L6PROP("PODStudioGX",   "POD Studio GX",    PCM),
 	L6PROP("PODStudioUX1",  "POD Studio UX1",   PCM),
 	L6PROP("PODStudioUX2",  "POD Studio UX2",   PCM),
-	L6PROP("PODX3",         "POD X3",           PCM),
-	L6PROP("PODX3Live",     "POD X3 Live",      PCM),
 	L6PROP("PODxt",         "PODxt",            CTRL_PCM_HW),
 	L6PROP("PODxtLive",     "PODxt Live",       CTRL_PCM_HW),
 	L6PROP("PODxtPro",      "PODxt Pro",        CTRL_PCM_HW),
@@ -673,8 +669,6 @@ static int line6_probe(struct usb_interface *interface,
 		break;
 
 	case LINE6_DEVID_PODHD500:
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
 		switch (interface_number) {
 		case 0:
 			alternate = 1;
@@ -765,14 +759,6 @@ static int line6_probe(struct usb_interface *interface,
 		ep_write = 0x02;
 		break;
 
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
-		/* currently unused! */
-		size = sizeof(struct usb_line6_pod);
-		ep_read = 0x81;
-		ep_write = 0x01;
-		break;
-
 	case LINE6_DEVID_PODSTUDIO_GX:
 	case LINE6_DEVID_PODSTUDIO_UX1:
 	case LINE6_DEVID_PODSTUDIO_UX2:
@@ -898,8 +884,6 @@ static int line6_probe(struct usb_interface *interface,
 	case LINE6_DEVID_BASSPODXTLIVE:
 	case LINE6_DEVID_BASSPODXTPRO:
 	case LINE6_DEVID_POCKETPOD:
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
 	case LINE6_DEVID_PODXT:
 	case LINE6_DEVID_PODXTPRO:
 		ret = line6_pod_init(interface, (struct usb_line6_pod *)line6);
@@ -971,14 +955,6 @@ static int line6_probe(struct usb_interface *interface,
 	dev_info(&interface->dev, "Line6 %s now attached\n",
 		 line6->properties->name);
 
-	switch (product) {
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
-		dev_info(&interface->dev,
-			 "NOTE: the Line6 %s is detected, but not yet supported\n",
-			 line6->properties->name);
-	}
-
 	/* increment reference counters: */
 	usb_get_intf(interface);
 	usb_get_dev(usbdev);
@@ -1026,8 +1002,6 @@ static void line6_disconnect(struct usb_interface *interface)
 		case LINE6_DEVID_BASSPODXTLIVE:
 		case LINE6_DEVID_BASSPODXTPRO:
 		case LINE6_DEVID_POCKETPOD:
-		case LINE6_DEVID_PODX3:
-		case LINE6_DEVID_PODX3LIVE:
 		case LINE6_DEVID_PODXT:
 		case LINE6_DEVID_PODXTPRO:
 			line6_pod_disconnect(interface);
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index a3136b1..076c87b 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -442,8 +442,6 @@ int line6_init_pcm(struct usb_line6 *line6,
 		break;
 
 	case LINE6_DEVID_PODHD500:
-	case LINE6_DEVID_PODX3:
-	case LINE6_DEVID_PODX3LIVE:
 		ep_read = 0x86;
 		ep_write = 0x02;
 		break;
diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index 2bc2fe7..06bf909 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -30,8 +30,6 @@
 #define LINE6_DEVID_PODSTUDIO_GX  0x4153
 #define LINE6_DEVID_PODSTUDIO_UX1 0x4150
 #define LINE6_DEVID_PODSTUDIO_UX2 0x4151
-#define LINE6_DEVID_PODX3         0x414a
-#define LINE6_DEVID_PODX3LIVE     0x414b
 #define LINE6_DEVID_PODXT         0x5044
 #define LINE6_DEVID_PODXTLIVE     0x4650
 #define LINE6_DEVID_PODXTPRO      0x5050
-- 
2.1.0

