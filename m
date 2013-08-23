Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3HWV01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:26:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3HWVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:25:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 12/15] HID: convert bus code to use dev_groups
Date: Fri, 23 Aug 2013 14:24:38 -0700
Message-Id: <1377293081-10957-12-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the HID bus code to use
the correct field.

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 36668d1a..b8f1c77f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1917,11 +1917,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 
 	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
 }
+static DEVICE_ATTR_RO(modalias);
 
-static struct device_attribute hid_dev_attrs[] = {
-	__ATTR_RO(modalias),
-	__ATTR_NULL,
+static struct attribute *hid_dev_attrs[] = {
+	&dev_attr_modalias.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(hid_dev);
 
 static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -1949,7 +1951,7 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static struct bus_type hid_bus_type = {
 	.name		= "hid",
-	.dev_attrs	= hid_dev_attrs,
+	.dev_groups	= hid_dev_groups,
 	.match		= hid_bus_match,
 	.probe		= hid_device_probe,
 	.remove		= hid_device_remove,
-- 
1.8.3.rc0.20.gb99dd2e

