Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3C0Ksq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:48:46 -0400
Received: from multi.imgtec.com ([194.200.65.239]:5693 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab3C0Ksm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:48:42 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Jeff Dike <jdike@addtoit.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/3] hostfs: move HOSTFS_SUPER_MAGIC to <linux/magic.h>
Date: Wed, 27 Mar 2013 10:47:13 +0000
Message-ID: <1364381234-22960-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364381234-22960-1-git-send-email-james.hogan@imgtec.com>
References: <1364381234-22960-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_10_48_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move HOSTFS_SUPER_MAGIC to <linux/magic.h> to be with it's magical
friends from other file systems.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 fs/hostfs/hostfs_kern.c    | 3 +--
 include/uapi/linux/magic.h | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 95b9c87..f2372ef 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/magic.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -45,8 +46,6 @@ static const struct dentry_operations hostfs_dentry_ops = {
 static char *root_ino = "";
 static int append = 0;
 
-#define HOSTFS_SUPER_MAGIC 0x00c0ffee
-
 static const struct inode_operations hostfs_iops;
 static const struct inode_operations hostfs_dir_iops;
 static const struct inode_operations hostfs_link_iops;
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 873e086..cebb124 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -29,6 +29,7 @@
 #define JFFS2_SUPER_MAGIC	0x72b6
 #define PSTOREFS_MAGIC		0x6165676C
 #define EFIVARFS_MAGIC		0xde5e81e4
+#define HOSTFS_SUPER_MAGIC	0x00c0ffee
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
1.8.1.2


