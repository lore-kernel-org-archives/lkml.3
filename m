Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaDXQdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:33:49 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:35694 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758494AbaDXQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:33:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoVAKE7WVNbsls8/2dsb2JhbABZgwaDZKgKmW8CAoEcF3SCUxMcIxiBAiQTiC0DFQHEaRWGZYVaiC4BAU+EQAEDjm+KCQGKbodrgzM7gTU
Date: Thu, 24 Apr 2014 18:35:46 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH 1/1] fs/ufs/balloc.c: remove err parameter in
 ufs_add_fragments
Message-Id: <20140424183546.809162d9334ef9e41486d364@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err is used in ufs_new_fragments (ufs_add_fragments only callsite)
not in ufs_add_fragments.

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/balloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 0ab1de4..184323c 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -24,7 +24,7 @@
 
 #define INVBLOCK ((u64)-1L)
 
-static u64 ufs_add_fragments(struct inode *, u64, unsigned, unsigned, int *);
+static u64 ufs_add_fragments(struct inode *, u64, unsigned, unsigned);
 static u64 ufs_alloc_fragments(struct inode *, unsigned, u64, unsigned, int *);
 static u64 ufs_alloccg_block(struct inode *, struct ufs_cg_private_info *, u64, int *);
 static u64 ufs_bitmap_search (struct super_block *, struct ufs_cg_private_info *, u64, unsigned);
@@ -432,7 +432,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 	/*
 	 * resize block
 	 */
-	result = ufs_add_fragments (inode, tmp, oldcount, newcount, err);
+	result = ufs_add_fragments(inode, tmp, oldcount, newcount);
 	if (result) {
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
@@ -491,7 +491,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 }		
 
 static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
-			     unsigned oldcount, unsigned newcount, int *err)
+			     unsigned oldcount, unsigned newcount)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-- 
1.8.4.5
