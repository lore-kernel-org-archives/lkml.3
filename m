Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3HWVZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:25:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab3HWVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:25:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 13/15] MEI: convert bus code to use dev_groups
Date: Fri, 23 Aug 2013 14:24:39 -0700
Message-Id: <1377293081-10957-13-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the MEI bus code to use
the correct field.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 9ecd49a7..2ce92a6a 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -108,11 +108,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 
 	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
 }
+static DEVICE_ATTR_RO(modalias);
 
-static struct device_attribute mei_cl_dev_attrs[] = {
-	__ATTR_RO(modalias),
-	__ATTR_NULL,
+static struct attribute *mei_cl_dev_attrs[] = {
+	&dev_attr_modalias.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(mei_cl_dev);
 
 static int mei_cl_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -124,7 +126,7 @@ static int mei_cl_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static struct bus_type mei_cl_bus_type = {
 	.name		= "mei",
-	.dev_attrs	= mei_cl_dev_attrs,
+	.dev_groups	= mei_cl_dev_groups,
 	.match		= mei_cl_device_match,
 	.probe		= mei_cl_device_probe,
 	.remove		= mei_cl_device_remove,
-- 
1.8.3.rc0.20.gb99dd2e

