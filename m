Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab3LBIQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:16:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18709 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3LBIP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:15:56 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f7e6d00000477d-30-529c41b7a39d
Content-transfer-encoding: 8BIT
Message-id: <1385972094.2417.104.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Mon, 02 Dec 2013 17:14:54 +0900
In-reply-to: <000201ceef25$e145cec0$a3d16c40$@samsung.com>
References: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
 <000201ceef25$e145cec0$a3d16c40$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ90djnOCDD79ZLT43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxpPec+wF
	twQqVvRcZ25gPMTbxcjJISFgInF0YhM7hC0mceHeerYuRi4OIYFljBIHz3xmhCnqefSfCSIx
	nVHi4YnrzCAJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxFYiZDAK0aJpkVBEOW6Es9n
	3GMDsYUFvCQaTr1jB2llE9CW2LzfAKJcUeLt/rusILaIgJLEr/mLWEHWMgssBLpnwU2wXhYB
	VYnVc66C3cYpYCXR8m0iE0RzuUTn2Xdgz/ALiEocXridGeJ+JYnd7Z3sIIMkBC6xS/zZ+Rlq
	kIDEt8mHwO6XEJCV2HQAql5S4uCKGywTGCVmIflyFsKXs5B8uYCReRWjaGpBckFxUnqRkV5x
	Ym5xaV66XnJ+7iZGSOT17WC8ecD6EGMy0MaJzFKiyfnAyM0riTc0NjOyMDUxNTYytzQjTVhJ
	nHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyOZ7jrOHW9W+INO3bmr09KPrGpZkpo
	pc7VnfuU1T3PCt3tuVXqwXZnocjUwDqjhP0Rd3JrNJg9FTYwOrauW3b+wX65d29ZMs/f6no9
	9VhId73Pp3uNWSvfmB1Y/m/KV+slhR+yH0tMCp1y3ae6Zld19NoGqyDRpvju6/senV6QpN/+
	re6fxVolluKMREMt5qLiRAAGDtIu0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd3tjnOCDFaftbL43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aT3nPsBbcEKlb0XGduYDzE28XIySEhYCLR8+g/E4QtJnHh3nq2
	LkYuDiGB6YwSD09cZwZJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYvASoQEXjFKNC0K
	gijXlXg+4x4biC0s4CXRcOodO0grm4C2xOb9BhDlihJv999lBbFFBJQkfs1fxAqylllgIaPE
	wQU3wXpZBFQlVs+5yghicwpYSbR8m8gE0Vwu0XkWZCYnB7+AqMThhduZIe5Xktjd3sk+gVFo
	FpKrZyFcPQvJ1QsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMf1M6kdjCsbLA4xCnAw
	KvHwXhSeEyTEmlhWXJl7iFGCg1lJhJfl7+wgId6UxMqq1KL8+KLSnNTiQ4zJQIdPZJYSTc4H
	ppy8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCcdfvxL4Vk
	rS2sbUGSe5fp7tm/p/jWXY7JKnxnpC2kGlPWeby1S5jveqT2X2b8Dd37E/8cLb/Rma57umSV
	qU+2/rSwQ04z7008+IjJJb9/39FZZ79xy6ukFoUXJJrmT8vxnc2lF+6z7+Iu73vSocpLDuUJ
	PoyxWXDyHM9u34J5Z3xj1gmJ781WYinOSDTUYi4qTgQAZbc3Ii8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-02 (월), 14:14 +0800, Chao Yu:
> Hi Kim,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Saturday, November 30, 2013 9:48 AM
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
> > 
> > Previously f2fs allocates its own bi_private data structure all the time even
> > though we don't use it. But, can we remove this bi_private allocation?
> > 
> > This patch removes such the additional bi_private allocation.
> > 
> > 1. Retrieve f2fs_sb_info from its page->mapping->host->i_sb.
> >  - This removes the usecases of bi_private in end_io.
> > 
> > 2. Use bi_private only when we really need it.
> >  - The bi_private is used only when the checkpoint procedure is conducted.
> >  - When conducting the checkpoint, f2fs submits a META_FLUSH bio to wait its bio
> > completion.
> >  - Since we have no dependancies to remove bi_private now, let's just use
> >  bi_private pointer as the completion pointer.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/segment.c | 43 ++++++++++++++++---------------------------
> >  fs/f2fs/segment.h |  7 -------
> >  2 files changed, 16 insertions(+), 34 deletions(-)
> > 
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 0387863..0db4027 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -791,7 +791,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
> >  {
> >  	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> >  	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> > -	struct bio_private *p = bio->bi_private;
> > +	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
> 
> I'm not sure whether bvec->bv_page->mapping will be set to NULL in the flow
> where may not check WRITEBACK flag of page. Is it possible?

The mapping should be not NULL cause it is a writebacking page.
Otherwise, it's a bug.
Thanks,

-- 
Jaegeuk Kim
Samsung

