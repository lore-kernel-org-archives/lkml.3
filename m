Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaF3McF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:32:05 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311AbaF3McB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:32:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 165/181] Btrfs: output warning instead of error when loading free space cache failed
Date: Mon, 30 Jun 2014 13:53:06 +0200
Message-Id: <8244121a2df89def804f22330dab3236268aafdb.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miao Xie <miaox@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 32d6b47fe6fc1714d5f1bba1b9f38e0ab0ad58a8 upstream.

If we fail to load a free space cache, we can rebuild it from the extent tree,
so it is not a serious error, we should not output a error message that
would make the users uncomfortable. This patch uses warning message instead
of it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/free-space-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b4f9904c4c6b..5467f84560fe 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -832,7 +832,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 
 	if (!matched) {
 		__btrfs_remove_free_space_cache(ctl);
-		btrfs_err(fs_info, "block group %llu has wrong amount of free space",
+		btrfs_warn(fs_info, "block group %llu has wrong amount of free space",
 			block_group->key.objectid);
 		ret = -1;
 	}
@@ -844,7 +844,7 @@ out:
 		spin_unlock(&block_group->lock);
 		ret = 0;
 
-		btrfs_err(fs_info, "failed to load free space cache for block group %llu",
+		btrfs_warn(fs_info, "failed to load free space cache for block group %llu, rebuild it now",
 			block_group->key.objectid);
 	}
 
-- 
2.0.0

