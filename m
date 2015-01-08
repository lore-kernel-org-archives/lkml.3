Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbbAHWxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:53:48 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:25579 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932132AbbAHWxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:53:45 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 08 Jan 2015 15:21:13 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH v2 3/3] HID: rmi: Add support for the touchpad in the Razer Blade 14 laptop
Date: Thu, 8 Jan 2015 14:51:35 -0800
Message-ID: <1420757496-3955-2-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420757496-3955-1-git-send-email-aduggan@synaptics.com>
References: <1420757496-3955-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have hid-rmi handle all of the Razer Blade HID devices that are part of the
composite USB device. This will allow hid-rmi to operate the touchpad in rmi
mode while passing events from the other devices to hid-input.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-core.c | 1 +
 drivers/hid/hid-ids.h  | 3 +++
 drivers/hid/hid-rmi.c  | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 81665b4..ef718f9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1982,6 +1982,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_RAZER, USB_DEVICE_ID_RAZER_BLADE_14) },
 	{ }
 };
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7460f34..7d0912d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -767,6 +767,9 @@
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001		0x3001
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
 
+#define USB_VENDOR_ID_RAZER            0x1532
+#define USB_DEVICE_ID_RAZER_BLADE_14   0x011D
+
 #define USB_VENDOR_ID_REALTEK		0x0bda
 #define USB_DEVICE_ID_REALTEK_READER	0x0152
 
diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 290f8f7..b08774a 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -1083,6 +1083,8 @@ static void rmi_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id rmi_id[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_RAZER, USB_DEVICE_ID_RAZER_BLADE_14),
+		.driver_data = RMI_DEVICE_HAS_PHYS_BUTTONS },
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_RMI, HID_ANY_ID, HID_ANY_ID) },
 	{ }
 };
-- 
2.1.0

