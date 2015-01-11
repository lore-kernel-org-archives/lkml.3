Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbbAKNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:09:58 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:42380 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbAKNJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:09:56 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: quota_local: Remove unused function
Date: Sun, 11 Jan 2015 14:13:01 +0100
Message-Id: <1420981981-16700-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ol_dqblk_file_block() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ocfs2/quota_local.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 10b6539..bb72af3 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -73,12 +73,6 @@ static loff_t ol_dqblk_off(struct super_block *sb, int c, int off)
 	       ol_dqblk_block_off(sb, c, off);
 }
 
-/* Compute block number from given offset */
-static inline unsigned int ol_dqblk_file_block(struct super_block *sb, loff_t off)
-{
-	return off >> sb->s_blocksize_bits;
-}
-
 static inline unsigned int ol_dqblk_block_offset(struct super_block *sb, loff_t off)
 {
 	return off & ((1 << sb->s_blocksize_bits) - 1);
-- 
1.7.10.4

