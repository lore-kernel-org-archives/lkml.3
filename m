Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaFCT1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:27:51 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:61417 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168AbaFCT1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:27:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOABwhjlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SCUy8jgRo3iEYB0SQXhVWIfR2EKgSPS4o/ix2IFoM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/omfs/inode.c: use ULLONG_MAX instead of ~0ULL
Date: Tue,  3 Jun 2014 21:26:36 +0200
Message-Id: <1401823596-4954-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more explicit kernel.h definition

Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/omfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index ec58c76..40c0707 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -317,7 +317,7 @@ static int omfs_get_imap(struct super_block *sb)
 	bitmap_size = DIV_ROUND_UP(sbi->s_num_blocks, 8);
 	array_size = DIV_ROUND_UP(bitmap_size, sb->s_blocksize);
 
-	if (sbi->s_bitmap_ino == ~0ULL)
+	if (sbi->s_bitmap_ino == ULLONG_MAX)
 		goto out;
 
 	sbi->s_imap_size = array_size;
@@ -516,7 +516,7 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_brelse_bh2;
 	}
 
-	if (sbi->s_bitmap_ino != ~0ULL &&
+	if (sbi->s_bitmap_ino != ULLONG_MAX &&
 	    sbi->s_bitmap_ino > sbi->s_num_blocks) {
 		printk(KERN_ERR "omfs: free space bitmap location is corrupt "
 			"(%llx, total blocks %llx)\n",
-- 
1.8.4.5

