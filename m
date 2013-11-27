Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab3K0FbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:31:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:47034 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3K0Fa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:30:56 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f126d00000418c-f3-5295838ad346
Content-transfer-encoding: 8BIT
Message-id: <1385530195.2417.22.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for
 restore_node_summary
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Wed, 27 Nov 2013 14:29:55 +0900
In-reply-to: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
References: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zfd2u5qlBBu83qlj8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY9eDH4wF
	XfIVR5+nNjC+E+9i5OSQEDCR2P7+PRuELSZx4d56IJuLQ0hgGaPEmtUrGWGKLvz6yAiRWMQo
	8eDDO7AEr4CgxI/J91i6GDk4mAXkJY5cygYJMwuoS0yat4gZov4Vo0TLiy/MEPU6Eu+W/APb
	JiwQLdG26ScTSC+bgLbE5v0GIGEhAUWJt/vvsoLYIgJKEr/mL2IFmcMssJBR4uCCm2C9LAKq
	Es9bOsBsTgEriZ9d71ggmi0lVnasBdvFLyAqcXjhdmaIB5Qkdrd3soMMkhA4xy4xuacbapCA
	xLfJh8AekBCQldh0AKpeUuLgihssExglZiF5cxbCm7OQvLmAkXkVo2hqQXJBcVJ6kYlecWJu
	cWleul5yfu4mRkjkTdjBeO+A9SHGZKCNE5mlRJPzgZGbVxJvaGxmZGFqYmpsZG5pRpqwkjiv
	2qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M6fd1FTwkaldpB25jjXv0Mf18dN53HSm/
	DMnn2t+PWEuYqwbXTWb2K06tv3lm96pv7EmOHgndegVJmce054ftN2PWNXY7UHdp4R2bM3GH
	74R0NP24E160iT0ucV1GncnZ/X/cm7X/ramIcp5T5tek1SZ0527P4/tXeTme6IRH6hTEcL6S
	TlBiKc5INNRiLipOBAAArYR60gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd2u5qlBBovvylr8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPXgx+MBV3yFUefpzYwvhPvYuTkkBAwkbjw6yMjhC0mceHeerYu
	Ri4OIYFFjBIPPrwDS/AKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmLmCHqXzFKtLz4wgxR
	ryPxbsk/NhBbWCBaom3TTyaQXjYBbYnN+w1AwkICihJv999lBbFFBJQkfs1fxAoyh1lgIaPE
	wQU3wXpZBFQlnrd0gNmcAlYSP7vesUA0W0qs7FgLtotfQFTi8MLtzBAPKEnsbu9kn8AoNAvJ
	2bMQzp6F5OwFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj+pn0DsZVDRaHGAU4GJV4
	eCdcnhIkxJpYVlyZe4hRgoNZSYQ3vHJqkBBvSmJlVWpRfnxRaU5q8SHGZKDDJzJLiSbnA1NO
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwrp676Iahxs/X
	y50OyBxk3Pimcf9LzdbdM1jO1k4Xji2YsKg37velynlnrLPf729drLr7ee3BAzlrvZh7lS9O
	e/1F08G6wu6QzRnh0A75Ame5LE/NMlupy1vV2L9tPVy0+YjL800zT37e78a2IE1g7Z/QrXk7
	WBpZsqdk+S62lfsvOW/mtLtLTZVYijMSDbWYi4oTAetoT7MvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

It seems that we already have a readahed function for node pages,
ra_node_page().
So, we don't make a page list for this, but can use the node_inode's
page cache.

So how about writing ra_node_pages() which use the node_inode's page
cache?

Thanks,

2013-11-22 (금), 15:48 +0800, Chao Yu:
> If cp has no CP_UMOUNT_FLAG, we will read all pages in whole node segment 
> one by one, it makes low performance. So let's merge contiguous pages and 
> readahead for better performance.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 63 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 4ac4150..81e704a 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1572,47 +1572,84 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>  	return 0;
>  }
>  
> +/*
> + * ra_sum_pages() merge contiguous pages into one bio and submit.
> + * these pre-readed pages are linked in pages list.
> + */
> +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> +				int start, int nrpages)
> +{
> +	struct page *page;
> +	int page_idx = start;
> +
> +	for (; page_idx < start + nrpages; page_idx++) {
> +		/* alloc temporal page for read node summary info*/
> +		page = alloc_page(GFP_NOFS | __GFP_ZERO);
> +		if (!page) {
> +			struct page *tmp;
> +			list_for_each_entry_safe(page, tmp, pages, lru) {
> +				list_del(&page->lru);
> +				unlock_page(page);
> +				__free_pages(page, 0);
> +			}
> +			return -ENOMEM;
> +		}
> +
> +		lock_page(page);
> +		page->index = page_idx;
> +		list_add_tail(&page->lru, pages);
> +	}
> +
> +	list_for_each_entry(page, pages, lru)
> +		submit_read_page(sbi, page, page->index, READ_SYNC);
> +
> +	f2fs_submit_read_bio(sbi, READ_SYNC);
> +	return 0;
> +}
> +
>  int restore_node_summary(struct f2fs_sb_info *sbi,
>  			unsigned int segno, struct f2fs_summary_block *sum)
>  {
>  	struct f2fs_node *rn;
>  	struct f2fs_summary *sum_entry;
> -	struct page *page;
> +	struct page *page, *tmp;
>  	block_t addr;
> -	int i, last_offset;
> -
> -	/* alloc temporal page for read node */
> -	page = alloc_page(GFP_NOFS | __GFP_ZERO);
> -	if (!page)
> -		return -ENOMEM;
> -	lock_page(page);
> +	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> +	int i, last_offset, nrpages, err = 0;
> +	LIST_HEAD(page_list);
>  
>  	/* scan the node segment */
>  	last_offset = sbi->blocks_per_seg;
>  	addr = START_BLOCK(sbi, segno);
>  	sum_entry = &sum->entries[0];
>  
> -	for (i = 0; i < last_offset; i++, sum_entry++) {
> -		/*
> -		 * In order to read next node page,
> -		 * we must clear PageUptodate flag.
> -		 */
> -		ClearPageUptodate(page);
> +	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
>  
> -		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
> -			goto out;
> +		nrpages = min(last_offset - i, bio_blocks);
> +		/* read ahead node pages */
> +		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> +		if (err)
> +			return err;
>  
> -		lock_page(page);
> -		rn = F2FS_NODE(page);
> -		sum_entry->nid = rn->footer.nid;
> -		sum_entry->version = 0;
> -		sum_entry->ofs_in_node = 0;
> -		addr++;
> +		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> +
> +			lock_page(page);
> +			if(PageUptodate(page)) {
> +				rn = F2FS_NODE(page);
> +				sum_entry->nid = rn->footer.nid;
> +				sum_entry->version = 0;
> +				sum_entry->ofs_in_node = 0;
> +				sum_entry++;
> +			} else {
> +				err = -EIO;
> +			}
> +
> +			list_del(&page->lru);
> +			unlock_page(page);
> +			__free_pages(page, 0);
> +		}
>  	}
> -	unlock_page(page);
> -out:
> -	__free_pages(page, 0);
> -	return 0;
> +	return err;
>  }
>  
>  static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)

-- 
Jaegeuk Kim
Samsung

