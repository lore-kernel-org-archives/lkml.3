Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFJOkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:40:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52526 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaFJOkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:40:13 -0400
Date: Tue, 10 Jun 2014 20:10:07 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] fs/ufs/super.c: Drop memory allocation cast
Message-ID: <20140610144007.GA3218@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop cast on the result of kmem_cache_alloc.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@
type T;
@@

- (T *)
  (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 fs/ufs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index b879f1b..1c19418 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1415,7 +1415,7 @@ static struct kmem_cache * ufs_inode_cachep;
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
 	struct ufs_inode_info *ei;
-	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
+	ei = kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 	ei->vfs_inode.i_version = 1;
-- 
1.9.1

