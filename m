Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536Ab3BSTJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:09:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162Ab3BSSwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: fangxiaozhi <huananhu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 32/81] USB: storage: Define a new macro for USB storage match rules
Date: Tue, 19 Feb 2013 15:48:55 -0300
Message-Id: <1361299784-8830-33-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangxiaozhi <huananhu@huawei.com>

commit 07c7be3d87e5cdaf5f94c271c516456364ef286c upstream.

1. Define a new macro for USB storage match rules:
    matching with Vendor ID and interface descriptors.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/storage/usb.c          |   12 ++++++++++++
 drivers/usb/storage/usual-tables.c |   15 +++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index e23c30a..2f232a2 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
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
@@ -131,6 +142,7 @@ static struct us_unusual_dev for_dynamic_ids =
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 #ifdef CONFIG_LOCKDEP
 
diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index b969279..a9b5f2e 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -46,6 +46,20 @@
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans), \
   .driver_info = ((useType)<<24) }
 
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
@@ -57,6 +71,7 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 
 /*
-- 
1.7.9.5

