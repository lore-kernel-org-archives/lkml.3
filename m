Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaLZGrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 01:47:16 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61976 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaLZGrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 01:47:15 -0500
From: Fred Chou <fred.chou.nd@gmail.com>
X-Google-Original-From: Fred Chou
To: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Cc: Fred Chou <fred.chou.nd@gmail.com>
Subject: [PATCH] fs: fat: use MSDOS_SB macro to get msdos_sb_info
Date: Fri, 26 Dec 2014 14:49:21 +0800
Message-Id: <1419576561-3516-1-git-send-email-fred.chou.nd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fred Chou <fred.chou.nd@gmail.com>

Use the MSDOS_SB macro to get msdos_sb_info, instead of coding it
directly.

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
---
 fs/fat/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 1956dae..0f52d5f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -640,7 +640,7 @@ static void fat_set_state(struct super_block *sb,
 {
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
-	struct msdos_sb_info *sbi = sb->s_fs_info;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
 	/* do not change any thing if mounted read only */
 	if ((sb->s_flags & MS_RDONLY) && !force)
-- 
1.9.1

