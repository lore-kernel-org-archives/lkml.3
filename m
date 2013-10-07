Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3JGG4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:56:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3JGG4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:56:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bruno Morelli <bruno@evidence.eu.com>, <linux-usb@vger.kernel.org>
Subject: [PATCH 05/11] uwb: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:44 -0700
Message-Id: <1381128950-28125-6-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the uwb bus code to use the
correct field.

Cc: Bruno Morelli <bruno@evidence.eu.com>
Cc: <linux-usb@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uwb/umc-bus.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/uwb/umc-bus.c b/drivers/uwb/umc-bus.c
index 5c5b3fc..e3ed6ff 100644
--- a/drivers/uwb/umc-bus.c
+++ b/drivers/uwb/umc-bus.c
@@ -201,6 +201,7 @@ static ssize_t capability_id_show(struct device *dev, struct device_attribute *a
 
 	return sprintf(buf, "0x%02x\n", umc->cap_id);
 }
+static DEVICE_ATTR_RO(capability_id);
 
 static ssize_t version_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -208,12 +209,14 @@ static ssize_t version_show(struct device *dev, struct device_attribute *attr, c
 
 	return sprintf(buf, "0x%04x\n", umc->version);
 }
+static DEVICE_ATTR_RO(version);
 
-static struct device_attribute umc_dev_attrs[] = {
-	__ATTR_RO(capability_id),
-	__ATTR_RO(version),
-	__ATTR_NULL,
+static struct attribute *umc_dev_attrs[] = {
+	&dev_attr_capability_id.attr,
+	&dev_attr_version.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(umc_dev);
 
 struct bus_type umc_bus_type = {
 	.name		= "umc",
@@ -222,7 +225,7 @@ struct bus_type umc_bus_type = {
 	.remove		= umc_device_remove,
 	.suspend        = umc_device_suspend,
 	.resume         = umc_device_resume,
-	.dev_attrs	= umc_dev_attrs,
+	.dev_groups	= umc_dev_groups,
 };
 EXPORT_SYMBOL_GPL(umc_bus_type);
 
-- 
1.8.4.6.g82e253f.dirty

