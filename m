Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3GJUFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:05:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3GJUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:05:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: oliver+list@schinagl.nl, linux@roeck-us.net, khali@linux-fr.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/6] sysfs.h: add ATTRIBUTE_GROUPS() macro
Date: Wed, 10 Jul 2013 13:05:10 -0700
Message-Id: <1373486714-14531-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make it easier for driver subsystems to work with attribute groups,
create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
typing for the most common use for attribute groups.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sysfs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 9cd20c8..f62ff01 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -94,6 +94,15 @@ struct attribute_group {
 #define __ATTR_IGNORE_LOCKDEP	__ATTR
 #endif
 
+#define ATTRIBUTE_GROUPS(name)					\
+static const struct attribute_group name##_group = {		\
+	.attrs = name##_attrs,					\
+};								\
+static const struct attribute_group *name##_groups[] = {	\
+	&name##_group,						\
+	NULL,							\
+}
+
 #define attr_name(_attr) (_attr).attr.name
 
 struct file;
-- 
1.8.3.rc0.20.gb99dd2e

