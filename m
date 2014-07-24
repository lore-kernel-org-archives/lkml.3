Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaGXJqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbaGXJqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miao Xie <miaox@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/128] Btrfs: output warning instead of error when loading free space cache failed
Date: Thu, 24 Jul 2014 10:44:14 +0100
Message-Id: <1406195177-8656-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Xie <miaox@cn.fujitsu.com>

commit 32d6b47fe6fc1714d5f1bba1b9f38e0ab0ad58a8 upstream.

If we fail to load a free space cache, we can rebuild it from the extent tree,
so it is not a serious error, we should not output a error message that
would make the users uncomfortable. This patch uses warning message instead
of it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/free-space-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b21a3cd667d8..cd9d696c489d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -835,7 +835,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 
 	if (!matched) {
 		__btrfs_remove_free_space_cache(ctl);
-		btrfs_err(fs_info, "block group %llu has wrong amount of free space",
+		btrfs_warn(fs_info, "block group %llu has wrong amount of free space",
 			block_group->key.objectid);
 		ret = -1;
 	}
@@ -847,7 +847,7 @@ out:
 		spin_unlock(&block_group->lock);
 		ret = 0;
 
-		btrfs_err(fs_info, "failed to load free space cache for block group %llu",
+		btrfs_warn(fs_info, "failed to load free space cache for block group %llu, rebuild it now",
 			block_group->key.objectid);
 	}
 
-- 
1.9.1

