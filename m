Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaDVEAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:00:14 -0400
Received: from ozlabs.org ([103.22.144.67]:37801 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbaDVD7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/9] drivers/mtd/devices/docg3.c: avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:24 +0930
Message-Id: <1398137612-9714-2-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/mtd/devices/docg3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index dd5e1018d37b..91a169c44b39 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1608,8 +1608,8 @@ static ssize_t dps1_insert_key(struct device *dev,
 #define FLOOR_SYSFS(id) { \
 	__ATTR(f##id##_dps0_is_keylocked, S_IRUGO, dps0_is_key_locked, NULL), \
 	__ATTR(f##id##_dps1_is_keylocked, S_IRUGO, dps1_is_key_locked, NULL), \
-	__ATTR(f##id##_dps0_protection_key, S_IWUGO, NULL, dps0_insert_key), \
-	__ATTR(f##id##_dps1_protection_key, S_IWUGO, NULL, dps1_insert_key), \
+	__ATTR(f##id##_dps0_protection_key, S_IWUSR|S_IWGRP, NULL, dps0_insert_key), \
+	__ATTR(f##id##_dps1_protection_key, S_IWUSR|S_IWGRP, NULL, dps1_insert_key), \
 }
 
 static struct device_attribute doc_sys_attrs[DOC_MAX_NBFLOORS][4] = {
-- 
1.8.3.2

