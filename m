Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaFJOiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:38:14 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55598 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaFJOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:38:12 -0400
Date: Tue, 10 Jun 2014 20:08:05 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jeff Mahoney <jeffm@suse.com>
Cc: julia.lawall@lip6.fr
Subject: [PATCH] fs/reiserfs/super.c : Drop memory allocation cast
Message-ID: <20140610143805.GA3091@himangi-Dell>
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
 fs/reiserfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 9fb2042..3902028 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -568,8 +568,7 @@ static struct kmem_cache *reiserfs_inode_cachep;
 static struct inode *reiserfs_alloc_inode(struct super_block *sb)
 {
 	struct reiserfs_inode_info *ei;
-	ei = (struct reiserfs_inode_info *)
-	    kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	atomic_set(&ei->openers, 0);
-- 
1.9.1

