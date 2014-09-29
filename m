Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaI2Ssr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:48:47 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:16420 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbaI2Ssp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:48:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoNAOCoKVRbtA8r/2dsb2JhbABggw6BKrYYBQFyAZpWgRUXAXuEMS8jgRo3iEIBr2CPcYYSigwdhDUFkT2La5Vdg2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/affs/super.c: remove unused variable
Date: Mon, 29 Sep 2014 20:48:35 +0200
Message-Id: <1412016515-16592-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

key is set in affs_fill_super but never used.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 51f1a95..a67dc72 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -308,7 +308,6 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	u32			 chksum;
 	int			 num_bm;
 	int			 i, j;
-	s32			 key;
 	kuid_t			 uid;
 	kgid_t			 gid;
 	int			 reserved;
@@ -367,7 +366,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 		i = j = blocksize;
 		size = size / (blocksize / 512);
 	}
-	for (blocksize = i, key = 0; blocksize <= j; blocksize <<= 1, size >>= 1) {
+	for (blocksize = i; blocksize <= j; blocksize <<= 1, size >>= 1) {
 		sbi->s_root_block = root_block;
 		if (root_block < 0)
 			sbi->s_root_block = (reserved + size - 1) / 2;
@@ -399,7 +398,6 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 			    be32_to_cpu(AFFS_ROOT_TAIL(sb, root_bh)->stype) == ST_ROOT) {
 				sbi->s_hashsize    = blocksize / 4 - 56;
 				sbi->s_root_block += num_bm;
-				key                        = 1;
 				goto got_root;
 			}
 			affs_brelse(root_bh);
-- 
1.9.3

