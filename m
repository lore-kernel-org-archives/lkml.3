Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3ALFl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:41:29 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56827 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3ALFl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:41:27 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/4] f2fs: remove redundant call to set_blocksize in f2fs_fill_super
Date: Sat, 12 Jan 2013 14:41:13 +0900
Message-Id: <1357969273-9293-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, f2fs supports only 4KB blocksize, which is set at the beginning in
f2fs_fill_super. So, we do not need to again check this blocksize setting
in such case.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/super.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0f2b2eb..ac127fd 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -443,7 +443,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sbi)
 		return -ENOMEM;
 
-	/* set a temporary block size */
+	/* set a block size */
 	if (!sb_set_blocksize(sb, F2FS_BLKSIZE)) {
 		f2fs_msg(sb, KERN_ERR, "unable to set blocksize");
 		goto free_sbi;
@@ -542,10 +542,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	INIT_LIST_HEAD(&sbi->dir_inode_list);
 	spin_lock_init(&sbi->dir_inode_lock);
 
-	/* init super block */
-	if (!sb_set_blocksize(sb, sbi->blocksize))
-		goto free_cp;
-
 	init_orphan_info(sbi);
 
 	/* setup f2fs internal modules */
-- 
1.7.9.5

