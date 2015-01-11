Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbbAKMsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:48:24 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57778 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbAKMsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:48:22 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: xattr: Remove unused function
Date: Sun, 11 Jan 2015 13:51:26 +0100
Message-Id: <1420980686-16090-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ocfs2_xattr_bucket_get_val() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ocfs2/xattr.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 016f01d..7f69575 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5334,16 +5334,6 @@ out:
 	return ret;
 }
 
-static inline char *ocfs2_xattr_bucket_get_val(struct inode *inode,
-					struct ocfs2_xattr_bucket *bucket,
-					int offs)
-{
-	int block_off = offs >> inode->i_sb->s_blocksize_bits;
-
-	offs = offs % inode->i_sb->s_blocksize;
-	return bucket_block(bucket, block_off) + offs;
-}
-
 /*
  * Truncate the specified xe_off entry in xattr bucket.
  * bucket is indicated by header_bh and len is the new length.
-- 
1.7.10.4

