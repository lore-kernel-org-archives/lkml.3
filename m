Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3KVJLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:11:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34258 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3KVJLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:11:35 -0500
X-AuditID: cbfee68f-b7f836d000001b39-b5-528f1fc51bdc
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1385111441.26319.81.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Fri, 22 Nov 2013 18:10:41 +0900
In-reply-to: <000301cee71f$b0e54160$12afc420$@samsung.com>
References: <000301cee71f$b0e54160$12afc420$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY92j8v1BBqemS1v8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr437zb9aC
	wzwVPbsvsDUwTubqYuTkkBAwkdh1eQsrhC0mceHeejYQW0hgGaNE88kimJr5014zdzFyAcUX
	MUqc3HUJrIhXQFDix+R7LCA2s4C6xKR5i4CKOIBsEYlFmwQhwtoSyxbC9L5ilNi8fCULRK+u
	xIwVx9hB6oUF8iWerEoFMdmA6jfvN4A4QVHi7f67YKeJCChJ/Jq/iBVkDLPAQkaJgwtugp3A
	IqAq8a//BhNIL6eAlcT1s+kQvZYSq8+cBuvlFxCVOLxwOzPEK0oSu9s72UHmSAicY5dY8Xc2
	I8QcAYlvkw+xgMyREJCV2HQAql5S4uCKGywTGCVnIXl4FpKHZyE8PAvJwwsYWVYxiqYWJBcU
	J6UXGesVJ+YWl+al6yXn525ihERp/w7GuwesDzEmA22fyCwlmpwPjPK8knhDYzMjC1MTU2Mj
	c0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCYtnPlpdAwV9U9G+U3teR1
	LPXVLPnYkjyjkS2Px+G7J8f1joi3D+fr5fEdFc6+FhTe1zmtqVqiw9li5uewyzvvplsYZH/+
	ltZkfzHlJuN0I7aHKzuLnjpbfTS0ttAXcPy75sxzPfVnE1YXFlbd7DIxnbyq5LOX4an8w88k
	Dn+cy7GGLYglzVSJpTgj0VCLuag4EQB21EZR6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd2j8v1BBrfeiFn8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMaPx4nTWgq08FbdXtzA3MLZydTFyckgImEjMn/aaGcIWk7hwbz1b
	FyMXh5DAIkaJk7susYEkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWvGCU2L1/J
	AlGvKzFjxTF2kHphgXyJJ6tSQUw2AW2JzfsNQCqEBBQl3u6/ywpiiwgoSfyav4gVZAyzwEJG
	iYMLboKtZRFQlfjXf4MJpJdTwEri+tl0iF5LidVnToP18guIShxeuB3qfCWJ3e2d7BMYhWYh
	OXoWwtGzkBy9gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwVD+T3sG4qsHiEKMAB6MS
	D+8Oy74gIdbEsuLK3EOMEhzMSiK81TL9QUK8KYmVValF+fFFpTmpxYcYk4HunsgsJZqcD0w4
	eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqO6hrLVs+6cA
	3icKN0SCporLXoy4pZGwMeLkI6bovQU8kX3JK5Uvfnl6vnXjhzWbYzMYyrkObdq37l1uX8gi
	7WMuzauz1l3NOakoVx0uz+Mj66kbNnNftmj3gqW3LTPl/lxYksZ3/qL++n9nbGc/CJyzqX2N
	kKlIQyFX5RndxgyR2tgt82W0lFiKMxINtZiLihMBo7G5yC4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just one niptick.

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

Can we remove SIT_BLK_CNT by replacing with sit_i->sit_blocks?

-- 
Jaegeuk Kim
Samsung

