Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaE0HWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:22:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26786 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaE0HWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:22:17 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c1-53843d265b82
Date: Tue, 27 May 2014 16:20:48 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: avoid crash when trace
 f2fs_submit_page_mbio event in ra_sum_pages
Message-id: <20140527072048.GC4886@cm224.lee>
References: <00f501cf7944$7e8a65d0$7b9f3170$@samsung.com>
 <20140527012505.GA4886@cm224.lee> <00ff01cf7975$a5f5fd10$f1e1f730$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <00ff01cf7975$a5f5fd10$f1e1f730$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zA11125Zgg1ZTi/9NH9ksru/6y2Rx
	aZG7xZ69J1ksLu+aw+bA6rF7wWcmj74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MrYs/UYe0Gf
	ZcW9ltlMDYzndLoYOTkkBEwkVjScZYewxSQu3FvP1sXIxSEksIxR4uCf7+wwRTcfr2eHSExn
	lJiy4BULhPOTUWLq69ksIFUsAqoSjXuugNlsAloS7afXgtkiAkoSv+YvYgVpYBaYxCix5Gcz
	UIKDQ1ggV6LjhB5IDa+ArsSSiXehNnQzSqxq+cMIkRCU+DH5HtggZqCh63ceZ4KwpSUe/Z0B
	dh6ngJXE3t+HwGpEBVQkppzcxgZx9iZ2iRNtzhDHCUh8m3wIbK+EgKzEpgPMECWSEgdX3GCZ
	wCg2C8m2WUi2zUKybQEj8ypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkGjq38F494D1IcZk
	oJUTmaVEk/OB0ZhXEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhiDZWQjrv6JMzFo5pPm5DAu377212v2VpP+G592uG77veLfBJ/i7fPyldUrfe9/
	uLLwPrtVYerEzXenqV1ZJq53/dbkKalGD/YUGP7WVH4QtoXZOdSxyO4/j97+lWdip55bU2K4
	9/VbmTjWw79+rn1p9ujqoeI24bL9a85btH2oMEv9fmLChaCrSizFGYmGWsxFxYkAHqQ/P7wC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoK6abUuwwfbH5hb/mz6yWVzf9ZfJ
	4tIid4s9e0+yWFzeNYfNgdVj94LPTB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmLFn6zH2gj7Linsts5kaGM/pdDFyckgImEjcfLyeHcIWk7hwbz1b
	FyMXh5DAdEaJKQtesUA4Pxklpr6ezQJSxSKgKtG45wqYzSagJdF+ei2YLSKgJPFr/iJWkAZm
	gUmMEkt+NgMlODiEBXIlOk7ogdTwCuhKLJl4lx1iaDejxKqWP4wQCUGJH5PvgQ1iBhq6fudx
	JghbWuLR3xlg53EKWEns/X0IrEZUQEViysltbBMYBWYhaZ+FpH0WkvYFjMyrGEVTC5ILipPS
	cw31ihNzi0vz0vWS83M3MYLj9ZnUDsaVDRaHGAU4GJV4eCf4NgcLsSaWFVfmHmKU4GBWEuGN
	ZWoJFuJNSaysSi3Kjy8qzUktPsSYDAyOicxSosn5wFSSVxJvaGxiZmRpZGZhZGJuTpqwkjjv
	gVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M27K9j50zef7q/PtFBSFRulULMz7tfLhSSvVA5yf5
	LnmPW+9iVCd/PrxWPa9Gd+9p2ynLPp3w0fKqrHvn83XdlXMrFSd0P8z1Xr7gMIff/Ctzoj8t
	W/ahwPJpXOVRRuP51efvr+B6e/TYqR3f5YKYnOb1muRLbJG0NrLVM9rnyahjolSxvnjiMyWW
	4oxEQy3mouJEAHTAQacbAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:32:57PM +0800, Chao Yu wrote:
> Hi changman,
> 
> > -----Original Message-----
> > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > Sent: Tuesday, May 27, 2014 9:25 AM
> > To: Chao Yu
> > Cc: Jaegeuk Kim; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH v2] f2fs: avoid crash when trace f2fs_submit_page_mbio event
> > in ra_sum_pages
> > 
> > Hi, Chao
> > 
> > Could you think about following once.
> > move node_inode in front of build_segment_manager, then use node_inode
> > instead of bd_inode.
> 
> Jaegeuk and I discussed this solution previously in
> [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> 
> You can see it from this url:
> http://sourceforge.net/p/linux-f2fs/mailman/linux-f2fs-devel/?viewmonth=201312&page=5
> 
> And it seems not easy to change order of build_*_manager and make node_inode,
> because there are dependency between them.
> 

Sorry to make a mess your patch thread.
I've understood it. In your patch, using NAT journal seems to be
possible. Anyway, thanks for your answer.

> > 
> > On Tue, May 27, 2014 at 08:41:07AM +0800, Chao Yu wrote:
> > > Previously we allocate pages with no mapping in ra_sum_pages(), so we may
> > > encounter a crash in event trace of f2fs_submit_page_mbio where we access
> > > mapping data of the page.
> > >
> > > We'd better allocate pages in bd_inode mapping and invalidate these pages after
> > > we restore data from pages. It could avoid crash in above scenario.
> > >
> > > Changes from V1
> > >  o remove redundant code in ra_sum_pages() suggested by Jaegeuk Kim.
> > >
> > > Call Trace:
> > >  [<f1031630>] ? ftrace_raw_event_f2fs_write_checkpoint+0x80/0x80 [f2fs]
> > >  [<f10377bb>] f2fs_submit_page_mbio+0x1cb/0x200 [f2fs]
> > >  [<f103c5da>] restore_node_summary+0x13a/0x280 [f2fs]
> > >  [<f103e22d>] build_curseg+0x2bd/0x620 [f2fs]
> > >  [<f104043b>] build_segment_manager+0x1cb/0x920 [f2fs]
> > >  [<f1032c85>] f2fs_fill_super+0x535/0x8e0 [f2fs]
> > >  [<c115b66a>] mount_bdev+0x16a/0x1a0
> > >  [<f102f63f>] f2fs_mount+0x1f/0x30 [f2fs]
> > >  [<c115c096>] mount_fs+0x36/0x170
> > >  [<c1173635>] vfs_kern_mount+0x55/0xe0
> > >  [<c1175388>] do_mount+0x1e8/0x900
> > >  [<c1175d72>] SyS_mount+0x82/0xc0
> > >  [<c16059cc>] sysenter_do_call+0x12/0x22
> > >
> > > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/node.c |   52 ++++++++++++++++++++++++----------------------------
> > >  1 file changed, 24 insertions(+), 28 deletions(-)
> > >
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 3d60d3d..02a59e9 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1658,35 +1658,29 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> > >
> > >  /*
> > >   * ra_sum_pages() merge contiguous pages into one bio and submit.
> > > - * these pre-readed pages are linked in pages list.
> > > + * these pre-readed pages are alloced in bd_inode's mapping tree.
> > >   */
> > > -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
> > >  				int start, int nrpages)
> > >  {
> > > -	struct page *page;
> > > -	int page_idx = start;
> > > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> > > +	struct address_space *mapping = inode->i_mapping;
> > > +	int i, page_idx = start;
> > >  	struct f2fs_io_info fio = {
> > >  		.type = META,
> > >  		.rw = READ_SYNC | REQ_META | REQ_PRIO
> > >  	};
> > >
> > > -	for (; page_idx < start + nrpages; page_idx++) {
> > > -		/* alloc temporal page for read node summary info*/
> > > -		page = alloc_page(GFP_F2FS_ZERO);
> > > -		if (!page)
> > > +	for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
> > > +		/* alloc page in bd_inode for reading node summary info */
> > > +		pages[i] = grab_cache_page(mapping, page_idx);
> > > +		if (!pages[i])
> > >  			break;
> > > -
> > > -		lock_page(page);
> > > -		page->index = page_idx;
> > > -		list_add_tail(&page->lru, pages);
> > > +		f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
> > >  	}
> > >
> > > -	list_for_each_entry(page, pages, lru)
> > > -		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> > > -
> > >  	f2fs_submit_merged_bio(sbi, META, READ);
> > > -
> > > -	return page_idx - start;
> > > +	return i;
> > >  }
> > >
> > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > > @@ -1694,11 +1688,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  {
> > >  	struct f2fs_node *rn;
> > >  	struct f2fs_summary *sum_entry;
> > > -	struct page *page, *tmp;
> > > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> > >  	block_t addr;
> > >  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > > -	int i, last_offset, nrpages, err = 0;
> > > -	LIST_HEAD(page_list);
> > > +	struct page *pages[bio_blocks];
> > > +	int i, idx, last_offset, nrpages, err = 0;
> > >
> > >  	/* scan the node segment */
> > >  	last_offset = sbi->blocks_per_seg;
> > > @@ -1709,29 +1703,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  		nrpages = min(last_offset - i, bio_blocks);
> > >
> > >  		/* read ahead node pages */
> > > -		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > +		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
> > >  		if (!nrpages)
> > >  			return -ENOMEM;
> > >
> > > -		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > > +		for (idx = 0; idx < nrpages; idx++) {
> > >  			if (err)
> > >  				goto skip;
> > >
> > > -			lock_page(page);
> > > -			if (unlikely(!PageUptodate(page))) {
> > > +			lock_page(pages[idx]);
> > > +			if (unlikely(!PageUptodate(pages[idx]))) {
> > >  				err = -EIO;
> > >  			} else {
> > > -				rn = F2FS_NODE(page);
> > > +				rn = F2FS_NODE(pages[idx]);
> > >  				sum_entry->nid = rn->footer.nid;
> > >  				sum_entry->version = 0;
> > >  				sum_entry->ofs_in_node = 0;
> > >  				sum_entry++;
> > >  			}
> > > -			unlock_page(page);
> > > +			unlock_page(pages[idx]);
> > >  skip:
> > > -			list_del(&page->lru);
> > > -			__free_pages(page, 0);
> > > +			page_cache_release(pages[idx]);
> > >  		}
> > > +
> > > +		invalidate_mapping_pages(inode->i_mapping, addr,
> > > +							addr + nrpages);
> > >  	}
> > >  	return err;
> > >  }
> > > --
> > > 1.7.9.5
> > >
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > The best possible search technologies are now affordable for all companies.
> > > Download your FREE open source Enterprise Search Engine today!
> > > Our experts will assist you in its installation for $59/mo, no commitment.
> > > Test it for FREE on our Cloud platform anytime!
> > > http://pubads.g.doubleclick.net/gampad/clk?id=145328191&iu=/4140/ostg.clktrk
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
