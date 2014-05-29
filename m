Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632AbaE2OWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:22:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59310 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933014AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yufeng Shen <miletus@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 008/103] HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay
Date: Thu, 29 May 2014 15:47:53 +0200
Message-Id: <aea22946135c7373d20d12d7c16470679b4c7455.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yufeng Shen <miletus@chromium.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 29191039e21f66e204acffed63c486674a1918bd upstream.

There is timeout error during initialization:
kernel: [   11.733104] hid-multitouch 0003:1870:0110.0001: usb_submit_urb(ctrl) failed: -1
kernel: [   11.734093] hid-multitouch 0003:1870:0110.0001: timeout initializing reports

Adding quirk HID_QUIRK_NO_INIT_REPORTS can solve the problem.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 050443460c46..4cc23648c510 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -636,6 +636,7 @@
 
 #define USB_VENDOR_ID_NEXIO		0x1870
 #define USB_DEVICE_ID_NEXIO_MULTITOUCH_420	0x010d
+#define USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750	0x0110
 
 #define USB_VENDOR_ID_NEXTWINDOW	0x1926
 #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 175ec0afb70c..dbd83878ff99 100644
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
1.9.3

