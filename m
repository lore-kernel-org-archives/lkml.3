Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbaGBUsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:48:51 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:7611 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbaGBUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:48:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicIANBvtFNXQBPR/2dsb2JhbABagw2sbgEBAQEBAQUBbgGZZwGBBhd1hAQBBScvIxBROR4ZiEYBx2QXhXCJMgeEQwWQBYpolAqDRTs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, sasha.levin@oracle.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/4] FS/CRAMFS: code clean-up
Date: Wed,  2 Jul 2014 22:47:14 +0200
Message-Id: <1404334035-7027-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404334035-7027-1-git-send-email-fabf@skynet.be>
References: <1404334035-7027-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes some checkpatch errors/warnings:

WARNING: Missing a blank line after declarations
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: "foo * bar" should be "foo *bar"
ERROR: space prohibited after that open parenthesis '('

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cramfs/inode.c      | 25 ++++++++++++++-----------
 fs/cramfs/uncompress.c |  2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index fa5c759..4d37c35 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -155,7 +155,7 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 
 static unsigned char read_buffers[READ_BUFFERS][BUFFER_SIZE];
 static unsigned buffer_blocknr[READ_BUFFERS];
-static struct super_block * buffer_dev[READ_BUFFERS];
+static struct super_block *buffer_dev[READ_BUFFERS];
 static int next_buffer;
 
 /*
@@ -207,6 +207,7 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
 
 	for (i = 0; i < BLKS_PER_BUF; i++) {
 		struct page *page = pages[i];
+
 		if (page) {
 			wait_on_page_locked(page);
 			if (!PageUptodate(page)) {
@@ -225,6 +226,7 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
 	data = read_buffers[buffer];
 	for (i = 0; i < BLKS_PER_BUF; i++) {
 		struct page *page = pages[i];
+
 		if (page) {
 			memcpy(data, kmap(page), PAGE_CACHE_SIZE);
 			kunmap(page);
@@ -239,6 +241,7 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
 static void cramfs_kill_sb(struct super_block *sb)
 {
 	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+
 	kill_block_super(sb);
 	kfree(sbi);
 }
@@ -312,16 +315,16 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	root_offset = super.root.offset << 2;
 	if (super.flags & CRAMFS_FLAG_FSID_VERSION_2) {
-		sbi->size=super.size;
-		sbi->blocks=super.fsid.blocks;
-		sbi->files=super.fsid.files;
+		sbi->size = super.size;
+		sbi->blocks = super.fsid.blocks;
+		sbi->files = super.fsid.files;
 	} else {
-		sbi->size=1<<28;
-		sbi->blocks=0;
-		sbi->files=0;
+		sbi->size = 1<<28;
+		sbi->blocks = 0;
+		sbi->files = 0;
 	}
-	sbi->magic=super.magic;
-	sbi->flags=super.flags;
+	sbi->magic = super.magic;
+	sbi->flags = super.flags;
 	if (root_offset == 0)
 		pr_info("empty filesystem");
 	else if (!(super.flags & CRAMFS_FLAG_SHIFTED_ROOT_OFFSET) &&
@@ -427,7 +430,7 @@ static int cramfs_readdir(struct file *file, struct dir_context *ctx)
 /*
  * Lookup and fill in the inode data..
  */
-static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
+static struct dentry *cramfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	unsigned int offset = 0;
 	struct inode *inode = NULL;
@@ -485,7 +488,7 @@ out:
 	return NULL;
 }
 
-static int cramfs_readpage(struct file *file, struct page * page)
+static int cramfs_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	u32 maxblock;
diff --git a/fs/cramfs/uncompress.c b/fs/cramfs/uncompress.c
index b7f030b..ec4f1d4 100644
--- a/fs/cramfs/uncompress.c
+++ b/fs/cramfs/uncompress.c
@@ -59,7 +59,7 @@ int cramfs_uncompress_init(void)
 {
 	if (!initialized++) {
 		stream.workspace = vmalloc(zlib_inflate_workspacesize());
-		if ( !stream.workspace ) {
+		if (!stream.workspace) {
 			initialized = 0;
 			return -ENOMEM;
 		}
-- 
1.8.4.5

