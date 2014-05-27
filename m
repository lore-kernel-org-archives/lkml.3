Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaE0B0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:26:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61159 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaE0B0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:26:34 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-5a-5383e9c88438
Date: Tue, 27 May 2014 10:25:05 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: avoid crash when trace
 f2fs_submit_page_mbio event in ra_sum_pages
Message-id: <20140527012505.GA4886@cm224.lee>
References: <00f501cf7944$7e8a65d0$7b9f3170$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <00f501cf7944$7e8a65d0$7b9f3170$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t8zA90TL5uDDSZfVbD43/SRzeL6rr9M
	FpcWuVvs2XuSxeLyrjlsDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujCkdAgVz
	dCoW/1jB1MC4R7mLkZNDQsBEouvNUSYIW0ziwr31bF2MXBxCAssYJZad28YKU/Rw8mN2iMQi
	RomVD64wQTg/GSU2vdrM0sXIwcEioCpx+4gzSAObgJZE++m1LCC2iICSxK/5i1hB6pkFJjBK
	/F/0HqxeWCBXouOEHkgNr4CuxL+3a9lAwkIClhIfnxVBhAUlfky+BzaGGWjk+p3HmSBsaYlH
	f2ewg5RzClhJvL9kChIWFVCRmHJyG9j9EgKb2CUOnHsGVs8iICDxbfIhsK0SArISmw4wQ7wl
	KXFwxQ2WCYxis5Bsm4Vk2ywk2xYwMq9iFE0tSC4oTkovMtIrTswtLs1L10vOz93ECImjvh2M
	Nw9YH2JMBlo5kVlKNDkfGId5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoFxwd33/GdS0tt9PifmGv67vG33ixv9q4KsjDQy7re5zKvoOzoz9bax
	kMdSkQPT3c4d8WTeMF1n08uYo3eX/0iV9pqVd4R31cr85Yc22cbcyfn/66+VQ+suFq2Yj0t6
	ZVT+yIZ7bk27HHrq/54fWXuPzhNd9TdHK36mReGR9OgMv17VR8WxLUF7lFiKMxINtZiLihMB
	SINTHrkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgO6Jl83BBreXSVv8b/rIZnF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aUDoGCOToVi3+sYGpg3KPcxcjJISFgIvFw8mN2CFtM4sK99Wxd
	jFwcQgKLGCVWPrjCBOH8ZJTY9GozSxcjBweLgKrE7SPOIA1sAloS7afXsoDYIgJKEr/mL2IF
	qWcWmMAo8X/Re7B6YYFciY4TeiA1vAK6Ev/ermUDCQsJWEp8fFYEERaU+DH5HtgYZqCR63ce
	Z4KwpSUe/Z3BDlLOKWAl8f6SKUhYVEBFYsrJbWwTGAVmIemehaR7FpLuBYzMqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGCo/SZ9A7GVQ0WhxgFOBiVeHgn+DYHC7EmlhVX5h5ilOBgVhLh
	3XASKMSbklhZlVqUH19UmpNafIgxGRgUE5mlRJPzgQkkryTe0NjEzMjSyMzCyMTcnDRhJXHe
	g63WgUIC6YklqdmpqQWpRTBbmDg4pRoYN5mmxrUqLdsw+fCqnID1GjOrnpa+nfSI92WN4Tv/
	gJJEE5aNHrP/Cr6yEfkQ0Xx6ekxYtWCRWejzED+xrU844iT+chw1XP79r+/3nZPvnk22T5B/
	fJF/hla0yNnCJzP9LiWf5zUVVtt8+m5oLddXj6sV8scm8+2b9urtjNwtK1cL2960DH7fosRS
	nJFoqMVcVJwIABD2iJwWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Chao

Could you think about following once.
move node_inode in front of build_segment_manager, then use node_inode
instead of bd_inode.

On Tue, May 27, 2014 at 08:41:07AM +0800, Chao Yu wrote:
> Previously we allocate pages with no mapping in ra_sum_pages(), so we may
> encounter a crash in event trace of f2fs_submit_page_mbio where we access
> mapping data of the page.
> 
> We'd better allocate pages in bd_inode mapping and invalidate these pages after
> we restore data from pages. It could avoid crash in above scenario.
> 
> Changes from V1
>  o remove redundant code in ra_sum_pages() suggested by Jaegeuk Kim.
> 
> Call Trace:
>  [<f1031630>] ? ftrace_raw_event_f2fs_write_checkpoint+0x80/0x80 [f2fs]
>  [<f10377bb>] f2fs_submit_page_mbio+0x1cb/0x200 [f2fs]
>  [<f103c5da>] restore_node_summary+0x13a/0x280 [f2fs]
>  [<f103e22d>] build_curseg+0x2bd/0x620 [f2fs]
>  [<f104043b>] build_segment_manager+0x1cb/0x920 [f2fs]
>  [<f1032c85>] f2fs_fill_super+0x535/0x8e0 [f2fs]
>  [<c115b66a>] mount_bdev+0x16a/0x1a0
>  [<f102f63f>] f2fs_mount+0x1f/0x30 [f2fs]
>  [<c115c096>] mount_fs+0x36/0x170
>  [<c1173635>] vfs_kern_mount+0x55/0xe0
>  [<c1175388>] do_mount+0x1e8/0x900
>  [<c1175d72>] SyS_mount+0x82/0xc0
>  [<c16059cc>] sysenter_do_call+0x12/0x22
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |   52 ++++++++++++++++++++++++----------------------------
>  1 file changed, 24 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 3d60d3d..02a59e9 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1658,35 +1658,29 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>  
>  /*
>   * ra_sum_pages() merge contiguous pages into one bio and submit.
> - * these pre-readed pages are linked in pages list.
> + * these pre-readed pages are alloced in bd_inode's mapping tree.
>   */
> -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
>  				int start, int nrpages)
>  {
> -	struct page *page;
> -	int page_idx = start;
> +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> +	struct address_space *mapping = inode->i_mapping;
> +	int i, page_idx = start;
>  	struct f2fs_io_info fio = {
>  		.type = META,
>  		.rw = READ_SYNC | REQ_META | REQ_PRIO
>  	};
>  
> -	for (; page_idx < start + nrpages; page_idx++) {
> -		/* alloc temporal page for read node summary info*/
> -		page = alloc_page(GFP_F2FS_ZERO);
> -		if (!page)
> +	for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
> +		/* alloc page in bd_inode for reading node summary info */
> +		pages[i] = grab_cache_page(mapping, page_idx);
> +		if (!pages[i])
>  			break;
> -
> -		lock_page(page);
> -		page->index = page_idx;
> -		list_add_tail(&page->lru, pages);
> +		f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
>  	}
>  
> -	list_for_each_entry(page, pages, lru)
> -		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> -
>  	f2fs_submit_merged_bio(sbi, META, READ);
> -
> -	return page_idx - start;
> +	return i;
>  }
>  
>  int restore_node_summary(struct f2fs_sb_info *sbi,
> @@ -1694,11 +1688,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  {
>  	struct f2fs_node *rn;
>  	struct f2fs_summary *sum_entry;
> -	struct page *page, *tmp;
> +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
>  	block_t addr;
>  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> -	int i, last_offset, nrpages, err = 0;
> -	LIST_HEAD(page_list);
> +	struct page *pages[bio_blocks];
> +	int i, idx, last_offset, nrpages, err = 0;
>  
>  	/* scan the node segment */
>  	last_offset = sbi->blocks_per_seg;
> @@ -1709,29 +1703,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  		nrpages = min(last_offset - i, bio_blocks);
>  
>  		/* read ahead node pages */
> -		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> +		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
>  		if (!nrpages)
>  			return -ENOMEM;
>  
> -		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> +		for (idx = 0; idx < nrpages; idx++) {
>  			if (err)
>  				goto skip;
>  
> -			lock_page(page);
> -			if (unlikely(!PageUptodate(page))) {
> +			lock_page(pages[idx]);
> +			if (unlikely(!PageUptodate(pages[idx]))) {
>  				err = -EIO;
>  			} else {
> -				rn = F2FS_NODE(page);
> +				rn = F2FS_NODE(pages[idx]);
>  				sum_entry->nid = rn->footer.nid;
>  				sum_entry->version = 0;
>  				sum_entry->ofs_in_node = 0;
>  				sum_entry++;
>  			}
> -			unlock_page(page);
> +			unlock_page(pages[idx]);
>  skip:
> -			list_del(&page->lru);
> -			__free_pages(page, 0);
> +			page_cache_release(pages[idx]);
>  		}
> +
> +		invalidate_mapping_pages(inode->i_mapping, addr,
> +							addr + nrpages);
>  	}
>  	return err;
>  }
> -- 
> 1.7.9.5
> 
> 
> 
> ------------------------------------------------------------------------------
> The best possible search technologies are now affordable for all companies.
> Download your FREE open source Enterprise Search Engine today!
> Our experts will assist you in its installation for $59/mo, no commitment.
> Test it for FREE on our Cloud platform anytime!
> http://pubads.g.doubleclick.net/gampad/clk?id=145328191&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
