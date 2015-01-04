Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbbADA5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 19:57:00 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:63511 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbADA46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 19:56:58 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: reada: Remove unused function
Date: Sun,  4 Jan 2015 01:59:57 +0100
Message-Id: <1420333197-6245-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function btrfs_reada_detach() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/btrfs/ctree.h |    1 -
 fs/btrfs/reada.c |    9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fe69edd..030a7b5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4111,7 +4111,6 @@ struct reada_control {
 struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 			      struct btrfs_key *start, struct btrfs_key *end);
 int btrfs_reada_wait(void *handle);
-void btrfs_reada_detach(void *handle);
 int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			 u64 start, int err);
 
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index b63ae20..97073c0c 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -37,7 +37,7 @@
  * To trigger a readahead, btrfs_reada_add must be called. It will start
  * a read ahead for the given range [start, end) on tree root. The returned
  * handle can either be used to wait on the readahead to finish
- * (btrfs_reada_wait), or to send it to the background (btrfs_reada_detach).
+ * (btrfs_reada_wait).
  *
  * The read ahead works as follows:
  * On btrfs_reada_add, the root of the tree is inserted into a radix_tree.
@@ -986,10 +986,3 @@ int btrfs_reada_wait(void *handle)
 	return 0;
 }
 #endif
-
-void btrfs_reada_detach(void *handle)
-{
-	struct reada_control *rc = handle;
-
-	kref_put(&rc->refcnt, reada_control_release);
-}
-- 
1.7.10.4

