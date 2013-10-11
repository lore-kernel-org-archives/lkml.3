Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab3JKToJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:44:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab3JKTmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "=?UTF-8?q?Anders=20F . =20U . =20Ki=C3=A6r?=" 
	<ablacksheep@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 131/135] HID: add Holtek USB ID 04d9:a081 SHARKOON DarkGlider
Date: Fri, 11 Oct 2013 12:40:12 -0700
Message-Id: <20131011193959.506865287@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders F. U. Kiær <ablacksheep@gmail.com>

commit 7da7cbbbeb60e0939fecdf9723b388136c175e5c upstream.

Added id, bindings and comments for Holtek USB ID 04d9:a081 SHARKOON
DarkGlider Gaming mouse to use the same corrections of the report
descriptor as Holtek 04d9:a04a. As the mouse exceed HID_MAX_USAGES
at the same offsets in the reported descriptor.
Tested on the hardware.

Signed-off-by: Anders F. U. Kiær <ablacksheep@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/Kconfig            |    1 +
 drivers/hid/hid-core.c         |    1 +
 drivers/hid/hid-holtek-mouse.c |    4 ++++
 drivers/hid/hid-ids.h          |    1 +
 4 files changed, 7 insertions(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -241,6 +241,7 @@ config HID_HOLTEK
 	  - Sharkoon Drakonia / Perixx MX-2000 gaming mice
 	  - Tracer Sniper TRM-503 / NOVA Gaming Slider X200 /
 	    Zalman ZM-GM1
+	  - SHARKOON DarkGlider Gaming mouse
 
 config HOLTEK_FF
 	bool "Holtek On Line Grip force feedback support"
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1673,6 +1673,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HUION, USB_DEVICE_ID_HUION_580) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ION, USB_DEVICE_ID_ICADE) },
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -27,6 +27,7 @@
  * - USB ID 04d9:a067, sold as Sharkoon Drakonia and Perixx MX-2000
  * - USB ID 04d9:a04a, sold as Tracer Sniper TRM-503, NOVA Gaming Slider X200
  *   and Zalman ZM-GM1
+ * - USB ID 04d9:a081, sold as SHARKOON DarkGlider Gaming mouse
  */
 
 static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
@@ -46,6 +47,7 @@ static __u8 *holtek_mouse_report_fixup(s
 			}
 			break;
 		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A:
+		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081:
 			if (*rsize >= 113 && rdesc[106] == 0xff && rdesc[107] == 0x7f
 					&& rdesc[111] == 0xff && rdesc[112] == 0x7f) {
 				hid_info(hdev, "Fixing up report descriptor\n");
@@ -63,6 +65,8 @@ static const struct hid_device_id holtek
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
+			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, holtek_mouse_devices);
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -450,6 +450,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD	0xa055
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A	0xa04a
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000


