Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3IMMLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:11:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59692 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3IMMLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:11:31 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ba-523300f18d6b
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jin Xu'" <linuxclimber@gmail.com>
Cc: "'???'" <jaegeuk.kim@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000001ceb069$318a87a0$949f96e0$@samsung.com>
 <5232FBC0.2030509@gmail.com>
In-reply-to: <5232FBC0.2030509@gmail.com>
Subject: RE: [f2fs-dev][PATCH] f2fs: limit nr_iovecs in bio_alloc
Date: Fri, 13 Sep 2013 20:10:37 +0800
Message-id: <000201ceb07a$60980fc0$21c82f40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLDNobmU2T910Ps1JKvh5e+dL2n3AFrBgCLl88rviA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd2PDMZBBpdPmltc3/WXyeLSIneL
	PXtPslhc3jWHzeLUyTOsFq0LzzM7sHnsnHWX3WP3gs9MHn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJXx7+wa1oJHEhWHmh+xNDAeFepi5OSQEDCRePfpOhuELSZx4d56IJuLQ0hgEaPEy+/r
	WCCcH4wSW3dPBqtiE1CRWN7xnwnEFhFQleg63g5mMwvsZJTYdSQTxBYSiJCY/+cVWJxTQFPi
	04JGRhBbWMBRYt2DtWBzWIB6ny3sZgWxeQUsJab+3c4OYQtK/Jh8jwVipoZE/6INbBC2tsST
	dxdYIS5VkNhx9jUjxA1WEku+LGCEqBGX2HjkFssERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kRHBnPpHcwrmqwOMQowMGoxMPbEWMUJMSaWFZcmXuIUYKD
	WUmEd9ZdoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbG
	fkbtR57aLVF32PsW3+2z7+79YBCso7X77tVt/Qv3iqyduGjl/8Pxh+dk94iyWQepbpBmXnxP
	Lrh73fdNdrffLvTQfzvbJPOU5btkJ6eb25O4S6fcTzI0fLPz2QGG/xxbqx68nykZUBT2q8hJ
	uWvBlj13bkuqc0RMnr/UV7uJcWu8LFt9fuRNJZbijERDLeai4kQA7XFN0IgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jin Xu [mailto:linuxclimber@gmail.com]
> Sent: Friday, September 13, 2013 7:49 PM
> To: Chao Yu
> Cc: ???; linux-f2fs-devel@lists.sourceforge.net;
linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org; Ì·æ­
> Subject: Re: [f2fs-dev][PATCH] f2fs: limit nr_iovecs in bio_alloc
> 
> Did this patch pass the basic build? There seems have a typo regarding
> MAX_BIO_BLOCK.
> 

I am so sorry about that.I miss the 'S' when merging the code by handwriting
from build path to git branch path.
I will check the patch carefully and resubmit it.

Thanks for reminding!

> --
> Jin
> 
> On 13/09/2013 18:07, Chao Yu wrote:
> > This patch add macro MAX_BIO_BLOCKS to limit value of npages in
> > f2fs_bio_alloc, it can avoid to return NULL in bio_alloc caused by
> > npages is larger than UIO_MAXIOV.
> >
> > Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> >  ---
> >  fs/f2fs/segment.c |    4 +++-
> >  fs/f2fs/segment.h |    3 +++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c index
> > 09af9c7..bd79bbe 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -657,6 +657,7 @@ static void submit_write_page(struct f2fs_sb_info
> > *sbi, struct page *page,
> >                                 block_t blk_addr, enum page_type
> type)
> > {
> >         struct block_device *bdev = sbi->sb->s_bdev;
> > +       int bio_blocks;
> >
> >         verify_block_addr(sbi, blk_addr);
> >
> > @@ -676,7 +677,8 @@ retry:
> >                         goto retry;
> >                 }
> >
> > -               sbi->bio[type] = f2fs_bio_alloc(bdev,
max_hw_blocks(sbi));
> > +               bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > +               sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
> >                 sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi,
> > blk_addr);
> >                 sbi->bio[type]->bi_private = priv;
> >                 /*
> > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> > bdd10ea..9cc95eb 100644
> > --- a/fs/f2fs/segment.h
> > +++ b/fs/f2fs/segment.h
> > @@ -9,6 +9,7 @@
> >   * published by the Free Software Foundation.
> >   */
> >  #include <linux/blkdev.h>
> > +#include <linux/uio.h>
> >
> >  /* constant macro */
> >  #define NULL_SEGNO                     ((unsigned int)(~0))
> > @@ -90,6 +91,8 @@
> >         (blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
> >  #define SECTOR_TO_BLOCK(sbi, sectors)
> \
> >         (sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
> > +#define MAX_BIO_BLOCK(max_hw_blocks)
> \
> > +       (min((int)max_hw_blocks, UIO_MAXIOV))
> >
> >  /* during checkpoint, bio_private is used to synchronize the last bio
> > */  struct bio_private {
> > ---
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

