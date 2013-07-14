Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3GNXJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:09:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab3GNXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/10] sysfs.h: add BIN_ATTR macro
Date: Sun, 14 Jul 2013 16:05:53 -0700
Message-Id: <1373843160-3990-4-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to create static binary attributes, which is needed
in a number of drivers, instead of "open coding" them.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sysfs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f62ff01e..d50a96b9 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -132,6 +132,15 @@ struct bin_attribute {
  */
 #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
 
+/* macro to create static binary attributes easier */
+#define BIN_ATTR(_name, _mode, _read, _write, _size)		\
+struct bin_attribute bin_attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.read	= _read,					\
+	.write	= _write,					\
+	.size	= _size,					\
+}
+
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
-- 
1.8.3.rc0.20.gb99dd2e

