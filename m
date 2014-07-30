Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaG3M7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:59:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32045 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaG3M7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:59:21 -0400
X-AuditID: cbfee61b-f79f86d00000144c-c1-53d8ec28efa5
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-8-git-send-email-jaegeuk@kernel.org>
 <009901cfab97$f2981be0$d7c853a0$@samsung.com>
 <20140730031820.GC99885@jaegeuk-mac02>
In-reply-to: <20140730031820.GC99885@jaegeuk-mac02>
Subject: RE: [f2fs-dev] [PATCH 08/11] f2fs: fix wrong condition for unlikely
Date: Wed, 30 Jul 2014 20:58:37 +0800
Message-id: <00f401cfabf6$14f52b70$3edf8250$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgGwpqWeAfWylWMB2iR7tptB5/Rg
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQV2NNzeCDRp2Clk8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXH1xEH2ghaJigcz
	5jM2MK4T7mLk5JAQMJF407iABcIWk7hwbz1bFyMXh5DAdEaJ7hULmCGcH4wSS3o2MoNUsQmo
	SCzv+M8EYosIqEn07psCZjMLZEpM6H/BDtFwhVFi947rQKM4ODgFjCU2/QWrERbwkVjbPZkF
	JMwioCrxbKYeSJhXwFLi5oYPTBC2oMSPyfdYIEZqSazfeRxqvLzE5jVvmSEOVZDYcfY1I0Rc
	XGLjkVssEOe4Seyd8J59AqPQLCSjZiEZNQvJqFlI2hcwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECA78Z9I7GFc1WBxiFOBgVOLhnfH/erAQa2JZcWXuIUYJDmYlEd7GpzeChXhTEiur
	Uovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTA2fn0Ue6zxTf0+E0/z
	7aenHv5+WPtx3H2rXdo6O7hPb53AWWM17cBJofCCnMSu/qdhW1UYV0zSXRLItfnXncc7Xh8R
	9TeeFHp3q9fGFqvY80I/JSqnhIW0JM+RUDYUPfFiAsPbsn3vqvxTN891WOBhHnSR6dEEwV7e
	w3ZdJU+Ot1b6atwq3a2oxFKckWioxVxUnAgAk3jbnHgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, July 30, 2014 11:18 AM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 08/11] f2fs: fix wrong condition for unlikely
> 
> On Wed, Jul 30, 2014 at 09:44:43AM +0800, Chao Yu wrote:
> > Hi Jaegeuk,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > Sent: Saturday, July 26, 2014 6:47 AM
> > > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > > linux-f2fs-devel@lists.sourceforge.net
> > > Cc: Jaegeuk Kim
> > > Subject: [f2fs-dev] [PATCH 08/11] f2fs: fix wrong condition for unlikely
> > >
> > > This patch fixes the wrongly used unlikely condition.
> > >
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> > > ---
> > >  fs/f2fs/checkpoint.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > > index 42a16c1..36b0d47 100644
> > > --- a/fs/f2fs/checkpoint.c
> > > +++ b/fs/f2fs/checkpoint.c
> > > @@ -932,7 +932,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> > >  	/* Here, we only have one bio having CP pack */
> > >  	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
> > >
> > > -	if (unlikely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
> > > +	if (!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {
> >
> > Maybe use likely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) or
> >
> > if (unlikely(is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)))
> > 	return;
> >
> > is more appropriate. How do you think?
> 
> Currently I'd like to put this without any likely or unlikely.
> Best thing is to measure some performance how this would make effect on.

I think we could get little improvement of performance if we use likely or unlikely
here. So if you'd like leave it without pre-judgment, it will be ok.
Let's just leave it as it was. :)

Thanks,

> Until then, it'd be better to do without it, since apparently this should
> not be unlikely.
> 
> How about you?
> Can we compare both of them explicitly?
> 
> Thanks,
> 
> >
> > >  		clear_prefree_segments(sbi);
> > >  		release_dirty_inode(sbi);
> > >  		F2FS_RESET_SB_DIRT(sbi);
> > > --
> > > 1.8.5.2 (Apple Git-48)
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Want fast and easy access to all the code in your enterprise? Index and
> > > search up to 200,000 lines of code with a free copy of Black Duck
> > > Code Sight - the same software that powers the world's largest code
> > > search on Ohloh, the Black Duck Open Hub! Try it now.
> > > http://p.sf.net/sfu/bds
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

