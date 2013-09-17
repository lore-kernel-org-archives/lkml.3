Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3IQDOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:14:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37162 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3IQDOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:14:20 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d5-5237c90afc65
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'Kim Jaegeuk'" <jaegeuk.kim@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000301ceb085$13189480$3949bd80$@samsung.com>
 <5236684C.6020606@cn.fujitsu.com>
 <000001ceb28c$9b293e20$d17bba60$@samsung.com> <52368BB2.7000008@cn.fujitsu.com>
In-reply-to: <52368BB2.7000008@cn.fujitsu.com>
Subject: RE: [f2fs-dev][PATCH RESEND] f2fs: avoid allocating failure in
 bio_alloc
Date: Tue, 17 Sep 2013 11:13:23 +0800
Message-id: <000201ceb353$ff0c80b0$fd258210$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKy8BC/mx3zsQcmWkc5BPvarxGQ4gGxOklPAlC03lsBUkNM95fWI/Ow
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAV2uk+ZBBtN36lg8bz/AbHH7yiQW
	i0uL3C327D3JYnF51xw2i9aF55kd2Dz+H5zE7LFz1l12j90LPjN59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bmq+/YCw5pVhxs72BuYLwl38XIySEhYCJx69dXZghbTOLCvfVsXYxcHEIC
	ixgldszZxwaSEBL4wShx86M+iM0moCKxvOM/E4gtIqAhMW3qfiaQBmaB/YwSC+49ZIdoWM8o
	8eq/EYjNKaAn8ezKfBYQW1ggWOJd3zewZhYBVYlfn46xgti8ApYS/650sEHYghI/Jt8Dq2cG
	WtC/aAMbhK0t8eTdBVaISxUkdpx9zQhxhJvE9BX7GSFqxCU2HrnFMoFRaBaSUbOQjJqFZNQs
	JC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTHyDOpHYwrGywOMQpwMCrx8M6QMg8S
	Yk0sK67MPcQowcGsJMIbpgsU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1
	ILUIJsvEwSnVwHjANspnq/RjgbUFOl/n2P7cK37gOPtJrraYPo7NqcYBrbPdvL/4h6WasB5Y
	x7pAyPxdRFXXvqeKCu2/NSwufPGqi+Ca+2Ezr68WW0mnbRz3jhrbbXP4HuR0rPH7v71V7vFd
	s4evPa6uqGr49C1Yb9IHZ1PvzMaKSRPKJvtN1Y62L7RzZ30TrMRSnJFoqMVcVJwIADargYON	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Monday, September 16, 2013 12:40 PM
> To: Chao Yu
> Cc: 'Kim Jaegeuk'; linux-f2fs-devel@lists.sourceforge.net;
> linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; 'Ì·æ­'
> Subject: Re: [f2fs-dev][PATCH RESEND] f2fs: avoid allocating failure in
bio_alloc
> 
> Hi Chao,
> 
> On 09/16/2013 11:26 AM, Chao Yu wrote:
> 
> > Hi Gu
> >
> >> -----Original Message-----
> >> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> >> Sent: Monday, September 16, 2013 10:09 AM
> >> To: Chao Yu
> >> Cc: Kim Jaegeuk; linux-f2fs-devel@lists.sourceforge.net;
> >> linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; Ì·æ­
> >> Subject: Re: [f2fs-dev][PATCH RESEND] f2fs: avoid allocating failure
> >> in
> > bio_alloc
> >>
> >> Hi Chao,
> >>
> >> On 09/13/2013 09:27 PM, Chao Yu wrote:
> >>
> >>> This patch add macro MAX_BIO_BLOCKS to limit value of npages in
> >>> f2fs_bio_alloc, it can avoid allocating failure in bio_alloc caused
> >>> by npages is larger than UIO_MAXIOV.
> >>
> >> As I know bio_alloc is based of *fs_bio_set* pool, without the
> >> limitation
> > of
> >> UIO_MAXIOV, am I missing something?
> >
> > Here is the code in bio.c, fs_bio_set is as the actual parameter pass
> > to bs without being inited.
> 
> fs_bio_set was initiated early in the bio subsystem init.
> 
> > So it may have opportunity to return NULL in this function.
> 
> It may be, but may not be the thread you mentioned below.
> 
> > ---
> > Bio.c
> > struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct
> > bio_set
> > *bs)
> > {
> > ......
> > 	if (!bs) {
> > 		if (nr_iovecs > UIO_MAXIOV)
> > 			return NULL;
> > ---
> > I did the abnormal test: modify the max_sectors_kb in
> > /sys/block/sdx/queue to 32767 for a disk with f2fs format, and I got a
> > segfualt in f2fs_bio_alloc after the img mounted.
> > Is there anyting I missed?
> 
> Hmm, this change will also trigger bvec_alloc failed, did you add some
traces to
> debug this?

I reviewed the code in bio_alloc, and then trace the process of bio_alloc
for verification.
It indicate that bvec_alloc() will fail on the condition that nr_iovecs is
greater than BIO_MAX_PAGES.
The patch should be updated for that.

I am sorry about the mistake in this patch, and thanks for the reviewing and
reminding.

> 
> Regards,
> Gu
> 
> >
> >>
> >> Thanks,
> >> Gu
> >>
> >>>
> >>> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> >>>  ---
> >>>  fs/f2fs/segment.c |    4 +++-
> >>>  fs/f2fs/segment.h |    3 +++
> >>>  2 files changed, 6 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c index
> >>> 09af9c7..bd79bbe 100644
> >>> --- a/fs/f2fs/segment.c
> >>> +++ b/fs/f2fs/segment.c
> >>> @@ -657,6 +657,7 @@ static void submit_write_page(struct
> >>> f2fs_sb_info *sbi, struct page *page,
> >>>                                 block_t blk_addr, enum page_type
> >> type)
> >>> {
> >>>         struct block_device *bdev = sbi->sb->s_bdev;
> >>> +       int bio_blocks;
> >>>
> >>>         verify_block_addr(sbi, blk_addr);
> >>>
> >>> @@ -676,7 +677,8 @@ retry:
> >>>                         goto retry;
> >>>                 }
> >>>
> >>> -               sbi->bio[type] = f2fs_bio_alloc(bdev,
> > max_hw_blocks(sbi));
> >>> +               bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> >>> +               sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
> >>>                 sbi->bio[type]->bi_sector =
> SECTOR_FROM_BLOCK(sbi,
> >>> blk_addr);
> >>>                 sbi->bio[type]->bi_private = priv;
> >>>                 /*
> >>> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> >>> bdd10ea..6352af1 100644
> >>> --- a/fs/f2fs/segment.h
> >>> +++ b/fs/f2fs/segment.h
> >>> @@ -9,6 +9,7 @@
> >>>   * published by the Free Software Foundation.
> >>>   */
> >>>  #include <linux/blkdev.h>
> >>> +#include <linux/uio.h>
> >>>
> >>>  /* constant macro */
> >>>  #define NULL_SEGNO                     ((unsigned int)(~0))
> >>> @@ -90,6 +91,8 @@
> >>>         (blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
> >>> #define SECTOR_TO_BLOCK(sbi, sectors)
> >> \
> >>>         (sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
> >>> +#define MAX_BIO_BLOCKS(max_hw_blocks)
> >> \
> >>> +       (min((int)max_hw_blocks, UIO_MAXIOV))
> >>>
> >>>  /* during checkpoint, bio_private is used to synchronize the last
> >>> bio */  struct bio_private {
> >>> ---
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe
> >>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>> Please read the FAQ at  http://www.tux.org/lkml/
> >>>
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> =

