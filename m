Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3LBTUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:20:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3LBTTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "=?UTF-8?q?Anders=20F . =20U . =20Ki=C3=A6r?=" 
	<ablacksheep@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 210/212] HID: add support for LEETGION Hellion Gaming Mouse
Date: Mon,  2 Dec 2013 11:16:41 -0800
Message-Id: <20131202191312.928943269@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders F. U. Kiær <ablacksheep@gmail.com>

commit f1a4914bd04911fbeaee23445112adae8977144a upstream.

Added id, bindings and comments for Holtek USB ID 04d9:a072
LEETGION Hellion Gaming mouse to use the same corrections of the report
descriptor as Holtek 04d9:a067. As the mouse exceed HID_MAX_USAGES at the
same offsets in the reported descriptor.
Tested on the hardware.

Signed-off-by: Anders F. U. Kiær <ablacksheep@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/Kconfig            |    1 +
 drivers/hid/hid-core.c         |    1 +
 drivers/hid/hid-holtek-mouse.c |    4 ++++
 drivers/hid/hid-ids.h          |    3 ++-
 4 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -242,6 +242,7 @@ config HID_HOLTEK
 	  - Tracer Sniper TRM-503 / NOVA Gaming Slider X200 /
 	    Zalman ZM-GM1
 	  - SHARKOON DarkGlider Gaming mouse
+	  - LEETGION Hellion Gaming Mouse
 
 config HOLTEK_FF
 	bool "Holtek On Line Grip force feedback support"
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1716,6 +1716,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HUION, USB_DEVICE_ID_HUION_580) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD) },
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -28,6 +28,7 @@
  * - USB ID 04d9:a04a, sold as Tracer Sniper TRM-503, NOVA Gaming Slider X200
  *   and Zalman ZM-GM1
  * - USB ID 04d9:a081, sold as SHARKOON DarkGlider Gaming mouse
+ * - USB ID 04d9:a072, sold as LEETGION Hellion Gaming Mouse
  */
 
 static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
@@ -40,6 +41,7 @@ static __u8 *holtek_mouse_report_fixup(s
 		 * 0x2fff, so they don't exceed HID_MAX_USAGES */
 		switch (hdev->product) {
 		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067:
+		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072:
 			if (*rsize >= 122 && rdesc[115] == 0xff && rdesc[116] == 0x7f
 					&& rdesc[120] == 0xff && rdesc[121] == 0x7f) {
 				hid_info(hdev, "Fixing up report descriptor\n");
@@ -66,6 +68,8 @@ static const struct hid_device_id holtek
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
+			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ }
 };
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


