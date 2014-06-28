Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaF1TDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:03:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaF1Rsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.10 65/77] Btrfs: output warning instead of error when loading free space cache failed
Date: Sat, 28 Jun 2014 10:46:58 -0700
Message-Id: <20140628174525.017357028@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Xie <miaox@cn.fujitsu.com>

commit 32d6b47fe6fc1714d5f1bba1b9f38e0ab0ad58a8 upstream.

If we fail to load a free space cache, we can rebuild it from the extent tree,
so it is not a serious error, we should not output a error message that
would make the users uncomfortable. This patch uses warning message instead
of it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/free-space-cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -835,7 +835,7 @@ int load_free_space_cache(struct btrfs_f
 
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
 


