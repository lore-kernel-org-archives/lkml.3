Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3CLPmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:42:46 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:32907 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab3CLPmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:42:42 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 11/13] vfs-export-inode_permission-to-modules
Date: Tue, 12 Mar 2013 16:41:46 +0100
Message-Id: <1363102908-28956-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

We need to be able to check inode permissions (but not filesystem implied
permissions) for stackable filesystems.  Expose this interface for overlayfs.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h      |    5 -----
 fs/namei.c         |    1 +
 include/linux/fs.h |    1 +
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 507141f..89481ac 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -42,11 +42,6 @@ static inline int __sync_blockdev(struct block_device *bdev, int wait)
 extern void __init chrdev_init(void);
 
 /*
- * namei.c
- */
-extern int __inode_permission(struct inode *, int);
-
-/*
  * namespace.c
  */
 extern int copy_mount_options(const void __user *, unsigned long *);
diff --git a/fs/namei.c b/fs/namei.c
index c1c0c15..e1cffbd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -402,6 +402,7 @@ int __inode_permission(struct inode *inode, int mask)
 
 	return security_inode_permission(inode, mask);
 }
+EXPORT_SYMBOL(__inode_permission);
 
 /**
  * sb_permission - Check superblock-level permissions
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e4e5fbd..3353de6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2224,6 +2224,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int __inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 
 static inline bool execute_ok(struct inode *inode)
-- 
1.7.10.4

