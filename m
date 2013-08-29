Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3H2L4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:56:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14605 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3H2L4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:56:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f756d000004512-33-521f36dc1028
Content-transfer-encoding: 8BIT
Message-id: <1377777368.2354.46.camel@kjgkr>
Subject: Re: [PATCH] f2fs: optimize gc for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jin Xu <jinuxstyle@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Aug 2013 20:56:08 +0900
In-reply-to: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com>
References: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zI907ZvJBBgsmCFvsfHKa2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK6O77zx7Qb9uxam/
	s9kbGJcrdzFycEgImEhc3s/excgJZIpJXLi3ng3EFhJYxihxay8nRNxE4vqZE0BxLqD4dEaJ
	Y0uuMoIkeAUEJX5MvscCModZQF7iyKVskDCzgLrEpHmLmCHqXzNKbFn/igWiXkeiY+skMFtY
	wFbi/6n5rCC9bALaEpv3G0DsVZR4u/8uWFgEyP60TxpiZKbEvaYZzCBhFgFVicOvgkDCnAKu
	EntO9jFBdLpI/NrzAWw4v4CoxOGF25khrleS2N3eyQ5yjYTAPnaJ7VNvgL3IIiAg8W3yIRZI
	KMhKbDoAVS8pcXDFDZYJjBKzkPw4C+HHWUh+XMDIvIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/
	dxMjJM76djDePGB9iDEZaONEZinR5HxgnOaVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgVEjP9CwiFszX4Uh2PuC51v2dd+Ob2lquKqWvSsm9c7f
	Fr/0GLagtuDkNuGF77Ku/l9eVW6+MPaL4ZL1jAzcEUamH75Of8dxnL9464nLyh+U0m4s1M45
	s+zLgfcS39Rac3K28jeHJ25yEXx1t09e2Cv3wCLeNjbfrsBqoQfx6XGhdw6Z3BBLVGIpzkg0
	1GIuKk4EADiAz5nJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd07ZvJBBj0tfBY7n5xmtri0yN1i
	z96TLBaXd81hc2Dx2DnrLrvH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zo7jvPXtCvW3Hq72z2Bsblyl2MnBwSAiYS18+cYIOwxSQu3FsPZHNxCAlM
	Z5Q4tuQqI0iCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+aUWLL+lcsEPU6Eh1b
	J4HZwgK2Ev9PzWcF6WUT0JbYvN8AJCwkoCjxdv9dsLAIkP1pnzTEyEyJe00zmEHCLAKqEodf
	BYGEOQVcJfac7GOC6HSR+LXnA9hwfgFRicMLtzNDXK8ksbu9k30Co9AsJDfPQrh5FpKbFzAy
	r2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjuRnUjsYVzZYHGIU4GBU4uGN+C0bJMSaWFZc
	mXuIUYKDWUmE9y2nfJAQb0piZVVqUX58UWlOavEhxmSguycyS4km5wOTTF5JvKGxiZmRpZGZ
	hZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MCbzLJZkmf/v5CEvW92YrUsu5OTG
	hCe8PCNoGf4tMsrwmqHHnnWaa7ct+M+9J0BUcvEGQycPbuug1f47evyL71ax9jMI7xG1Fnf+
	V5Fxunf6Jdm6Ts7Lnz2f/ziy5WFBtinDUh7b5oeLA1viXmz5Zv13m41FyvPNbDevb4yTfr7e
	VeeN7BGWBCWW4oxEQy3mouJEAFxqi4IoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-08-29 (목), 08:48 +0800, Jin Xu:
> From: Jin Xu <jinuxstyle@gmail.com>
> 
> This patch improves the foreground gc efficiency by optimizing the
> victim selection policy. With this optimization, the random re-write
> performance could increase up to 20%.
> 
> For f2fs, foreground gc happens when disk is lack of free spaces,
> it selects dirty segments and moves valid blocks around for making
> more space available. The gc cost of a segment is determined by the
> valid blocks in the segment. The less the valid blocks, the higher
> the efficiency. The ideal victim segment is the one that has the
> most garbage blocks.
> 
> Currently, it searches up to 20 dirty segments for a victim segment.
> The selected victim is not likely the best victim for gc when there
> are much more dirty segments. Why not searching more dirty segments
> for a better victim? The cost of searching dirty segments is
> negligible in comparison to moving blocks.
> 
> In this patch, it does not search a constant number of dirty segments
> anymore, instead it calculates the number based on the total segments,
> dirty segments and a threshold. Following is the pseudo formula.
> 		,-- nr_dirty_segments, if total_segments < threshold
> (# of search) = |
> 		`-- (nr_dirty_segments * threshold) / total_segments,
>                         Otherwise

Nice catch, but,
I don't understand why we search the # of segments in proportion to the
# of dirty segments.
How about the case where threshold = 10 and total_segments = 100000?
Or threshold = 1000000 and total_segments = 100?
For this, we need to define additional MIN/MAX thresholds and another
handling codes as your proposal.

> 
> The test case is simple. It creates as many files until the disk full.
> The size for each file is 32KB. Then it writes as many as 100000
> records of 4KB size to random offsets of random files in sync mode.
> The testing was done on a 2GB partition of a SDHC card. Let's see the
> test result of f2fs without and with the patch.

It seems that we can obtain the performance gain just by setting the
MAX_VICTIM_SEARCH to 4096, for example.
So, how about just adding an ending criteria like below?

[snip]

> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 35f9b1a..4e045e6 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -138,10 +138,12 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
>  	if (p->alloc_mode == SSR) {
>  		p->gc_mode = GC_GREEDY;
>  		p->dirty_segmap = dirty_i->dirty_segmap[type];
> +		p->dirty_type = type;

		p->max_search = dirty_i->nr_dirty[type];

>  		p->ofs_unit = 1;
>  	} else {
>  		p->gc_mode = select_gc_type(gc_type);
>  		p->dirty_segmap = dirty_i->dirty_segmap[DIRTY];
> +		p->dirty_type = DIRTY;

		p->max_search = dirty_i->nr_dirty[DIRTY];

>  		p->ofs_unit = sbi->segs_per_sec;
>  	}

	if (p->max_search > MAX_VICTIM_SEARCH)
		p->max_search = MAX_VICTIM_SEARCH;

#define MAX_VICTIM_SEARCH 4096 /* covers 8GB */

>  	p->offset = sbi->last_victim[p->gc_mode];
> @@ -243,6 +245,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>  	struct victim_sel_policy p;
>  	unsigned int secno, max_cost;
>  	int nsearched = 0;
> +	unsigned int max_search = MAX_VICTIM_SEARCH;
> +	unsigned int nr_dirty;
>  
>  	p.alloc_mode = alloc_mode;
>  	select_policy(sbi, gc_type, type, &p);
> @@ -258,6 +262,27 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>  			goto got_it;
>  	}
>  
> +	nr_dirty = dirty_i->nr_dirty[p.dirty_type];
> +	if (p.gc_mode == GC_GREEDY && p.alloc_mode != SSR) {
> +		if (TOTAL_SEGS(sbi) <= FULL_VICTIM_SEARCH_THRESH)
> +			max_search = nr_dirty; /* search all the dirty segs */
> +		else {
> +			/*
> +			 * With more dirty segments, garbage blocks are likely
> +			 * more scattered, thus search harder for better
> +			 * victim.
> +			 */
> +			max_search = div_u64 ((nr_dirty *
> +				FULL_VICTIM_SEARCH_THRESH), TOTAL_SEGS(sbi));
> +			if (max_search < MIN_VICTIM_SEARCH_GREEDY)
> +				max_search = MIN_VICTIM_SEARCH_GREEDY;
> +		}
> +	}
> +
> +	/* no more than the total dirty segments */
> +	if (max_search > nr_dirty)
> +		max_search = nr_dirty;
> +
>  	while (1) {
>  		unsigned long cost;
>  		unsigned int segno;
> @@ -290,7 +315,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>  		if (cost == max_cost)
>  			continue;
>  
> -		if (nsearched++ >= MAX_VICTIM_SEARCH) {
> +		if (nsearched++ >= max_search) {

		if (nsearched++ >= p.max_search) {

>  			sbi->last_victim[p.gc_mode] = segno;
>  			break;
>  		}
> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
> index 2c6a6bd..2f525aa 100644
> --- a/fs/f2fs/gc.h
> +++ b/fs/f2fs/gc.h
> @@ -20,7 +20,9 @@
>  #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
>  
>  /* Search max. number of dirty segments to select a victim segment */
> -#define MAX_VICTIM_SEARCH	20
> +#define MAX_VICTIM_SEARCH		20
> +#define MIN_VICTIM_SEARCH_GREEDY	20
> +#define FULL_VICTIM_SEARCH_THRESH	4096
>  
>  struct f2fs_gc_kthread {
>  	struct task_struct *f2fs_gc_task;
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 062424a..cd33f96 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -142,6 +142,7 @@ struct victim_sel_policy {
>  	int alloc_mode;			/* LFS or SSR */
>  	int gc_mode;			/* GC_CB or GC_GREEDY */
>  	unsigned long *dirty_segmap;	/* dirty segment bitmap */
> +	int dirty_type;

	int max_search;		/* maximum # of segments to search */

>  	unsigned int offset;		/* last scanned bitmap offset */
>  	unsigned int ofs_unit;		/* bitmap search unit */
>  	unsigned int min_cost;		/* minimum cost */

-- 
Jaegeuk Kim
Samsung

