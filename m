Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3JUVnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:43:46 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:49337 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3JUVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:43:44 -0400
From: =?UTF-8?q?Anders=20F=2E=20U=2E=20Ki=C3=A6r?= 
	<ablacksheep@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Anders=20F=2E=20U=2E=20Ki=C3=A6r?= 
	<ablacksheep@gmail.com>
Subject: [PATCH] HID: Added Holtek USB ID 04d9:a072 LEETGION Hellion Gaming Mouse 
Date: Mon, 21 Oct 2013 23:42:22 +0200
Message-Id: <1382391742-31335-1-git-send-email-ablacksheep@gmail.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Added id, bindings and comments for Holtek USB ID 04d9:a072
 LEETGION Hellion Gaming mouse to use the same corrections of the report
 descriptor as Holtek 04d9:a067. As the mouse exceed HID_MAX_USAGES at the
 same offsets in the reported descriptor.
 Tested on the hardware.

Signed-off-by: Anders F. U. Kiær <ablacksheep@gmail.com>
---
 drivers/hid/Kconfig            | 1 +
 drivers/hid/hid-core.c         | 1 +
 drivers/hid/hid-holtek-mouse.c | 4 ++++
 drivers/hid/hid-ids.h          | 3 ++-
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index c91d547..d68292a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -242,6 +242,7 @@ config HID_HOLTEK
 	  - Tracer Sniper TRM-503 / NOVA Gaming Slider X200 /
 	    Zalman ZM-GM1
 	  - SHARKOON DarkGlider Gaming mouse
+	  - LEETGION Hellion Gaming Mouse
 
 config HOLTEK_FF
 	bool "Holtek On Line Grip force feedback support"
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5a8c011..6ab7133 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1715,6 +1715,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HUION, USB_DEVICE_ID_HUION_580) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD) },
diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
index e696566..0caa676 100644
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -28,6 +28,7 @@
  * - USB ID 04d9:a04a, sold as Tracer Sniper TRM-503, NOVA Gaming Slider X200
  *   and Zalman ZM-GM1
  * - USB ID 04d9:a081, sold as SHARKOON DarkGlider Gaming mouse
+ * - USB ID 04d9:a072, sold as LEETGION Hellion Gaming Mouse
  */
 
 static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
@@ -40,6 +41,7 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 * 0x2fff, so they don't exceed HID_MAX_USAGES */
 		switch (hdev->product) {
 		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067:
+		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072:
 			if (*rsize >= 122 && rdesc[115] == 0xff && rdesc[116] == 0x7f
 					&& rdesc[120] == 0xff && rdesc[121] == 0x7f) {
 				hid_info(hdev, "Fixing up report descriptor\n");
@@ -66,6 +68,8 @@ static const struct hid_device_id holtek_mouse_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
+			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ }
 };
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9cbc7ab..8ebaef95 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -448,8 +448,9 @@
 
 #define USB_VENDOR_ID_HOLTEK_ALT		0x04d9
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD	0xa055
-#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A	0xa04a
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072	0xa072
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 
 #define USB_VENDOR_ID_IMATION		0x0718
-- 
1.8.1.2

