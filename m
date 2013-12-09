Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736Ab3LIICI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:02:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47853 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3LIICD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:02:03 -0500
X-AuditID: cbfee690-b7f676d00000310d-09-52a578f68c61
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1386576057.2101.106.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page()
 to add page into node_inode cache
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 09 Dec 2013 17:00:57 +0900
In-reply-to: <000a01cef4a0$9f2d64a0$dd882de0$@samsung.com>
References: <000a01cef4a0$9f2d64a0$dd882de0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zfd1vFUuDDHZ1Wlj8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytjWs5W9YLJUxdwF
	t1gbGA+KdDFycEgImEgcO23YxcgJZIpJXLi3nq2LkYtDSGAZo8Si369YIBImEg/7/zBBJBYx
	Sky5MZkVJMErICjxY/I9sCJmAXWJSfMWMUPYIhLvmqdA2doSyxa+ZoZofsUoMXnzJjaIZl2J
	Wetes4PYwgKFEmt2v2UGuYgNqGHzfgOQsJCAosTb/XfBdokIKEn8mr+IFWJmpsSc1xA3sAio
	Shw6sgRsF6eAlcTxddtZIXotJfZv3s8EYvMLiEocXridGeIZJYnd7Z3sIPdICBxjl7jQcpIZ
	YpCAxLfJh1ggoSIrsekAVL2kxMEVN1gmMErOQvLyLCQvz0Ly8iwkLy9gZFnFKJpakFxQnJRe
	ZKJXnJhbXJqXrpecn7uJERKhE3Yw3jtgfYgxGWj9RGYp0eR8YITnlcQbGpsZWZiamBobmVua
	kSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjJaPckefu19ymT3DI/33L6tC5
	WL/3N+R8//x88OvGnxdSNmK/TuVHvj80pWPrqbhGqeTovl8Fy5Zu/cajduFBd+yz1HOWVUky
	37iOVLktT1ttMb9+J2PZ95uhMTeDmeYXtbVwHxDmq+ZmFZ1uMDdejT+97U7ml/eT0nRqJs24
	mb5B/qyOb0W0EktxRqKhFnNRcSIAmdv9Y+YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd1vFUuDDDZeNbb43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix4Pc61oLfkhVHnpxga2BcKdLFyMkhIWAi8bD/DxOELSZx4d56ti5GLg4h
	gUWMElNuTGYFSfAKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmLmCHqXzFKTN68iQ2iXldi
	1rrX7CC2sEChxJrdb5lBetkEtCU27zcACQsJKEq83X8XbLyIgJLEr/mLWCFmZkrMeQ2xlkVA
	VeLQkSXMIDangJXE8XXbWSF6LSX2b94PdjO/gKjE4YXbmSHuV5LY3d7JPoFRaBaSq2chXD0L
	ydULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH8zOpHYwrGywOMQpwMCrx8K5gXRok
	xJpYVlyZe4hRgoNZSYTXPAooxJuSWFmVWpQfX1Sak1p8iDEZ6PCJzFKiyfnARJNXEm9obGJm
	ZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzGE0yD/j5/ImG+7k7Ni7KG
	quaC0hf/y5+9+P2ujIf9ZwR32qP26q3TlH/NfaJ8oyi/rl95PmPPt9RNiqubvrg2TWdtWPmf
	WXL+73cOKZvf6fvd/6vjM/3enmXbQ/4dE1EQC0s4GSE69WniNM53odLLSjN/zfvhnXTi8cZQ
	gRDXM0afvl3wlX+kxFKckWioxVxUnAgA5bvPCyoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the noise.
Once I tested this patch, I recognized that I made a mistake:

f2fs_fill_super()
 1. build_segment_manager()
    -> restore_node_summary()
       -> NULL pointer exception, due to no NAT cache.
 2. build_node_manager()

So, we should not call get_node_info() prior to build_node_manager().
And, it's not easy to change the order of build_*_manager simply.

Let's consider in more details.
Thanks,

2013-12-09 (월), 13:35 +0800, Chao Yu:
> This patch introduces f2fs_cache_node_page(), in this function, page which is
> readed ahead will be copy to node_inode's mapping cache.
> It will avoid rereading these node pages.
> 
> change log:
>  o check validity of page by searching NAT suggested by Jaegeuk Kim.
>  o add 'unlikely' for compiler optimization suggested by Jaegeuk Kim.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |   39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 099f06f..4c6da98 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1600,13 +1600,46 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
>  	return 0;
>  }
>  
> +/*
> + * f2fs_cache_node_page() check validaty of input page by searching NAT.
> + * Then, it will copy updated data of vaild page to node_inode cache.
> + */
> +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> +						nid_t nid, block_t blkaddr)
> +{
> +	struct address_space *mapping = sbi->node_inode->i_mapping;
> +	struct page *npage;
> +	struct node_info ni;
> +
> +	get_node_info(sbi, nid, &ni);
> +
> +	if (ni.blk_addr != blkaddr)
> +		return;
> +
> +	npage = grab_cache_page(mapping, nid);
> +	if (unlikely(!npage))
> +		return;
> +
> +	if (PageUptodate(npage)) {
> +		f2fs_put_page(npage, 1);
> +		return;
> +	}
> +
> +	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
> +
> +	SetPageUptodate(npage);
> +	f2fs_put_page(npage, 1);
> +
> +	return;
> +}
> +
>  int restore_node_summary(struct f2fs_sb_info *sbi,
>  			unsigned int segno, struct f2fs_summary_block *sum)
>  {
>  	struct f2fs_node *rn;
>  	struct f2fs_summary *sum_entry;
>  	struct page *page, *tmp;
> -	block_t addr;
> +	block_t addr, blkaddr;
>  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
>  	int i, last_offset, nrpages, err = 0;
>  	LIST_HEAD(page_list);
> @@ -1624,6 +1657,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  		if (err)
>  			return err;
>  
> +		blkaddr = addr;
>  		list_for_each_entry_safe(page, tmp, &page_list, lru) {
>  
>  			lock_page(page);
> @@ -1633,6 +1667,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  				sum_entry->version = 0;
>  				sum_entry->ofs_in_node = 0;
>  				sum_entry++;
> +				f2fs_cache_node_page(sbi, page,
> +					le32_to_cpu(rn->footer.nid), blkaddr);
>  			} else {
>  				err = -EIO;
>  			}
> @@ -1640,6 +1676,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  			list_del(&page->lru);
>  			unlock_page(page);
>  			__free_pages(page, 0);
> +			blkaddr++;
>  		}
>  	}
>  	return err;

-- 
Jaegeuk Kim
Samsung

