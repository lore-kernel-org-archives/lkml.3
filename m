Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3JWJcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:32:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31520 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3JWJcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:32:50 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f836d000001b39-64-526797c0b163
Content-transfer-encoding: 8BIT
Message-id: <1382520734.992.78.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with
 integer data type for better mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Wed, 23 Oct 2013 18:32:14 +0900
In-reply-to: <000001cecf9f$7113b630$533b2290$@samsung.com>
References: <000701cecf09$2b2a2280$817e6780$@samsung.com>
 <1382444612.992.67.camel@kjgkr> <000001cecf9f$7113b630$533b2290$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA90D09ODDP5tlLT43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXRteVfsaC
	ZZIVN3qb2RoYDwp3MXJySAiYSKxedYYZwhaTuHBvPVsXIxeHkMAyRol3v14wdTFygBW9m+ME
	EV/EKHHw0l92kAZeAUGJH5PvsYDUMAvISxy5lA0SZhZQl5g0bxEzRP0rRokpx+axQNRrS8xe
	eoUJxBYWqJJ4OvUqO0gvG1B8834DkLCQgKLE2/13WUFsEQEliV/zF7GCzGEWWM4osb3/Gdhe
	FgFVieOHloLN5BSwkvh/8gE7xLJORonJN9eBdfMLiEocXrgd6jMlid3tnWBFEgKX2CXmz5rO
	DDFJQOLb5EMsEF/KSmw6AFUvKXFwxQ2WCYwSs5D8OQvhz1lI/lzAyLyKUTS1ILmgOCm9yFiv
	ODG3uDQvXS85P3cTIyT2+ncw3j1gfYgxGWjjRGYp0eR8YOzmlcQbGpsZWZiamBobmVuakSas
	JM57/2FSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGjeueq38+qb5U3jzS27+E4YXDs+K+
	g2/314XeeNTZ2h3rn1frMe/r2ma/ltYw5ildz3nePs9b5HhNfcJaDoelTp8+7pjYwrGFZfVq
	+fIax4J4u7o/2bvfrl+wyUczxOORe1vpfbmt9z75VqlP2sxfVL6I3ZQ3dI7petclPS4GfYF/
	lFmCjFWUWIozEg21mIuKEwERiNks0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd0D09ODDM5dFLH43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY0bXlX7GgmWSFTd6m9kaGA8KdzFycEgImEi8m+PUxcgJZIpJXLi3
	nq2LkYtDSGARo8TBS3/ZQRK8AoISPybfYwGpZxaQlzhyKRskzCygLjFp3iJmiPpXjBJTjs1j
	gajXlpi99AoTiC0sUCXxdOpVdpBeNqD45v0GIGEhAUWJt/vvsoLYIgJKEr/mL2IFmcMssJxR
	Ynv/M7C9LAKqEscPLQWbySlgJfH/5AN2iGWdjBKTb64D6+YXEJU4vHA7M8QHShK72zvZJzAK
	zUJy9yyEu2chuXsBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODIfia1g3Flg8UhRgEO
	RiUeXov2tCAh1sSy4srcQ4wSHMxKIrzqE9KDhHhTEiurUovy44tKc1KLDzEmA10+kVlKNDkf
	mHTySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFxWelbGY9Z
	JfbHDy7U28PK/HPhNQF3Ye8Xfy577jvl2PTV890Xr/rfBa/mpNqdUyxxuzizaqPn+ufJ677n
	Obharl7wfJ+M5w+dDG3H6XlTFpfOeMolq3vm8TIXl3IHDravCxfL97VeT01d+uDXZp3sR7xq
	UQb7NispLftxOzu623aZ9Ozb6k/clFiKMxINtZiLihMBycY6/zADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-23 (수), 11:23 +0800, Chao Yu:
> Hi, Kim:
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Tuesday, October 22, 2013 8:24 PM
> > To: Chao Yu
> > Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> > linux-kernel@vger.kernel.org; 谭姝
> > Subject: Re: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with integer
> > data type for better mount performance
> > 
> > Hi,
> > 
> > 2013-10-22 (화), 17:28 +0800, Chao Yu:
> > > Previously, check_block_count check valid_map with bit data type in
> > > common scenario that sit has all ones or zeros bitmap, it makes low
> > > mount performance.
> > > So let's check the special bitmap with integer data type instead of
> > > the bit one.
> > >
> > > Signed-off-by: Tan Shu <shu.tan@samsung.com>
> > > Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/segment.h |   13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > >
> > > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> > > 7f94d78..d43ab9f 100644
> > > --- a/fs/f2fs/segment.h
> > > +++ b/fs/f2fs/segment.h
> > > @@ -543,6 +543,7 @@ static inline void check_block_count(struct
> > > f2fs_sb_info *sbi,  {
> > >  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> > >  	unsigned int end_segno = sm_info->segment_count - 1;
> > > +	int *valid_map = (int *)raw_sit->valid_map;
> > >  	int valid_blocks = 0;
> > >  	int i;
> > >
> > > @@ -552,6 +553,19 @@ static inline void check_block_count(struct
> > > f2fs_sb_info *sbi,
> > >  	/* check boundary of a given segment number */
> > >  	BUG_ON(segno > end_segno);
> > >
> > > +	/* check all ones or zeros valid_map */
> > > +	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
> > > +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
> > 
> > We cannot guarantee all the time that SIT_VBLOCK_MAP_SIZE is multiple of
> > sizeof(int).
> Well, It's really large changes for f2fs if SIT_VBLOCK_MAP_SIZE value is being modified.

But, it can be changed.
Please do not add any unnecessary assumption.

> 
> > How about using memcmp() with __u8?
> Do you mean that we can alloc all zeros or ones memory in SIT_VBLOCK_MAP_SIZE size,
> then memcmp() it with sit bitmap by __u8?

Yap.
Ah, but there is another one.
It would be better to use find_next_bit_le() and
find_next_zero_bit_le().
Any idea?

> 
> > 
> > > +			if (unlikely(valid_map[i] != 0))
> > > +				BUG();
> > > +		return;
> > > +	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
> > > +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
> > > +			if (unlikely(valid_map[i] != -1))
> > > +				BUG();
> > > +		return;
> > > +	}
> > > +
> > >  	/* check bitmap with valid block count */
> > >  	for (i = 0; i < sbi->blocks_per_seg; i++)
> > >  		if (f2fs_test_bit(i, raw_sit->valid_map))
> > > ---
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-fsdevel" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > Jaegeuk Kim
> > Samsung
> 

-- 
Jaegeuk Kim
Samsung

