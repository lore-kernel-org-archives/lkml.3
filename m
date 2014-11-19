Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaKSVs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:48:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547AbaKSVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 070/122] nfs: Fix use of uninitialized variable in nfs_getattr()
Date: Wed, 19 Nov 2014 12:52:00 -0800
Message-Id: <20141119205211.119292502@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 16caf5b6101d03335b386e77e9e14136f989be87 upstream.

Variable 'err' needn't be initialized when nfs_getattr() uses it to
check whether it should call generic_fillattr() or not. That can result
in spurious error returns. Initialize 'err' properly.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -592,7 +592,7 @@ int nfs_getattr(struct vfsmount *mnt, st
 {
 	struct inode *inode = dentry->d_inode;
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
-	int err;
+	int err = 0;
 
 	trace_nfs_getattr_enter(inode);
 	/* Flush out writes to the server in order to update c/mtime.  */


