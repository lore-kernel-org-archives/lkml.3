Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaEWJoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:44:04 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45337 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaEWJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:00 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 03/13] vfs: export __inode_permission() to modules
Date: Fri, 23 May 2014 11:43:33 +0200
Message-Id: <1400838223-30844-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

We need to be able to check inode permissions (but not filesystem implied
permissions) for stackable filesystems.  Expose this interface for overlayfs.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h      | 1 -
 fs/namei.c         | 1 +
 include/linux/fs.h | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 873cdf544d54..dd41b12c13f1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -42,7 +42,6 @@ extern void __init chrdev_init(void);
 /*
  * namei.c
  */
-extern int __inode_permission(struct inode *, int);
 extern int user_path_mountpoint_at(int, const char __user *, unsigned int, struct path *);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
diff --git a/fs/namei.c b/fs/namei.c
index a7cf0fb1f638..fe615561c90e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -414,6 +414,7 @@ int __inode_permission(struct inode *inode, int mask)
 
 	return security_inode_permission(inode, mask);
 }
+EXPORT_SYMBOL(__inode_permission);
 
 /**
  * sb_permission - Check superblock-level permissions
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 90463dfd77d1..0ca904f5cd1c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2233,6 +2233,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *, struct inode **);
 extern int inode_permission(struct inode *, int);
+extern int __inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 
 static inline bool execute_ok(struct inode *inode)
-- 
1.8.1.4

