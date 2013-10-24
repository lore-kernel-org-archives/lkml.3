Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3JXD33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 23:29:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33936 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3JXD31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 23:29:27 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-2e-526894169cf4
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000701cecf09$2b2a2280$817e6780$@samsung.com>
 <1382444612.992.67.camel@kjgkr> <000001cecf9f$7113b630$533b2290$@samsung.com>
 <1382520734.992.78.camel@kjgkr>
In-reply-to: <1382520734.992.78.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with
 integer data type for better mount performance
Date: Thu, 24 Oct 2013 11:28:19 +0800
Message-id: <000101ced069$3d89fd40$b89df7c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDZIwqdT2gfBmAxVRhZqO8VDeOyHgI34XxsAiua/IUBstFve5u9yrHg
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQV2xKRlBBm83c1pc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXRufZm6wF
	sxQqdr/Zw9zA+Faii5GDQ0LARGJSm0cXIyeQKSZx4d56ti5GLg4hgemMEqfu/GCHcH4wSvy6
	954NpIpNQEViecd/JhBbREBaYtaneSwgRcwCMxkltk3/wAjRsZpR4v+BA+wgVZwCOhLfF51n
	AbGFBaoknk69ChZnEVCVaL7wDyzOK2Ap8bJtNzOELSjxY/I9FpDzmAXUJaZMyQUJMwtoSzx5
	d4EV4lQFiR1nXzOClIgIuEn0dihBlIhLbDxyi2UCo9AsJINmIQyahWTQLCQdCxhZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIER8Az6R2MqxosDjEKcDAq8fBqfEgPEmJNLCuuzD3EKMHB
	rCTC61mRESTEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qB
	cQ7j+YV5Dhf3elZrfde4pPKH81yV1a52zmLHWqd5W8/IL29osCnqSHn87/rcz9tE54osvKF0
	x/hPQrT+y/xbmmpqe9fu8D6hOilFJIv9SFBqKmvLgnJfo/aJxxc93qkpNbf0e+MyxdYvK8N7
	7OdE12y/1GB1i19UuXqL2UfuDO+bt523dT6/pMRSnJFoqMVcVJwIALb2PnF8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Wednesday, October 23, 2013 5:32 PM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org; '谭姝'
> Subject: RE: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with integer
> data type for better mount performance
> 
> Hi,
> 
> 2013-10-23 (수), 11:23 +0800, Chao Yu:
> > Hi, Kim:
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Tuesday, October 22, 2013 8:24 PM
> > > To: Chao Yu
> > > Cc: linux-f2fs-devel@lists.sourceforge.net;
> > > linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; 谭姝
> > > Subject: Re: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap
> > > with integer data type for better mount performance
> > >
> > > Hi,
> > >
> > > 2013-10-22 (화), 17:28 +0800, Chao Yu:
> > > > Previously, check_block_count check valid_map with bit data type
> > > > in common scenario that sit has all ones or zeros bitmap, it makes
> > > > low mount performance.
> > > > So let's check the special bitmap with integer data type instead
> > > > of the bit one.
> > > >
> > > > Signed-off-by: Tan Shu <shu.tan@samsung.com>
> > > > Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> > > > ---
> > > >  fs/f2fs/segment.h |   13 +++++++++++++
> > > >  1 file changed, 13 insertions(+)
> > > >
> > > > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> > > > 7f94d78..d43ab9f 100644
> > > > --- a/fs/f2fs/segment.h
> > > > +++ b/fs/f2fs/segment.h
> > > > @@ -543,6 +543,7 @@ static inline void check_block_count(struct
> > > > f2fs_sb_info *sbi,  {
> > > >  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> > > >  	unsigned int end_segno = sm_info->segment_count - 1;
> > > > +	int *valid_map = (int *)raw_sit->valid_map;
> > > >  	int valid_blocks = 0;
> > > >  	int i;
> > > >
> > > > @@ -552,6 +553,19 @@ static inline void check_block_count(struct
> > > > f2fs_sb_info *sbi,
> > > >  	/* check boundary of a given segment number */
> > > >  	BUG_ON(segno > end_segno);
> > > >
> > > > +	/* check all ones or zeros valid_map */
> > > > +	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
> > > > +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
> > >
> > > We cannot guarantee all the time that SIT_VBLOCK_MAP_SIZE is
> > > multiple of sizeof(int).
> > Well, It's really large changes for f2fs if SIT_VBLOCK_MAP_SIZE value is being
> modified.
> 
> But, it can be changed.
> Please do not add any unnecessary assumption.
Got it, sorry for the unmeaning assumption.

> 
> >
> > > How about using memcmp() with __u8?
> > Do you mean that we can alloc all zeros or ones memory in
> > SIT_VBLOCK_MAP_SIZE size, then memcmp() it with sit bitmap by __u8?
> 
> Yap.
> Ah, but there is another one.
> It would be better to use find_next_bit_le() and find_next_zero_bit_le().
> Any idea?
Good point.
I try to use memcmp(bitmap, bitmap+1, size-1) and bitmap[0], 
But yours got better performance and readable.
Thanks.

> 
> >
> > >
> > > > +			if (unlikely(valid_map[i] != 0))
> > > > +				BUG();
> > > > +		return;
> > > > +	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
> > > > +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
> > > > +			if (unlikely(valid_map[i] != -1))
> > > > +				BUG();
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	/* check bitmap with valid block count */
> > > >  	for (i = 0; i < sbi->blocks_per_seg; i++)
> > > >  		if (f2fs_test_bit(i, raw_sit->valid_map))
> > > > ---
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > > linux-fsdevel" in the body of a message to
> > > > majordomo@vger.kernel.org More majordomo info at
> > > > http://vger.kernel.org/majordomo-info.html
> > >
> > > --
> > > Jaegeuk Kim
> > > Samsung
> >
> 
> --
> Jaegeuk Kim
> Samsung

