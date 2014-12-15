Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaLOH1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:27:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:34403 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaLOH1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:27:40 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/7] f2fs: remove checking dirty_exceed
Date: Sun, 14 Dec 2014 23:27:32 -0800
Message-Id: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to force to write dirty_exceeded for f2fs_balance_fs_bg.
This flag was only meaningful to write bypassing conditions.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f83326c..d6f073e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -57,8 +57,6 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 	} else if (type == INO_ENTRIES) {
 		int i;
 
-		if (sbi->sb->s_bdi->dirty_exceeded)
-			return false;
 		for (i = 0; i <= UPDATE_INO; i++)
 			mem_size += (sbi->im[i].ino_num *
 				sizeof(struct ino_entry)) >> PAGE_CACHE_SHIFT;
-- 
2.1.1

