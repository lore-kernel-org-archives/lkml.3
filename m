Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaJXVV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:21:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:29890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbaJXVVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:21:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,782,1406617200"; 
   d="scan'208";a="610845655"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v12 14/20] ext2: Remove xip.c and xip.h
Date: Fri, 24 Oct 2014 17:20:46 -0400
Message-Id: <1414185652-28663-15-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files are now empty, so delete them

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 fs/ext2/Makefile |  1 -
 fs/ext2/inode.c  |  1 -
 fs/ext2/namei.c  |  1 -
 fs/ext2/super.c  |  1 -
 fs/ext2/xip.c    | 15 ---------------
 fs/ext2/xip.h    | 16 ----------------
 6 files changed, 35 deletions(-)
 delete mode 100644 fs/ext2/xip.c
 delete mode 100644 fs/ext2/xip.h

diff --git a/fs/ext2/Makefile b/fs/ext2/Makefile
index f42af45..445b0e9 100644
--- a/fs/ext2/Makefile
+++ b/fs/ext2/Makefile
@@ -10,4 +10,3 @@ ext2-y := balloc.o dir.o file.o ialloc.o inode.o \
 ext2-$(CONFIG_EXT2_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
 ext2-$(CONFIG_EXT2_FS_POSIX_ACL) += acl.o
 ext2-$(CONFIG_EXT2_FS_SECURITY)	 += xattr_security.o
-ext2-$(CONFIG_EXT2_FS_XIP)	 += xip.o
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index cba3833..154cbcf 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -34,7 +34,6 @@
 #include <linux/aio.h>
 #include "ext2.h"
 #include "acl.h"
-#include "xip.h"
 #include "xattr.h"
 
 static int __ext2_write_inode(struct inode *inode, int do_sync);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 846c356..7ca803f 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -35,7 +35,6 @@
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
-#include "xip.h"
 
 static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
 {
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f975854..b1f25f8 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -35,7 +35,6 @@
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
-#include "xip.h"
 
 static void ext2_sync_super(struct super_block *sb,
 			    struct ext2_super_block *es, int wait);
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
deleted file mode 100644
index 66ca113..0000000
--- a/fs/ext2/xip.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- *  linux/fs/ext2/xip.c
- *
- * Copyright (C) 2005 IBM Corporation
- * Author: Carsten Otte (cotte@de.ibm.com)
- */
-
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/genhd.h>
-#include <linux/buffer_head.h>
-#include <linux/blkdev.h>
-#include "ext2.h"
-#include "xip.h"
-
diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
deleted file mode 100644
index 87eeb04..0000000
--- a/fs/ext2/xip.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- *  linux/fs/ext2/xip.h
- *
- * Copyright (C) 2005 IBM Corporation
- * Author: Carsten Otte (cotte@de.ibm.com)
- */
-
-#ifdef CONFIG_EXT2_FS_XIP
-static inline int ext2_use_xip (struct super_block *sb)
-{
-	struct ext2_sb_info *sbi = EXT2_SB(sb);
-	return (sbi->s_mount_opt & EXT2_MOUNT_XIP);
-}
-#else
-#define ext2_use_xip(sb)			0
-#endif
-- 
2.1.1

