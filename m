Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3GLHCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:02:16 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:40641 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3GLHCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:02:15 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andreas.dilger@intel.com, tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] staging/lustre/libcfs: replaced string duplication code with kstrdup
Date: Fri, 12 Jul 2013 10:02:06 +0300
Message-Id: <1373612526-15990-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified cfs_strdup function to use kstrdup instead of duplicating its
implementation.

Found using Coccinelle.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/libcfs_string.c |   13 +------------
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
1.7.10.4

