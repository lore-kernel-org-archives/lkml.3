Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162537Ab3LFNXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:23:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161862Ab3LFNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Anders=20F=2E=20U=2E=20Ki=C3=A6r?= 
	<ablacksheep@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 211/272] HID: add support for LEETGION Hellion Gaming Mouse
Date: Fri,  6 Dec 2013 12:58:20 +0000
Message-Id: <1386334761-25517-212-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Anders=20F=2E=20U=2E=20Ki=C3=A6r?= <ablacksheep@gmail.com>

commit f1a4914bd04911fbeaee23445112adae8977144a upstream.

Added id, bindings and comments for Holtek USB ID 04d9:a072
LEETGION Hellion Gaming mouse to use the same corrections of the report
descriptor as Holtek 04d9:a067. As the mouse exceed HID_MAX_USAGES at the
same offsets in the reported descriptor.
Tested on the hardware.

Signed-off-by: Anders F. U. Kiær <ablacksheep@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/Kconfig            | 1 +
 drivers/hid/hid-core.c         | 1 +
 drivers/hid/hid-holtek-mouse.c | 4 ++++
 drivers/hid/hid-ids.h          | 3 ++-
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 70178f3..4992908 100644
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
index 3eb8c11..d22cc95 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1674,6 +1674,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
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
index a3e2fe0..96fa2d1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -453,8 +453,9 @@
 
 #define USB_VENDOR_ID_HOLTEK_ALT		0x04d9
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD	0xa055
-#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A	0xa04a
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072	0xa072
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 
 #define USB_VENDOR_ID_IMATION		0x0718
-- 
1.8.3.2

