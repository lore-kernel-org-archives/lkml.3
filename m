Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3H2UMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:12:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55481 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756941Ab3H2UMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:12:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 6/6] f2fs: Convert kmem_cache_alloc(...GFP_ZERO) to kmem_cache_zalloc
Date: Thu, 29 Aug 2013 13:11:10 -0700
Message-Id: <075e5f4b42ddc2d3192a59f8b31e52fd3f220804.1377806578.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1377806578.git.joe@perches.com>
References: <cover.1377806578.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper exists, might as well use it instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 13d0a0f..d43709a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -286,7 +286,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 {
 	struct f2fs_inode_info *fi;
 
-	fi = kmem_cache_alloc(f2fs_inode_cachep, GFP_NOFS | __GFP_ZERO);
+	fi = kmem_cache_zalloc(f2fs_inode_cachep, GFP_NOFS);
 	if (!fi)
 		return NULL;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

