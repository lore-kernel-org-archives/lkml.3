Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3KHCVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:21:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3KHCVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 40/91] jfs: fix error path in ialloc
Date: Thu,  7 Nov 2013 18:14:55 -0800
Message-Id: <1383876946-2396-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 8660998608cfa1077e560034db81885af8e1e885 upstream.

If insert_inode_locked() fails, we shouldn't be calling
unlock_new_inode().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/jfs/jfs_inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index c1a3e60..7f464c5 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -95,7 +95,7 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 
 	if (insert_inode_locked(inode) < 0) {
 		rc = -EINVAL;
-		goto fail_unlock;
+		goto fail_put;
 	}
 
 	inode_init_owner(inode, parent, mode);
@@ -156,7 +156,6 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-fail_unlock:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 fail_put:
-- 
1.8.1.2

