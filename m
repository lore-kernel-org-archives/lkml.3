Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3K2RB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:01:27 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38523 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3K2RBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:01:23 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: remove dead code
Date: Fri, 29 Nov 2013 18:01:15 +0100
Message-Id: <1385744475-9614-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

[commit 8185554d: fix incorrect inode acl reset] introduced a dead
code by adding a condition which can never be true to an else
branch.  The condition can never be true because it is already
checked by a previous if statement which causes function to return.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 fs/btrfs/acl.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 0890c83..460f36b 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -225,13 +225,8 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (ret < 0)
 			return ret;
-
-		if (ret > 0) {
-			/* we need an acl */
+		if (ret > 0) /* we need an acl */
 			ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
-		} else if (ret < 0) {
-			cache_no_acl(inode);
-		}
 	} else {
 		cache_no_acl(inode);
 	}
-- 
1.8.4.1

