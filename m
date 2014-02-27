Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaB0LmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:42:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9521 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaB0LkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:40:20 -0500
X-AuditID: cbfee68f-b7f156d00000276c-99-530f242221cc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: introduce large directory support
Date: Thu, 27 Feb 2014 20:38:38 +0900
Message-id: <1393501119-12976-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1393501119-12976-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1393501119-12976-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zI10lFf5gg3t3hS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjh6eRdLwQLzim0n
	HzE3MH7X7GLk4JAQMJGYe5iji5ETyBSTuHBvPVsXIxeHkMAyRomNyzaxQiRMJBpPr2SGSExn
	lPi0/jiU08kk8fbAHRaQSWwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQBLCAjYSH05c
	B7NZBFQl3r/6wgxi8wq4S6zuvMAMsU1bYtvziYwgNqeAh8SULffZQGwhoJqb7WvBzpMQ+M0m
	0froOxPEIAGJb5MPsUC8Iyux6QDUHEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQv
	XS85P3cTIyRk+3cw3j1gfYgxGWjcRGYp0eR8YMjnlcQbGpsZWZiamBobmVuakSasJM57/2FS
	kJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGV5ffvnzmOqvv7licserT0veGjZPjjpq3rLQo
	uiHr1vEyX6zhsdaDE2tV+oNfPdI3aT43rfvWs4frDTVO1P/Vm+Rjz/esbDvHwt+7au9c3XN3
	0mK9mcvk/xsnCk1N+3bzZ8fvv4d3/+5xd/1rq5EwxbbEJ4FDqMBAvDDozOq/8T1Pe45atOSs
	U2Ipzkg01GIuKk4EAIqFcPxvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV0lFf5gg8UH+S2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4enkXS8EC84ptJx8xNzB+1+xi5OSQEDCRaDy9khnCFpO4cG89WxcjF4eQ
	wHRGiU/rjzNDOJ1MEm8P3GHpYuTgYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4ves8CkhAW
	sJH4cOI6mM0ioCrx/tUXsA28Au4SqzsvQG3Tltj2fCIjiM0p4CExZct9NhBbCKjmZvtatgmM
	vAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfEM6kdjCsbLA4xCnAwKvHwKrDxBQux
	JpYVV+YeYpTgYFYS4V3PxB8sxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnAeM0riTc0NjEz
	sjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsa4r3eTl+9s2Tg7gvfAx27r
	ZNvDRk0vj3zJ6/50dPNutwrPJ+f+cQk9YnXWfr5YT0HpMsPDLSb3Psm9a82+3vbx4/F7/i6M
	yRYXXTmiXRbPvTD58SfBj5ekYm/3LTD6tHH2+X1JOkIrGC+f/LRQw1Ot0vvv4pmn+6s/tX1p
	1739uPTXap7pbs9eK7EUZyQaajEXFScCAABDwjXNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces an i_dir_level field to support large directory.

Previously, f2fs maintains multi-level hash tables to find a dentry quickly
from a bunch of chiild dentries in a directory, and the hash tables consist of
the following tree structure as below.

In Documentation/filesystems/f2fs.txt,

----------------------
A : bucket
B : block
N : MAX_DIR_HASH_DEPTH
----------------------

level #0   | A(2B)
           |
level #1   | A(2B) - A(2B)
           |
level #2   | A(2B) - A(2B) - A(2B) - A(2B)
     .     |   .       .       .       .
level #N/2 | A(2B) - A(2B) - A(2B) - A(2B) - A(2B) - ... - A(2B)
     .     |   .       .       .       .
level #N   | A(4B) - A(4B) - A(4B) - A(4B) - A(4B) - ... - A(4B)

But, if we can guess that a directory will handle a number of child files,
we don't need to traverse the tree from level #0 to #N all the time.
Since the lower level tables contain relatively small number of dentries,
the miss ratio of the target dentry is likely to be high.

In order to avoid that, we can configure the hash tables sparsely from level #0
like this.

level #0   | A(2B) - A(2B) - A(2B) - A(2B)

level #1   | A(2B) - A(2B) - A(2B) - A(2B) - A(2B) - ... - A(2B)
     .     |   .       .       .       .
level #N/2 | A(2B) - A(2B) - A(2B) - A(2B) - A(2B) - ... - A(2B)
     .     |   .       .       .       .
level #N   | A(4B) - A(4B) - A(4B) - A(4B) - A(4B) - ... - A(4B)

With this structure, we can skip the ineffective tree searches in lower level
hash tables.

This patch adds just a facility for this by introducing i_dir_level in
f2fs_inode.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt |  6 ++++--
 fs/f2fs/dir.c                      | 21 ++++++++++++---------
 fs/f2fs/f2fs.h                     |  1 +
 fs/f2fs/inode.c                    |  2 ++
 include/linux/f2fs_fs.h            |  2 +-
 5 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index b8d2849..8eb06b0 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -444,9 +444,11 @@ The number of blocks and buckets are determined by,
   # of blocks in level #n = |
                             `- 4, Otherwise
 
-                             ,- 2^n, if n < MAX_DIR_HASH_DEPTH / 2,
+                             ,- 2^ (n + dir_level),
+			     |            if n < MAX_DIR_HASH_DEPTH / 2,
   # of buckets in level #n = |
-                             `- 2^((MAX_DIR_HASH_DEPTH / 2) - 1), Otherwise
+                             `- 2^((MAX_DIR_HASH_DEPTH / 2 + dir_level) - 1),
+			                  Otherwise
 
 When F2FS finds a file name in a directory, at first a hash value of the file
 name is calculated. Then, F2FS scans the hash table in level #0 to find the
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c3ea8f8..582fa00 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -21,12 +21,12 @@ static unsigned long dir_blocks(struct inode *inode)
 							>> PAGE_CACHE_SHIFT;
 }
 
-static unsigned int dir_buckets(unsigned int level)
+static unsigned int dir_buckets(unsigned int level, int dir_level)
 {
 	if (level < MAX_DIR_HASH_DEPTH / 2)
-		return 1 << level;
+		return 1 << (level + dir_level);
 	else
-		return 1 << ((MAX_DIR_HASH_DEPTH / 2) - 1);
+		return 1 << ((MAX_DIR_HASH_DEPTH / 2 + dir_level) - 1);
 }
 
 static unsigned int bucket_blocks(unsigned int level)
@@ -65,13 +65,14 @@ static void set_de_type(struct f2fs_dir_entry *de, struct inode *inode)
 	de->file_type = f2fs_type_by_mode[(mode & S_IFMT) >> S_SHIFT];
 }
 
-static unsigned long dir_block_index(unsigned int level, unsigned int idx)
+static unsigned long dir_block_index(unsigned int level,
+				int dir_level, unsigned int idx)
 {
 	unsigned long i;
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i) * bucket_blocks(i);
+		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }
@@ -143,10 +144,11 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 
 	f2fs_bug_on(level > MAX_DIR_HASH_DEPTH);
 
-	nbucket = dir_buckets(level);
+	nbucket = dir_buckets(level, F2FS_I(dir)->i_dir_level);
 	nblock = bucket_blocks(level);
 
-	bidx = dir_block_index(level, le32_to_cpu(namehash) % nbucket);
+	bidx = dir_block_index(level, F2FS_I(dir)->i_dir_level,
+					le32_to_cpu(namehash) % nbucket);
 	end_block = bidx + nblock;
 
 	for (; bidx < end_block; bidx++) {
@@ -467,10 +469,11 @@ start:
 	if (level == current_depth)
 		++current_depth;
 
-	nbucket = dir_buckets(level);
+	nbucket = dir_buckets(level, F2FS_I(dir)->i_dir_level);
 	nblock = bucket_blocks(level);
 
-	bidx = dir_block_index(level, (le32_to_cpu(dentry_hash) % nbucket));
+	bidx = dir_block_index(level, F2FS_I(dir)->i_dir_level,
+				(le32_to_cpu(dentry_hash) % nbucket));
 
 	for (block = bidx; block <= (bidx + nblock - 1); block++) {
 		dentry_page = get_new_data_page(dir, NULL, block, true);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4beedcc..a826916 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -200,6 +200,7 @@ struct f2fs_inode_info {
 	struct inode vfs_inode;		/* serve a vfs inode */
 	unsigned long i_flags;		/* keep an inode flags for ioctl */
 	unsigned char i_advise;		/* use to give file attribute hints */
+	unsigned char i_dir_level;	/* use for dentry level for large dir */
 	unsigned int i_current_depth;	/* use only in directory structure */
 	unsigned int i_pino;		/* parent inode number */
 	umode_t i_acl_mode;		/* keep file acl mode temporarily */
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 08d69c9..d518e37 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -107,6 +107,7 @@ static int do_read_inode(struct inode *inode)
 	fi->flags = 0;
 	fi->i_advise = ri->i_advise;
 	fi->i_pino = le32_to_cpu(ri->i_pino);
+	fi->i_dir_level = ri->i_dir_level;
 
 	get_extent_info(&fi->ext, ri->i_ext);
 	get_inline_info(fi, ri);
@@ -204,6 +205,7 @@ void update_inode(struct inode *inode, struct page *node_page)
 	ri->i_flags = cpu_to_le32(F2FS_I(inode)->i_flags);
 	ri->i_pino = cpu_to_le32(F2FS_I(inode)->i_pino);
 	ri->i_generation = cpu_to_le32(inode->i_generation);
+	ri->i_dir_level = F2FS_I(inode)->i_dir_level;
 
 	__set_inode_rdev(inode, ri);
 	set_cold_node(inode, node_page);
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index da74d87..df53e17 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -183,7 +183,7 @@ struct f2fs_inode {
 	__le32 i_pino;			/* parent inode number */
 	__le32 i_namelen;		/* file name length */
 	__u8 i_name[F2FS_NAME_LEN];	/* file name for SPOR */
-	__u8 i_reserved2;		/* for backward compatibility */
+	__u8 i_dir_level;		/* dentry_level for large dir */
 
 	struct f2fs_extent i_ext;	/* caching a largest extent */
 
-- 
1.8.4.474.g128a96c

