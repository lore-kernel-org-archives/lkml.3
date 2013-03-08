Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3CHNAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:00:02 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49917 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3CHNAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:00:00 -0500
From: Valentin Ilie <valentin.ilie@gmail.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] amba: bus: Fix checkpatch warnings
Date: Fri,  8 Mar 2013 14:59:46 +0200
Message-Id: <1362747586-27384-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warnings:
- ERROR: space required after that ','.
- WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/amba/bus.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index cdbad3a..d214ba7 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -58,7 +58,7 @@ static int amba_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return retval;
 }
 
-#define amba_attr_func(name,fmt,arg...)					\
+#define amba_attr_func(name, fmt, arg...)				\
 static ssize_t name##_show(struct device *_dev,				\
 			   struct device_attribute *attr, char *buf)	\
 {									\
@@ -66,8 +66,8 @@ static ssize_t name##_show(struct device *_dev,				\
 	return sprintf(buf, fmt, arg);					\
 }
 
-#define amba_attr(name,fmt,arg...)	\
-amba_attr_func(name,fmt,arg)		\
+#define amba_attr(name, fmt, arg...)	\
+amba_attr_func(name, fmt, arg)		\
 static DEVICE_ATTR(name, S_IRUGO, name##_show, NULL)
 
 amba_attr_func(id, "%08x\n", dev->periphid);
@@ -428,6 +428,7 @@ int amba_driver_register(struct amba_driver *drv)
 
 	return driver_register(&drv->drv);
 }
+EXPORT_SYMBOL(amba_driver_register);
 
 /**
  *	amba_driver_unregister - remove an AMBA device driver
@@ -441,7 +442,7 @@ void amba_driver_unregister(struct amba_driver *drv)
 {
 	driver_unregister(&drv->drv);
 }
-
+EXPORT_SYMBOL(amba_driver_unregister);
 
 static void amba_device_release(struct device *dev)
 {
@@ -668,6 +669,7 @@ int amba_device_register(struct amba_device *dev, struct resource *parent)
 
 	return amba_device_add(dev, parent);
 }
+EXPORT_SYMBOL(amba_device_register);
 
 /**
  *	amba_device_put - put an AMBA device
@@ -694,7 +696,7 @@ void amba_device_unregister(struct amba_device *dev)
 {
 	device_unregister(&dev->dev);
 }
-
+EXPORT_SYMBOL(amba_device_unregister);
 
 struct find_data {
 	struct amba_device *dev;
@@ -754,6 +756,7 @@ amba_find_device(const char *busid, struct device *parent, unsigned int id,
 
 	return data.dev;
 }
+EXPORT_SYMBOL(amba_find_device);
 
 /**
  *	amba_request_regions - request all mem regions associated with device
@@ -775,6 +778,7 @@ int amba_request_regions(struct amba_device *dev, const char *name)
 
 	return ret;
 }
+EXPORT_SYMBOL(amba_request_regions);
 
 /**
  *	amba_release_regions - release mem regions associated with device
@@ -789,11 +793,4 @@ void amba_release_regions(struct amba_device *dev)
 	size = resource_size(&dev->res);
 	release_mem_region(dev->res.start, size);
 }
-
-EXPORT_SYMBOL(amba_driver_register);
-EXPORT_SYMBOL(amba_driver_unregister);
-EXPORT_SYMBOL(amba_device_register);
-EXPORT_SYMBOL(amba_device_unregister);
-EXPORT_SYMBOL(amba_find_device);
-EXPORT_SYMBOL(amba_request_regions);
 EXPORT_SYMBOL(amba_release_regions);
-- 
1.7.10.4

