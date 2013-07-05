Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3GEImy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:42:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63007 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3GEImw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:42:52 -0400
X-AuditID: cbfee691-b7fef6d000002d62-f3-51d686fd5e6a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: add proc entry to monitor current usage of segments
Date: Fri, 05 Jul 2013 17:42:29 +0900
Message-id: <1373013749-10370-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zfd2/bdcCDU6+0bC4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2N1/2WmgtvSFUuu
	L2BpYLwr1sXIySEhYCJxd+ovVghbTOLCvfVsXYxcHEICyxgl5jZeZoMparl2gBEisYhRorNl
	P1RVG5PErcttLF2MHBxsAtoSm/cbgDSICDBLLJh6HqyBWWACo8T/Re9ZQBLCAl4SL1+3g9ks
	AqoSp2ZNALN5BdwlfjQdZoHYpiux6MRBVpBmCYH7bBKLtxxlh2gQkPg2+RDYMgkBWYlNB5gh
	6iUlDq64wTKBUXABI8MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJAgnLiD8f4B60OMyUDj
	JjJLiSbnA4M4ryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2M6w7e4pB78/9F+3nVzWfXZh/dvteCbbHn1G1s/n9apyWxvNjWp9gvUjtV8drC5lM9
	0q+fTytmv126oVzv4zlLuUn20z9KH9u/T3HTx/O+vz5pKl3jWHZoq0y4E2/zk72PzG7P6Zx+
	4Pq9Jr1P0+s8RCVzZx5cZRI4pcRto3np+7h1d6/5fZnlmqvEUpyRaKjFXFScCADte8idWAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd2/bdcCDS6vUbG4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFjdf9lpoLb0hVLri9gaWC8K9bFyMkhIWAi0XLtACOELSZx4d56ti5GLg4h
	gUWMEp0t+6GcNiaJW5fbWLoYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAW8
	JF6+bgezWQRUJU7NmgBm8wq4S/xoOswCsU1XYtGJg6wTGLkXMDKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAgO8WfSOxhXNVgcYhTgYFTi4X1QfzVQiDWxrLgy9xCjBAezkgivfcK1QCHe
	lMTKqtSi/Pii0pzU4kOMyUDbJzJLiSbnA+MvryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC
	6YklqdmpqQWpRTBbmDg4pRoY9edkKzStZmOM4l8xO09c5aYx6/63Et++ThHO3315v+jcXd/M
	2cyenN6ePe9csFTgfs66ZQW/nS/+bzcId9LM2sN2rdn4t6kJY4z8yj0Wbdf0Q/O8tedxTLqU
	v7hUx9WiYrULo/4Mzx9Ll8oHr5gauOPa5JJ1sau3fn1mv6fyutRFd7WuE92cSizFGYmGWsxF
	xYkAT3hpXbUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can monitor valid block counts of whole segments in:
  /proc/fs/f2fs/sdb1/segment_info.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/super.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 82e187f..e3a611d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -365,6 +365,7 @@ enum page_type {
 
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
+	struct proc_dir_entry *s_proc;		/* proc entry */
 	struct buffer_head *raw_super_buf;	/* buffer head of raw sb */
 	struct f2fs_super_block *raw_super;	/* raw super block pointer */
 	int s_dirty;				/* dirty flag for checkpoint */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index d48d995..1ed0279 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -18,6 +18,7 @@
 #include <linux/parser.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/proc_fs.h>
 #include <linux/random.h>
 #include <linux/exportfs.h>
 #include <linux/blkdev.h>
@@ -31,6 +32,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/f2fs.h>
 
+static struct proc_dir_entry *f2fs_proc_root;
 static struct kmem_cache *f2fs_inode_cachep;
 
 enum {
@@ -404,6 +406,11 @@ static void f2fs_put_super(struct super_block *sb)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 
+	if (sbi->s_proc) {
+		remove_proc_entry("segment_info", sbi->s_proc);
+		remove_proc_entry(sb->s_id, f2fs_proc_root);
+	}
+
 	f2fs_destroy_stats(sbi);
 	stop_gc_thread(sbi);
 
@@ -521,6 +528,36 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 	return 0;
 }
 
+static int segment_info_seq_show(struct seq_file *seq, void *offset)
+{
+	struct super_block *sb = seq->private;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	unsigned int total_segs = le32_to_cpu(sbi->raw_super->segment_count_main);
+	int i;
+
+	for (i = 0; i < total_segs; i++) {
+		seq_printf(seq, "%u", get_valid_blocks(sbi, i, 1));
+		if (i != 0 && (i % 10) == 0)
+			seq_puts(seq, "\n");
+		else
+			seq_puts(seq, " ");
+	}
+	return 0;
+}
+
+static int segment_info_open_fs(struct inode *inode, struct file *file)
+{
+	return single_open(file, segment_info_seq_show, PDE_DATA(inode));
+}
+
+static const struct file_operations f2fs_seq_segment_info_fops = {
+	.owner = THIS_MODULE,
+	.open = segment_info_open_fs,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
@@ -947,6 +984,13 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto fail;
 
+	if (f2fs_proc_root)
+		sbi->s_proc = proc_mkdir(sb->s_id, f2fs_proc_root);
+
+	if (sbi->s_proc)
+		proc_create_data("segment_info", S_IRUGO, sbi->s_proc,
+				 &f2fs_seq_segment_info_fops, sb);
+
 	if (test_opt(sbi, DISCARD)) {
 		struct request_queue *q = bdev_get_queue(sb->s_bdev);
 		if (!blk_queue_discard(q))
@@ -1033,12 +1077,14 @@ static int __init init_f2fs_fs(void)
 	if (err)
 		goto fail;
 	f2fs_create_root_stats();
+	f2fs_proc_root = proc_mkdir("fs/f2fs", NULL);
 fail:
 	return err;
 }
 
 static void __exit exit_f2fs_fs(void)
 {
+	remove_proc_entry("fs/f2fs", NULL);
 	f2fs_destroy_root_stats();
 	unregister_filesystem(&f2fs_fs_type);
 	destroy_checkpoint_caches();
-- 
1.8.3.1.437.g0dbd812

