Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3GXWP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:15:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3GXWGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>
Subject: [PATCH 20/36] UIO: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:23 -0700
Message-Id: <1374703539-9705-21-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the uio class code to use the
correct field.

Cc: Hans J. Koch <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 3b96f185..170a178d 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -224,38 +224,42 @@ static struct kobj_type portio_attr_type = {
 	.default_attrs	= portio_attrs,
 };
 
-static ssize_t show_name(struct device *dev,
+static ssize_t name_show(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
 	return sprintf(buf, "%s\n", idev->info->name);
 }
+static DEVICE_ATTR_RO(name);
 
-static ssize_t show_version(struct device *dev,
+static ssize_t version_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
 	return sprintf(buf, "%s\n", idev->info->version);
 }
+static DEVICE_ATTR_RO(version);
 
-static ssize_t show_event(struct device *dev,
+static ssize_t event_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
 	return sprintf(buf, "%u\n", (unsigned int)atomic_read(&idev->event));
 }
+static DEVICE_ATTR_RO(event);
 
-static struct device_attribute uio_class_attributes[] = {
-	__ATTR(name, S_IRUGO, show_name, NULL),
-	__ATTR(version, S_IRUGO, show_version, NULL),
-	__ATTR(event, S_IRUGO, show_event, NULL),
-	{}
+static struct attribute *uio_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_version.attr,
+	&dev_attr_event.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(uio);
 
 /* UIO class infrastructure */
 static struct class uio_class = {
 	.name = "uio",
-	.dev_attrs = uio_class_attributes,
+	.dev_groups = uio_groups,
 };
 
 /*
-- 
1.8.3.rc0.20.gb99dd2e

