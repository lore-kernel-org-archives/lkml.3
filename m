Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3JGG6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:58:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3JGGzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:55:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 11/11] hsi: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:50 -0700
Message-Id: <1381128950-28125-12-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the hsi code to use the
correct field.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hsi/hsi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 66d4458..749f7b5 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -33,11 +33,13 @@ static ssize_t modalias_show(struct device *dev,
 {
 	return sprintf(buf, "hsi:%s\n", dev_name(dev));
 }
+static DEVICE_ATTR_RO(modalias);
 
-static struct device_attribute hsi_bus_dev_attrs[] = {
-	__ATTR_RO(modalias),
-	__ATTR_NULL,
+static struct attribute *hsi_bus_dev_attrs[] = {
+	&dev_attr_modalias.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(hsi_bus_dev);
 
 static int hsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -53,7 +55,7 @@ static int hsi_bus_match(struct device *dev, struct device_driver *driver)
 
 static struct bus_type hsi_bus_type = {
 	.name		= "hsi",
-	.dev_attrs	= hsi_bus_dev_attrs,
+	.dev_groups	= hsi_bus_dev_groups,
 	.match		= hsi_bus_match,
 	.uevent		= hsi_bus_uevent,
 };
-- 
1.8.4.6.g82e253f.dirty

