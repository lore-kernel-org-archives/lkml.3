Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3KRAaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 19:30:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34279 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3KRAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:30:11 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fa16d0000029b0-b0-52895f91528a
Content-transfer-encoding: 8BIT
Message-id: <1384734560.26319.10.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for
 merging contiguous read
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Mon, 18 Nov 2013 09:29:20 +0900
In-reply-to: <000001cee293$3b6e3030$b24a9090$@samsung.com>
References: <000001cee293$3b6e3030$b24a9090$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA92J8Z1BBpt6pCz+N31ks7i0yN1i
	z96TLBaXd81hs2hdeJ7ZgdVj94LPTB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcX1qP2NB
	n0zFy9vrmBoYj4h1MXJySAiYSOy785kNwhaTuHBvPZDNxSEksIxR4t2xTiaYov2906ES0xkl
	fl3axwqS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/YpQ48HANVL2uxPN5O5lB
	bGGBDIlzT66D9bIJaEts3m8AEhYSUJR4u/8uWLmIgJLEr/mLWEHmMAssZJQ4uOAm2KUsAqoS
	s5asZwSxOQWsJFas2s0E0Wwp8fn0EnYQm19AVOLwwu3MEA8oSexu72QHGSQhcI5d4u6mr8wQ
	gwQkvk0+BHaEhICsxKYDUPWSEgdX3GCZwCgxC8mbsxDenIXkzQWMzKsYRVMLkguKk9KLDPWK
	E3OLS/PS9ZLzczcxQmKvdwfj7QPWhxiTgTZOZJYSTc4Hxm5eSbyhsZmRhamJqbGRuaUZacJK
	4rxJD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBO+/aOy0Brj6PKkwMz0mrr/ssnNv/O
	339rwbdfJblf6ubnS+QfTqsM0+19abpV9E198fu4D/ue5f7oat/ofvF+WqT2+6lG3ssUmVVM
	jmaJrC7/FhlvuzlR+qfnspYnzVEenhWNai3VvlEC0TWcpw6sLhPOrs97uGFGecX25DJ9JcPp
	mqIyy5RYijMSDbWYi4oTAeDfYXrTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd2J8Z1BBotPi1r8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMeP61H7Ggj6Zipe31zE1MB4R62Lk5JAQMJHY3zudDcIWk7hwbz2Q
	zcUhJDCdUeLXpX2sIAleAUGJH5PvsXQxcnAwC8hLHLmUDRJmFlCXmDRvETNE/StGiQMP10DV
	60o8n7eTGcQWFsiQOPfkOlgvm4C2xOb9BiBhIQFFibf774KViwgoSfyav4gVZA6zwEJGiYML
	boIdxCKgKjFryXpGEJtTwEpixardTBDNlhKfTy9hB7H5BUQlDi/czgzxgJLE7vZO9gmMQrOQ
	nD0L4exZSM5ewMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4sp9J7WBc2WBxiFGAg1GJ
	h1cjrDNIiDWxrLgy9xCjBAezkgiviT9QiDclsbIqtSg/vqg0J7X4EGMy0OETmaVEk/OBSSev
	JN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgNJpdJB6+YcZ85
	gPmP0Xmz/Wa3O33FHR3PvZly5lVlSq/LwbnxUk9d6l4ZGZbbXDD7IB9QbzqRcbH2P26nfKOP
	68vXJuxWlL+Sdd/ycfijZXb3tz1aXGPu+vfjkwaZX/xnThb3Pjs+R1TE4ZXPB+tne9XmfVI/
	nNhm4Hp5qdOkW0YX/Dndmp2VWIozEg21mIuKEwGqqRLbMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

2013-11-16 (토), 14:14 +0800, Chao Yu:
> For better read performance, we add a new function to support for merging contiguous read as the one for write.

Please consider 80 columns for the description.
I cannot fix this at every time though. :(

> 
> v1-->v2:
>  o add declarations here as Gu Zheng suggested.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/data.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/f2fs/f2fs.h |    4 ++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index aa3438c..18107cb 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -404,6 +404,51 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>  	return 0;
>  }
>  
> +void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
> +{
> +	down_read(&sbi->bio_sem);

Is there any reason to use down_read()?
It seems that we need to declare sbi->bio_read and sbi->bio_write
instead of sbi->bio_sem.
In addition to that, we need to use down_write(&sbi->bio_read) here.

> +	if (sbi->read_bio) {
> +		submit_bio(rw, sbi->read_bio);
> +		sbi->read_bio = NULL;
> +	}
> +	up_read(&sbi->bio_sem);

up_write(&sbi->bio_read);

> +}
> +
> +void submit_read_page(struct f2fs_sb_info *sbi, struct page *page,
> +					block_t blk_addr, int rw)
> +{
> +	struct block_device *bdev = sbi->sb->s_bdev;
> +	int bio_blocks;
> +
> +	verify_block_addr(sbi, blk_addr);
> +
> +	down_read(&sbi->bio_sem);

down_write(&sbi->bio_read);

> +
> +	if (sbi->read_bio && sbi->last_read_block != blk_addr - 1) {
> +		submit_bio(rw, sbi->read_bio);
> +		sbi->read_bio = NULL;
> +	}
> +
> +alloc_new:
> +	if (sbi->read_bio == NULL) {
> +		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> +		sbi->read_bio = f2fs_bio_alloc(bdev, bio_blocks);
> +		sbi->read_bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> +		sbi->read_bio->bi_end_io = read_end_io;
> +	}
> +
> +	if (bio_add_page(sbi->read_bio, page, PAGE_CACHE_SIZE, 0) <
> +							PAGE_CACHE_SIZE) {
> +		submit_bio(rw, sbi->read_bio);
> +		sbi->read_bio = NULL;
> +		goto alloc_new;
> +	}
> +
> +	sbi->last_read_block = blk_addr;
> +
> +	up_read(&sbi->bio_sem);

up_write(&sbi->bio_read);

> +}
> +
>  /*
>   * This function should be used by the data read flow only where it
>   * does not check the "create" flag that indicates block allocation.
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 89dc750..bfe9d87 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -359,6 +359,8 @@ struct f2fs_sb_info {
>  
>  	/* for segment-related operations */
>  	struct f2fs_sm_info *sm_info;		/* segment manager */
> +	struct bio *read_bio;			/* read bios to merge */
> +	sector_t last_read_block;		/* last read block number */
>  	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
>  	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
>  	struct rw_semaphore bio_sem;		/* IO semaphore */
> @@ -1111,6 +1113,8 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
>  struct page *get_lock_data_page(struct inode *, pgoff_t);
>  struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
>  int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
> +void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
> +void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
>  int do_write_data_page(struct page *);
>  
>  /*

-- 
Jaegeuk Kim
Samsung

