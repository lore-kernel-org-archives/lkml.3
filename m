Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3IEEuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:50:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28648 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3IEEuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:50:04 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fe86d0000077a5-04-52280d7b01a7
Content-transfer-encoding: 8BIT
Message-id: <1378356595.2354.90.camel@kjgkr>
Subject: Re: [PATCH] f2fs: optimize gc for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jin Xu <jinuxstyle@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Sep 2013 13:49:55 +0900
In-reply-to: <1378356326-2915-1-git-send-email-jinuxstyle@gmail.com>
References: <1378356326-2915-1-git-send-email-jinuxstyle@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zI91qXo0gg9ddzBY7n5xmtri0yN1i
	z96TLBaXd81hc2Dx2DnrLrvH7gWfmTw+b5ILYI7isklJzcksSy3St0vgyuj+MYm54Kh6xd+9
	lxgbGJ/LdTFyckgImEgc77/BCGGLSVy4t56ti5GLQ0hgGaPEssU7mWGKPh1byAKRWMQocejl
	Y3aQBK+AoMSPyfeAEhwczALyEkcuZYOEmQXUJSbNW8QMUf+aUWL6kZOsEPU6EvP/94H1CgvY
	Svw/NZ8VpJdNQFti834DkLCQgKLE2/13wcIiQPanfdIQIzMl7jXNADuHRUBV4vifH2wgNqeA
	i0T/rJNMEK3OEidW7WMBsfkFRCUOL9wOdb6SxO72TnaQcyQEDrFLdLy4ywIxSEDi2+RDYOdL
	CMhKbDoAVS8pcXDFDZYJjBKzkDw5C+HJWUieXMDIvIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/
	dxMjJNp6dzDePmB9iDEZaONEZinR5HxgtOaVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgZEt/N42G9uucHUGJ4+V3vxbvx879oOxhmNraqOkcEN5
	ukyyolXs52dqGheTcjJvfV+QO8eroZXx94O+B/qXLEPffb86pSbx9B9vmfpvEsfkc3PLX0s+
	VbRudS37clX/KsuMvam5UZz58tdyz/VsnVv5/WX59Z3+6spv7LKbfhwV/2+tZ3DsjBJLcUai
	oRZzUXEiAH/3v9jMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd0qXo0ggw3zrC12PjnNbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jR/WMSc8FR9Yq/ey8xNjA+l+ti5OSQEDCR+HRsIQuELSZx4d56ti5GLg4h
	gUWMEodePmYHSfAKCEr8mHwPqIiDg1lAXuLIpWyQMLOAusSkeYuYIepfM0pMP3KSFaJeR2L+
	/z6wXmEBW4n/p+azgvSyCWhLbN5vABIWElCUeLv/LlhYBMj+tE8aYmSmxL2mGcwgNouAqsTx
	Pz/YQGxOAReJ/lknmSBanSVOrNoHdjK/gKjE4YXbmSHOV5LY3d7JPoFRaBaSo2chHD0LydEL
	GJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH8jOpHYwrGywOMQpwMCrx8DYYqwcJsSaW
	FVfmHmKU4GBWEuG1WAkU4k1JrKxKLcqPLyrNSS0+xJgMdPhEZinR5HxgmskriTc0NjEzsjQy
	szAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkZLz97D5e5uHA+3iUsfK7/52Nmt
	63/wK4+S8hWT9q1z/3Of88xzF5OjNdMthZf/ca/SuvTg45WF968+ubkztu+bcHf3Rwfhem7f
	YJWPZjuz5AMzVTxfTOcM69oyoSzAcYfCXZ3owzNNrCR+9zpJ2P6ynyX7PtjRVPlSAf+8/ob8
	RCOmO4/W8yixFGckGmoxFxUnAgDf5dY9KQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged.
Thank you,

2013-09-05 (목), 12:45 +0800, Jin Xu:
> From: Jin Xu <jinuxstyle@gmail.com>
> 
> This patch improves the gc efficiency by optimizing the victim
> selection policy. With this optimization, the random re-write
> performance could increase up to 20%.
> 
> For f2fs, when disk is in shortage of free spaces, gc will selects
> dirty segments and moves valid blocks around for making more space
> available. The gc cost of a segment is determined by the valid blocks
> in the segment. The less the valid blocks, the higher the efficiency.
> The ideal victim segment is the one that has the most garbage blocks.
> 
> Currently, it searches up to 20 dirty segments for a victim segment.
> The selected victim is not likely the best victim for gc when there
> are much more dirty segments. Why not searching more dirty segments
> for a better victim? The cost of searching dirty segments is
> negligible in comparison to moving blocks.
> 
> In this patch, it enlarges the MAX_VICTIM_SEARCH to 4096 to make
> the search more aggressively for a possible better victim. Since
> it also applies to victim selection for SSR, it will likely improve
> the SSR efficiency as well.
> 
> The test case is simple. It creates as many files until the disk full.
> The size for each file is 32KB. Then it writes as many as 100000
> records of 4KB size to random offsets of random files in sync mode.
> The testing was done on a 2GB partition of a SDHC card. Let's see the
> test result of f2fs without and with the patch.
> 
> ---------------------------------------
> 2GB partition, SDHC
> create 52023 files of size 32768 bytes
> random re-write 100000 records of 4KB
> ---------------------------------------
> | file creation (s) | rewrite time (s) | gc count | gc garbage blocks |
> [no patch]  341         4227             1174          174840
> [patched]   324         2958             645           106682
> 
> It's obvious that, with the patch, f2fs finishes the test in 20+% less
> time than without the patch. And internally it does much less gc with
> higher efficiency than before.
> 
> Since the performance improvement is related to gc, it might not be so
> obvious for other tests that do not trigger gc as often as this one (
> This is because f2fs selects dirty segments for SSR use most of the
> time when free space is in shortage). The well-known iozone test tool
> was not used for benchmarking the patch becuase it seems do not have
> a test case that performs random re-write on a full disk.
> 
> This patch is the revised version based on the suggestion from
> Jaegeuk Kim.
> 
> Signed-off-by: Jin Xu <jinuxstyle@gmail.com>
> [Jaegeuk Kim: suggested simpler solution]
> Reviewed-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/gc.c      |    8 +++++++-
>  fs/f2fs/gc.h      |    2 +-
>  fs/f2fs/segment.h |    1 +
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 35f9b1a..a78b8e3 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -138,12 +138,18 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
>  	if (p->alloc_mode == SSR) {
>  		p->gc_mode = GC_GREEDY;
>  		p->dirty_segmap = dirty_i->dirty_segmap[type];
> +		p->max_search = dirty_i->nr_dirty[type];
>  		p->ofs_unit = 1;
>  	} else {
>  		p->gc_mode = select_gc_type(gc_type);
>  		p->dirty_segmap = dirty_i->dirty_segmap[DIRTY];
> +		p->max_search = dirty_i->nr_dirty[DIRTY];
>  		p->ofs_unit = sbi->segs_per_sec;
>  	}
> +
> +	if (p->max_search > MAX_VICTIM_SEARCH)
> +		p->max_search = MAX_VICTIM_SEARCH;
> +
>  	p->offset = sbi->last_victim[p->gc_mode];
>  }
>  
> @@ -290,7 +296,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>  		if (cost == max_cost)
>  			continue;
>  
> -		if (nsearched++ >= MAX_VICTIM_SEARCH) {
> +		if (nsearched++ >= p.max_search) {
>  			sbi->last_victim[p.gc_mode] = segno;
>  			break;
>  		}
> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
> index 2c6a6bd..f8ee8a8 100644
> --- a/fs/f2fs/gc.h
> +++ b/fs/f2fs/gc.h
> @@ -20,7 +20,7 @@
>  #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
>  
>  /* Search max. number of dirty segments to select a victim segment */
> -#define MAX_VICTIM_SEARCH	20
> +#define MAX_VICTIM_SEARCH 4096 /* covers 8GB */
>  
>  struct f2fs_gc_kthread {
>  	struct task_struct *f2fs_gc_task;
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 062424a..dca6379 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -142,6 +142,7 @@ struct victim_sel_policy {
>  	int alloc_mode;			/* LFS or SSR */
>  	int gc_mode;			/* GC_CB or GC_GREEDY */
>  	unsigned long *dirty_segmap;	/* dirty segment bitmap */
> +	unsigned int max_search;	/* maximum # of segments to search */
>  	unsigned int offset;		/* last scanned bitmap offset */
>  	unsigned int ofs_unit;		/* bitmap search unit */
>  	unsigned int min_cost;		/* minimum cost */

-- 
Jaegeuk Kim
Samsung

