Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab3CMTNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:13:21 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48736 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3CMTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:13:20 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] arch: s390: hypfs: Use PTR_RET function
Date: Wed, 13 Mar 2013 21:12:38 +0200
Message-Id: <1363201958-17855-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 arch/s390/hypfs/hypfs_dbfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/hypfs/hypfs_dbfs.c b/arch/s390/hypfs/hypfs_dbfs.c
index 9fd4a40..bb5dd49 100644
--- a/arch/s390/hypfs/hypfs_dbfs.c
+++ b/arch/s390/hypfs/hypfs_dbfs.c
@@ -105,9 +105,7 @@ void hypfs_dbfs_remove_file(struct hypfs_dbfs_file *df)
 int hypfs_dbfs_init(void)
 {
 	dbfs_dir = debugfs_create_dir("s390_hypfs", NULL);
-	if (IS_ERR(dbfs_dir))
-		return PTR_ERR(dbfs_dir);
-	return 0;
+	return PTR_RET(dbfs_dir);
 }
 
 void hypfs_dbfs_exit(void)
-- 
1.7.9.5

