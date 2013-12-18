Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3LRWU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:20:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:08:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH 3.4 14/31] USB: serial: option: blacklist interface 1 for Huawei E173s-6
Date: Wed, 18 Dec 2013 13:08:22 -0800
Message-Id: <20131218210523.199017463@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -85,6 +85,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
+#define HUAWEI_PRODUCT_E173S6			0x1C07
 
 #define QUANTA_VENDOR_ID			0x0408
 #define QUANTA_PRODUCT_Q101			0xEA02
@@ -586,6 +587,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173S6, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1750, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1441, USB_CLASS_COMM, 0x02, 0xff) },


