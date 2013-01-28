Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3A1PrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:47:23 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:38725 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3A1PrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:47:21 -0500
From: Daniele Palmas <dnlplm@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] USB: option: add support for Telit LE920
Date: Mon, 28 Jan 2013 16:47:10 +0100
Message-Id: <1359388030-2821-1-git-send-email-dnlplm@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: danielepa <danielepa@L2011.(none)>

Add PID and special handling for Telit LE920

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/usb/serial/option.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 0d9dac9..384bb92 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -242,6 +242,7 @@ static void option_instat_callback(struct urb *urb);
 #define TELIT_PRODUCT_CC864_DUAL		0x1005
 #define TELIT_PRODUCT_CC864_SINGLE		0x1006
 #define TELIT_PRODUCT_DE910_DUAL		0x1010
+#define TELIT_PRODUCT_LE920			0x1200
 
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -534,6 +535,11 @@ static const struct option_blacklist_info zte_1255_blacklist = {
 	.reserved = BIT(3) | BIT(4),
 };
 
+static const struct option_blacklist_info telit_le920_blacklist = {
+	.sendsetup = BIT(0),
+	.reserved = BIT(1) | BIT(5),
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -784,6 +790,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
+		.driver_info = (kernel_ulong_t)&telit_le920_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf1_blacklist },
-- 
1.7.4.1

