Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbbAJFg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:57 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35616 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbbAJFgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:55 -0500
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
Subject: [PATCH 17/25] staging: line6: Move altsetting to properties
Date: Fri,  9 Jan 2015 23:36:03 -0600
Message-Id: <1420868171-2031-18-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device type can now be used to determine the altsetting for the
interface.  Drop the conditional logic and make this value a property.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 74 +++++++++++++-----------------------------
 drivers/staging/line6/driver.h |  2 ++
 2 files changed, 25 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index f04ff80..0150470 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -67,6 +67,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 5,
 	},
 	[LINE6_BASSPODXTLIVE] = {
 		.id = "BassPODxtLive",
@@ -74,6 +75,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 1,
 	},
 	[LINE6_BASSPODXTPRO] = {
 		.id = "BassPODxtPro",
@@ -81,16 +83,19 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 5,
 	},
 	[LINE6_GUITARPORT] = {
 		.id = "GuitarPort",
 		.name = "GuitarPort",
 		.capabilities	= LINE6_CAP_PCM,
+		.altsetting = 2,  /* 1..4 seem to be ok */
 	},
 	[LINE6_POCKETPOD] = {
 		.id = "PocketPOD",
 		.name = "Pocket POD",
 		.capabilities	= LINE6_CAP_CONTROL,
+		.altsetting = 0,
 	},
 	[LINE6_PODHD300] = {
 		.id = "PODHD300",
@@ -98,6 +103,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 5,
 	},
 	[LINE6_PODHD400] = {
 		.id = "PODHD400",
@@ -105,6 +111,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 5,
 	},
 	[LINE6_PODHD500_0] = {
 		.id = "PODHD500",
@@ -112,6 +119,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 1,
 	},
 	[LINE6_PODHD500_1] = {
 		.id = "PODHD500",
@@ -119,21 +127,25 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 1,
 	},
 	[LINE6_PODSTUDIO_GX] = {
 		.id = "PODStudioGX",
 		.name = "POD Studio GX",
 		.capabilities	= LINE6_CAP_PCM,
+		.altsetting = 2,  /* 1..4 seem to be ok */
 	},
 	[LINE6_PODSTUDIO_UX1] = {
 		.id = "PODStudioUX1",
 		.name = "POD Studio UX1",
 		.capabilities	= LINE6_CAP_PCM,
+		.altsetting = 2,  /* 1..4 seem to be ok */
 	},
 	[LINE6_PODSTUDIO_UX2] = {
 		.id = "PODStudioUX2",
 		.name = "POD Studio UX2",
 		.capabilities	= LINE6_CAP_PCM,
+		.altsetting = 2,  /* defaults to 44.1kHz, 16-bit */
 	},
 	[LINE6_PODXT] = {
 		.id = "PODxt",
@@ -141,6 +153,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 5,
 	},
 	[LINE6_PODXTLIVE_POD] = {
 		.id = "PODxtLive",
@@ -148,6 +161,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 1,
 	},
 	[LINE6_PODXTLIVE_VARIAX] = {
 		.id = "PODxtLive",
@@ -155,6 +169,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 1,
 	},
 	[LINE6_PODXTPRO] = {
 		.id = "PODxtPro",
@@ -162,26 +177,31 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
+		.altsetting = 5,
 	},
 	[LINE6_TONEPORT_GX] = {
 		.id = "TonePortGX",
 		.name = "TonePort GX",
 		.capabilities	= LINE6_CAP_PCM,
+		.altsetting = 2,  /* 1..4 seem to be ok */
 	},
 	[LINE6_TONEPORT_UX1] = {
 		.id = "TonePortUX1",
 		.name = "TonePort UX1",
 		.capabilities	= LINE6_CAP_PCM,
+		.altsetting = 2,  /* 1..4 seem to be ok */
 	},
 	[LINE6_TONEPORT_UX2] = {
 		.id = "TonePortUX2",
 		.name = "TonePort UX2",
 		.capabilities	= LINE6_CAP_PCM,
+		.altsetting = 2,  /* defaults to 44.1kHz, 16-bit */
 	},
 	[LINE6_VARIAX] = {
 		.id = "Variax",
 		.name = "Variax Workbench",
 		.capabilities	= LINE6_CAP_CONTROL,
+		.altsetting = 1,
 	}
 };
 
@@ -703,7 +723,7 @@ static int line6_probe(struct usb_interface *interface,
 	struct usb_device *usbdev;
 	struct usb_line6 *line6;
 	const struct line6_properties *properties;
-	int interface_number, alternate = 0;
+	int interface_number;
 	int size = 0;
 	int ep_read = 0, ep_write = 0;
 	int ret;
@@ -729,56 +749,8 @@ static int line6_probe(struct usb_interface *interface,
 	/* query interface number */
 	interface_number = interface->cur_altsetting->desc.bInterfaceNumber;
 
-	switch (devtype) {
-	case LINE6_BASSPODXTLIVE:
-	case LINE6_PODXTLIVE_POD:
-	case LINE6_PODXTLIVE_VARIAX:
-	case LINE6_VARIAX:
-		alternate = 1;
-		break;
-
-	case LINE6_POCKETPOD:
-		alternate = 0;
-		break;
-
-	case LINE6_PODHD500_0:
-		alternate = 1;
-		break;
-
-	case LINE6_PODHD500_1:
-		alternate = 0;
-		break;
-
-	case LINE6_BASSPODXT:
-	case LINE6_BASSPODXTPRO:
-	case LINE6_PODXT:
-	case LINE6_PODXTPRO:
-	case LINE6_PODHD300:
-	case LINE6_PODHD400:
-		alternate = 5;
-		break;
-
-	case LINE6_GUITARPORT:
-	case LINE6_PODSTUDIO_GX:
-	case LINE6_PODSTUDIO_UX1:
-	case LINE6_TONEPORT_GX:
-	case LINE6_TONEPORT_UX1:
-		alternate = 2;	/* 1..4 seem to be ok */
-		break;
-
-	case LINE6_TONEPORT_UX2:
-	case LINE6_PODSTUDIO_UX2:
-		/* defaults to 44.1kHz, 16-bit */
-		alternate = 2;
-		break;
-
-	default:
-		MISSING_CASE;
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	ret = usb_set_interface(usbdev, interface_number, alternate);
+	ret = usb_set_interface(usbdev, interface_number,
+			properties->altsetting);
 	if (ret < 0) {
 		dev_err(&interface->dev, "set_interface failed\n");
 		goto err_put;
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 9d6b351..97d6be1 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -115,6 +115,8 @@ struct line6_properties {
 		 line6usb driver.
 	*/
 	int capabilities;
+
+	int altsetting;
 };
 
 /**
-- 
2.1.0

