Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3GNXGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:06:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3GNXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 04/10] driver core: device.h: add RW and RO attribute macros
Date: Sun, 14 Jul 2013 16:05:54 -0700
Message-Id: <1373843160-3990-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to create attributes without having to always audit the
mode settings.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index bcf8c0d4..f207a8f4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -47,7 +47,11 @@ struct bus_attribute {
 };
 
 #define BUS_ATTR(_name, _mode, _show, _store)	\
-struct bus_attribute bus_attr_##_name = __ATTR(_name, _mode, _show, _store)
+	struct bus_attribute bus_attr_##_name = __ATTR(_name, _mode, _show, _store)
+#define BUS_ATTR_RW(_name) \
+	struct bus_attribute bus_attr_##_name = __ATTR_RW(_name)
+#define BUS_ATTR_RO(_name) \
+	struct bus_attribute bus_attr_##_name = __ATTR_RO(_name)
 
 extern int __must_check bus_create_file(struct bus_type *,
 					struct bus_attribute *);
@@ -261,9 +265,12 @@ struct driver_attribute {
 			 size_t count);
 };
 
-#define DRIVER_ATTR(_name, _mode, _show, _store)	\
-struct driver_attribute driver_attr_##_name =		\
-	__ATTR(_name, _mode, _show, _store)
+#define DRIVER_ATTR(_name, _mode, _show, _store) \
+	struct driver_attribute driver_attr_##_name = __ATTR(_name, _mode, _show, _store)
+#define DRIVER_ATTR_RW(_name) \
+	struct driver_attribute driver_attr_##_name = __ATTR_RW(_name)
+#define DRIVER_ATTR_RO(_name) \
+	struct driver_attribute driver_attr_##_name = __ATTR_RO(_name)
 
 extern int __must_check driver_create_file(struct device_driver *driver,
 					const struct driver_attribute *attr);
@@ -414,8 +421,12 @@ struct class_attribute {
 				 const struct class_attribute *attr);
 };
 
-#define CLASS_ATTR(_name, _mode, _show, _store)			\
-struct class_attribute class_attr_##_name = __ATTR(_name, _mode, _show, _store)
+#define CLASS_ATTR(_name, _mode, _show, _store) \
+	struct class_attribute class_attr_##_name = __ATTR(_name, _mode, _show, _store)
+#define CLASS_ATTR_RW(_name) \
+	struct class_attribute class_attr_##_name = __ATTR_RW(_name)
+#define CLASS_ATTR_RO(_name) \
+	struct class_attribute class_attr_##_name = __ATTR_RO(_name)
 
 extern int __must_check class_create_file(struct class *class,
 					  const struct class_attribute *attr);
@@ -423,7 +434,6 @@ extern void class_remove_file(struct class *class,
 			      const struct class_attribute *attr);
 
 /* Simple class attribute that is just a static string */
-
 struct class_attribute_string {
 	struct class_attribute attr;
 	char *str;
@@ -512,6 +522,10 @@ ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
 
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
+#define DEVICE_ATTR_RW(_name) \
+	struct device_attribute dev_attr_##_name = __ATTR_RW(_name)
+#define DEVICE_ATTR_RO(_name) \
+	struct device_attribute dev_attr_##_name = __ATTR_RO(_name)
 #define DEVICE_ULONG_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
-- 
1.8.3.rc0.20.gb99dd2e

