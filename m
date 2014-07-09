Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaGIDHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:07:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49817 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaGIDHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:07:22 -0400
X-AuditID: cbfee61b-f79f86d00000144c-91-53bcb1e9fa1c
From: Chao Yu <chao2.yu@samsung.com>
To: "'Huang Ying'" <ying.huang@intel.com>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1404711988-18264-1-git-send-email-ying.huang@intel.com>
 <20140708075843.GA59558@jmac> <1404807412.13519.46.camel@yhuang-dev>
In-reply-to: <1404807412.13519.46.camel@yhuang-dev>
Subject: RE: [f2fs-dev] f2fs: Add f2fs_balance_fs for direct IO
Date: Wed, 09 Jul 2014 11:06:35 +0800
Message-id: <006401cf9b22$e658db10$b30a9130$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIq9lshuiPSC8EQEB7iOSulJI6IuwIaOQOkA4l+E3iaszmAIA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jAd2XG/cEG9x8KWLxZP0sZotLi9wt
	Lu+aw2ZxctZkFgcWj8V7XjJ5bFrVyeaxe8FnJo/Pm+QCWKK4bFJSczLLUov07RK4Mt5NX8xW
	sEOi4tum9awNjFuEuxg5OCQETCSmHkjuYuQEMsUkLtxbz9bFyMUhJLCIUWL++1nsEM4PRol5
	kxawg1SxCahILO/4zwRiiwh4SxzY+p0RZBCzgIfErmOlEPXdjBLPH6xhAolzChhLbF9oC2IK
	C9hLLHnGC9LJIqAq8XrNK1aQMK+ApcTEQ2An8AoISvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtm
	iDMVJHacfc0IcYCTxMQ1SxghasQlNh65xTKBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEB/8z6R2MqxosDjEKcDAq8fAq8OwJFmJNLCuuzD3EKMHBrCTC
	+80NKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoExJNF9
	Oe8no563jzUOmDQF7qqoSC878/2OXUo3R1qR5dOJ13qddH51LaiZVbauS4nnDO+bxI2n1q7a
	8fIBk/SJueemJ7v6Xpy+7dTuaMljG0UO6s3puHL6+ouPh9+ZzFTYn9682/uy+e+/qSu/me3O
	1/5x49PXgi5GJ7cHiezXf7b8eR+d/nnSaSWW4oxEQy3mouJEAIp0pqJ6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

> -----Original Message-----
> From: Huang Ying [mailto:ying.huang@intel.com]
> Sent: Tuesday, July 08, 2014 4:17 PM
> To: Jaegeuk Kim
> Cc: linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] f2fs: Add f2fs_balance_fs for direct IO
> 
> Hi, Jaegeuk,
> 
> On Tue, 2014-07-08 at 00:58 -0700, Jaegeuk Kim wrote:
> > Hi Huang,
> >
> > It occurs a merge conflict.
> > Please check the patch.
> 
> Sorry, my fault.  I think I need to base my patch on f2fs tree instead
> of latest Linus' tree?

I think you patch is not conflict to both latest linux's tree and f2fs dev tree.
but conflict to this patch 
"f2fs: introduce f2fs_write_failed to handle error case when write" which
maybe in Jaegeuk's local tree, not update to f2fs dev tree.

If possible, you could wait for Jaegeuk to update f2fs tree, or merge this patch,
then apply your new patch.

Thanks,
Yu

> 
> > Anyway, IMO, it needs to place f2fs_balance_fs somewhere in get_data_block.
> 
> Yes.  I think so too.  So you prefer to add f2fs_balance_fs in both
> f2fs_direct_IO and get_data_block, or just add f2fs_blance_fs in
> get_data_block only?
> 
> Best Regards,
> Huang, Ying
> 
> > Thanks,
> >
> > On Mon, Jul 07, 2014 at 01:46:28PM +0800, Huang Ying wrote:
> > > Otherwise, if a large amount of direct IO writes were done, the
> > > segment allocation may be failed because no enough segments are gced.
> > >
> > > Signed-off-by: Huang, Ying <ying.huang@intel.com>
> > > ---
> > >  fs/f2fs/data.c |    6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > --- a/fs/f2fs/data.c
> > > +++ b/fs/f2fs/data.c
> > > @@ -1038,6 +1038,7 @@ static ssize_t f2fs_direct_IO(int rw, st
> > >  {
> > >  	struct file *file = iocb->ki_filp;
> > >  	struct inode *inode = file->f_mapping->host;
> > > +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > >
> > >  	/* Let buffer I/O handle the inline data case. */
> > >  	if (f2fs_has_inline_data(inode))
> > > @@ -1046,8 +1047,11 @@ static ssize_t f2fs_direct_IO(int rw, st
> > >  	if (check_direct_IO(inode, rw, iter, offset))
> > >  		return 0;
> > >
> > > +	if (rw == WRITE)
> > > +		f2fs_balance_fs(sbi);
> > > +
> > >  	/* clear fsync mark to recover these blocks */
> > > -	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
> > > +	fsync_mark_clear(sbi, inode->i_ino);
> > >
> > >  	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
> > >  				  get_data_block);
> >
> 
> 
> 
> ------------------------------------------------------------------------------
> Open source business process management suite built on Java and Eclipse
> Turn processes into business applications with Bonita BPM Community Edition
> Quickly connect people, data, and systems into organized workflows
> Winner of BOSSIE, CODIE, OW2 and Gartner awards
> http://p.sf.net/sfu/Bonitasoft
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

