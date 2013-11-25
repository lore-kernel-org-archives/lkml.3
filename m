Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab3KYOQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:16:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58872 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab3KYNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:42 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dave Kleikamp" <dave.kleikamp@oracle.com>,
        "Michael L. Semon" <mlsemon35@gmail.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.408899654@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 36/87] jfs: fix error path in ialloc
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 8660998608cfa1077e560034db81885af8e1e885 upstream.

If insert_inode_locked() fails, we shouldn't be calling
unlock_new_inode().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jfs/jfs_inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -95,7 +95,7 @@ struct inode *ialloc(struct inode *paren
 
 	if (insert_inode_locked(inode) < 0) {
 		rc = -EINVAL;
-		goto fail_unlock;
+		goto fail_put;
 	}
 
 	inode_init_owner(inode, parent, mode);
@@ -156,7 +156,6 @@ struct inode *ialloc(struct inode *paren
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-fail_unlock:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 fail_put:

