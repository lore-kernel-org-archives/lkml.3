Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaICJ6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:44 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57463 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932531AbaICJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wangzhao Cai <microcaicai@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 07/56] HID: add quirk for 0x04d9:0xa096 device
Date: Wed,  3 Sep 2014 11:26:26 +0200
Message-Id: <0325fb03fe49b37dfb9a66be6083ce4aebe17df9.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wangzhao Cai <microcaicai@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 30c6fd4277ebab2a32ae5635d34283354b1bc8f2 upstream.

I am using a USB keyborad that give me "usb_submit_urb(ctrl) failed: -1" error
when I plugin it.  and I need to wait for 10s for this device to be ready.

By adding this quirks, the usb keyborad is usable right after plugin

Signed-off-by: Wangzhao Cai <microcaicai@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ca275f47e860..b921bc55a19b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -457,6 +457,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072	0xa072
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
 
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 8e4ddb369883..da22a5e0d86f 100644
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
2.1.0

