Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJTFTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:59800 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaJTFSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:45 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 09/09] f2fs: avoid infinite loop at cp_error
Date: Sun, 19 Oct 2014 22:18:32 -0700
Message-Id: <1413782312-11631-9-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
References: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch avoids an infinite loop in sync_dirty_inode_page when -EIO was
detected.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index dd10a03..ca514d5 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -731,6 +731,9 @@ void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
 	struct dir_inode_entry *entry;
 	struct inode *inode;
 retry:
+	if (unlikely(f2fs_cp_error(sbi)))
+		return;
+
 	spin_lock(&sbi->dir_inode_lock);
 
 	head = &sbi->dir_inode_list;
-- 
2.1.1

