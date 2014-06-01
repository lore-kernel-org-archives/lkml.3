Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaFANwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:52:13 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37463 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaFANwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:52:12 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: ocfs2: dir.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:53:04 +0200
Message-Id: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ocfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0717662..27aa4a1 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3738,7 +3738,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 	int credits, ret, i, num_used, did_quota = 0;
 	u32 cpos, split_hash, insert_hash = hinfo->major_hash;
 	u64 orig_leaves_start;
-	int num_dx_leaves;
+	int num_dx_leaves = 0;
 	struct buffer_head **orig_dx_leaves = NULL;
 	struct buffer_head **new_dx_leaves = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL, *meta_ac = NULL;
-- 
1.7.10.4

