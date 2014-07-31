Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaGaCIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:08:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57242 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaGaCIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:08:39 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-d6-53d9a525a2dc
Date: Thu, 31 Jul 2014 11:07:08 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: reduce competition among node page writes
Message-id: <20140731020708.GB24081@lcm>
References: <003901cf96ad$dbd17680$93746380$@samsung.com>
 <00f601cfabf7$691af580$3b50e080$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <00f601cfabf7$691af580$3b50e080$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zfV3VpTeDDe59ELT43/SRzeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	fm27wlpwUq1i65e5jA2Mf+S6GDk5JARMJK4/38QIYYtJXLi3nq2LkYtDSGAZo0RPy0Z2mKLp
	E94wQiQWMUrs6HrFBOH8ZJQ4t3QNM0gVi4CqxLsXT1hAbDYBLYn202vBbBEBJYlf8xexgjQw
	C/QySsxdfJcJJCEs4C/x+OwUsBW8AhoS//r/sYHYQgKZEr+ffmWEiAtK/Jh8D2wQM9DQ9TuP
	M0HY0hKP/s4A6+UUsJLYvngxK4gtKqAiMeXkNrAfJAS2sUu0fb7EBnGdgMS3yYeABnEAJWQl
	Nh1ghnhNUuLgihssExjFZiFZNwvJullI1i1gZF7FKJpakFxQnJReZKxXnJhbXJqXrpecn7uJ
	ERJb/TsY7x6wPsSYDLRyIrOUaHI+MDbzSuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAPjEe3jE49m/X+gvXSX0eHN2Z362QK37EMtnv5x3DztpGKV
	5dd/h1vX/f0gNa2/UPj3RjUuZXW2w6bndjlYc/UKdVzk+eJt/n3bgcfvLh91awt1qHTfmx3/
	17S7bM63h90LHc448+hJFLTzJXm9++fkp+jo1mFv3WjbzWT0eGfg8QuTp5Ww91xRYinOSDTU
	Yi4qTgQAd4ibkcMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jAV3VpTeDDf794rX43/SRzeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM35tu8JacFKtYuuXuYwNjH/kuhg5OSQETCSmT3jDCGGL
	SVy4t56ti5GLQ0hgEaPEjq5XTBDOT0aJc0vXMINUsQioSrx78YQFxGYT0JJoP70WzBYRUJL4
	NX8RK0gDs0Avo8TcxXeZQBLCAv4Sj89OYQexeQU0JP71/2MDsYUEMiV+P/3KCBEXlPgx+R7Y
	IGagoet3HmeCsKUlHv2dAdbLKWAlsX3xYlYQW1RARWLKyW1sExgFZiFpn4WkfRaS9gWMzKsY
	RVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP3mdQOxpUNFocYBTgYlXh4f5jcDBZiTSwrrsw9
	xCjBwawkwntwAVCINyWxsiq1KD++qDQntfgQoykwOCYyS4km5wOTSl5JvKGxiZmRpZGZhZGJ
	ubmSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsYpZ6T/5tlM8mQ0/f/x6v3j267rvNv/iSFh
	q3/o1PjnVXXlD/vNv9q9EPgcwCr0MqiAXZN/whMJG/3f+lsf8usc/VTQXRnAmtO/4Jhn+lFH
	nVs3IzUv+h9UmPh+Zbyql2ZgmWzQq1k1QtkNLk4MRQLXHd5rVXQdO9L86gELV6TTFQODyx4H
	vZVYijMSDbWYi4oTAZeJsy/yAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Wed, Jul 30, 2014 at 09:07:49PM +0800, Chao Yu wrote:
> Hi Jaegeuk Changman,
> 
> > -----Original Message-----
> > From: Chao Yu [mailto:chao2.yu@samsung.com]
> > Sent: Thursday, July 03, 2014 6:59 PM
> > To: Jaegeuk Kim; Changman Lee
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Subject: [f2fs-dev] [PATCH] f2fs: reduce competition among node page writes
> > 
> > We do not need to block on ->node_write among different node page writers e.g.
> > fsync/flush, unless we have a node page writer from write_checkpoint.
> > So it's better use rw_semaphore instead of mutex type for ->node_write to
> > promote performance.
> 
> If you could have time to help explaining the problem of this patch, I will be
> appreciated for that.

I have no clue. Except checkpoint, I don't know why need to block to
write node page.
Do you have any problem when you test with this patch?

> 
> Another question is what is ->writepages in sbi used for? I'm not quite clear.
> 

I remember it is for writing data pages per thread as much as possible.
When multi-threads write some files simultaneously, multi-threads contended with
each other to allocate a block. So block allocation was interleaved
across threads. It makes fragmentation of file.

Thanks,

> Thanks,
> 
> > 
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/checkpoint.c |    6 +++---
> >  fs/f2fs/f2fs.h       |    2 +-
> >  fs/f2fs/node.c       |    4 ++--
> >  fs/f2fs/super.c      |    2 +-
> >  4 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 0b4710c..eec406b 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -714,10 +714,10 @@ retry_flush_dents:
> >  	 * until finishing nat/sit flush.
> >  	 */
> >  retry_flush_nodes:
> > -	mutex_lock(&sbi->node_write);
> > +	down_write(&sbi->node_write);
> > 
> >  	if (get_pages(sbi, F2FS_DIRTY_NODES)) {
> > -		mutex_unlock(&sbi->node_write);
> > +		up_write(&sbi->node_write);
> >  		sync_node_pages(sbi, 0, &wbc);
> >  		goto retry_flush_nodes;
> >  	}
> > @@ -726,7 +726,7 @@ retry_flush_nodes:
> > 
> >  static void unblock_operations(struct f2fs_sb_info *sbi)
> >  {
> > -	mutex_unlock(&sbi->node_write);
> > +	up_write(&sbi->node_write);
> >  	f2fs_unlock_all(sbi);
> >  }
> > 
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index ae3b4ac..ca30b5a 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -444,7 +444,7 @@ struct f2fs_sb_info {
> >  	struct inode *meta_inode;		/* cache meta blocks */
> >  	struct mutex cp_mutex;			/* checkpoint procedure lock */
> >  	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
> > -	struct mutex node_write;		/* locking node writes */
> > +	struct rw_semaphore node_write;		/* locking node writes */
> >  	struct mutex writepages;		/* mutex for writepages() */
> >  	bool por_doing;				/* recovery is doing or not */
> >  	wait_queue_head_t cp_wait;
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index a90f51d..7b5b5de 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1231,12 +1231,12 @@ static int f2fs_write_node_page(struct page *page,
> >  	if (wbc->for_reclaim)
> >  		goto redirty_out;
> > 
> > -	mutex_lock(&sbi->node_write);
> > +	down_read(&sbi->node_write);
> >  	set_page_writeback(page);
> >  	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
> >  	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
> >  	dec_page_count(sbi, F2FS_DIRTY_NODES);
> > -	mutex_unlock(&sbi->node_write);
> > +	up_read(&sbi->node_write);
> >  	unlock_page(page);
> >  	return 0;
> > 
> > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > index 8f96d93..bed9413 100644
> > --- a/fs/f2fs/super.c
> > +++ b/fs/f2fs/super.c
> > @@ -947,7 +947,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
> >  	mutex_init(&sbi->gc_mutex);
> >  	mutex_init(&sbi->writepages);
> >  	mutex_init(&sbi->cp_mutex);
> > -	mutex_init(&sbi->node_write);
> > +	init_rwsem(&sbi->node_write);
> >  	sbi->por_doing = false;
> >  	spin_lock_init(&sbi->stat_lock);
> > 
> > --
> > 1.7.9.5
> > 
> > 
> > 
> > ------------------------------------------------------------------------------
> > Open source business process management suite built on Java and Eclipse
> > Turn processes into business applications with Bonita BPM Community Edition
> > Quickly connect people, data, and systems into organized workflows
> > Winner of BOSSIE, CODIE, OW2 and Gartner awards
> > http://p.sf.net/sfu/Bonitasoft
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
