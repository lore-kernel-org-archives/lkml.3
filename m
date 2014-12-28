Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaL1SOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:14:00 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:57116 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbaL1SN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:13:59 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnUNALtHoFRXQ78c/2dsb2JhbABcgwaBKrQdBgEBAQEBBQF3lzaBDBcBAQEBAX2EOi8jgRo3iBgDFQG1XolgFYUBLIYDiRATAQFPHYQTBY10iRSRUCKBRQGCKT0xgQMJF4EgAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH V2 linux-next] fs/ufs/super.c: remove unnecessary casting
Date: Sun, 28 Dec 2014 19:13:52 +0100
Message-Id: <1419790432-10588-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following coccinelle warning:
fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
allocation function to (struct ufs_inode_info *) is useless.

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: separate declaration from allocation (suggested by Joe Perches)

 fs/ufs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index da73801..e515e99 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1415,9 +1415,11 @@ static struct kmem_cache * ufs_inode_cachep;
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
 	struct ufs_inode_info *ei;
-	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
+
+	ei = kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+
 	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
-- 
2.1.0

