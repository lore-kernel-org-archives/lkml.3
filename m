Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaI0QKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 12:10:24 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:32319 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbaI0QKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 12:10:23 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4NAHTgJlRXQy06/2dsb2JhbABfgw62CwUBcppXfRcBe4RgI4EaN4hCAa8nj3uGEooMHYQ1BZE9i2uMQIkdg2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/affs: remove redundant sys_tz declarations
Date: Sat, 27 Sep 2014 18:10:16 +0200
Message-Id: <1411834216-17372-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_tz is already declared in include/linux/time.h

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/amigaffs.c | 2 --
 fs/affs/inode.c    | 1 -
 fs/affs/super.c    | 2 --
 3 files changed, 5 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 406b298..abc8539 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -10,8 +10,6 @@
 
 #include "affs.h"
 
-extern struct timezone sys_tz;
-
 static char ErrorBuffer[256];
 
 /*
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index bec2d1a..31c2e37 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -14,7 +14,6 @@
 #include "affs.h"
 
 extern const struct inode_operations affs_symlink_inode_operations;
-extern struct timezone sys_tz;
 
 struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 {
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 51f1a95..314b3ff 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -20,8 +20,6 @@
 #include <linux/writeback.h>
 #include "affs.h"
 
-extern struct timezone sys_tz;
-
 static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int affs_remount (struct super_block *sb, int *flags, char *data);
 
-- 
1.9.3

