Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaHVH6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:58:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16976 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHVH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:58:41 -0400
X-AuditID: cbfee61b-f79f86d00000144c-43-53f6f82f06c1
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-13-git-send-email-jaegeuk@kernel.org>
 <007f01cfbc62$8aeb3140$a0c193c0$@samsung.com>
 <20140821203215.GA85961@jaegeuk-mac02.mot-mobility.com>
In-reply-to: <20140821203215.GA85961@jaegeuk-mac02.mot-mobility.com>
Subject: RE: [f2fs-dev] [PATCH 13/13] f2fs: handle EIO not to break fs
 consistency
Date: Fri, 22 Aug 2014 15:57:54 +0800
Message-id: <000c01cfbdde$e2274ed0$a675ec70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwHOJEfvAaPryAMB+xB/Spvezfhw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jQV39H9+CDXZ8VbZ4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+P0jROsBYd8Kjr+
	/GJvYFxi3cXIySEhYCIxpeMLI4QtJnHh3nq2LkYuDiGB6YwSd9f9ZYVwfjBK9HXOYwepYhNQ
	kVje8Z8JxBYRUJPo3TcFzGYWyJSY0P+CHaLhGaPEq8dbwBKcAi4Sf383g9nCAiESC7fvYAGx
	WQRUJfZsmcsMYvMKWErsub2cHcIWlPgx+R4LxFAtifU7j0MtkJfYvOYtM8SpChI7zr5mhDjC
	TeLJ3z1sEDXiEhuP3GKZwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxgoP/mfQOxlUNFocYBTgYlXh4I758DRZiTSwrrsw9xCjBwawkwrtp3rdgId6UxMqq
	1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYzFXR4vFOV9t13ZHxd8
	N+T9z3nelWtSVzh3T9899yxX4zP1//frO15c4mreVXxc/e3Nx/cXSujUdN+L2nTPetVVhTeb
	kg9O7Sy5991fobfqYG31qcknk/IVvZ/LuPwuUyyoCz/9JfObeDlP3WrmJ+19xiUCF8tkezJc
	O3t+rbn+csefhB77GmYlluKMREMt5qLiRADjGQC/egIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, August 22, 2014 4:34 AM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 13/13] f2fs: handle EIO not to break fs consistency
> 
> On Wed, Aug 20, 2014 at 06:35:18PM +0800, Chao Yu wrote:
> > Hi Jaegeuk,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > Sent: Wednesday, August 13, 2014 3:49 AM
> > > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > > linux-f2fs-devel@lists.sourceforge.net
> > > Cc: Jaegeuk Kim
> > > Subject: [f2fs-dev] [PATCH 13/13] f2fs: handle EIO not to break fs consistency
> > >
> > > There are two rules when EIO is occurred.
> > > 1. don't write any checkpoint data to preserve the previous checkpoint
> > > 2. don't lose the cached data/node/meta pages
> > >
> > > So, at first, this patch adds set_page_dirty in f2fs_write_end_io's failure.
> > > Then, writing checkpoint/dentry/node blocks is not allowed.
> >
> > do_checkpoint()
> > 	/* wait for previous submitted node/meta pages writeback */
> > 	wait_on_all_pages_writeback(sbi);
> >
> > 	if (unlikely(f2fs_cp_error(sbi)))
> > 		return;
> > add here to prevent unneeded syncing for meta/node pages.
> 
> Well, there is one below. But it's not a big deal to change the location.

I saw the last code in git respository, it's not like what I thought.
What I meant is to add one additionally here, not moving from below to here.
It's my mistaken that having expressed unclearly, but like what you said,
it's not a big deal, let's pass it.

> 
> >
> > >
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >  fs/f2fs/checkpoint.c | 47 +++++++++++++++++++++++++++++++++--------------
> > >  fs/f2fs/data.c       | 10 +++++++++-
> > >  fs/f2fs/f2fs.h       |  1 +
> > >  fs/f2fs/node.c       |  2 ++
> > >  fs/f2fs/super.c      |  3 +++
> > >  5 files changed, 48 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > > index d074e27..b365c64 100644
> > > --- a/fs/f2fs/checkpoint.c
> > > +++ b/fs/f2fs/checkpoint.c
> > > @@ -160,14 +160,11 @@ static int f2fs_write_meta_page(struct page *page,
> > >  		goto redirty_out;
> > >  	if (wbc->for_reclaim)
> > >  		goto redirty_out;
> > > -
> > > -	/* Should not write any meta pages, if any IO error was occurred */
> > >  	if (unlikely(f2fs_cp_error(sbi)))
> > > -		goto no_write;
> > > +		goto redirty_out;
> > >
> > >  	f2fs_wait_on_page_writeback(page, META);
> > >  	write_meta_page(sbi, page);
> > > -no_write:
> > >  	dec_page_count(sbi, F2FS_DIRTY_META);
> > >  	unlock_page(page);
> > >  	return 0;
> > > @@ -348,7 +345,7 @@ bool exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
> > >  	return e ? true : false;
> > >  }
> > >
> > > -static void release_dirty_inode(struct f2fs_sb_info *sbi)
> > > +void release_dirty_inode(struct f2fs_sb_info *sbi)
> > >  {
> > >  	struct ino_entry *e, *tmp;
> > >  	int i;
> > > @@ -737,7 +734,7 @@ retry:
> > >  /*
> > >   * Freeze all the FS-operations for checkpoint.
> > >   */
> > > -static void block_operations(struct f2fs_sb_info *sbi)
> > > +static int block_operations(struct f2fs_sb_info *sbi)
> > >  {
> > >  	struct writeback_control wbc = {
> > >  		.sync_mode = WB_SYNC_ALL,
> > > @@ -745,6 +742,7 @@ static void block_operations(struct f2fs_sb_info *sbi)
> > >  		.for_reclaim = 0,
> > >  	};
> > >  	struct blk_plug plug;
> > > +	int err = 0;
> > >
> > >  	blk_start_plug(&plug);
> > >
> > > @@ -754,6 +752,10 @@ retry_flush_dents:
> > >  	if (get_pages(sbi, F2FS_DIRTY_DENTS)) {
> > >  		f2fs_unlock_all(sbi);
> > >  		sync_dirty_dir_inodes(sbi);
> > > +		if (unlikely(f2fs_cp_error(sbi))) {
> > > +			err = -EIO;
> > > +			goto out;
> > > +		}
> > >  		goto retry_flush_dents;
> > >  	}
> > >
> > > @@ -767,9 +769,16 @@ retry_flush_nodes:
> > >  	if (get_pages(sbi, F2FS_DIRTY_NODES)) {
> > >  		up_write(&sbi->node_write);
> > >  		sync_node_pages(sbi, 0, &wbc);
> > > +		if (unlikely(f2fs_cp_error(sbi))) {
> > > +			f2fs_unlock_all(sbi);
> > > +			err = -EIO;
> > > +			goto out;
> > > +		}
> > >  		goto retry_flush_nodes;
> > >  	}
> > > +out:
> > >  	blk_finish_plug(&plug);
> > > +	return err;
> > >  }
> > >
> > >  static void unblock_operations(struct f2fs_sb_info *sbi)
> > > @@ -813,8 +822,11 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> > >  	discard_next_dnode(sbi, NEXT_FREE_BLKADDR(sbi, curseg));
> > >
> > >  	/* Flush all the NAT/SIT pages */
> > > -	while (get_pages(sbi, F2FS_DIRTY_META))
> > > +	while (get_pages(sbi, F2FS_DIRTY_META)) {
> > >  		sync_meta_pages(sbi, META, LONG_MAX);
> > > +		if (unlikely(f2fs_cp_error(sbi)))
> > > +			return;
> > > +	}
> > >
> > >  	next_free_nid(sbi, &last_nid);
> > >
> > > @@ -931,14 +943,19 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> > >  	sbi->last_valid_block_count = sbi->total_valid_block_count;
> > >  	sbi->alloc_valid_block_count = 0;
> > >
> > > +	if (unlikely(f2fs_cp_error(sbi)))
> > > +		return;
> > > +
> > >  	/* Here, we only have one bio having CP pack */
> > >  	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
> > >
> > > -	if (!f2fs_cp_error(sbi)) {
> > > -		clear_prefree_segments(sbi);
> > > -		release_dirty_inode(sbi);
> > > -		F2FS_RESET_SB_DIRT(sbi);
> > > -	}
> > > +	release_dirty_inode(sbi);
> > > +
> > > +	if (unlikely(f2fs_cp_error(sbi)))
> > > +		return;
> > > +
> > > +	clear_prefree_segments(sbi);
> > > +	F2FS_RESET_SB_DIRT(sbi);
> > >  }
> > >
> > >  /*
> > > @@ -955,8 +972,10 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> > >
> > >  	if (!sbi->s_dirty)
> > >  		goto out;
> > > -
> > > -	block_operations(sbi);
> > > +	if (unlikely(f2fs_cp_error(sbi)))
> > > +		goto out;
> > > +	if (block_operations(sbi))
> > > +		goto out;
> > >
> > >  	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish block_ops");
> > >
> > > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > > index ac3ccc2..68834e2 100644
> > > --- a/fs/f2fs/data.c
> > > +++ b/fs/f2fs/data.c
> > > @@ -53,7 +53,7 @@ static void f2fs_write_end_io(struct bio *bio, int err)
> > >  		struct page *page = bvec->bv_page;
> > >
> > >  		if (unlikely(err)) {
> > > -			SetPageError(page);
> > > +			set_page_dirty(page);
> > >  			set_bit(AS_EIO, &page->mapping->flags);
> > >  			f2fs_stop_checkpoint(sbi);
> > >  		}
> > > @@ -836,10 +836,18 @@ write:
> > >
> > >  	/* Dentry blocks are controlled by checkpoint */
> > >  	if (S_ISDIR(inode->i_mode)) {
> > > +		if (unlikely(f2fs_cp_error(sbi)))
> > > +			goto redirty_out;
> > >  		err = do_write_data_page(page, &fio);
> > >  		goto done;
> > >  	}
> > >
> > > +	if (unlikely(f2fs_cp_error(sbi))) {
> > > +		SetPageError(page);
> > > +		unlock_page(page);
> > > +		return 0;
> >
> > Without redirtying it, we may lose cached page here which against the
> > second rule.
> 
> Ya, I need to change the description for this. If we call redirty_out for all
> the dirty data pages, kworker cannot finish the job, resulting in 98% of cpu to
> retry flushes. This can be found through xfstests/019.
> So, for that reason, we need to drop user data for now.
> It might be worth to do something to support removable devices later.

Oh, got it, and thanks for your explanation.

Regards,
Yu

> 
> Thanks,
> 
> >
> > Thanks,
> > Yu
> >
> >
> > > +	}
> > > +
> > >  	if (!wbc->for_reclaim)
> > >  		need_balance_fs = true;
> > >  	else if (has_not_enough_free_secs(sbi, 0))
> > > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > > index 46ceb88..2d009ae 100644
> > > --- a/fs/f2fs/f2fs.h
> > > +++ b/fs/f2fs/f2fs.h
> > > @@ -1267,6 +1267,7 @@ int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
> > >  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
> > >  void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> > >  void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> > > +void release_dirty_inode(struct f2fs_sb_info *);
> > >  bool exist_written_data(struct f2fs_sb_info *, nid_t, int);
> > >  int acquire_orphan_inode(struct f2fs_sb_info *);
> > >  void release_orphan_inode(struct f2fs_sb_info *);
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 9f126f8..d2f7842 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1215,6 +1215,8 @@ static int f2fs_write_node_page(struct page *page,
> > >
> > >  	if (unlikely(sbi->por_doing))
> > >  		goto redirty_out;
> > > +	if (unlikely(f2fs_cp_error(sbi)))
> > > +		goto redirty_out;
> > >
> > >  	f2fs_wait_on_page_writeback(page, NODE);
> > >
> > > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > > index c4f90cd..c999d67 100644
> > > --- a/fs/f2fs/super.c
> > > +++ b/fs/f2fs/super.c
> > > @@ -435,6 +435,9 @@ static void f2fs_put_super(struct super_block *sb)
> > >  	if (sbi->s_dirty)
> > >  		write_checkpoint(sbi, true);
> > >
> > > +	/* EIO will skip do checkpoint, so here we need to release this */
> > > +	release_dirty_inode(sbi);
> > > +
> > >  	iput(sbi->node_inode);
> > >  	iput(sbi->meta_inode);
> > >
> > > --
> > > 1.8.5.2 (Apple Git-48)
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

