Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaHLTw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:52:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:57992 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaHLTtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:20 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 03/13] f2fs: fix the initial inode page for recovery
Date: Tue, 12 Aug 2014 12:49:17 -0700
Message-Id: <1407872967-26423-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a new inode page is needed for recover_dentry, we should assing i_inline
as zero.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1f33299..093d799 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1651,6 +1651,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	dst->i_blocks = cpu_to_le64(1);
 	dst->i_links = cpu_to_le32(1);
 	dst->i_xattr_nid = 0;
+	dst->i_inline = src->i_inline & F2FS_INLINE_XATTR;
 
 	new_ni = old_ni;
 	new_ni.ino = ino;
@@ -1659,6 +1660,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 		WARN_ON(1);
 	set_node_addr(sbi, &new_ni, NEW_ADDR, false);
 	inc_valid_inode_count(sbi);
+	set_page_dirty(ipage);
 	f2fs_put_page(ipage, 1);
 	return 0;
 }
-- 
1.8.5.2 (Apple Git-48)

