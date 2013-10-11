Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab3JKTve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:51:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799Ab3JKTmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 102/135] USB: serial: option: Ignore card reader interface on Huawei E1750
Date: Fri, 11 Oct 2013 12:39:43 -0700
Message-Id: <20131011193956.338800036@linuxfoundation.org>
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

From: Michal Malý <madcatxster@prifuk.cz>

commit eb2addd4044b4b2ce77693bde5bc810536dd96ee upstream.

Hi,

my Huawei 3G modem has an embedded Smart Card reader which causes
trouble when the modem is being detected (a bunch of "<warn>  (ttyUSBx):
open blocked by driver for more than 7 seconds!" in messages.log). This
trivial patch corrects the problem for me. The modem identifies itself
as "12d1:1406 Huawei Technologies Co., Ltd. E1750" in lsusb although the
description on the body says "Model E173u-1"

Signed-off-by: Michal Malý <madcatxster@prifuk.cz>
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -81,6 +81,7 @@ static void option_instat_callback(struc
 
 #define HUAWEI_VENDOR_ID			0x12D1
 #define HUAWEI_PRODUCT_E173			0x140C
+#define HUAWEI_PRODUCT_E1750			0x1406
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
@@ -567,6 +568,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1750, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t) &net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1441, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1442, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4505, 0xff, 0xff, 0xff),


