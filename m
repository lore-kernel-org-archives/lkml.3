Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaJKI7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 04:59:18 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58492 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaJKI7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 04:59:17 -0400
Date: Sat, 11 Oct 2014 14:29:09 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Anh Le <anhlq2110@gmail.com>
Cc: oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: lustre: llite: fix some sparse warnings about
 userspace pointer
Message-ID: <20141011085909.GB8231@sudip-PC>
References: <1413009077-10158-1-git-send-email-anhlq2110@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413009077-10158-1-git-send-email-anhlq2110@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 01:31:17PM +0700, Anh Le wrote:
> Add __user macro to the function declarations that accept userspace pointers as
> arguments.
>
if you check your patch with --strict option of checkpatch.pl , you will see many check of :
Alignment should match open parenthesis

thanks
sudip


> Signed-off-by: Anh Le <anhlq2110@gmail.com>
> ---
>  .../staging/lustre/lustre/include/lprocfs_status.h |  6 +--
>  drivers/staging/lustre/lustre/llite/lproc_llite.c  | 48 +++++++++++-----------
>  .../lustre/lustre/obdclass/lprocfs_status.c        |  4 +-
>  3 files changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
> index ccb6cd4..42fdb64 100644
> --- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
> +++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
> @@ -374,8 +374,8 @@ static inline void s2dhms(struct dhms *ts, time_t secs)
>  #define JOBSTATS_PROCNAME_UID		"procname_uid"
>  #define JOBSTATS_NODELOCAL		"nodelocal"
>  
> -extern int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
> -				     int *val, int mult);
> +extern int lprocfs_write_frac_helper(const char __user *buffer,
> +		unsigned long count, int *val, int mult);
>  extern int lprocfs_read_frac_helper(char *buffer, unsigned long count,
>  				    long val, int mult);
>  #if defined (CONFIG_PROC_FS)
> @@ -647,7 +647,7 @@ extern int lprocfs_rd_kbytesavail(struct seq_file *m, void *data);
>  extern int lprocfs_rd_filestotal(struct seq_file *m, void *data);
>  extern int lprocfs_rd_filesfree(struct seq_file *m, void *data);
>  
> -extern int lprocfs_write_helper(const char *buffer, unsigned long count,
> +extern int lprocfs_write_helper(const char __user *buffer, unsigned long count,
>  				int *val);
>  extern int lprocfs_seq_read_frac_helper(struct seq_file *m, long val, int mult);
>  extern int lprocfs_write_u64_helper(const char *buffer, unsigned long count,
> diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
> index 3b3df9f..2a97df1 100644
> --- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
> +++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
> @@ -227,8 +227,8 @@ static int ll_max_readahead_mb_seq_show(struct seq_file *m, void *v)
>  	return lprocfs_seq_read_frac_helper(m, pages_number, mult);
>  }
>  
> -static ssize_t ll_max_readahead_mb_seq_write(struct file *file, const char *buffer,
> -					 size_t count, loff_t *off)
> +static ssize_t ll_max_readahead_mb_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
>  	struct ll_sb_info *sbi = ll_s2sbi(sb);
> @@ -269,7 +269,7 @@ static int ll_max_readahead_per_file_mb_seq_show(struct seq_file *m, void *v)
>  }
>  
>  static ssize_t ll_max_readahead_per_file_mb_seq_write(struct file *file,
> -						  const char *buffer,
> +						  const char __user *buffer,
>  						  size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
> @@ -313,7 +313,7 @@ static int ll_max_read_ahead_whole_mb_seq_show(struct seq_file *m, void *unused)
>  }
>  
>  static ssize_t ll_max_read_ahead_whole_mb_seq_write(struct file *file,
> -						const char *buffer,
> +						const char __user *buffer,
>  						size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
> @@ -469,8 +469,8 @@ static int ll_checksum_seq_show(struct seq_file *m, void *v)
>  	return seq_printf(m, "%u\n", (sbi->ll_flags & LL_SBI_CHECKSUM) ? 1 : 0);
>  }
>  
> -static ssize_t ll_checksum_seq_write(struct file *file, const char *buffer,
> -				 size_t count, loff_t *off)
> +static ssize_t ll_checksum_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
>  	struct ll_sb_info *sbi = ll_s2sbi(sb);
> @@ -504,8 +504,8 @@ static int ll_max_rw_chunk_seq_show(struct seq_file *m, void *v)
>  	return seq_printf(m, "%lu\n", ll_s2sbi(sb)->ll_max_rw_chunk);
>  }
>  
> -static ssize_t ll_max_rw_chunk_seq_write(struct file *file, const char *buffer,
> -				     size_t count, loff_t *off)
> +static ssize_t ll_max_rw_chunk_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
>  	int rc, val;
> @@ -533,8 +533,8 @@ static int ll_rd_track_id(struct seq_file *m, enum stats_track_type type)
>  	}
>  }
>  
> -static int ll_wr_track_id(const char *buffer, unsigned long count, void *data,
> -			  enum stats_track_type type)
> +static int ll_wr_track_id(const char __user *buffer, unsigned long count,
> +		 void *data, enum stats_track_type type)
>  {
>  	struct super_block *sb = data;
>  	int rc, pid;
> @@ -556,8 +556,8 @@ static int ll_track_pid_seq_show(struct seq_file *m, void *v)
>  	return ll_rd_track_id(m, STATS_TRACK_PID);
>  }
>  
> -static ssize_t ll_track_pid_seq_write(struct file *file, const char *buffer,
> -				  size_t count, loff_t *off)
> +static ssize_t ll_track_pid_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct seq_file *seq = file->private_data;
>  	return ll_wr_track_id(buffer, count, seq->private, STATS_TRACK_PID);
> @@ -569,8 +569,8 @@ static int ll_track_ppid_seq_show(struct seq_file *m, void *v)
>  	return ll_rd_track_id(m, STATS_TRACK_PPID);
>  }
>  
> -static ssize_t ll_track_ppid_seq_write(struct file *file, const char *buffer,
> -				   size_t count, loff_t *off)
> +static ssize_t ll_track_ppid_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct seq_file *seq = file->private_data;
>  	return ll_wr_track_id(buffer, count, seq->private, STATS_TRACK_PPID);
> @@ -582,8 +582,8 @@ static int ll_track_gid_seq_show(struct seq_file *m, void *v)
>  	return ll_rd_track_id(m, STATS_TRACK_GID);
>  }
>  
> -static ssize_t ll_track_gid_seq_write(struct file *file, const char *buffer,
> -				  size_t count, loff_t *off)
> +static ssize_t ll_track_gid_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct seq_file *seq = file->private_data;
>  	return ll_wr_track_id(buffer, count, seq->private, STATS_TRACK_GID);
> @@ -598,8 +598,8 @@ static int ll_statahead_max_seq_show(struct seq_file *m, void *v)
>  	return seq_printf(m, "%u\n", sbi->ll_sa_max);
>  }
>  
> -static ssize_t ll_statahead_max_seq_write(struct file *file, const char *buffer,
> -				      size_t count, loff_t *off)
> +static ssize_t ll_statahead_max_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
>  	struct ll_sb_info *sbi = ll_s2sbi(sb);
> @@ -628,8 +628,8 @@ static int ll_statahead_agl_seq_show(struct seq_file *m, void *v)
>  			sbi->ll_flags & LL_SBI_AGL_ENABLED ? 1 : 0);
>  }
>  
> -static ssize_t ll_statahead_agl_seq_write(struct file *file, const char *buffer,
> -				      size_t count, loff_t *off)
> +static ssize_t ll_statahead_agl_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
>  	struct ll_sb_info *sbi = ll_s2sbi(sb);
> @@ -672,8 +672,8 @@ static int ll_lazystatfs_seq_show(struct seq_file *m, void *v)
>  			(sbi->ll_flags & LL_SBI_LAZYSTATFS) ? 1 : 0);
>  }
>  
> -static ssize_t ll_lazystatfs_seq_write(struct file *file, const char *buffer,
> -				   size_t count, loff_t *off)
> +static ssize_t ll_lazystatfs_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct super_block *sb = ((struct seq_file *)file->private_data)->private;
>  	struct ll_sb_info *sbi = ll_s2sbi(sb);
> @@ -787,8 +787,8 @@ static int ll_xattr_cache_seq_show(struct seq_file *m, void *v)
>  	return rc;
>  }
>  
> -static ssize_t ll_xattr_cache_seq_write(struct file *file, const char *buffer,
> -					size_t count, loff_t *off)
> +static ssize_t ll_xattr_cache_seq_write(struct file *file,
> +		 const char __user *buffer, size_t count, loff_t *off)
>  {
>  	struct seq_file *seq = file->private_data;
>  	struct super_block *sb = seq->private;
> diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> index 61e04af..686bc18 100644
> --- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> +++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> @@ -177,7 +177,7 @@ int lprocfs_read_frac_helper(char *buffer, unsigned long count, long val,
>  }
>  EXPORT_SYMBOL(lprocfs_read_frac_helper);
>  
> -int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
> +int lprocfs_write_frac_helper(const char __user *buffer, unsigned long count,
>  			      int *val, int mult)
>  {
>  	char kernbuf[20], *end, *pbuf;
> @@ -1819,7 +1819,7 @@ __s64 lprocfs_read_helper(struct lprocfs_counter *lc,
>  }
>  EXPORT_SYMBOL(lprocfs_read_helper);
>  
> -int lprocfs_write_helper(const char *buffer, unsigned long count,
> +int lprocfs_write_helper(const char __user *buffer, unsigned long count,
>  			 int *val)
>  {
>  	return lprocfs_write_frac_helper(buffer, count, val, 1);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
