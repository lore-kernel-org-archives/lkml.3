Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbbAKWI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:08:28 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51352 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAKWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:08:24 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        logfs@logfs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] logfs: readwrite: Remove unused function
Date: Sun, 11 Jan 2015 23:11:28 +0100
Message-Id: <1421014288-23746-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function init_shadow_tree() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/logfs/readwrite.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 380d86e..eafaa29 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -377,15 +377,6 @@ static unsigned long get_bits(u64 val, level_t skip)
 	return __get_bits(val, (__force int)skip, LOGFS_BLOCK_BITS);
 }
 
-static inline void init_shadow_tree(struct super_block *sb,
-		struct shadow_tree *tree)
-{
-	struct logfs_super *super = logfs_super(sb);
-
-	btree_init_mempool64(&tree->new, super->s_btree_pool);
-	btree_init_mempool64(&tree->old, super->s_btree_pool);
-}
-
 static void indirect_write_block(struct logfs_block *block)
 {
 	struct page *page;
-- 
1.7.10.4

