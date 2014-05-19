Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaESEdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:33:51 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14034 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbaESEcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:54 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474223"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] ufs: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:13 +0200
Message-Id: <1400473875-22228-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/ufs/truncate.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index f04f89f..a17f0a9 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -72,7 +72,6 @@ static int ufs_trunc_direct(struct inode *inode)
 	u64 frag1, frag2, frag3, frag4, block1, block2;
 	unsigned frag_to_free, free_count;
 	unsigned i, tmp;
-	int retry;
 	
 	UFSD("ENTER: ino %lu\n", inode->i_ino);
 
@@ -81,7 +80,6 @@ static int ufs_trunc_direct(struct inode *inode)
 	
 	frag_to_free = 0;
 	free_count = 0;
-	retry = 0;
 	
 	frag1 = DIRECT_FRAGMENT;
 	frag4 = min_t(u64, UFS_NDIR_FRAGMENT, ufsi->i_lastfrag);
@@ -164,7 +162,7 @@ next1:
  next3:
 
 	UFSD("EXIT: ino %lu\n", inode->i_ino);
-	return retry;
+	return 0;
 }
 
 
@@ -176,7 +174,6 @@ static int ufs_trunc_indirect(struct inode *inode, u64 offset, void *p)
 	void *ind;
 	u64 tmp, indirect_block, i, frag_to_free;
 	unsigned free_count;
-	int retry;
 
 	UFSD("ENTER: ino %lu, offset %llu, p: %p\n",
 	     inode->i_ino, (unsigned long long)offset, p);
@@ -188,7 +185,6 @@ static int ufs_trunc_indirect(struct inode *inode, u64 offset, void *p)
 
 	frag_to_free = 0;
 	free_count = 0;
-	retry = 0;
 	
 	tmp = ufs_data_ptr_to_cpu(sb, p);
 	if (!tmp)
@@ -248,7 +244,7 @@ static int ufs_trunc_indirect(struct inode *inode, u64 offset, void *p)
 	
 	UFSD("EXIT: ino %lu\n", inode->i_ino);
 	
-	return retry;
+	return 0;
 }
 
 static int ufs_trunc_dindirect(struct inode *inode, u64 offset, void *p)

