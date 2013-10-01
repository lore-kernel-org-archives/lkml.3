Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3JARWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:22:19 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:47116 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3JARWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:22:17 -0400
From: =?UTF-8?q?Anders=20F=2E=20U=2E=20Ki=C3=A6r?= 
	<ablacksheep@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Anders=20F=2E=20U=2E=20Ki=C3=A6r?= 
	<ablacksheep@gmail.com>
Subject: [PATCH] HID: Added Holtek USB ID 04d9:a081 SHARKOON DarkGlider Gaming mouse
Date: Tue,  1 Oct 2013 19:22:05 +0200
Message-Id: <1380648125-5735-1-git-send-email-ablacksheep@gmail.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Target: 3.11.2
Added id, bindings and comments for Holtek USB ID 04d9:a081 SHARKOON
DarkGlider Gaming mouse to use the same corrections of the report
descriptor as Holtek 04d9:a04a. As the mouse exceed HID_MAX_USAGES
at the same offsets in the reported descriptor.
Tested on the hardware.

Signed-off-by: Anders F. U. Kiær <ablacksheep@gmail.com>
---
 drivers/hid/Kconfig            | 1 +
 drivers/hid/hid-core.c         | 1 +
 drivers/hid/hid-holtek-mouse.c | 4 ++++
 drivers/hid/hid-ids.h          | 1 +
 4 files changed, 7 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 14ef6ab..750adde 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -241,6 +241,7 @@ config HID_HOLTEK
 	  - Sharkoon Drakonia / Perixx MX-2000 gaming mice
 	  - Tracer Sniper TRM-503 / NOVA Gaming Slider X200 /
 	    Zalman ZM-GM1
+	  - SHARKOON DarkGlider Gaming mouse
 
 config HOLTEK_FF
 	bool "Holtek On Line Grip force feedback support"
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5956445..754cd59 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1600,6 +1600,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HUION, USB_DEVICE_ID_HUION_580) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ION, USB_DEVICE_ID_ICADE) },
diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
index 7e6db3c..e696566 100644
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -27,6 +27,7 @@
  * - USB ID 04d9:a067, sold as Sharkoon Drakonia and Perixx MX-2000
  * - USB ID 04d9:a04a, sold as Tracer Sniper TRM-503, NOVA Gaming Slider X200
  *   and Zalman ZM-GM1
+ * - USB ID 04d9:a081, sold as SHARKOON DarkGlider Gaming mouse
  */
 
 static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
@@ -46,6 +47,7 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			}
 			break;
 		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A:
+		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081:
 			if (*rsize >= 113 && rdesc[106] == 0xff && rdesc[107] == 0x7f
 					&& rdesc[111] == 0xff && rdesc[112] == 0x7f) {
 				hid_info(hdev, "Fixing up report descriptor\n");
@@ -63,6 +65,8 @@ static const struct hid_device_id holtek_mouse_devices[] = {
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
+			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, holtek_mouse_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 22134d4..b602b02 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -450,6 +450,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD	0xa055
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A	0xa04a
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
-- 
1.8.1.2

