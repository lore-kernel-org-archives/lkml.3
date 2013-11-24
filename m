Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3KXEGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 23:06:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61303 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3KXEGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 23:06:20 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7f1a6d0000055a7-0e-52917b3a1b19
Content-transfer-encoding: 8BIT
Message-id: <1385265926.26319.96.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Sun, 24 Nov 2013 13:05:26 +0900
In-reply-to: <000c01cee7f7$471c04c0$d5540e40$@samsung.com>
References: <000301cee71f$b0e54160$12afc420$@samsung.com>
 <1385111441.26319.81.camel@kjgkr> <000c01cee7f7$471c04c0$d5540e40$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zY12r6olBBvdXGFv8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4+OxjYwF
	c4UrDmyTa2Ccyt/FyMEhIWAicfNsThcjJ5ApJnHh3no2EFtIYBmjRMcXSYi4icS8F21MXYxc
	QPHpjBLfe6YxgSR4BQQlfky+xwIyh1lAXuLIpWyQMLOAusSkeYuYIepfMUpMaX3NDlGvK7Hu
	6FuwBcIC+RJTd9xgB+llE9CW2LzfAGKvosTb/XdZQWwRASWJX/MXsYLMYRZYzijxfPI5FpAE
	i4CqRP/FyWBzOAWsJP5vfA11XDejxJJ3R5hBEvwCohKHF25nhvhASWJ3eyc7SJGEwDl2iZUr
	O5ggJglIfJt8iAUSErISmw5A1UtKHFxxg2UCo8QsJH/OQvhzFpI/FzAyr2IUTS1ILihOSi8y
	1CtOzC0uzUvXS87P3cQIibveHYy3D1gfYkwG2jiRWUo0OR8Yt3kl8YbGZkYWpiamxkbmlmak
	CSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFjlzFf58NTHd6vKik40J+8+w7dr
	gVDLhf671gW/tTgzLi5w8Xxqki+1TNLukfXZH6HPzziJuc51rt9SaGy/YN2lpxNtN71hyTBV
	u9p+1dvOZo+X+M2Xzo8fbE+NfhRzpFb23mJZ8+CYCdpp3+RVzRq6mRX9mALLnoXXTmr5IcWu
	UF3/6u7kRiWW4oxEQy3mouJEAMghOBrRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV2r6olBBtMP61n8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePjsY2MBXOFKw5sk2tgnMrfxcjJISFgIjHvRRsThC0mceHeerYu
	Ri4OIYHpjBLfe6aBJXgFBCV+TL7H0sXIwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxglprS+Zoeo
	15VYd/QtG4gtLJAvMXXHDXaQXjYBbYnN+w1AwkICihJv999lBbFFBJQkfs1fxAoyh1lgOaPE
	88nnWEASLAKqEv0XJ4PN4RSwkvi/8TUTxLJuRokl744wgyT4BUQlDi/czgzxgZLE7vZO9gmM
	QrOQ3D0L4e5ZSO5ewMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4sp9J72Bc1WBxiFGA
	g1GJh7fRcWKQEGtiWXFl7iFGCQ5mJRHernigEG9KYmVValF+fFFpTmrxIcZkoMsnMkuJJucD
	k05eSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTAuSvppvep0
	QWE3k9SXRlH5sgo51hq+3nN2klmhDlvXLpvA2N0x574Ys2O5etCqme5zZ92wKsteLeL/9q/F
	AqNHa2K7vPw71II2aFnX/ZALZ8iVXL6J8d3mibdVfgQLlv632r08ZUZYsphGl79AweqpWQ52
	CiUTGdST/PY/dAjauedVXY56mBJLcUaioRZzUXEiANja8wUwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-23 (토), 10:53 +0800, Chao Yu:
> Hi,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Friday, November 22, 2013 5:11 PM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > Subject: Re: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by merging for mount performance
> > 
> > Hi,
> > 
> > Just one niptick.
> > 
> > 2013-11-22 (금), 09:09 +0800, Chao Yu:
> > > Previously we read sit entries page one by one, this method lost the chance
> > > of reading contiguous page together. So we read pages as contiguous as
> > > possible for better mount performance.
> > >
> > > change log:
> > >  o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng
> > >    suggested.
> > >  o add mark_page_accessed() before release page to delay VM reclaiming.
> > >  o remove '*order' for simplification of function as Jaegeuk Kim suggested.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/segment.c |  103 +++++++++++++++++++++++++++++++++++++++--------------
> > >  fs/f2fs/segment.h |    2 ++
> > >  2 files changed, 78 insertions(+), 27 deletions(-)
> > >
> > > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > > index 8149eba..998e7d3 100644
> > > --- a/fs/f2fs/segment.c
> > > +++ b/fs/f2fs/segment.c
> > > @@ -14,6 +14,7 @@
> > >  #include <linux/blkdev.h>
> > >  #include <linux/prefetch.h>
> > >  #include <linux/vmalloc.h>
> > > +#include <linux/swap.h>
> > >
> > >  #include "f2fs.h"
> > >  #include "segment.h"
> > > @@ -1488,41 +1489,89 @@ static int build_curseg(struct f2fs_sb_info *sbi)
> > >  	return restore_curseg_summaries(sbi);
> > >  }
> > >
> > > +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
> > > +{
> > > +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> > > +	struct page *page;
> > > +	block_t blk_addr, prev_blk_addr = 0;
> > > +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> > 
> > Can we remove SIT_BLK_CNT by replacing with sit_i->sit_blocks?
> 
> Because sit_i->sit_blocks is a multiple of segment size(i.e. 512/1024),
> but we may use part of sit_blocks, not all of them. So it's waste to read 
> all of them.
> What's your opinion?

Got it.
It's right and we can avoid that.
Thanks, :)

-- 
Jaegeuk Kim
Samsung

