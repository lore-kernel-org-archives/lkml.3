Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaAOWkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:40:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40704 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaAOVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 016/166] USB: serial: option: blacklist interface 1 for Huawei E173s-6
Date: Wed, 15 Jan 2014 13:50:30 -0800
Message-Id: <1389822780-4729-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Zacarias <gustavo@zacarias.com.ar>

commit 8f173e22abf2258ddfa73f46eadbb6a6c29f1631 upstream.

Interface 1 on this device isn't for option to bind to otherwise an oops
on usb_wwan with log flooding will happen when accessing the port:

tty_release: ttyUSB1: read/write wait queue active!

It doesn't seem to respond to QMI if it's added to qmi_wwan so don't add
it there - it's likely used by the card reader.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 4da1743..0ec2147 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -85,6 +85,7 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
+#define HUAWEI_PRODUCT_E173S6			0x1C07
 
 #define QUANTA_VENDOR_ID			0x0408
 #define QUANTA_PRODUCT_Q101			0xEA02
@@ -572,6 +573,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173S6, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1750, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1441, USB_CLASS_COMM, 0x02, 0xff) },
-- 
1.8.3.2

