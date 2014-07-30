Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaG3DSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:18:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:56664 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbaG3DSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:18:06 -0400
Date: Tue, 29 Jul 2014 20:18:20 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 08/11] f2fs: fix wrong condition for unlikely
Message-ID: <20140730031820.GC99885@jaegeuk-mac02>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-8-git-send-email-jaegeuk@kernel.org>
 <009901cfab97$f2981be0$d7c853a0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009901cfab97$f2981be0$d7c853a0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 09:44:43AM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Saturday, July 26, 2014 6:47 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 08/11] f2fs: fix wrong condition for unlikely
> > 
> > This patch fixes the wrongly used unlikely condition.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/checkpoint.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 42a16c1..36b0d47 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -932,7 +932,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> >  	/* Here, we only have one bio having CP pack */
> >  	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
> > 
> > -	if (unlikely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
> > +	if (!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {
> 
> Maybe use likely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) or
> 
> if (unlikely(is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)))
> 	return;
> 
> is more appropriate. How do you think?

Currently I'd like to put this without any likely or unlikely.
Best thing is to measure some performance how this would make effect on.
Until then, it'd be better to do without it, since apparently this should
not be unlikely.

How about you?
Can we compare both of them explicitly?

Thanks,

> 
> >  		clear_prefree_segments(sbi);
> >  		release_dirty_inode(sbi);
> >  		F2FS_RESET_SB_DIRT(sbi);
> > --
> > 1.8.5.2 (Apple Git-48)
> > 
> > 
> > ------------------------------------------------------------------------------
> > Want fast and easy access to all the code in your enterprise? Index and
> > search up to 200,000 lines of code with a free copy of Black Duck
> > Code Sight - the same software that powers the world's largest code
> > search on Ohloh, the Black Duck Open Hub! Try it now.
> > http://p.sf.net/sfu/bds
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
