Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaEZGPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:15:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30136 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaEZGPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:15:22 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-9d-5382dbf7e978
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <005801cf70e7$66cb0090$346101b0$@samsung.com>
 <1400643406.12240.6.camel@kjgkr>
In-reply-to: <1400643406.12240.6.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: avoid crash when trace
 f2fs_submit_page_mbio event in ra_sum_pages
Date: Mon, 26 May 2014 14:14:28 +0800
Message-id: <00cb01cf78a9$de935f40$9bba1dc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJwOG7Gz2CPmbug9iCDoFZDCoNgZwF/NEK3mgTeD2A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQd3vt5uCDX7fNra4vusvk8WT9bOY
	LS4tcrfYs/cki8XlXXPYHFg9Nq3qZPPYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	zF7/jbngoEHFvzlT2BsYW9W6GDk4JARMJDquMXYxcgKZYhIX7q1nA7GFBKYzSqxqE+9i5AKy
	fzBK/OmaCZZgE1CRWN7xnwnEFhFQk+jdN4UJpIhZYBKjxJKfzSwQ3TES//5cZQaxOQV0Jf5f
	38UOYgsLZEnsbr0FZrMIqEqseXwJbDOvgKXE7zsf2CBsQYkfk++BzWEWUJeYNG8RM4StLfHk
	3QVWiEsVJHacfc0IcYSVxJKp06BqxCU2HrnFMoFRaBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgRHwzOpHYwrGywOMQpwMCrx8B7wbgoWYk0sK67MPcQowcGs
	JMJ7IRcoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgZHz
	/mqnrbPv89SWPn2ryjVDaf4OLWfh6+3TRPVeSLd2dF6flxi0IV/vdoJLhKLMzu17y8Km/93U
	dpvb9smyjjNXb86w2nUnX/iXk5nFrOfR1lwz5q2NYVmx/vl6qQ4Rces49rtiLDN4dIOW/JSy
	epOlHRPgrSNy6u/ukGz5SvNHpSmTeL/MjlNiKc5INNRiLipOBABcfPQ6ggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, May 21, 2014 11:37 AM
> To: Chao Yu
> Cc: Jaegeuk Kim; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid crash when trace f2fs_submit_page_mbio event in
> ra_sum_pages
> 
> Hi Chao,
> 
> 2014-05-16 (금), 17:14 +0800, Chao Yu:
> > Previously we allocate pages with no mapping in ra_sum_pages(), so we may
> > encounter a crash in event trace of f2fs_submit_page_mbio where we access
> > mapping data of the page.
> >
> > We'd better allocate pages in bd_inode mapping and invalidate these pages after
> > we restore data from pages. It could avoid crash in above scenario.
> >
> > Call Trace:
> >  [<f1031630>] ? ftrace_raw_event_f2fs_write_checkpoint+0x80/0x80 [f2fs]
> >  [<f10377bb>] f2fs_submit_page_mbio+0x1cb/0x200 [f2fs]
> >  [<f103c5da>] restore_node_summary+0x13a/0x280 [f2fs]
> >  [<f103e22d>] build_curseg+0x2bd/0x620 [f2fs]
> >  [<f104043b>] build_segment_manager+0x1cb/0x920 [f2fs]
> >  [<f1032c85>] f2fs_fill_super+0x535/0x8e0 [f2fs]
> >  [<c115b66a>] mount_bdev+0x16a/0x1a0
> >  [<f102f63f>] f2fs_mount+0x1f/0x30 [f2fs]
> >  [<c115c096>] mount_fs+0x36/0x170
> >  [<c1173635>] vfs_kern_mount+0x55/0xe0
> >  [<c1175388>] do_mount+0x1e8/0x900
> >  [<c1175d72>] SyS_mount+0x82/0xc0
> >  [<c16059cc>] sysenter_do_call+0x12/0x22
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c |   49 ++++++++++++++++++++++++++++---------------------
> >  1 file changed, 28 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 3d60d3d..b5cd814 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1658,13 +1658,16 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> >
> >  /*
> >   * ra_sum_pages() merge contiguous pages into one bio and submit.
> > - * these pre-readed pages are linked in pages list.
> > + * these pre-readed pages are alloced in bd_inode's mapping tree.
> >   */
> > -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
> >  				int start, int nrpages)
> >  {
> >  	struct page *page;
> > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> > +	struct address_space *mapping = inode->i_mapping;
> >  	int page_idx = start;
> > +	int alloced, readed;
> >  	struct f2fs_io_info fio = {
> >  		.type = META,
> >  		.rw = READ_SYNC | REQ_META | REQ_PRIO
> > @@ -1672,21 +1675,23 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head
> *pages,
> >
> >  	for (; page_idx < start + nrpages; page_idx++) {
> >  		/* alloc temporal page for read node summary info*/
> > -		page = alloc_page(GFP_F2FS_ZERO);
> > +		page = grab_cache_page(mapping, page_idx);
> >  		if (!page)
> >  			break;
> > -
> > -		lock_page(page);
> > -		page->index = page_idx;
> > -		list_add_tail(&page->lru, pages);
> > +		page_cache_release(page);
> 
> IMO, we don't need to do like this.
> Instead,
> 	for() {
> 		page = grab_cache_page();
> 		if (!page)
> 			break;
> 		page[page_idx] = page;
> 		f2fs_submit_page_mbio(sbi, page, &fio);
> 	}
> 	f2fs_submit_merged_bio(sbi, META, READ);
> 	return page_idx - start;

Agreed, it helps to remove a lot of redundant code here.
Thanks!

> 
> Afterwards, in restore_node_summry(),
> 	lock_page() will wait the end_io for read.
> 	...
> 	f2fs_put_page(pages[index], 1);
> 
> Thanks,
> 
> >  	}
> >
> > -	list_for_each_entry(page, pages, lru)
> > -		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> > +	alloced = page_idx - start;
> > +	readed = find_get_pages_contig(mapping, start, alloced, pages);
> > +	BUG_ON(alloced != readed);
> > +
> > +	for (page_idx = 0; page_idx < readed; page_idx++)
> > +		f2fs_submit_page_mbio(sbi, pages[page_idx],
> > +					pages[page_idx]->index, &fio);
> >
> >  	f2fs_submit_merged_bio(sbi, META, READ);
> >
> > -	return page_idx - start;
> > +	return readed;
> >  }
> >
> >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > @@ -1694,11 +1699,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  {
> >  	struct f2fs_node *rn;
> >  	struct f2fs_summary *sum_entry;
> > -	struct page *page, *tmp;
> > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> >  	block_t addr;
> >  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > -	int i, last_offset, nrpages, err = 0;
> > -	LIST_HEAD(page_list);
> > +	struct page *pages[bio_blocks];
> > +	int i, index, last_offset, nrpages, err = 0;
> >
> >  	/* scan the node segment */
> >  	last_offset = sbi->blocks_per_seg;
> > @@ -1709,29 +1714,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  		nrpages = min(last_offset - i, bio_blocks);
> >
> >  		/* read ahead node pages */
> > -		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > +		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
> >  		if (!nrpages)
> >  			return -ENOMEM;
> >
> > -		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > +		for (index = 0; index < nrpages; index++) {
> >  			if (err)
> >  				goto skip;
> >
> > -			lock_page(page);
> > -			if (unlikely(!PageUptodate(page))) {
> > +			lock_page(pages[index]);
> > +			if (unlikely(!PageUptodate(pages[index]))) {
> >  				err = -EIO;
> >  			} else {
> > -				rn = F2FS_NODE(page);
> > +				rn = F2FS_NODE(pages[index]);
> >  				sum_entry->nid = rn->footer.nid;
> >  				sum_entry->version = 0;
> >  				sum_entry->ofs_in_node = 0;
> >  				sum_entry++;
> >  			}
> > -			unlock_page(page);
> > +			unlock_page(pages[index]);
> >  skip:
> > -			list_del(&page->lru);
> > -			__free_pages(page, 0);
> > +			page_cache_release(pages[index]);
> >  		}
> > +
> > +		invalidate_mapping_pages(inode->i_mapping, addr,
> > +							addr + nrpages);
> >  	}
> >  	return err;
> >  }
> 
> --
> Jaegeuk Kim

