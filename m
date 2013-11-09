Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3KIGu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:50:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab3KIGuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        "Michael L. Semon" <mlsemon35@gmail.com>
Subject: [PATCH 3.10 20/74] jfs: fix error path in ialloc
Date: Fri,  8 Nov 2013 22:51:25 -0800
Message-Id: <20131109065114.954901193@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 8660998608cfa1077e560034db81885af8e1e885 upstream.

If insert_inode_locked() fails, we shouldn't be calling
unlock_new_inode().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jfs/jfs_inode.c |    3 +--
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


