Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3GKAhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:37:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3GKAg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:36:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: oliver+list@schinagl.nl, linux@roeck-us.net, khali@linux-fr.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 4/7] driver core: device.h: add RW and RO attribute macros
Date: Wed, 10 Jul 2013 17:36:02 -0700
Message-Id: <1373502965-1683-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to create attributes without having to always audit the
mode settings.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index bcf8c0d..f207a8f 100644
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

