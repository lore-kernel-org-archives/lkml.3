Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaGaFco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:32:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11743 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaGaFcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:32:42 -0400
X-AuditID: cbfee61b-f79f86d00000144c-b7-53d9d4f82e67
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <003901cf96ad$dbd17680$93746380$@samsung.com>
 <00f601cfabf7$691af580$3b50e080$@samsung.com> <20140731020708.GB24081@lcm>
In-reply-to: <20140731020708.GB24081@lcm>
Subject: RE: [f2fs-dev] [PATCH] f2fs: reduce competition among node page writes
Date: Thu, 31 Jul 2014 13:31:46 +0800
Message-id: <016201cfac80$d6e336c0$84a9a440$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQIDqdX3kbhQL0bQPBsk1Qmt1GnMiAL7I+IyARKYY8ObMRsn0A==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQd0fV24GG5xsMra4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Pu9dx1zwSb9i3ZETLA2Mv1W7GDk5JARMJJ6uuMkOYYtJXLi3nq2LkYtDSGA6o8TMSzuZIZwf
	jBLTJu5gAaliE1CRWN7xn6mLkYNDRMBP4ma7PUiYWSBTYs7ryawQ9W2MEofPTWQGSXAKaEr0
	zjwCZgsL+EvMnzabCcRmEVCVODtpFpjNK2Ap8enjXBYIW1Dix+R7LBBDtSTW7zzOBGHLS2xe
	85YZ4lIFiR1nXzNCxMUlNh65BVYvIuAkcXrCGtYJjEKzkIyahWTULCSjZiFpX8DIsopRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOB6eSe9gXNVgcYhRgINRiYf3h8nNYCHWxLLiytxDjBIc
	zEoivAcXAIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUw
	Tj+5124Ps27G3w1rkwymGcg4aOZe52Gv4DNjOORreFRa5IkPd49uNd9BWcFPKp0bm3WWTnix
	Rr7jW5fz80qfnenuQR61lxNlOb3rtG6bSYWHLfGNnz55q/FCdonlf/eyvjTTE9SYd0/3P8/+
	uM1TmvLcare8uKLbunrJ+thLi8/IPr78seiXEktxRqKhFnNRcSIASwpSpYMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Thursday, July 31, 2014 10:07 AM
> To: Chao Yu
> Cc: 'Jaegeuk Kim'; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: reduce competition among node page writes
> 
> Hi Chao,
> 
> On Wed, Jul 30, 2014 at 09:07:49PM +0800, Chao Yu wrote:
> > Hi Jaegeuk Changman,
> >
> > > -----Original Message-----
> > > From: Chao Yu [mailto:chao2.yu@samsung.com]
> > > Sent: Thursday, July 03, 2014 6:59 PM
> > > To: Jaegeuk Kim; Changman Lee
> > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > linux-f2fs-devel@lists.sourceforge.net
> > > Subject: [f2fs-dev] [PATCH] f2fs: reduce competition among node page writes
> > >
> > > We do not need to block on ->node_write among different node page writers e.g.
> > > fsync/flush, unless we have a node page writer from write_checkpoint.
> > > So it's better use rw_semaphore instead of mutex type for ->node_write to
> > > promote performance.
> >
> > If you could have time to help explaining the problem of this patch, I will be
> > appreciated for that.
> 
> I have no clue. Except checkpoint, I don't know why need to block to
> write node page.
> Do you have any problem when you test with this patch?

I don't have.
I send this patch about one month ago, but got no respond.
So I want to ask if any problem in this patch or forget to look at this patch?

To Jaegeuk:
Any idea about this patch?

> 
> >
> > Another question is what is ->writepages in sbi used for? I'm not quite clear.
> >
> 
> I remember it is for writing data pages per thread as much as possible.
> When multi-threads write some files simultaneously, multi-threads contended with
> each other to allocate a block. So block allocation was interleaved
> across threads. It makes fragmentation of file.

Thank you for the explanation! :)
I think what you say is reasonable.

Previously I tested without this lock, although I found that the blocks written
_almost_ were continuous in each '->writepages()'. Still I think we can gain more
from readahead continuous block when using this lock, rather than remove it for
promoting concurrent of writers.

Thanks,
Yu

> 
> Thanks,
> 
> > Thanks,
> >
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/checkpoint.c |    6 +++---
> > >  fs/f2fs/f2fs.h       |    2 +-
> > >  fs/f2fs/node.c       |    4 ++--
> > >  fs/f2fs/super.c      |    2 +-
> > >  4 files changed, 7 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > > index 0b4710c..eec406b 100644
> > > --- a/fs/f2fs/checkpoint.c
> > > +++ b/fs/f2fs/checkpoint.c
> > > @@ -714,10 +714,10 @@ retry_flush_dents:
> > >  	 * until finishing nat/sit flush.
> > >  	 */
> > >  retry_flush_nodes:
> > > -	mutex_lock(&sbi->node_write);
> > > +	down_write(&sbi->node_write);
> > >
> > >  	if (get_pages(sbi, F2FS_DIRTY_NODES)) {
> > > -		mutex_unlock(&sbi->node_write);
> > > +		up_write(&sbi->node_write);
> > >  		sync_node_pages(sbi, 0, &wbc);
> > >  		goto retry_flush_nodes;
> > >  	}
> > > @@ -726,7 +726,7 @@ retry_flush_nodes:
> > >
> > >  static void unblock_operations(struct f2fs_sb_info *sbi)
> > >  {
> > > -	mutex_unlock(&sbi->node_write);
> > > +	up_write(&sbi->node_write);
> > >  	f2fs_unlock_all(sbi);
> > >  }
> > >
> > > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > > index ae3b4ac..ca30b5a 100644
> > > --- a/fs/f2fs/f2fs.h
> > > +++ b/fs/f2fs/f2fs.h
> > > @@ -444,7 +444,7 @@ struct f2fs_sb_info {
> > >  	struct inode *meta_inode;		/* cache meta blocks */
> > >  	struct mutex cp_mutex;			/* checkpoint procedure lock */
> > >  	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
> > > -	struct mutex node_write;		/* locking node writes */
> > > +	struct rw_semaphore node_write;		/* locking node writes */
> > >  	struct mutex writepages;		/* mutex for writepages() */
> > >  	bool por_doing;				/* recovery is doing or not */
> > >  	wait_queue_head_t cp_wait;
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index a90f51d..7b5b5de 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1231,12 +1231,12 @@ static int f2fs_write_node_page(struct page *page,
> > >  	if (wbc->for_reclaim)
> > >  		goto redirty_out;
> > >
> > > -	mutex_lock(&sbi->node_write);
> > > +	down_read(&sbi->node_write);
> > >  	set_page_writeback(page);
> > >  	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
> > >  	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
> > >  	dec_page_count(sbi, F2FS_DIRTY_NODES);
> > > -	mutex_unlock(&sbi->node_write);
> > > +	up_read(&sbi->node_write);
> > >  	unlock_page(page);
> > >  	return 0;
> > >
> > > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > > index 8f96d93..bed9413 100644
> > > --- a/fs/f2fs/super.c
> > > +++ b/fs/f2fs/super.c
> > > @@ -947,7 +947,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
> > >  	mutex_init(&sbi->gc_mutex);
> > >  	mutex_init(&sbi->writepages);
> > >  	mutex_init(&sbi->cp_mutex);
> > > -	mutex_init(&sbi->node_write);
> > > +	init_rwsem(&sbi->node_write);
> > >  	sbi->por_doing = false;
> > >  	spin_lock_init(&sbi->stat_lock);
> > >
> > > --
> > > 1.7.9.5
> > >
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Open source business process management suite built on Java and Eclipse
> > > Turn processes into business applications with Bonita BPM Community Edition
> > > Quickly connect people, data, and systems into organized workflows
> > > Winner of BOSSIE, CODIE, OW2 and Gartner awards
> > > http://p.sf.net/sfu/Bonitasoft
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

