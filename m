Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaHTIWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:22:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65010 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaHTIV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:21:56 -0400
X-AuditID: cbfee61a-f79e46d00000134f-26-53f45a9ddec4
From: Chao Yu <chao2.yu@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <001201cfb838$fb0ac4a0$f1204de0$@samsung.com>
 <20140815061138.GA940@swordfish> <002d01cfbb70$ea7410c0$bf5c3240$@samsung.com>
 <20140819112500.GA2484@swordfish> <20140820020924.GD32620@bbox>
In-reply-to: <20140820020924.GD32620@bbox>
Subject: RE: [PATCH] zram: add num_discards for discarded pages stat
Date: Wed, 20 Aug 2014 16:20:48 +0800
Message-id: <006701cfbc4f$c9d2fe00$5d78fa00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLPTAw4onMCo+gZju9DfYrrOaResgJq92h2AoAbnpACr8Gx1gD+LFnWmZU1N/A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoO7cqC/BBp/PmFrMWb+GzeLUn+tM
	Fpd3zWGzuLfmP6vFsq/v2S02tMxit1j7+TG7A7vHzll32T02repk89j0aRK7x4kZv1k83u+7
	yuax89NmVo/Pm+QC2KO4bFJSczLLUov07RK4Mv6tbWIruG9asW/KDtYGxv+aXYycHBICJhLt
	tyayQthiEhfurWfrYuTiEBKYzijR/fkNO4Tzg1Fize6lYFVsAioSyzv+M4HYIgKxEmf/XAcr
	YhZYyCgxacMDZoiOM4wSe259Aari4OAU0JLo/S0G0iAs4CLx7P5ddhCbRUBV4ujfbWwgNq+A
	pcTOtwsZIWxBiR+T77GA2MwC6hKT5i1ihrDlJTavecsMcaqCxI6zrxkhjvCTmPh0PStEjbjE
	xiO3WCYwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgKHom
	tYNxZYPFIUYBDkYlHl6F7M/BQqyJZcWVuYcYJTiYlUR4682+BAvxpiRWVqUW5ccXleakFh9i
	lOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpg9GCclXW7Ytkv37SrZ9c6lyeLtek6hN98
	90Rsk9x/1Vb+YyxeXpsDhBQXZl1Ju1T67qvKmdziAHdejf5oSYm8S49lwnZ1HdGYbNn4rZvn
	wyeflB3chUz5SWJP+dfKT36XUDTXaIPEwao7e8smukyYuOFnZLHz+1l1mz0XF4a5XpXuD2hx
	Vl2nxFKckWioxVxUnAgAm8sRnZ4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

> -----Original Message-----
> From: Minchan Kim [mailto:minchan@kernel.org]
> Sent: Wednesday, August 20, 2014 10:09 AM
> To: Sergey Senozhatsky
> Cc: Chao Yu; linux-kernel@vger.kernel.org; linux-mm@kvack.org; ngupta@vflare.org; 'Jerome
> Marchand'; 'Andrew Morton'
> Subject: Re: [PATCH] zram: add num_discards for discarded pages stat
> 
> Hi Sergey,
> 
> On Tue, Aug 19, 2014 at 08:25:00PM +0900, Sergey Senozhatsky wrote:
> > Hello,
> >
> > On (08/19/14 13:45), Chao Yu wrote:
> > > > On (08/15/14 11:27), Chao Yu wrote:
> > > > > Now we have supported handling discard request which is sended by filesystem,
> > > > > but no interface could be used to show information of discard.
> > > > > This patch adds num_discards to stat discarded pages, then export it to sysfs
> > > > > for displaying.
> > > > >
> > > >
> > > > a side question: we account discarded pages via slot free notify in
> > > > notify_free and via req_discard in num_discards. how about accounting
> > > > both of them in num_discards? because, after all, they account a number
> > > > of discarded pages (zram_free_page()). or there any particular reason we
> > > > want to distinguish.
> > >
> > > Yeah, I agree with you as I have no such reason unless there are our users'
> > > explicitly requirement for showing notify_free/num_discards separately later.
> > >
> > > How do you think of sending another patch to merge these two counts?
> > >
> >
> > Minchan, what do you think? let's account discarded pages in one place.
> 
> First of all, I'd like to know why we need num_discards.
> It should be in description and depends on it whether we should merge both
> counts or separate.

Oh, it's my mistaken.

When commit 	9b9913d80b2896ecd9e0a1a8f167ccad66fac79c (Staging: zram: Update
zram documentation) and commit e98419c23b1a189c932775f7833e94cb5230a16b (Staging:
zram: Document sysfs entries) description related to 'discard' stat was designed
and added to zram.txt and sysfs-block-zram, but without implementation of function
for handling discard request, description in documents were removed in commit
8dd1d3247e6c00b50ef83934ea8b22a1590015de (zram: document failed_reads,
failed_writes stats)

For now, we have already supported discard handling, so it's better to resume
the stat of discard number, this discard stat supports user one more kind of runtime
information of zram as other stats supported.

How do you think?

> 
> Thanks.
> 
> 
> 
> >
> > > One more thing is that I am missing to update document of zram, sorry about
> > > that, let me update it in v2.
> >
> > thanks.
> >
> > 	-ss
> >
> > > Thanks,
> > > Yu
> > >
> > > >
> > > > 	-ss
> > > >
> > > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > > ---
> > > > >  Documentation/ABI/testing/sysfs-block-zram | 10 ++++++++++
> > > > >  drivers/block/zram/zram_drv.c              |  3 +++
> > > > >  drivers/block/zram/zram_drv.h              |  1 +
> > > > >  3 files changed, 14 insertions(+)
> > > > >
> > > > > diff --git a/Documentation/ABI/testing/sysfs-block-zram
> > > > b/Documentation/ABI/testing/sysfs-block-zram
> > > > > index 70ec992..fa8936e 100644
> > > > > --- a/Documentation/ABI/testing/sysfs-block-zram
> > > > > +++ b/Documentation/ABI/testing/sysfs-block-zram
> > > > > @@ -57,6 +57,16 @@ Description:
> > > > >  		The failed_writes file is read-only and specifies the number of
> > > > >  		failed writes happened on this device.
> > > > >
> > > > > +
> > > > > +What:		/sys/block/zram<id>/num_discards
> > > > > +Date:		August 2014
> > > > > +Contact:	Chao Yu <chao2.yu@samsung.com>
> > > > > +Description:
> > > > > +		The num_discards file is read-only and specifies the number of
> > > > > +		physical blocks which are discarded by this device. These blocks
> > > > > +		are included in discard request which is sended by filesystem as
> > > > > +		the blocks are no longer used.
> > > > > +
> > > > >  What:		/sys/block/zram<id>/max_comp_streams
> > > > >  Date:		February 2014
> > > > >  Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > > > > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > > > > index d00831c..904e7a5 100644
> > > > > --- a/drivers/block/zram/zram_drv.c
> > > > > +++ b/drivers/block/zram/zram_drv.c
> > > > > @@ -606,6 +606,7 @@ static void zram_bio_discard(struct zram *zram, u32 index,
> > > > >  		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
> > > > >  		zram_free_page(zram, index);
> > > > >  		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
> > > > > +		atomic64_inc(&zram->stats.num_discards);
> > > > >  		index++;
> > > > >  		n -= PAGE_SIZE;
> > > > >  	}
> > > > > @@ -866,6 +867,7 @@ ZRAM_ATTR_RO(num_reads);
> > > > >  ZRAM_ATTR_RO(num_writes);
> > > > >  ZRAM_ATTR_RO(failed_reads);
> > > > >  ZRAM_ATTR_RO(failed_writes);
> > > > > +ZRAM_ATTR_RO(num_discards);
> > > > >  ZRAM_ATTR_RO(invalid_io);
> > > > >  ZRAM_ATTR_RO(notify_free);
> > > > >  ZRAM_ATTR_RO(zero_pages);
> > > > > @@ -879,6 +881,7 @@ static struct attribute *zram_disk_attrs[] = {
> > > > >  	&dev_attr_num_writes.attr,
> > > > >  	&dev_attr_failed_reads.attr,
> > > > >  	&dev_attr_failed_writes.attr,
> > > > > +	&dev_attr_num_discards.attr,
> > > > >  	&dev_attr_invalid_io.attr,
> > > > >  	&dev_attr_notify_free.attr,
> > > > >  	&dev_attr_zero_pages.attr,
> > > > > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> > > > > index e0f725c..2994aaf 100644
> > > > > --- a/drivers/block/zram/zram_drv.h
> > > > > +++ b/drivers/block/zram/zram_drv.h
> > > > > @@ -86,6 +86,7 @@ struct zram_stats {
> > > > >  	atomic64_t num_writes;	/* --do-- */
> > > > >  	atomic64_t failed_reads;	/* can happen when memory is too low */
> > > > >  	atomic64_t failed_writes;	/* can happen when memory is too low */
> > > > > +	atomic64_t num_discards;	/* no. of discarded pages */
> > > > >  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
> > > > >  	atomic64_t notify_free;	/* no. of swap slot free notifications */
> > > > >  	atomic64_t zero_pages;		/* no. of zero filled pages */
> > > > > --
> > > > > 2.0.1.474.g72c7794
> > > > >
> > > > >
> > > >
> > > > --
> > > > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > > > the body to majordomo@kvack.org.  For more info on Linux MM,
> > > > see: http://www.linux-mm.org/ .
> > > > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> > >
> >
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> --
> Kind regards,
> Minchan Kim

