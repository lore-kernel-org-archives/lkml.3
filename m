Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaJTFV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:21:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:60017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbaJTFT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:56 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 08/11] f2fs: should not truncate any inline_dentry
Date: Sun, 19 Oct 2014 22:19:36 -0700
Message-Id: <1413782379-11758-8-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the inode has inline_dentry, we should not truncate any block indices.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d054e0e..402e381 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -471,7 +471,7 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 
 	trace_f2fs_truncate_blocks_enter(inode, from);
 
-	if (f2fs_has_inline_data(inode))
+	if (f2fs_has_inline_data(inode) || f2fs_has_inline_dentry(inode))
 		goto done;
 
 	free_from = (pgoff_t)
-- 
2.1.1

