Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab3BHBPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:15:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab3BHA5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        fangxiaozhi <huananhu@huawei.com>
Subject: [ 28/34] USB: storage: Define a new macro for USB storage match rules
Date: Thu,  7 Feb 2013 16:57:24 -0800
Message-Id: <20130208004631.749331933@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangxiaozhi <huananhu@huawei.com>

commit 07c7be3d87e5cdaf5f94c271c516456364ef286c upstream.

1. Define a new macro for USB storage match rules:
    matching with Vendor ID and interface descriptors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/usb.c          |   12 ++++++++++++
 drivers/usb/storage/usual-tables.c |   15 +++++++++++++++
 2 files changed, 27 insertions(+)

--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
 	.useTransport = use_transport,	\
 }
 
+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
+		vendor_name, product_name, use_protocol, use_transport, \
+		init_function, Flags) \
+{ \
+	.vendorName = vendor_name,	\
+	.productName = product_name,	\
+	.useProtocol = use_protocol,	\
+	.useTransport = use_transport,	\
+	.initFunction = init_function,	\
+}
+
 static struct us_unusual_dev us_unusual_dev_list[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -131,6 +142,7 @@ static struct us_unusual_dev for_dynamic
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 #ifdef CONFIG_LOCKDEP
 
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -41,6 +41,20 @@
 #define USUAL_DEV(useProto, useTrans) \
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
 
+/* Define the device is matched with Vendor ID and interface descriptors */
+#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
+			vendorName, productName, useProtocol, useTransport, \
+			initFunction, flags) \
+{ \
+	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
+				| USB_DEVICE_ID_MATCH_VENDOR, \
+	.idVendor    = (id_vendor), \
+	.bInterfaceClass = (cl), \
+	.bInterfaceSubClass = (sc), \
+	.bInterfaceProtocol = (pr), \
+	.driver_info = (flags) \
+}
+
 struct usb_device_id usb_storage_usb_ids[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -50,6 +64,7 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 /*
  * The table of devices to ignore


