Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3GVAkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:40:51 -0400
Received: from mail-gg0-f169.google.com ([209.85.161.169]:40897 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab3GVAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:40:49 -0400
From: David Graham White <dgwhite11@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, David Graham White <dgwhite11@gmail.com>
Subject: [PATCH] drivers:base:core: Moved sym export macros to respective functions
Date: Sun, 21 Jul 2013 20:41:14 -0400
Message-Id: <1374453674-6832-1-git-send-email-dgwhite11@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved 11 calls to the EXPORT_SYMBOL_GPL beneath their respective functions per
checkpatch.pl warnings.

Signed-off-by: David Graham White <dgwhite11@gmail.com>
---
 drivers/base/core.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8856d74..4b9b0d7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -626,6 +626,7 @@ int device_create_file(struct device *dev,
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(device_create_file);
 
 /**
  * device_remove_file - remove sysfs attribute file.
@@ -638,6 +639,7 @@ void device_remove_file(struct device *dev,
 	if (dev)
 		sysfs_remove_file(&dev->kobj, &attr->attr);
 }
+EXPORT_SYMBOL_GPL(device_remove_file);
 
 /**
  * device_create_bin_file - create sysfs binary attribute file for device.
@@ -748,6 +750,7 @@ void device_initialize(struct device *dev)
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }
+EXPORT_SYMBOL_GPL(device_initialize);
 
 struct kobject *virtual_device_parent(struct device *dev)
 {
@@ -1187,6 +1190,7 @@ name_error:
 	dev->p = NULL;
 	goto done;
 }
+EXPORT_SYMBOL_GPL(device_add);
 
 /**
  * device_register - register a device with the system.
@@ -1211,6 +1215,7 @@ int device_register(struct device *dev)
 	device_initialize(dev);
 	return device_add(dev);
 }
+EXPORT_SYMBOL_GPL(device_register);
 
 /**
  * get_device - increment reference count for device.
@@ -1224,6 +1229,7 @@ struct device *get_device(struct device *dev)
 {
 	return dev ? kobj_to_dev(kobject_get(&dev->kobj)) : NULL;
 }
+EXPORT_SYMBOL_GPL(get_device);
 
 /**
  * put_device - decrement reference count.
@@ -1235,6 +1241,7 @@ void put_device(struct device *dev)
 	if (dev)
 		kobject_put(&dev->kobj);
 }
+EXPORT_SYMBOL_GPL(put_device);
 
 /**
  * device_del - delete device from system.
@@ -1297,6 +1304,7 @@ void device_del(struct device *dev)
 	kobject_del(&dev->kobj);
 	put_device(parent);
 }
+EXPORT_SYMBOL_GPL(device_del);
 
 /**
  * device_unregister - unregister device from system.
@@ -1315,6 +1323,7 @@ void device_unregister(struct device *dev)
 	device_del(dev);
 	put_device(dev);
 }
+EXPORT_SYMBOL_GPL(device_unregister);
 
 static struct device *next_device(struct klist_iter *i)
 {
@@ -1403,6 +1412,7 @@ int device_for_each_child(struct device *parent, void *data,
 	klist_iter_exit(&i);
 	return error;
 }
+EXPORT_SYMBOL_GPL(device_for_each_child);
 
 /**
  * device_find_child - device iterator for locating a particular device.
@@ -1437,6 +1447,7 @@ struct device *device_find_child(struct device *parent, void *data,
 	klist_iter_exit(&i);
 	return child;
 }
+EXPORT_SYMBOL_GPL(device_find_child);
 
 int __init devices_init(void)
 {
@@ -1464,21 +1475,6 @@ int __init devices_init(void)
 	return -ENOMEM;
 }
 
-EXPORT_SYMBOL_GPL(device_for_each_child);
-EXPORT_SYMBOL_GPL(device_find_child);
-
-EXPORT_SYMBOL_GPL(device_initialize);
-EXPORT_SYMBOL_GPL(device_add);
-EXPORT_SYMBOL_GPL(device_register);
-
-EXPORT_SYMBOL_GPL(device_del);
-EXPORT_SYMBOL_GPL(device_unregister);
-EXPORT_SYMBOL_GPL(get_device);
-EXPORT_SYMBOL_GPL(put_device);
-
-EXPORT_SYMBOL_GPL(device_create_file);
-EXPORT_SYMBOL_GPL(device_remove_file);
-
 static DEFINE_MUTEX(device_hotplug_lock);
 
 void lock_device_hotplug(void)
-- 
1.8.3.2

