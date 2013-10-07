Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3JGCmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 22:42:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16917 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3JGCmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 22:42:09 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f1e6d000004e8d-45-52521f7f4e4d
Content-transfer-encoding: 8BIT
Message-id: <1381113703.4529.61.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH]f2fs: avoid congestion_wait when do_checkpoint
 for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: yuan zhong <yuan.mark.zhong@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, shu.tan@samsung.com
Date: Mon, 07 Oct 2013 11:41:43 +0900
In-reply-to: <000201cebdc7$dec4bce0$9c4e36a0$%mark.zhong@samsung.com>
References: <000201cebdc7$dec4bce0$9c4e36a0$%mark.zhong@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zQ916+aAgg4v/RCwuLXK32LP3JIvF
	5V1z2CxaF55ntvizqZPJgdVj94LPTB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV8eXPJ8aC
	TTIVqw8eZ2pgnCTexcjBISFgInF1n0AXIyeQKSZx4d56ti5GLg4hgWWMEo9O3maDSJhI3Pv7
	ixEiMZ1RonN+K1iCV0BQ4sfkeywgg5gF5CWOXMoGCTMLqEtMmreIGaL+FaNE7/pL7CA1vAI6
	Ehv2FIDUCAukSnR197GBhNkEtCU27zcACQsJKEq83X+XFcQWAaru2LiQHWJknUTrzAfMIDaL
	gKrEsfOdLCA2p4CrxLL2U4wQvS4Snz48A6vnFxCVOLxwOzPE+UoSu9s72UHOkRA4xy5xs+8G
	I8QgAYlvkw+xQMJBVmLTAah6SYmDK26wTGCUmIXkyVkIT85C8uQCRuZVjKKpBckFxUnpRcZ6
	xYm5xaV56XrJ+bmbGCFR17+D8e4B60OMyUAbJzJLiSbnA6M2ryTe0NjMyMLUxNTYyNzSjDRh
	JXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MHWVf42rYMxNeOObO41Wv+RR7QnmN
	ejX78+Xp4eISmu+u9jhyf28U4T2/srXrsvyi4Hty7pZRJy6qXa9cc1X7q4ZiWr9RfVV8n+DC
	rwu3/9l63sgj/Y1x2otJibxx/gKh6+aFC7G6mX47+0a+qDvpy9IXpxoL5WTO37T25BbZHH5h
	jZHWu1wlluKMREMt5qLiRACYsV0e0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd16+aAgg9svBSwuLXK32LP3JIvF
	5V1z2CxaF55ntvizqZPJgdVj94LPTB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmPHlzyfGgk0yFasPHmdqYJwk3sXIySEhYCJx7+8vRghbTOLCvfVs
	XYxcHEIC0xklOue3soEkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWvGCV6119i
	B6nhFdCR2LCnAKRGWCBVoqu7jw0kzCagLbF5vwFIWEhAUeLt/rusILYIUHXHxoXsECPrJFpn
	PmAGsVkEVCWOne9kAbE5BVwllrWfYoTodZH49OEZWD2/gKjE4YXbmSHOV5LY3d7JPoFRaBaS
	o2chHD0LydELGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH9TPpHYyrGiwOMQpwMCrx
	8O64HxgkxJpYVlyZe4hRgoNZSYT3Uh1QiDclsbIqtSg/vqg0J7X4EGMy0OETmaVEk/OBCSev
	JN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgTazwyZlT0rbuZ
	fSWz527IQ4+5kb8dM72/XFp90dSvePF5KRe5g4Irf73rbN2WKMQR0WF8qTbsqPnfovKPzRp+
	rBt/dYnt115asOXB5s4LS0sLE7ceydrdmXGiYf+zYwYm/ze84Y3X1Eq4pfr1IHfw3KoJC+qF
	V5p3M005xjyrU1ptz/2dVwKVWIozEg21mIuKEwHvccBxLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please do checkpatch.pl before sending a patch.
Thanks,

2013-09-30 (월), 18:28 +0800, yuan zhong:
> Previously,  do_checkpoint() will call congestion_wait() for waiting the pages (previous submitted node/meta/data pages) to be written back.
> Because congestion_wait() will set a regular period (e.g. HZ / 50 ) for waiting.
> For this reason, there is a situation that after the pages have been written back, but the checkpoint thread still wait for congestion_wait to exit.
> This is a problem here, especially, when sync a large number of small files or dirs.
> In order to avoid this, a wait_list is introduced, the checkpoint thread will be dropped into the wait_list if the pages have not been written back, and will be waked up by contrast.
> 
> Signed-off-by: Yuan Zhong <yuan.mark.zhong@samsung.com>
> ---
>  fs/f2fs/checkpoint.c |  3 +--
>  fs/f2fs/f2fs.h       | 19 +++++++++++++++++++
>  fs/f2fs/segment.c    |  1 +
>  fs/f2fs/super.c      |  1 +
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c index bb31220..cf6b4a5 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -756,8 +756,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
>  	f2fs_put_page(cp_page, 1);
>  
>  	/* wait for previous submitted node/meta pages writeback */
> -	while (get_pages(sbi, F2FS_WRITEBACK))
> -		congestion_wait(BLK_RW_ASYNC, HZ / 50);
> +	f2fs_writeback_wait(sbi);
>  
>  	filemap_fdatawait_range(sbi->node_inode->i_mapping, 0, LONG_MAX);
>  	filemap_fdatawait_range(sbi->meta_inode->i_mapping, 0, LONG_MAX); diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h index 608f0df..f8b62cc 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -18,6 +18,7 @@
>  #include <linux/crc32.h>
>  #include <linux/magic.h>
>  #include <linux/kobject.h>
> +#include <linux/wait.h>
>  
>  /*
>   * For mount options
> @@ -430,6 +431,8 @@ struct f2fs_sb_info {
>  	/* For sysfs suppport */
>  	struct kobject s_kobj;
>  	struct completion s_kobj_unregister;
> +	
> +	wait_queue_head_t writeback_wqh;
>  };
>  
>  /*
> @@ -961,6 +964,22 @@ static inline int f2fs_readonly(struct super_block *sb)
>  	return sb->s_flags & MS_RDONLY;
>  }
>  
> +static inline void f2fs_writeback_wait(struct f2fs_sb_info *sbi) {
> +	DEFINE_WAIT(wait);
> +
> +	prepare_to_wait(&sbi->writeback_wqh, &wait, TASK_UNINTERRUPTIBLE);
> +	if (get_pages(sbi, F2FS_WRITEBACK))
> +		io_schedule();
> +	finish_wait(&sbi->writeback_wqh, &wait); }
> +
> +static inline void f2fs_writeback_wake(struct f2fs_sb_info *sbi) {
> +	if (!get_pages(sbi, F2FS_WRITEBACK))
> +		wake_up_all(&sbi->writeback_wqh);
> +}
> +
>  /*
>   * file.c
>   */
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c index 09af9c7..79293fe 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -597,6 +597,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
>  
>  	if (p->is_sync)
>  		complete(p->wait);
> +	f2fs_writeback_wake(p->sbi);	
>  	kfree(p);
>  	bio_put(bio);
>  }
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c index 13d0a0f..b31f686 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -818,6 +818,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>  	mutex_init(&sbi->gc_mutex);
>  	mutex_init(&sbi->writepages);
>  	mutex_init(&sbi->cp_mutex);
> +	init_waitqueue_head(&sbi->writeback_wqh);
>  	for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>  		mutex_init(&sbi->fs_lock[i]);
>  	mutex_init(&sbi->node_write);
> 

-- 
Jaegeuk Kim
Samsung

