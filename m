Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaKROJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:09:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbaKROJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Daniel Kamil Kozar <dkk089@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/206] HID: usbhid: enable NO_INIT_REPORTS quirk for Semico USB Keykoard
Date: Tue, 18 Nov 2014 15:06:16 +0100
Message-Id: <d9892fefa40e5f6a7e2ec30e3ec288fe9f3f19e7.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9ea63c439c5dffcb7c46c741929fe74b31b9676b upstream.

The device which identifies itself as a "USB Keykoard" (no typo) with VID:PID
1a2c:0023 does not seem to be handling the reports initialization very well.
This results in a "usb_submit_urb(ctrl) failed: -1" message from the kernel
when connected, and a delay before its initialization.  This patch adds the
quirk for this device, which causes the delay to disappear.

[jkosina@suse.cz: remove superfluous comment and fix ordering]
Signed-off-by: Daniel Kamil Kozar <dkk089@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-ids.h           | 3 +++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 10e01bd3f082..63bbe2c2c2bc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -749,6 +749,9 @@
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 #define USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE	0x0600
 
+#define USB_VENDOR_ID_SEMICO			0x1a2c
+#define USB_DEVICE_ID_SEMICO_USB_KEYKOARD	0x0023
+
 #define USB_VENDOR_ID_SENNHEISER	0x1395
 #define USB_DEVICE_ID_SENNHEISER_BTD500USB	0x002c
 
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 175a2bc344e0..0dd568170d6e 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -118,6 +118,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS1, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_LTS2, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, HID_QUIRK_NO_INIT_REPORTS },
-- 
2.1.3

