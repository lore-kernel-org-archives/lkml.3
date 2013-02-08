Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946350Ab3BHLmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:42:20 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:49348 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946317Ab3BHLmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:42:08 -0500
From: Tommi Rantala <tt.rantala@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: davej@redhat.com, Bill Pemberton <wfp5p@virginia.edu>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 2/2] staging: dgrp: prefix function names with dgrp_ in dgrp_specproc.c
Date: Fri,  8 Feb 2013 13:41:26 +0200
Message-Id: <1360323686-14845-2-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360323686-14845-1-git-send-email-tt.rantala@gmail.com>
References: <1360323686-14845-1-git-send-email-tt.rantala@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefix the functions in dgrp_specproc.c to avoid ambiguity in backtraces, such
as the "info_proc_open" in this one:

unreferenced object 0xffff88003b6696e0 (size 32):
  comm "cat", pid 2321, jiffies 4294705179 (age 29.434s)
  hex dump (first 32 bytes):
    40 79 1c 81 ff ff ff ff 60 79 1c 81 ff ff ff ff  @y......`y......
    50 79 1c 81 ff ff ff ff b0 62 89 81 ff ff ff ff  Py.......b......
  backtrace:
    [<ffffffff81c7e3b1>] kmemleak_alloc+0x21/0x50
    [<ffffffff811955cb>] kmem_cache_alloc_trace+0x11b/0x190
    [<ffffffff811c87dc>] single_open+0x3c/0xc0
    [<ffffffff81896495>] info_proc_open+0x15/0x20
    [<ffffffff8120c6d7>] proc_reg_open+0xb7/0x160
    [<ffffffff811a1a5c>] do_dentry_open+0x1cc/0x280
    [<ffffffff811a296a>] finish_open+0x4a/0x60
    [<ffffffff811b14d7>] do_last+0xb07/0xdb0
    [<ffffffff811b1842>] path_openat+0xc2/0x4f0
    [<ffffffff811b1cac>] do_filp_open+0x3c/0xa0
    [<ffffffff811a2dcc>] do_sys_open+0x11c/0x1c0
    [<ffffffff811a2e8c>] sys_open+0x1c/0x20
    [<ffffffff81ca3d69>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 drivers/staging/dgrp/dgrp_specproc.c | 66 +++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dgrp_specproc.c
index aff6707c..d55e639 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -81,25 +81,26 @@ static struct dgrp_proc_entry dgrp_mon_table[];
 static struct dgrp_proc_entry dgrp_ports_table[];
 static struct dgrp_proc_entry dgrp_dpa_table[];
 
-static ssize_t config_proc_write(struct file *file, const char __user *buffer,
-				 size_t count, loff_t *pos);
+static ssize_t dgrp_config_proc_write(struct file *file,
+				      const char __user *buffer,
+				      size_t count, loff_t *pos);
 
-static int nodeinfo_proc_open(struct inode *inode, struct file *file);
-static int info_proc_open(struct inode *inode, struct file *file);
-static int config_proc_open(struct inode *inode, struct file *file);
+static int dgrp_nodeinfo_proc_open(struct inode *inode, struct file *file);
+static int dgrp_info_proc_open(struct inode *inode, struct file *file);
+static int dgrp_config_proc_open(struct inode *inode, struct file *file);
 
 static struct file_operations config_proc_file_ops = {
 	.owner	 = THIS_MODULE,
-	.open	 = config_proc_open,
+	.open	 = dgrp_config_proc_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
 	.release = seq_release,
-	.write   = config_proc_write
+	.write   = dgrp_config_proc_write,
 };
 
 static struct file_operations info_proc_file_ops = {
 	.owner	 = THIS_MODULE,
-	.open	 = info_proc_open,
+	.open	 = dgrp_info_proc_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
 	.release = single_release,
@@ -107,7 +108,7 @@ static struct file_operations info_proc_file_ops = {
 
 static struct file_operations nodeinfo_proc_file_ops = {
 	.owner	 = THIS_MODULE,
-	.open	 = nodeinfo_proc_open,
+	.open	 = dgrp_nodeinfo_proc_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
 	.release = seq_release,
@@ -403,21 +404,21 @@ done:
 	return 0;
 }
 
-static void *config_proc_start(struct seq_file *m, loff_t *pos)
+static void *dgrp_config_proc_start(struct seq_file *m, loff_t *pos)
 {
 	return seq_list_start_head(&nd_struct_list, *pos);
 }
 
-static void *config_proc_next(struct seq_file *p, void *v, loff_t *pos)
+static void *dgrp_config_proc_next(struct seq_file *p, void *v, loff_t *pos)
 {
 	return seq_list_next(v, &nd_struct_list, pos);
 }
 
-static void config_proc_stop(struct seq_file *m, void *v)
+static void dgrp_config_proc_stop(struct seq_file *m, void *v)
 {
 }
 
-static int config_proc_show(struct seq_file *m, void *v)
+static int dgrp_config_proc_show(struct seq_file *m, void *v)
 {
 	struct nd_struct *nd;
 	char tmp_id[4];
@@ -443,13 +444,13 @@ static int config_proc_show(struct seq_file *m, void *v)
 }
 
 static const struct seq_operations proc_config_ops = {
-	.start = config_proc_start,
-	.next  = config_proc_next,
-	.stop  = config_proc_stop,
-	.show  = config_proc_show
+	.start = dgrp_config_proc_start,
+	.next  = dgrp_config_proc_next,
+	.stop  = dgrp_config_proc_stop,
+	.show  = dgrp_config_proc_show,
 };
 
-static int config_proc_open(struct inode *inode, struct file *file)
+static int dgrp_config_proc_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &proc_config_ops);
 }
@@ -460,8 +461,9 @@ static int config_proc_open(struct inode *inode, struct file *file)
  *  write) is treated as an independent request.  See the "parse"
  *  description for more details.
  */
-static ssize_t config_proc_write(struct file *file, const char __user *buffer,
-				 size_t count, loff_t *pos)
+static ssize_t dgrp_config_proc_write(struct file *file,
+				      const char __user *buffer,
+				      size_t count, loff_t *pos)
 {
 	ssize_t retval;
 	char *inbuf, *sp;
@@ -625,7 +627,7 @@ static int parse_write_config(char *buf)
 	return retval;
 }
 
-static int info_proc_show(struct seq_file *m, void *v)
+static int dgrp_info_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "version: %s\n", DIGI_VERSION);
 	seq_puts(m, "register_with_sysfs: 1\n");
@@ -635,27 +637,27 @@ static int info_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int info_proc_open(struct inode *inode, struct file *file)
+static int dgrp_info_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, info_proc_show, NULL);
+	return single_open(file, dgrp_info_proc_show, NULL);
 }
 
 
-static void *nodeinfo_start(struct seq_file *m, loff_t *pos)
+static void *dgrp_nodeinfo_start(struct seq_file *m, loff_t *pos)
 {
 	return seq_list_start_head(&nd_struct_list, *pos);
 }
 
-static void *nodeinfo_next(struct seq_file *p, void *v, loff_t *pos)
+static void *dgrp_nodeinfo_next(struct seq_file *p, void *v, loff_t *pos)
 {
 	return seq_list_next(v, &nd_struct_list, pos);
 }
 
-static void nodeinfo_stop(struct seq_file *m, void *v)
+static void dgrp_nodeinfo_stop(struct seq_file *m, void *v)
 {
 }
 
-static int nodeinfo_show(struct seq_file *m, void *v)
+static int dgrp_nodeinfo_show(struct seq_file *m, void *v)
 {
 	struct nd_struct *nd;
 	char hwver[8];
@@ -697,13 +699,13 @@ static int nodeinfo_show(struct seq_file *m, void *v)
 
 
 static const struct seq_operations nodeinfo_ops = {
-	.start = nodeinfo_start,
-	.next  = nodeinfo_next,
-	.stop  = nodeinfo_stop,
-	.show  = nodeinfo_show
+	.start = dgrp_nodeinfo_start,
+	.next  = dgrp_nodeinfo_next,
+	.stop  = dgrp_nodeinfo_stop,
+	.show  = dgrp_nodeinfo_show,
 };
 
-static int nodeinfo_proc_open(struct inode *inode, struct file *file)
+static int dgrp_nodeinfo_proc_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &nodeinfo_ops);
 }
-- 
1.8.1

