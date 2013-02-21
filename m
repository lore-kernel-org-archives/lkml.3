Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134Ab3BUW2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:28:00 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:52967 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743Ab3BUW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:27:57 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH] [RFC] usb: gadget: composite: Allow idVendor and other module_params to be writable
Date: Thu, 21 Feb 2013 14:27:27 -0800
Message-Id: <1361485647-9439-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In many cases, documentation around composite drivers suggest
setting the idVendor and other module params as follows:

$ insmod g_ffs.ko idVendor=<ID> iSerialNumber=<string>

However, this won't work if the driver is not compiled in as a
module, as the module_param permissions are S_IRUGO.

Thus this patch changes the composite module_param permissions
to S_IRUGO|S_IWUSR to allow the module_params to be set at
runtime via /sys/modules/<driver>/parameters/

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/usb/composite.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index b09c37e..22b1b02 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -399,24 +399,28 @@ struct usb_composite_overwrite {
 #define USB_GADGET_COMPOSITE_OPTIONS()					\
 	static struct usb_composite_overwrite coverwrite;		\
 									\
-	module_param_named(idVendor, coverwrite.idVendor, ushort, S_IRUGO); \
+	module_param_named(idVendor, coverwrite.idVendor, ushort,	\
+			S_IRUGO|S_IWUSR);				\
 	MODULE_PARM_DESC(idVendor, "USB Vendor ID");			\
 									\
-	module_param_named(idProduct, coverwrite.idProduct, ushort, S_IRUGO); \
+	module_param_named(idProduct, coverwrite.idProduct, ushort,	\
+			S_IRUGO|S_IWUSR);				\
 	MODULE_PARM_DESC(idProduct, "USB Product ID");			\
 									\
-	module_param_named(bcdDevice, coverwrite.bcdDevice, ushort, S_IRUGO); \
+	module_param_named(bcdDevice, coverwrite.bcdDevice, ushort,	\
+			S_IRUGO|S_IWUSR);				\
 	MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");	\
 									\
 	module_param_named(iSerialNumber, coverwrite.serial_number, charp, \
-			S_IRUGO); \
+			S_IRUGO|S_IWUSR);				\
 	MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");		\
 									\
 	module_param_named(iManufacturer, coverwrite.manufacturer, charp, \
-			S_IRUGO); \
+			S_IRUGO|S_IWUSR);				\
 	MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");	\
 									\
-	module_param_named(iProduct, coverwrite.product, charp, S_IRUGO); \
+	module_param_named(iProduct, coverwrite.product, charp,		\
+			S_IRUGO|S_IWUSR);				\
 	MODULE_PARM_DESC(iProduct, "USB Product string")
 
 void usb_composite_overwrite_options(struct usb_composite_dev *cdev,
-- 
1.7.10.4

