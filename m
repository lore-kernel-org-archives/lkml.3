Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaA0XDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:03:17 -0500
Received: from mail-oa0-f73.google.com ([209.85.219.73]:42361 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaA0XDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:03:13 -0500
From: Yufeng Shen <miletus@chromium.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, miletus@chromium.org, adlr@chromium.org
Subject: [PATCH] HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay
Date: Mon, 27 Jan 2014 18:02:46 -0500
Message-Id: <1390863766-14491-1-git-send-email-miletus@chromium.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is timeout error during initialization:
kernel: [   11.733104] hid-multitouch 0003:1870:0110.0001: usb_submit_urb(ctrl) failed: -1
kernel: [   11.734093] hid-multitouch 0003:1870:0110.0001: timeout initializing reports

Adding quirk HID_QUIRK_NO_INIT_REPORTS can solve the problem.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f9304cb..ece2997 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -636,6 +636,7 @@
 
 #define USB_VENDOR_ID_NEXIO		0x1870
 #define USB_DEVICE_ID_NEXIO_MULTITOUCH_420	0x010d
+#define USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750	0x0110
 
 #define USB_VENDOR_ID_NEXTWINDOW	0x1926
 #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 0db9a67..be5270a 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -74,6 +74,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
-- 
1.8.5.3

