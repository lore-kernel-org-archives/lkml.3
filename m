Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3KSDTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:19:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9898 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3KSDTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:19:08 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-18-528ad8aa4a96
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1384831096.26319.25.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: split sbi->write_mutex for DATA/NODE/META
 to avoid unnecessary race
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Tue, 19 Nov 2013 12:18:16 +0900
In-reply-to: <001201cee4c8$de450360$9acf0a20$@samsung.com>
References: <001201cee4c8$de450360$9acf0a20$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zfd1VN7qCDN7eN7P43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxtXXJ9kL
	jopVPNg9lb2BcYNQFyMnh4SAicTvKzdZIGwxiQv31rN1MXJxCAksY5Q4+fwcC0zRlG0tTBCJ
	6YwStw/uYANJ8AoISvyYfA+siFlAXWLSvEXMELaIxKHvZ1ghbG2JZQtfM0M0v2KUmHrsDiNE
	s67EjJ77YLawQLbE/MuvgGwODjaghs37DUDCQgKKEm/33wWbIyKgJPFr/iJWkDnMAgsZJQ4u
	uAl2BIuAqsS0bx/AjuAUsJLYdOUYE0SzpcTnc+vYQWx+AVGJwwu3M0N8oySxu72THWSQhMAl
	domGZVtYIAYJSHybfIgF5AgJAVmJTQeg6iUlDq64wTKBUXIWkp9nIfl5FpKfZyH5eQEjyypG
	0dSC5ILipPQiE73ixNzi0rx0veT83E2MkHidsIPx3gHrQ4zJQOsnMkuJJucD4z2vJN7Q2MzI
	wtTE1NjI3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiXPLvjlRPk/+Xl
	rF9HL/188JQ398ld+/K/9itNxJfVd5ZetXSQsZ3Q1832Iajz76MzsTH9Rz8qaosu9jpxeY1p
	49f8JKPcKsav7Ylsd1nyrLICZqlM9XcN4ap8Zszteu7Ukw93M8ykblkdnCWgGrXmBnvJUtdZ
	Ug21jOm7Npw9xfn40p4n/+8qsRRnJBpqMRcVJwIA4ux7OO0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd1VN7qCDHa1Gln8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMaN/3Xv2gt1iFdeuiTYwLhPqYuTkkBAwkZiyrYUJwhaTuHBvPVsX
	IxeHkMB0RonbB3ewgSR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ9a8YJaYeu8MI
	Ua8rMaPnPpgtLJAtMf/yK0aQXjYBbYnN+w1AwkICihJv999lBbFFBJQkfs1fxAoyh1lgIaPE
	wQU3wfayCKhKTPv2gQXE5hSwkth05RgTRLOlxOdz69hBbH4BUYnDC7czQzygJLG7vZN9AqPQ
	LCRnz0I4exaSsxcwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7rZ1I7GFc2WBxiFOBg
	VOLhneDeFSTEmlhWXJl7iFGCg1lJhFfyClCINyWxsiq1KD++qDQntfgQYzLQ4ROZpUST84Ep
	J68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGJlO2d460Jld
	lHbqhcbcg3OX/pVa+knOYeashWtUDuTIbptVIrk96eEBltb6yRXJBj/2V5itC7x/5N6LqtMc
	YTZaAm2SedozHk/jvBu/WG3+ZrV573TqlvB6fFl0pP50J/faDm1R/5fPPdOmes89c1td7G2v
	1O2OyFK2ZN9qu+ANd+Qfx60JP6bEUpyRaKjFXFScCADVZ2/+LwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-19 (화), 09:43 +0800, Chao Yu:
> All DATA/NODE/META bio buffers in superblock is protected by 
> 'sbi->write_mutex', but each bio buffer area is independent, So we 
> should split write_mutex to three for DATA/NODE/META.

Agreed, one comment below though.
Anyway I'll send v2.
Thanks, :)

> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/f2fs.h    |    2 +-
>  fs/f2fs/segment.c |    8 ++++----
>  fs/f2fs/super.c   |    4 +++-
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 2df1e61..1c67521 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -362,7 +362,7 @@ struct f2fs_sb_info {
>  	struct f2fs_sm_info *sm_info;		/* segment manager */
>  	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
>  	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
> -	struct mutex write_mutex;		/* mutex for writing IOs */
> +	struct mutex write_mutex[NR_PAGE_TYPE];	/* mutex for writing IOs */
>  
>  	/* for checkpoint */
>  	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 556965f..a36713ae 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -661,9 +661,9 @@ void f2fs_submit_bio(struct f2fs_sb_info *sbi, enum
> page_type type, bool sync)
>  	if (!sbi->bio[btype])
>  		return;
>  
> -	mutex_lock(&sbi->write_mutex);
> +	mutex_lock(&sbi->write_mutex[type]);

btype instead of type.

>  	do_submit_bio(sbi, type, sync);
> -	mutex_unlock(&sbi->write_mutex);
> +	mutex_unlock(&sbi->write_mutex[type]);
>  }
>  
>  static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
> @@ -674,7 +674,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi,
> struct page *page,
>  
>  	verify_block_addr(sbi, blk_addr);
>  
> -	mutex_lock(&sbi->write_mutex);
> +	mutex_lock(&sbi->write_mutex[type]);
>  
>  	inc_page_count(sbi, F2FS_WRITEBACK);
>  
> @@ -709,7 +709,7 @@ retry:
>  
>  	sbi->last_block_in_bio[type] = blk_addr;
>  
> -	mutex_unlock(&sbi->write_mutex);
> +	mutex_unlock(&sbi->write_mutex[type]);
>  	trace_f2fs_submit_write_page(page, blk_addr, type);
>  }
>  
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index f56941c..6928c0a 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -874,7 +874,9 @@ static int f2fs_fill_super(struct super_block *sb, void
> *data, int silent)
>  	mutex_init(&sbi->node_write);
>  	sbi->por_doing = false;
>  	spin_lock_init(&sbi->stat_lock);
> -	mutex_init(&sbi->write_mutex);
> +	mutex_init(&sbi->write_mutex[DATA]);
> +	mutex_init(&sbi->write_mutex[NODE]);
> +	mutex_init(&sbi->write_mutex[META]);
>  	init_rwsem(&sbi->cp_rwsem);
>  	init_waitqueue_head(&sbi->cp_wait);
>  	init_sb_info(sbi);

-- 
Jaegeuk Kim
Samsung

