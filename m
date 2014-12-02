Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027AbaLBTty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:49:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaLBTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:58 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 075/121] nfs: Fix use of uninitialized variable in nfs_getattr()
Date: Tue,  2 Dec 2014 11:19:14 -0800
Message-Id: <1417548000-1794-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 16caf5b6101d03335b386e77e9e14136f989be87 upstream.

Variable 'err' needn't be initialized when nfs_getattr() uses it to
check whether it should call generic_fillattr() or not. That can result
in spurious error returns. Initialize 'err' properly.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index be955cf..8af210f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -592,7 +592,7 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
-	int err;
+	int err = 0;
 
 	trace_nfs_getattr_enter(inode);
 	/* Flush out writes to the server in order to update c/mtime.  */
-- 
1.9.1

