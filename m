Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbbAGCdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:33:23 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:36396 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbbAGCdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:33:20 -0500
From: Alan Wu <alan.c.wu@gmail.com>
To: Alan Wu <alan.c.wu@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Karlis Dreizis <karlisdreizis@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 1/1] x86: Added support for Japanese Surface Type Cover 3
Date: Tue,  6 Jan 2015 18:32:51 -0800
Message-Id: <1420597971-4438-1-git-send-email-alan.c.wu@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on code for the US Surface Type Cover 3 
from commit be3b16341d5cd8cf2a64fcc7a604a8efe6599ff0
("HID: add support for MS Surface Pro 3 Type Cover"):

Signed-off-by: Alan Wu <alan.c.wu@gmail.com>
Tested-by: Karlis Dreizis <karlisdreizis@gmail.com> 
---
 drivers/hid/hid-core.c          | 4 +++-
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/hid-microsoft.c     | 2 ++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c3d0ac1..0cea5a0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -704,7 +704,8 @@ static void hid_scan_collection(struct hid_parser *parser, unsigned type)
 		hid->group = HID_GROUP_SENSOR_HUB;
 
 	if (hid->vendor == USB_VENDOR_ID_MICROSOFT &&
-	    hid->product == USB_DEVICE_ID_MS_TYPE_COVER_3 &&
+	    (hid->product == USB_DEVICE_ID_MS_TYPE_COVER_3 ||
+	     hid->product == USB_DEVICE_ID_MS_TYPE_COVER_3_JP) &&
 	    hid->group == HID_GROUP_MULTITOUCH)
 		hid->group = HID_GROUP_GENERIC;
 }
@@ -1860,6 +1861,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_OFFICE_KB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3_JP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7460f34..95ee91b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -653,6 +653,7 @@
 #define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
 #define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
 #define USB_DEVICE_ID_MS_TYPE_COVER_3    0x07dc
+#define USB_DEVICE_ID_MS_TYPE_COVER_3_JP 0x07dd
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index cacda43..fbaea6e 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -276,6 +276,8 @@ static const struct hid_device_id ms_devices[] = {
 		.driver_data = MS_DUPLICATE_USAGES },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3),
 		.driver_data = MS_HIDINPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3_JP),
+		.driver_data = MS_HIDINPUT },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT),
 		.driver_data = MS_PRESENTER },
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index dc89be9..6591b5d 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -80,6 +80,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3_JP, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
-- 
2.1.0

