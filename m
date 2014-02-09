Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaBISJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:09:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaBISJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:09:07 -0500
Message-ID: <52F7C432.8080905@suse.com>
Date: Sun, 09 Feb 2014 13:08:50 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Elder <alex.elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ionut-Gabriel Radu <ihonius@gmail.com>, reiserfs-devel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 20/21] fs: Move prototype declaration to header file reiserfs.h
 from super.c
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com> <764a2eddc09cb8670d757cd4170d44d41b3971e0.1391949868.git.rashika.kheria@gmail.com>
In-Reply-To: <764a2eddc09cb8670d757cd4170d44d41b3971e0.1391949868.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 08:29 AM, Rashika Kheria wrote:
> Move prototype declaration to header file reiserfs/reiserfs.h from
> reiserfs/super.c because they are used by more than one file.
> 
> This eliminates the following warning in reiserfs/bitmap.c:
> fs/reiserfs/bitmap.c:647:6: warning: no previous prototype for ‘show_alloc_options’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Jeff Mahoney <jeffm@suse.com>


> ---
>  fs/reiserfs/reiserfs.h |    1 +
>  fs/reiserfs/super.c    |    1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
> index 8d06adf..83d4eac 100644
> --- a/fs/reiserfs/reiserfs.h
> +++ b/fs/reiserfs/reiserfs.h
> @@ -2831,6 +2831,7 @@ void reiserfs_init_alloc_options(struct super_block *s);
>   */
>  __le32 reiserfs_choose_packing(struct inode *dir);
>  
> +void show_alloc_options(struct seq_file *seq, struct super_block *s);
>  int reiserfs_init_bitmap_cache(struct super_block *sb);
>  void reiserfs_free_bitmap_cache(struct super_block *sb);
>  void reiserfs_cache_bitmap_metadata(struct super_block *sb, struct buffer_head *bh, struct reiserfs_bitmap_info *info);
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index 2c80335..16d5335 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -62,7 +62,6 @@ static int is_any_reiserfs_magic_string(struct reiserfs_super_block *rs)
>  
>  static int reiserfs_remount(struct super_block *s, int *flags, char *data);
>  static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf);
> -void show_alloc_options(struct seq_file *seq, struct super_block *s);
>  
>  static int reiserfs_sync_fs(struct super_block *s, int wait)
>  {
> 


-- 
Jeff Mahoney
SUSE Labs
