Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211AbaGYWug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:50:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:48823 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760683AbaGYWt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:49:27 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 08/11] f2fs: fix wrong condition for unlikely
Date: Fri, 25 Jul 2014 15:47:22 -0700
Message-Id: <1406328445-63707-8-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the wrongly used unlikely condition.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 42a16c1..36b0d47 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -932,7 +932,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	/* Here, we only have one bio having CP pack */
 	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
 
-	if (unlikely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
+	if (!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {
 		clear_prefree_segments(sbi);
 		release_dirty_inode(sbi);
 		F2FS_RESET_SB_DIRT(sbi);
-- 
1.8.5.2 (Apple Git-48)

