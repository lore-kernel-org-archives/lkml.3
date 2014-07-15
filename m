Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbaGOUfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:35:52 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:46953 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932797AbaGOUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:35:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokRAJ2PxVNbsm9N/2dsb2JhbABZgw6BKaw8CwUBbpwAgRAXdYQxLyOBGjeIRgHKPBeFe4lQHYQtBZsYi1mITINGOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, hch@infradead.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/3] FS/SYSV: add SysV FS: pr_fmt in sysv.h
Date: Tue, 15 Jul 2014 22:37:08 +0200
Message-Id: <1405456628-1994-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefix is now defined only once.
Note that all pr_foo() are now prefixed.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/sysv/super.c | 8 ++++----
 fs/sysv/sysv.h  | 6 ++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index ef3141e..20b70bd 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -217,7 +217,7 @@ static int detect_sysv(struct sysv_sb_info *sbi, struct buffer_head *bh)
  		sbi->s_type = FSTYPE_AFS;
 		sbi->s_forced_ro = 1;
  		if (!(sb->s_flags & MS_RDONLY)) {
-			pr_err("SysV FS: SCO EAFS on %s detected, forcing read-only mode.\n",
+			pr_err("SCO EAFS on %s detected, forcing read-only mode.\n",
 			       sb->s_id);
  		}
  		return type;
@@ -239,7 +239,7 @@ static int detect_sysv(struct sysv_sb_info *sbi, struct buffer_head *bh)
            feature read-only mode seems to be a reasonable approach... -KGB */
 
 	if (type >= 0x10) {
-		pr_err("SysV FS: can't handle long file names on %s, forcing read-only mode.\n",
+		pr_err("can't handle long file names on %s, forcing read-only mode.\n",
 		       sb->s_id);
 		sbi->s_forced_ro = 1;
 	}
@@ -337,12 +337,12 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_d_op = &sysv_dentry_operations;
 	root_inode = sysv_iget(sb, SYSV_ROOT_INO);
 	if (IS_ERR(root_inode)) {
-		pr_err("SysV FS: get root inode failed\n");
+		pr_err("get root inode failed\n");
 		return 0;
 	}
 	sb->s_root = d_make_root(root_inode);
 	if (!sb->s_root) {
-		pr_err("SysV FS: get root dentry failed\n");
+		pr_err("get root dentry failed\n");
 		return 0;
 	}
 	return 1;
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 69d4889..d35badb 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -1,6 +1,12 @@
 #ifndef _SYSV_H
 #define _SYSV_H
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "SysV FS: " fmt
+
 #include <linux/buffer_head.h>
 
 typedef __u16 __bitwise __fs16;
-- 
1.8.4.5

