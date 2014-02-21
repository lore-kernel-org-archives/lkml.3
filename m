Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbaBUMta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaBUMtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/121] Btrfs: disable snapshot aware defrag for now
Date: Fri, 21 Feb 2014 12:47:13 +0000
Message-Id: <1392986945-9693-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 8101c8dbf6243ba517aab58d69bf1bc37d8b7b9c upstream.

It's just broken and it's taking a lot of effort to fix it, so for now just
disable it so people can defrag in peace.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5a4bc34..f992daf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2688,7 +2688,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			EXTENT_DEFRAG, 1, cached_state);
 	if (ret) {
 		u64 last_snapshot = btrfs_root_last_snapshot(&root->root_item);
-		if (last_snapshot >= BTRFS_I(inode)->generation)
+		if (0 && last_snapshot >= BTRFS_I(inode)->generation)
 			/* the inode is shared */
 			new = record_old_file_extents(inode, ordered_extent);
 
-- 
1.9.0

