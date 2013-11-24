Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3KXE05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 23:26:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52823 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3KXE0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 23:26:55 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f7e6d00000477d-46-5291800dd354
Content-transfer-encoding: 8BIT
Message-id: <1385267160.26319.98.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Sun, 24 Nov 2013 13:26:00 +0900
In-reply-to: <000301cee71f$b0e54160$12afc420$@samsung.com>
References: <000301cee71f$b0e54160$12afc420$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zQ13eholBBtdeq1r8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4/ahbewF
	O/kqPrdsZmxg3MHdxcjBISFgItH+y7WLkRPIFJO4cG89WxcjF4eQwDJGib9Xr7FAJEwkjvy8
	CZWYzihx//4xNpAEr4CgxI/J91hABjELyEscuZQNEmYWUJeYNG8RM0T9K0aJH6s/MUPU60pc
	mTWVEaReWCBf4smqVBCTTUBbYvN+A5AKIQFFibf777KC2CICShK/5i9iBRnDLLCQUeLggptg
	a1kEVCXun3rJDNLLKWAlcf1sOkSvpcTqM6fBevkFRCUOL9zODHG+ksTu9k52kDkSAqfYJY5M
	+soIMUdA4tvkQyyQcJCV2HQAql5S4uCKGywTGCVmIXlyFsKTs5A8uYCReRWjaGpBckFxUnqR
	kV5xYm5xaV66XnJ+7iZGSNT17WC8ecD6EGMy0MaJzFKiyfnAqM0riTc0NjOyMDUxNTYytzQj
	TVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxruVhnSam5/g2esS68OH+5tYqx
	zaZIw42XjkTMX+B9fl7hat7irY4PEha2fT2QZ7NO4pb4zFcam+7YG8rEcO48NLX/dNb9awYi
	5ZkVNrftLhhuFvuuacjz59QVA2afzebPORi+vJwk25O7/L6yiafA1j7F4Jgbf2+8K67YskeB
	q32ZmZj+AXYlluKMREMt5qLiRAAGsPuj0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV3eholBBq96FC3+N31ks7i0yN1i
	z96TLBaXd81hs2hdeJ7ZgdVj94LPTB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmHH70Db2gp18FZ9bNjM2MO7g7mLk5JAQMJE48vMmG4QtJnHh3nog
	m4tDSGA6o8T9+8fAErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6V4wSP1Z/Yoao
	15W4MmsqI0i9sEC+xJNVqSAmm4C2xOb9BiAVQgKKEm/332UFsUUElCR+zV/ECjKGWWAho8TB
	BRD3sAioStw/9ZIZpJdTwEri+tl0iF5LidVnToP18guIShxeuJ0Z4nwlid3tnewTGIVmITl6
	FsLRs5AcvYCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFQ/k97BuKrB4hCjAAejEg9v
	o+PEICHWxLLiytxDjBIczEoivF3xQCHelMTKqtSi/Pii0pzU4kOMyUB3T2SWEk3OByacvJJ4
	Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgTJOcWvI7Q83plcbb
	+L8JtmVZSb9VE/Ztq9Jt/sqkOnfrrVOX/LIlmLcfaZy20/58s7WkiIlnkKFChX6S4t97f7v+
	T9ulUC0y8bLby2CWPxp3yr/LfHZ4sfuKcmtr7e5PuRpbvVmVf31U/Ol3/nXqq5a0tdbOS6aI
	7K4or1scJW9zgPNQ1uoiJZbijERDLeai4kQA5Jpfdy4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-22 (금), 09:09 +0800, Chao Yu:
> Previously we read sit entries page one by one, this method lost the chance 
> of reading contiguous page together. So we read pages as contiguous as 
> possible for better mount performance.
> 
> change log:
>  o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng 
>    suggested.
>  o add mark_page_accessed() before release page to delay VM reclaiming.
>  o remove '*order' for simplification of function as Jaegeuk Kim suggested.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.c |  103 +++++++++++++++++++++++++++++++++++++++--------------
>  fs/f2fs/segment.h |    2 ++
>  2 files changed, 78 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 8149eba..998e7d3 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -14,6 +14,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/prefetch.h>
>  #include <linux/vmalloc.h>
> +#include <linux/swap.h>
>  
>  #include "f2fs.h"
>  #include "segment.h"
> @@ -1488,41 +1489,89 @@ static int build_curseg(struct f2fs_sb_info *sbi)
>  	return restore_curseg_summaries(sbi);
>  }
>  
> +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
> +{
> +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> +	struct page *page;
> +	block_t blk_addr, prev_blk_addr = 0;
> +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> +	int blkno = start;
> +
> +	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
> +
> +		blk_addr = current_sit_addr(sbi, start * SIT_ENTRY_PER_BLOCK);

Should be:
	blk_addr = current_sit_addr(sbi, blkno * SIT_ENTRY_PER_BLOCK);
	                                -------
I'll fix this and merge the patch though.
Thanks,

-- 
Jaegeuk Kim
Samsung

