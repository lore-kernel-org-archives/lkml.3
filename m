Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3BHA6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:58:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589Ab3BHA6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [ 14/26] USB: option: add support for Telit LE920
Date: Thu,  7 Feb 2013 16:57:42 -0800
Message-Id: <20130208004629.761411319@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 03eb466f276ceef9dcf023dc5474db02af68aad9 upstream.

Add PID and special handling for Telit LE920

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -242,6 +242,7 @@ static void option_instat_callback(struc
 #define TELIT_PRODUCT_CC864_DUAL		0x1005
 #define TELIT_PRODUCT_CC864_SINGLE		0x1006
 #define TELIT_PRODUCT_DE910_DUAL		0x1010
+#define TELIT_PRODUCT_LE920			0x1200
 
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -534,6 +535,11 @@ static const struct option_blacklist_inf
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
@@ -784,6 +790,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
+		.driver_info = (kernel_ulong_t)&telit_le920_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf1_blacklist },


