Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3GXWOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:14:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3GXWGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH 22/36] staging: comedi: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:25 -0700
Message-Id: <1374703539-9705-23-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the comedi class code to use the
correct field.

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_fops.c | 39 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 86475182..2f2ff8f0 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -262,7 +262,7 @@ static int resize_async_buffer(struct comedi_device *dev,
 
 /* sysfs attribute files */
 
-static ssize_t show_max_read_buffer_kb(struct device *csdev,
+static ssize_t max_read_buffer_kb_show(struct device *csdev,
 				       struct device_attribute *attr, char *buf)
 {
 	unsigned int minor = MINOR(csdev->devt);
@@ -283,7 +283,7 @@ static ssize_t show_max_read_buffer_kb(struct device *csdev,
 	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
-static ssize_t store_max_read_buffer_kb(struct device *csdev,
+static ssize_t max_read_buffer_kb_store(struct device *csdev,
 					struct device_attribute *attr,
 					const char *buf, size_t count)
 {
@@ -314,8 +314,9 @@ static ssize_t store_max_read_buffer_kb(struct device *csdev,
 
 	return err ? err : count;
 }
+static DEVICE_ATTR_RW(max_read_buffer_kb);
 
-static ssize_t show_read_buffer_kb(struct device *csdev,
+static ssize_t read_buffer_kb_show(struct device *csdev,
 				   struct device_attribute *attr, char *buf)
 {
 	unsigned int minor = MINOR(csdev->devt);
@@ -336,7 +337,7 @@ static ssize_t show_read_buffer_kb(struct device *csdev,
 	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
-static ssize_t store_read_buffer_kb(struct device *csdev,
+static ssize_t read_buffer_kb_store(struct device *csdev,
 				    struct device_attribute *attr,
 				    const char *buf, size_t count)
 {
@@ -367,8 +368,9 @@ static ssize_t store_read_buffer_kb(struct device *csdev,
 
 	return err ? err : count;
 }
+static DEVICE_ATTR_RW(read_buffer_kb);
 
-static ssize_t show_max_write_buffer_kb(struct device *csdev,
+static ssize_t max_write_buffer_kb_show(struct device *csdev,
 					struct device_attribute *attr,
 					char *buf)
 {
@@ -390,7 +392,7 @@ static ssize_t show_max_write_buffer_kb(struct device *csdev,
 	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
-static ssize_t store_max_write_buffer_kb(struct device *csdev,
+static ssize_t max_write_buffer_kb_store(struct device *csdev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
@@ -421,8 +423,9 @@ static ssize_t store_max_write_buffer_kb(struct device *csdev,
 
 	return err ? err : count;
 }
+static DEVICE_ATTR_RW(max_write_buffer_kb);
 
-static ssize_t show_write_buffer_kb(struct device *csdev,
+static ssize_t write_buffer_kb_show(struct device *csdev,
 				    struct device_attribute *attr, char *buf)
 {
 	unsigned int minor = MINOR(csdev->devt);
@@ -443,7 +446,7 @@ static ssize_t show_write_buffer_kb(struct device *csdev,
 	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
-static ssize_t store_write_buffer_kb(struct device *csdev,
+static ssize_t write_buffer_kb_store(struct device *csdev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
@@ -474,18 +477,16 @@ static ssize_t store_write_buffer_kb(struct device *csdev,
 
 	return err ? err : count;
 }
+static DEVICE_ATTR_RW(write_buffer_kb);
 
-static struct device_attribute comedi_dev_attrs[] = {
-	__ATTR(max_read_buffer_kb, S_IRUGO | S_IWUSR,
-		show_max_read_buffer_kb, store_max_read_buffer_kb),
-	__ATTR(read_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
-		show_read_buffer_kb, store_read_buffer_kb),
-	__ATTR(max_write_buffer_kb, S_IRUGO | S_IWUSR,
-		show_max_write_buffer_kb, store_max_write_buffer_kb),
-	__ATTR(write_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
-		show_write_buffer_kb, store_write_buffer_kb),
-	__ATTR_NULL
+static struct attribute *comedi_dev_attrs[] = {
+	&dev_attr_max_read_buffer_kb.attr,
+	&dev_attr_read_buffer_kb.attr,
+	&dev_attr_max_write_buffer_kb.attr,
+	&dev_attr_write_buffer_kb.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(comedi_dev);
 
 static void comedi_set_subdevice_runflags(struct comedi_subdevice *s,
 					  unsigned mask, unsigned bits)
@@ -2554,7 +2555,7 @@ static int __init comedi_init(void)
 		return PTR_ERR(comedi_class);
 	}
 
-	comedi_class->dev_attrs = comedi_dev_attrs;
+	comedi_class->dev_groups = comedi_dev_groups;
 
 	/* XXX requires /proc interface */
 	comedi_proc_init();
-- 
1.8.3.rc0.20.gb99dd2e

