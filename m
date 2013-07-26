Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3GZUvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:51:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab3GZUtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:49:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniil Bolsun <dan.bolsun@gmail.com>
Subject: [ 63/79] USB: option: append Petatel NP10T device to GSM modems list
Date: Fri, 26 Jul 2013 13:47:53 -0700
Message-Id: <20130726204729.358689352@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Bolsun <dan.bolsun@gmail.com>

commit c38e83b6cc2adf80e3f091fd92cfbeacc9748347 upstream.

This patch was tested on 3.10.1 kernel.

Same models of Petatel NP10T modems have different device IDs.
Unfortunately they have no additional revision information on a board
which may treat them as different devices. Currently I've seen only
two NP10T devices with various IDs. Possibly Petatel NP10T list will
be appended upon devices with new IDs will appear.

Signed-off-by: Daniil Bolsun <dan.bolsun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -439,7 +439,8 @@ static void option_instat_callback(struc
 
 /* Hyundai Petatel Inc. products */
 #define PETATEL_VENDOR_ID			0x1ff4
-#define PETATEL_PRODUCT_NP10T			0x600e
+#define PETATEL_PRODUCT_NP10T_600A		0x600a
+#define PETATEL_PRODUCT_NP10T_600E		0x600e
 
 /* TP-LINK Incorporated products */
 #define TPLINK_VENDOR_ID			0x2357
@@ -1325,7 +1326,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
-	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
+	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
+	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
 	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(TPLINK_VENDOR_ID, 0x9000),					/* TP-Link MA260 */


