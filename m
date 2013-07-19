Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab3GSOqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:46:06 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:52549 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSOqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:46:04 -0400
From: Alexandru Juncu <alexj@rosedu.org>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com, tao.peng@emc.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Alexandru Juncu <alexj@rosedu.org>
Subject: [PATCH] lustre:libcfs: remove redundant code.
Date: Fri, 19 Jul 2013 17:45:48 +0300
Message-Id: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using coccinelle. It suggested kmalloc/strcpy should be replaced
with kstrdup, but the entire function can be replaced by kstrdup.

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 drivers/staging/lustre/lustre/libcfs/libcfs_string.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
index 9edccc9..4dba304 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
@@ -135,18 +135,7 @@ EXPORT_SYMBOL(cfs_str2mask);
 /* Duplicate a string in a platform-independent way */
 char *cfs_strdup(const char *str, u_int32_t flags)
 {
-	size_t lenz; /* length of str + zero byte */
-	char *dup_str;
-
-	lenz = strlen(str) + 1;
-
-	dup_str = kmalloc(lenz, flags);
-	if (dup_str == NULL)
-		return NULL;
-
-	memcpy(dup_str, str, lenz);
-
-	return dup_str;
+	return kstrdup(str, flags);
 }
 EXPORT_SYMBOL(cfs_strdup);
 
-- 
1.8.1.2

