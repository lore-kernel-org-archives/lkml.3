Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaB0Lki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:40:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9521 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaB0LkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:40:22 -0500
X-AuditID: cbfee690-b7f266d00000287c-32-530f24222101
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: add an sysfs entry to control the directory level
Date: Thu, 27 Feb 2014 20:38:39 +0900
Message-id: <1393501119-12976-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1393501119-12976-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1393501119-12976-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ10lFf5gg4/7pCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgymjYdo65oFO24vy3
	G+wNjM3iXYycHBICJhLLVp9khbDFJC7cW8/WxcjFISSwjFHi+aR1bDBFd1dfY4dITGeUePS6
	mRHC6WSSeHvgDksXIwcHm4C2xOb9BiANIgLMEgumngerYRaYwCjxf9F7FpCEsICPxO+ft8Fs
	FgFVidnvZzCB9PIKuEs0fbGBWKYtse35REYQm1PAQ2LKlvtgRwgBldxsXwt2nYTAdzaJide7
	oeYISHybfAjsBgkBWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ
	+bmbGCEhO2EH470D1ocYk4HGTWSWEk3OB4Z8Xkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwdrRe0WXwtzll/Kglq/la04yUHQ9+yV1a6/jU1Kam
	68X0mdddLn3PL451WLDJzzusvUQnekN8Tyun+jGbtD8/NSs/ewj/Y5t6y2nKuj6R5FdaLrMT
	o37mWBdO/WtmkCKetZkt/MrnQK3E1BDDffxrebYn76xV8/MuPn9tR1DVA+3A+vnrUpiUWIoz
	Eg21mIuKEwF865vBbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV0lFf5gg/+PxSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xo2HaOuaBTtuL8txvsDYzN4l2MnBwSAiYSd1dfY4ewxSQu3FvP1sXIxSEk
	MJ1R4tHrZkYIp5NJ4u2BOyxdjBwcbALaEpv3G4A0iAgwSyyYeh6shllgAqPE/0XvWUASwgI+
	Er9/3gazWQRUJWa/n8EE0ssr4C7R9MUGYpm2xLbnExlBbE4BD4kpW+6zgdhCQCU329eyTWDk
	XcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOCKeSe1gXNlgcYhRgINRiYdXgY0vWIg1
	say4MvcQowQHs5II73om/mAh3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgdGa15JvKGxiZmR
	pZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MBbOTbdLq1t2rTY30fHxt032
	Xw3YROYlpMwSVH0VsjH2PJf2nb8L7h4XPbPxmtmZBdMXfjqQc/fDPpZv5s5ZClfNtTbly5p/
	X8j5/k2ow3qOltW/eXjjLfu3Nb+LmahSX19YsyhEzdtfyESx6pukfFRj2CaePe6tD8ttShbe
	ednzzKxAtX39YyWW4oxEQy3mouJEAPos+4fMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an sysfs entry to control dir_level used by the large directory.

The description of this entry is:

 dir_level                    This parameter controls the directory level to
			      support large directory. If a directory has a
			      number of files, it can reduce the file lookup
			      latency by increasing this dir_level value.
			      Otherwise, it needs to decrease this value to
			      reduce the space overhead. The default value is 0.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 7 +++++++
 fs/f2fs/f2fs.h                     | 3 +++
 fs/f2fs/super.c                    | 7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 8eb06b0..803784e 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -195,6 +195,13 @@ Files in /sys/fs/f2fs/<devname>
 			      cleaning operations. The default value is 4096
 			      which covers 8GB block address range.
 
+ dir_level                    This parameter controls the directory level to
+			      support large directory. If a directory has a
+			      number of files, it can reduce the file lookup
+			      latency by increasing this dir_level value.
+			      Otherwise, it needs to decrease this value to
+			      reduce the space overhead. The default value is 0.
+
 ================================================================================
 USAGE
 ================================================================================
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a826916..6f88191 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -196,6 +196,8 @@ struct extent_info {
 #define FADVISE_COLD_BIT	0x01
 #define FADVISE_LOST_PINO_BIT	0x02
 
+#define DEF_DIR_LEVEL		0
+
 struct f2fs_inode_info {
 	struct inode vfs_inode;		/* serve a vfs inode */
 	unsigned long i_flags;		/* keep an inode flags for ioctl */
@@ -447,6 +449,7 @@ struct f2fs_sb_info {
 	unsigned int total_valid_node_count;	/* valid node block count */
 	unsigned int total_valid_inode_count;	/* valid inode count */
 	int active_logs;			/* # of active logs */
+	int dir_level;				/* directory level */
 
 	block_t user_block_count;		/* # of user blocks */
 	block_t total_valid_block_count;	/* # of valid blocks */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 475560e..1bd9153 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -184,6 +184,7 @@ F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, max_small_discards, max_discards);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, ipu_policy, ipu_policy);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, min_ipu_util, min_ipu_util);
 F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, max_victim_search, max_victim_search);
+F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, dir_level, dir_level);
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
@@ -196,6 +197,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(ipu_policy),
 	ATTR_LIST(min_ipu_util),
 	ATTR_LIST(max_victim_search),
+	ATTR_LIST(dir_level),
 	NULL,
 };
 
@@ -359,6 +361,9 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	if (test_opt(F2FS_SB(sb), INLINE_XATTR))
 		set_inode_flag(fi, FI_INLINE_XATTR);
 
+	/* Will be used by directory only */
+	fi->i_dir_level = F2FS_SB(sb)->dir_level;
+
 	return &fi->vfs_inode;
 }
 
@@ -785,6 +790,8 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 
 	for (i = 0; i < NR_COUNT_TYPE; i++)
 		atomic_set(&sbi->nr_pages[i], 0);
+
+	sbi->dir_level = DEF_DIR_LEVEL;
 }
 
 /*
-- 
1.8.4.474.g128a96c

