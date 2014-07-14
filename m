Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaGNBNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 21:13:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37822 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaGNBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 21:13:10 -0400
From: microcai@fedoraproject.org
To: linux-usb@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org,
        microcai <microcaicai@gmail.com>
Subject: [PATCH] add quirks for 0x04d9:0xa096 hid keyborad device
Date: Mon, 14 Jul 2014 09:13:32 +0800
Message-Id: <1405300412-31346-1-git-send-email-microcai@fedoraproject.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: microcai <microcaicai@gmail.com>

I am using a USB keyborad that give me
"usb_submit_urb(ctrl) failed: -1" error when I plugin it.
and I need to wait for 10s for this device to be ready.

by adding this quirks, the usb keyborad is usable right after plugin

Signed-off-by: Wangzhao Cai <microcaicai@gmail.com>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 34bb220..bda276b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -477,6 +477,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A070	0xa070
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072	0xa072
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
 
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 8e4ddb3..da22a5e 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -120,6 +120,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_QUAD_HD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096, HID_QUIRK_NO_INIT_INPUT_REPORTS },
 
 	{ 0, 0 }
 };
-- 
2.0.0

