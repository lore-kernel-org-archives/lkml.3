Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3KUBcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:32:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22702 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3KUBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:32:50 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f866d000001b8c-8e-528d62c0b769
Content-transfer-encoding: 8BIT
Message-id: <1384997517.26319.60.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry
 pages by merging for mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Thu, 21 Nov 2013 10:31:57 +0900
In-reply-to: <001d01cee5bc$779c2fe0$66d48fa0$@samsung.com>
References: <001d01cee5bc$779c2fe0$66d48fa0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zA90DSb1BBhPeyFv8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEro+nvDraC
	BwYVt7susDcwHlbrYuTgkBAwkXh1pqSLkRPIFJO4cG89WxcjF4eQwDJGiT0t/9kgEiYSz/Zt
	Y4VITGeUWDHrGhNIgldAUOLH5HssIIOYBeQljlzKBgkzC6hLTJq3iBnEFhJ4xSjxuAmqXFei
	f+ImdhBbWKBMYs6zt2wgrWwC2hKb9xtAlCtKvN1/lxXEFhFQkvg1fxHYWmaBhYwSBxfcBKtn
	EVCV+HWVF6SGU8BKYuWXPSwQvZYSK582gdn8AqIShxduZ4Y4X0lid3snO8gcCYFz7BKzGs6A
	FbEICEh8m3yIBRIOshKbDkDVS0ocXHGDZQKjxCwkT85CeHIWkicXMDKvYhRNLUguKE5KLzLV
	K07MLS7NS9dLzs/dxAiJuok7GO8fsD7EmAy0cSKzlGhyPjBq80riDY3NjCxMTUyNjcwtzUgT
	VhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkZ07PuF9xY+EDpG/e5sPvNr/m7//
	xerL6tvdLsk/MD+xOtrH94O0mPrftxenxycrsNpe51PJ6rzEttal54vQ/3eK+duL0tpZeM6/
	7xM8nv+9M7/FS/OmqP/fyHD5m7EZC9eu5Z1sOXk7u8TtdJ6rXl9LCh+fdNb6tG33RAYmmw9P
	9yXfvurvrMRSnJFoqMVcVJwIAIWp/hrQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd0DSb1BBg+/Sln8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMaPp7w62ggcGFbe7LrA3MB5W62Lk5JAQMJF4tm8bK4QtJnHh3nq2
	LkYuDiGB6YwSK2ZdYwJJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuYQWwhgVeMEo+b
	oMp1JfonbmIHsYUFyiTmPHvLBtLKJqAtsXm/AUS5osTb/XfB1ooIKEn8mr+IFWQts8BCRomD
	C26C1bMIqEr8usoLUsMpYCWx8sseFoheS4mVT5vAbH4BUYnDC7czQ5yvJLG7vZN9AqPQLCRH
	z0I4ehaSoxcwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7qZ9I7GFc1WBxiFOBgVOLh
	ffC0J0iINbGsuDL3EKMEB7OSCG+MdW+QEG9KYmVValF+fFFpTmrxIcZkoLsnMkuJJucDE05e
	SbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDyrng7O28e95RV
	XbJPdzN9e3HreUPUc/5JtrtVC0MnNK0te1u4/8p/x2Nbv8i5f3f0t25SZVq44PWhicvX2+QL
	Gq3Y/+GF8cYEOze9Q1fjAsX+yLXrJm7/4adrc7N7knwB64smvfaDnqE9Ki8nJWYH/uKfv1/K
	LpfhZr9A6D/nBRong/Y1K/1VYinOSDTUYi4qTgQAo8v4gy4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that ra_sit_pages() is too tightly coupled with
build_sit_entries().
Is there another way not to use *is_order?

The ra_sit_pages() tries to read consecutive sit pages as many as
possible.
So then, what about just checking whether its block address is
contiguous or not?

Something like this:
 -ra_sit_pages()
	blkno = start;
	while (blkno < sit_i->sit_blocks) {
		blk_addr = current_sit_addr(sbi, blkno);
		if (blkno != start && prev_blk_addr + 1 != blk_addr)
			break;

		/* grab and submit_read_page */

		prev_blk_addr = blk_addr;
		blkno++;
	}

Thanks,

2013-11-20 (수), 14:47 +0800, Chao Yu:
> Previously we read sit entries page one by one, this method lost the chance 
> of reading contiguous page together. So we read pages as contiguous as 
> possible for better mount performance.
> 
> v1-->v2:
>  o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng 
>     suggested.
>  o add mark_page_accessed() before release page to delay VM reclaiming them.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.c |  108 ++++++++++++++++++++++++++++++++++++++++-------------
>  fs/f2fs/segment.h |    2 +
>  2 files changed, 84 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 8149eba..52c88de 100644
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
> @@ -1488,41 +1489,96 @@ static int build_curseg(struct f2fs_sb_info *sbi)
>  	return restore_curseg_summaries(sbi);
>  }
>  
> +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start,
> +					int nrpages, bool *is_order)

Why do you use nrpages?

> +{
> +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> +	struct sit_info *sit_i = SIT_I(sbi);
> +	struct page *page;
> +	block_t blk_addr;
> +	int blkno = start, readcnt = 0;
> +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> +
> +	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
> +
> +		if ((!f2fs_test_bit(blkno, sit_i->sit_bitmap) ^ !*is_order)) {
> +			*is_order = !*is_order;
> +			break;
> +		}
> +
> +		blk_addr = sit_i->sit_base_addr + blkno;
> +		if (*is_order)
> +			blk_addr += sit_i->sit_blocks;
> +repeat:
> +		page = grab_cache_page(mapping, blk_addr);
> +		if (!page) {
> +			cond_resched();
> +			goto repeat;
> +		}
> +		if (PageUptodate(page)) {
> +			mark_page_accessed(page);
> +			f2fs_put_page(page, 1);
> +			readcnt++;
> +			continue;
> +		}
> +
> +		submit_read_page(sbi, page, blk_addr, READ_SYNC);
> +
> +		mark_page_accessed(page);
> +		f2fs_put_page(page, 0);
> +		readcnt++;
> +	}
> +
> +	f2fs_submit_read_bio(sbi, READ_SYNC);
> +	return readcnt;
> +}
> +
>  static void build_sit_entries(struct f2fs_sb_info *sbi)
>  {
>  	struct sit_info *sit_i = SIT_I(sbi);
>  	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
>  	struct f2fs_summary_block *sum = curseg->sum_blk;
> -	unsigned int start;
> -
> -	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
> -		struct seg_entry *se = &sit_i->sentries[start];
> -		struct f2fs_sit_block *sit_blk;
> -		struct f2fs_sit_entry sit;
> -		struct page *page;
> -		int i;
> +	bool is_order = f2fs_test_bit(0, sit_i->sit_bitmap) ? true : false;
> +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> +	unsigned int i, start, end;
> +	unsigned int readed, start_blk = 0;
>  
> -		mutex_lock(&curseg->curseg_mutex);
> -		for (i = 0; i < sits_in_cursum(sum); i++) {
> -			if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
> -				sit = sit_in_journal(sum, i);
> -				mutex_unlock(&curseg->curseg_mutex);
> -				goto got_it;
> +	do {
> +		readed = ra_sit_pages(sbi, start_blk, sit_blk_cnt, &is_order);
> +
> +		start = start_blk * sit_i->sents_per_block;
> +		end = (start_blk + readed) * sit_i->sents_per_block;
> +
> +		for (; start < end && start < TOTAL_SEGS(sbi); start++) {
> +			struct seg_entry *se = &sit_i->sentries[start];
> +			struct f2fs_sit_block *sit_blk;
> +			struct f2fs_sit_entry sit;
> +			struct page *page;
> +
> +			mutex_lock(&curseg->curseg_mutex);
> +			for (i = 0; i < sits_in_cursum(sum); i++) {
> +				if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
> +					sit = sit_in_journal(sum, i);
> +					mutex_unlock(&curseg->curseg_mutex);
> +					goto got_it;
> +				}
>  			}
> -		}
> -		mutex_unlock(&curseg->curseg_mutex);
> -		page = get_current_sit_page(sbi, start);
> -		sit_blk = (struct f2fs_sit_block *)page_address(page);
> -		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
> -		f2fs_put_page(page, 1);
> +			mutex_unlock(&curseg->curseg_mutex);
> +
> +			page = get_current_sit_page(sbi, start);
> +			sit_blk = (struct f2fs_sit_block *)page_address(page);
> +			sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
> +			f2fs_put_page(page, 1);
>  got_it:
> -		check_block_count(sbi, start, &sit);
> -		seg_info_from_raw_sit(se, &sit);
> -		if (sbi->segs_per_sec > 1) {
> -			struct sec_entry *e = get_sec_entry(sbi, start);
> -			e->valid_blocks += se->valid_blocks;
> +			check_block_count(sbi, start, &sit);
> +			seg_info_from_raw_sit(se, &sit);
> +			if (sbi->segs_per_sec > 1) {
> +				struct sec_entry *e = get_sec_entry(sbi, start);
> +				e->valid_blocks += se->valid_blocks;
> +			}
>  		}
> -	}
> +		start_blk += readed;
> +	} while (start_blk < sit_blk_cnt);
>  }
>  
>  static void init_free_segmap(struct f2fs_sb_info *sbi)
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 269f690..ad5b9f1 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -83,6 +83,8 @@
>  	(segno / SIT_ENTRY_PER_BLOCK)
>  #define	START_SEGNO(sit_i, segno)		\
>  	(SIT_BLOCK_OFFSET(sit_i, segno) * SIT_ENTRY_PER_BLOCK)
> +#define SIT_BLK_CNT(sbi)			\
> +	((TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
>  #define f2fs_bitmap_size(nr)			\
>  	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
>  #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)

-- 
Jaegeuk Kim
Samsung

