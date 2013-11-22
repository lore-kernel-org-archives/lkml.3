Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3KVDgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:36:38 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60850 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3KVDgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:36:33 -0500
Message-ID: <1385091383.25843.1.camel@phoenix>
Subject: [PATCH] ramfs: move ramfs_aops to inode.c
From: Axel Lin <axel.lin@ingics.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 22 Nov 2013 11:36:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ramfs_aops is identical in file-mmu.c and file-nommu.c.
Thus move it to fs/ramfs/inode.c and make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 fs/ramfs/file-mmu.c   | 7 -------
 fs/ramfs/file-nommu.c | 7 -------
 fs/ramfs/inode.c      | 7 +++++++
 fs/ramfs/internal.h   | 1 -
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index 4884ac5..1e56a4e 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -30,13 +30,6 @@
 
 #include "internal.h"
 
-const struct address_space_operations ramfs_aops = {
-	.readpage	= simple_readpage,
-	.write_begin	= simple_write_begin,
-	.write_end	= simple_write_end,
-	.set_page_dirty = __set_page_dirty_no_writeback,
-};
-
 const struct file_operations ramfs_file_operations = {
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 80862b1..0b3d8e4 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -34,13 +34,6 @@ static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 						   unsigned long flags);
 static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma);
 
-const struct address_space_operations ramfs_aops = {
-	.readpage		= simple_readpage,
-	.write_begin		= simple_write_begin,
-	.write_end		= simple_write_end,
-	.set_page_dirty		= __set_page_dirty_no_writeback,
-};
-
 const struct file_operations ramfs_file_operations = {
 	.mmap			= ramfs_nommu_mmap,
 	.get_unmapped_area	= ramfs_nommu_get_unmapped_area,
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 39d1465..6eadc96 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -43,6 +43,13 @@
 static const struct super_operations ramfs_ops;
 static const struct inode_operations ramfs_dir_inode_operations;
 
+static const struct address_space_operations ramfs_aops = {
+	.readpage	= simple_readpage,
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
+};
+
 static struct backing_dev_info ramfs_backing_dev_info = {
 	.name		= "ramfs",
 	.ra_pages	= 0,	/* No readahead */
diff --git a/fs/ramfs/internal.h b/fs/ramfs/internal.h
index 6b33063..a9d8ae8 100644
--- a/fs/ramfs/internal.h
+++ b/fs/ramfs/internal.h
@@ -10,5 +10,4 @@
  */
 
 
-extern const struct address_space_operations ramfs_aops;
 extern const struct inode_operations ramfs_file_inode_operations;
-- 
1.8.1.2



