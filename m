Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBIJAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 04:00:22 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34309 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaBIJAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 04:00:21 -0500
From: Raymond Wanyoike <raymond.wanyoike@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bjorn@mork.no,
        Raymond Wanyoike <raymond.wanyoike@gmail.com>
Subject: [RFC] usb: option: blacklist ZTE MF667 net interface
Date: Sun,  9 Feb 2014 11:59:46 +0300
Message-Id: <1391936386-2890-1-git-send-email-raymond.wanyoike@gmail.com>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interface #5 of 19d2:1270 is a net interface which has been submitted to the
qmi_wwan driver so consequently remove it from the option driver.

Signed-off-by: Raymond Wanyoike <raymond.wanyoike@gmail.com>
---
 drivers/usb/serial/option.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5c86f57..216d20a 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1362,7 +1362,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1267, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1268, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1269, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1270, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1270, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1271, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1272, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1273, 0xff, 0xff, 0xff) },
-- 
1.8.5.4

