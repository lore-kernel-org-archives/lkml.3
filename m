Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3JHCRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:17:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3JHCRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:17:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/8] memstick: convert bus code to use dev_groups
Date: Mon,  7 Oct 2013 18:27:41 -0700
Message-Id: <1381195662-28009-8-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the memstick bus code to use the
correct field.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/memstick.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index ffcb10a..bbf4aea 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -153,24 +153,24 @@ static ssize_t name##_show(struct device *dev, struct device_attribute *attr, \
 	struct memstick_dev *card = container_of(dev, struct memstick_dev,    \
 						 dev);                        \
 	return sprintf(buf, format, card->id.name);                           \
-}
+}                                                                             \
+static DEVICE_ATTR_RO(name);
 
 MEMSTICK_ATTR(type, "%02X");
 MEMSTICK_ATTR(category, "%02X");
 MEMSTICK_ATTR(class, "%02X");
 
-#define MEMSTICK_ATTR_RO(name) __ATTR(name, S_IRUGO, name##_show, NULL)
-
-static struct device_attribute memstick_dev_attrs[] = {
-	MEMSTICK_ATTR_RO(type),
-	MEMSTICK_ATTR_RO(category),
-	MEMSTICK_ATTR_RO(class),
-	__ATTR_NULL
+static struct attribute *memstick_dev_attrs[] = {
+	&dev_attr_type.attr,
+	&dev_attr_category.attr,
+	&dev_attr_class.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(memstick_dev);
 
 static struct bus_type memstick_bus_type = {
 	.name           = "memstick",
-	.dev_attrs      = memstick_dev_attrs,
+	.dev_groups	= memstick_dev_groups,
 	.match          = memstick_bus_match,
 	.uevent         = memstick_uevent,
 	.probe          = memstick_device_probe,
-- 
1.8.4.6.g82e253f.dirty

