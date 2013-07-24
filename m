Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3GXWG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3GXWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 15/36] x86: wmi: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:18 -0700
Message-Id: <1374703539-9705-16-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the wmi class code to use the
correct field.

Cc: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Matthew, feel free to take this through your tree, or ACK it and I can take it
through mine.

 drivers/platform/x86/wmi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index b13344c5..6e02c953 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -693,11 +693,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 
 	return sprintf(buf, "wmi:%s\n", guid_string);
 }
+static DEVICE_ATTR_RO(modalias);
 
-static struct device_attribute wmi_dev_attrs[] = {
-	__ATTR_RO(modalias),
-	__ATTR_NULL
+static struct attribute *wmi_attrs[] = {
+	&dev_attr_modalias.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(wmi);
 
 static int wmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -732,7 +734,7 @@ static struct class wmi_class = {
 	.name = "wmi",
 	.dev_release = wmi_dev_free,
 	.dev_uevent = wmi_dev_uevent,
-	.dev_attrs = wmi_dev_attrs,
+	.dev_groups = wmi_groups,
 };
 
 static int wmi_create_device(const struct guid_block *gblock,
-- 
1.8.3.rc0.20.gb99dd2e

