Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaJLJH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 05:07:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52655 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaJLJHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 05:07:24 -0400
From: Anh Le <anhlq2110@gmail.com>
To: oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sudipm.mukherjee@gmail.com
Subject: [PATCH v2] Staging: lustre: llite: fix some sparse warnings about userspace pointer
Date: Sun, 12 Oct 2014 16:07:10 +0700
Message-Id: <1413104830-5287-1-git-send-email-anhlq2110@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413009077-10158-1-git-send-email-anhlq2110@gmail.com>
References: <1413009077-10158-1-git-send-email-anhlq2110@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __user macro to the function declarations that accept userspace pointers as
arguments.

Signed-off-by: Anh Le <anhlq2110@gmail.com>
---
v2: Fixed checkpatch's parenthesis alignment warnings, noted by Sudip Mukherjee <sudipm.mukherjee@gmail.com>.

 .../staging/lustre/lustre/include/lprocfs_status.h |  6 +--
 drivers/staging/lustre/lustre/llite/lproc_llite.c  | 56 +++++++++++++---------
 .../lustre/lustre/obdclass/lprocfs_status.c        |  4 +-
 3 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index ccb6cd4..54c5226 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -374,8 +374,8 @@ static inline void s2dhms(struct dhms *ts, time_t secs)
 #define JOBSTATS_PROCNAME_UID		"procname_uid"
 #define JOBSTATS_NODELOCAL		"nodelocal"
 
-extern int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
-				     int *val, int mult);
+extern int lprocfs_write_frac_helper(const char __user *buffer,
+				     unsigned long count, int *val, int mult);
 extern int lprocfs_read_frac_helper(char *buffer, unsigned long count,
 				    long val, int mult);
 #if defined (CONFIG_PROC_FS)
@@ -647,7 +647,7 @@ extern int lprocfs_rd_kbytesavail(struct seq_file *m, void *data);
 extern int lprocfs_rd_filestotal(struct seq_file *m, void *data);
 extern int lprocfs_rd_filesfree(struct seq_file *m, void *data);
 
-extern int lprocfs_write_helper(const char *buffer, unsigned long count,
+extern int lprocfs_write_helper(const char __user *buffer, unsigned long count,
 				int *val);
 extern int lprocfs_seq_read_frac_helper(struct seq_file *m, long val, int mult);
 extern int lprocfs_write_u64_helper(const char *buffer, unsigned long count,
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 3b3df9f..dd52b81 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -227,8 +227,9 @@ static int ll_max_readahead_mb_seq_show(struct seq_file *m, void *v)
 	return lprocfs_seq_read_frac_helper(m, pages_number, mult);
 }
 
-static ssize_t ll_max_readahead_mb_seq_write(struct file *file, const char *buffer,
-					 size_t count, loff_t *off)
+static ssize_t ll_max_readahead_mb_seq_write(struct file *file,
+					     const char __user *buffer,
+					     size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -269,7 +270,7 @@ static int ll_max_readahead_per_file_mb_seq_show(struct seq_file *m, void *v)
 }
 
 static ssize_t ll_max_readahead_per_file_mb_seq_write(struct file *file,
-						  const char *buffer,
+						  const char __user *buffer,
 						  size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
@@ -313,7 +314,7 @@ static int ll_max_read_ahead_whole_mb_seq_show(struct seq_file *m, void *unused)
 }
 
 static ssize_t ll_max_read_ahead_whole_mb_seq_write(struct file *file,
-						const char *buffer,
+						const char __user *buffer,
 						size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
@@ -469,8 +470,9 @@ static int ll_checksum_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%u\n", (sbi->ll_flags & LL_SBI_CHECKSUM) ? 1 : 0);
 }
 
-static ssize_t ll_checksum_seq_write(struct file *file, const char *buffer,
-				 size_t count, loff_t *off)
+static ssize_t ll_checksum_seq_write(struct file *file,
+				     const char __user *buffer,
+				     size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -504,8 +506,9 @@ static int ll_max_rw_chunk_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%lu\n", ll_s2sbi(sb)->ll_max_rw_chunk);
 }
 
-static ssize_t ll_max_rw_chunk_seq_write(struct file *file, const char *buffer,
-				     size_t count, loff_t *off)
+static ssize_t ll_max_rw_chunk_seq_write(struct file *file,
+					 const char __user *buffer,
+					 size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
 	int rc, val;
@@ -533,8 +536,8 @@ static int ll_rd_track_id(struct seq_file *m, enum stats_track_type type)
 	}
 }
 
-static int ll_wr_track_id(const char *buffer, unsigned long count, void *data,
-			  enum stats_track_type type)
+static int ll_wr_track_id(const char __user *buffer, unsigned long count,
+			  void *data, enum stats_track_type type)
 {
 	struct super_block *sb = data;
 	int rc, pid;
@@ -556,8 +559,9 @@ static int ll_track_pid_seq_show(struct seq_file *m, void *v)
 	return ll_rd_track_id(m, STATS_TRACK_PID);
 }
 
-static ssize_t ll_track_pid_seq_write(struct file *file, const char *buffer,
-				  size_t count, loff_t *off)
+static ssize_t ll_track_pid_seq_write(struct file *file,
+				      const char __user *buffer,
+				      size_t count, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 	return ll_wr_track_id(buffer, count, seq->private, STATS_TRACK_PID);
@@ -569,8 +573,9 @@ static int ll_track_ppid_seq_show(struct seq_file *m, void *v)
 	return ll_rd_track_id(m, STATS_TRACK_PPID);
 }
 
-static ssize_t ll_track_ppid_seq_write(struct file *file, const char *buffer,
-				   size_t count, loff_t *off)
+static ssize_t ll_track_ppid_seq_write(struct file *file,
+				       const char __user *buffer,
+				       size_t count, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 	return ll_wr_track_id(buffer, count, seq->private, STATS_TRACK_PPID);
@@ -582,8 +587,9 @@ static int ll_track_gid_seq_show(struct seq_file *m, void *v)
 	return ll_rd_track_id(m, STATS_TRACK_GID);
 }
 
-static ssize_t ll_track_gid_seq_write(struct file *file, const char *buffer,
-				  size_t count, loff_t *off)
+static ssize_t ll_track_gid_seq_write(struct file *file,
+				      const char __user *buffer,
+				      size_t count, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
 	return ll_wr_track_id(buffer, count, seq->private, STATS_TRACK_GID);
@@ -598,8 +604,9 @@ static int ll_statahead_max_seq_show(struct seq_file *m, void *v)
 	return seq_printf(m, "%u\n", sbi->ll_sa_max);
 }
 
-static ssize_t ll_statahead_max_seq_write(struct file *file, const char *buffer,
-				      size_t count, loff_t *off)
+static ssize_t ll_statahead_max_seq_write(struct file *file,
+					  const char __user *buffer,
+					  size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -628,8 +635,9 @@ static int ll_statahead_agl_seq_show(struct seq_file *m, void *v)
 			sbi->ll_flags & LL_SBI_AGL_ENABLED ? 1 : 0);
 }
 
-static ssize_t ll_statahead_agl_seq_write(struct file *file, const char *buffer,
-				      size_t count, loff_t *off)
+static ssize_t ll_statahead_agl_seq_write(struct file *file,
+					  const char __user *buffer,
+					  size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -672,8 +680,9 @@ static int ll_lazystatfs_seq_show(struct seq_file *m, void *v)
 			(sbi->ll_flags & LL_SBI_LAZYSTATFS) ? 1 : 0);
 }
 
-static ssize_t ll_lazystatfs_seq_write(struct file *file, const char *buffer,
-				   size_t count, loff_t *off)
+static ssize_t ll_lazystatfs_seq_write(struct file *file,
+				       const char __user *buffer,
+				       size_t count, loff_t *off)
 {
 	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
@@ -787,7 +796,8 @@ static int ll_xattr_cache_seq_show(struct seq_file *m, void *v)
 	return rc;
 }
 
-static ssize_t ll_xattr_cache_seq_write(struct file *file, const char *buffer,
+static ssize_t ll_xattr_cache_seq_write(struct file *file,
+					const char __user *buffer,
 					size_t count, loff_t *off)
 {
 	struct seq_file *seq = file->private_data;
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 61e04af..686bc18 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -177,7 +177,7 @@ int lprocfs_read_frac_helper(char *buffer, unsigned long count, long val,
 }
 EXPORT_SYMBOL(lprocfs_read_frac_helper);
 
-int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
+int lprocfs_write_frac_helper(const char __user *buffer, unsigned long count,
 			      int *val, int mult)
 {
 	char kernbuf[20], *end, *pbuf;
@@ -1819,7 +1819,7 @@ __s64 lprocfs_read_helper(struct lprocfs_counter *lc,
 }
 EXPORT_SYMBOL(lprocfs_read_helper);
 
-int lprocfs_write_helper(const char *buffer, unsigned long count,
+int lprocfs_write_helper(const char __user *buffer, unsigned long count,
 			 int *val)
 {
 	return lprocfs_write_frac_helper(buffer, count, val, 1);
-- 
1.9.1

