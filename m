Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab3K1De1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:34:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24276 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3K1DeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:34:24 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f7e6d00000477d-c7-5296b9bfd843
Content-transfer-encoding: 8BIT
Message-id: <1385609608.2417.38.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for
 restore_node_summary
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Thu, 28 Nov 2013 12:33:28 +0900
In-reply-to: <003001ceebd9$07157380$15405a80$@samsung.com>
References: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
 <1385530195.2417.22.camel@kjgkr> <002f01ceeb46$8758b9a0$960a2ce0$@samsung.com>
 <1385540365.2417.28.camel@kjgkr> <003001ceebd9$07157380$15405a80$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI939O6cFGWx4bmTxv+kjm8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujI5tq9kL
	vlpUXLr4hqmB8a5mFyMnh4SAicTEvcsZIWwxiQv31rN1MXJxCAksY5T4++cDK0xR6/wzrBCJ
	6YwSF/smgnXwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5gh6l8xSpxe9IsFol5HYl/X
	WbChwgLREu8e9bCD9LIJaEts3m8AEhYSUJR4u/8uWImIgJLEr/mLwPYyCyxnlHg++RzYHBYB
	VYlrx2YygdicAlYSb6YsY4RYdptR4sOxq2DH8QuIShxeuJ0Z4gMlid3tnewgRRICl9glWne2
	s0FMEpD4NvkQ2AcSArISmw5A1UtKHFxxg2UCo8QsJH/OQvhzFpI/FzAyr2IUTS1ILihOSi8y
	0itOzC0uzUvXS87P3cQIib6+HYw3D1gfYkwG2jiRWUo0OR8YvXkl8YbGZkYWpiamxkbmlmak
	CSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZF94qo/6nYvuWqmF1r8i5HfWp3y
	KVY4N/NVWalUjkryv72ap18ssnjV2bZws82FPed/zun5c8hnd1CGMNdJxqADPe272V1aztl6
	OOz7ajVru2iuqWCuUG3Bg1jppStT+eun7ciNPOPMcm3ulmPOlxcWb32dqd5xRvvqg2ebSqdu
	nqXyNamlZL4SS3FGoqEWc1FxIgB5Jyas1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd39O6cFGWxu1bX43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY0bHttXsBV8tKi5dfMPUwHhXs4uRk0NCwESidf4ZVghbTOLCvfVs
	XYxcHEIC0xklLvZNZARJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuYIepfMUqcXvSL
	BaJeR2Jf11mwocIC0RLvHvWwg/SyCWhLbN5vABIWElCUeLv/LliJiICSxK/5i1hB5jALLGeU
	eD75HNgcFgFViWvHZjKB2JwCVhJvpixjhFh2m1Hiw7GrYMfxC4hKHF64nRniAyWJ3e2d7BMY
	hWYhuXsWwt2zkNy9gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwbD+T2sG4ssHiEKMA
	B6MSD6+EzrQgIdbEsuLK3EOMEhzMSiK8CsVAId6UxMqq1KL8+KLSnNTiQ4zJQJdPZJYSTc4H
	pp28knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamD0WMdfJ/8x
	w3uF5tHIjz8+5ZWrmy24kmT+Yrmme8nuoqKeM0LRJ5UuVVXxrEpetdDrrmLa8f2rt78JXcJv
	Ljf5yJ6V2+Vu19RF/l6+our83RcHnmglBXZG8J9LuuIhbjD1bv/2AgeJy4urN1tUX75y+Wk1
	s6N1udSqeY+kuVVfLZd5WeW9jeu8EktxRqKhFnNRcSIA7+1J4DEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-28 (목), 09:26 +0800, Chao Yu:
> Hi Kim,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Wednesday, November 27, 2013 4:19 PM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; '谭姝'
> > Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> > 
> > Hi,
> > 
> > 2013-11-27 (수), 15:58 +0800, Chao Yu:
> > > Hi Kim,
> > >
> > > > -----Original Message-----
> > > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > > Sent: Wednesday, November 27, 2013 1:30 PM
> > > > To: Chao Yu
> > > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > > > Subject: Re: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> > > >
> > > > Hi Chao,
> > > >
> > > > It seems that we already have a readahed function for node pages,
> > > > ra_node_page().
> > > > So, we don't make a page list for this, but can use the node_inode's
> > > > page cache.
> > >
> > > So you mean it's waste to release page list with updated data after we
> > > finish work in restore_node_summary, right?
> > 
> > Right.
> 
> So how about add all pages of page list to node_inode's address space by
> add_to_page_cache_lru() with arg sum_entry->nid?

I don't think it's proper way to use add_to_page_cache_lru() directly.

> 
> > 
> > >
> > > >
> > > > So how about writing ra_node_pages() which use the node_inode's page
> > > > cache?
> > >
> > > Hmm, so ra_node_pages is introduced for read node_inode's pages which are
> > > logical contiguously? and it also could take place of ra_node_page?
> > 
> > Ah. The ra_node_page() read a node page ahead for a given node id.
> > So it doesn't match exactly between ra_node_page() and ra_node_pages()
> > that I suggested.
> > So how about reading node pages and then caching some of them in the
> > page cache, node_inode's address space?
> 
> Got it,
> If we do not use the method above, we should search the NAT for nid number
> as the index of node_inode's page by the specified node page blkaddr, that costs
> a lot.
> How do you think?

1. grab_cache_page(node_footer->nid);
2. memcpy();
3. SetPageUptodate();
4. f2fs_put_page();

Thanks,

> 
> > 
> > Thanks,
> > 
> > >
> > >
> > > >
> > > > Thanks,
> > > >
> > > > 2013-11-22 (금), 15:48 +0800, Chao Yu:
> > > > > If cp has no CP_UMOUNT_FLAG, we will read all pages in whole node segment
> > > > > one by one, it makes low performance. So let's merge contiguous pages and
> > > > > readahead for better performance.
> > > > >
> > > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > > ---
> > > > >  fs/f2fs/node.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
> > > > >  1 file changed, 63 insertions(+), 26 deletions(-)
> > > > >
> > > > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > > > index 4ac4150..81e704a 100644
> > > > > --- a/fs/f2fs/node.c
> > > > > +++ b/fs/f2fs/node.c
> > > > > @@ -1572,47 +1572,84 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> > > > >  	return 0;
> > > > >  }
> > > > >
> > > > > +/*
> > > > > + * ra_sum_pages() merge contiguous pages into one bio and submit.
> > > > > + * these pre-readed pages are linked in pages list.
> > > > > + */
> > > > > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > > > > +				int start, int nrpages)
> > > > > +{
> > > > > +	struct page *page;
> > > > > +	int page_idx = start;
> > > > > +
> > > > > +	for (; page_idx < start + nrpages; page_idx++) {
> > > > > +		/* alloc temporal page for read node summary info*/
> > > > > +		page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > > > +		if (!page) {
> > > > > +			struct page *tmp;
> > > > > +			list_for_each_entry_safe(page, tmp, pages, lru) {
> > > > > +				list_del(&page->lru);
> > > > > +				unlock_page(page);
> > > > > +				__free_pages(page, 0);
> > > > > +			}
> > > > > +			return -ENOMEM;
> > > > > +		}
> > > > > +
> > > > > +		lock_page(page);
> > > > > +		page->index = page_idx;
> > > > > +		list_add_tail(&page->lru, pages);
> > > > > +	}
> > > > > +
> > > > > +	list_for_each_entry(page, pages, lru)
> > > > > +		submit_read_page(sbi, page, page->index, READ_SYNC);
> > > > > +
> > > > > +	f2fs_submit_read_bio(sbi, READ_SYNC);
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > > > >  			unsigned int segno, struct f2fs_summary_block *sum)
> > > > >  {
> > > > >  	struct f2fs_node *rn;
> > > > >  	struct f2fs_summary *sum_entry;
> > > > > -	struct page *page;
> > > > > +	struct page *page, *tmp;
> > > > >  	block_t addr;
> > > > > -	int i, last_offset;
> > > > > -
> > > > > -	/* alloc temporal page for read node */
> > > > > -	page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > > > -	if (!page)
> > > > > -		return -ENOMEM;
> > > > > -	lock_page(page);
> > > > > +	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > > > > +	int i, last_offset, nrpages, err = 0;
> > > > > +	LIST_HEAD(page_list);
> > > > >
> > > > >  	/* scan the node segment */
> > > > >  	last_offset = sbi->blocks_per_seg;
> > > > >  	addr = START_BLOCK(sbi, segno);
> > > > >  	sum_entry = &sum->entries[0];
> > > > >
> > > > > -	for (i = 0; i < last_offset; i++, sum_entry++) {
> > > > > -		/*
> > > > > -		 * In order to read next node page,
> > > > > -		 * we must clear PageUptodate flag.
> > > > > -		 */
> > > > > -		ClearPageUptodate(page);
> > > > > +	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
> > > > >
> > > > > -		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
> > > > > -			goto out;
> > > > > +		nrpages = min(last_offset - i, bio_blocks);
> > > > > +		/* read ahead node pages */
> > > > > +		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > > > +		if (err)
> > > > > +			return err;
> > > > >
> > > > > -		lock_page(page);
> > > > > -		rn = F2FS_NODE(page);
> > > > > -		sum_entry->nid = rn->footer.nid;
> > > > > -		sum_entry->version = 0;
> > > > > -		sum_entry->ofs_in_node = 0;
> > > > > -		addr++;
> > > > > +		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > > > > +
> > > > > +			lock_page(page);
> > > > > +			if(PageUptodate(page)) {
> > > > > +				rn = F2FS_NODE(page);
> > > > > +				sum_entry->nid = rn->footer.nid;
> > > > > +				sum_entry->version = 0;
> > > > > +				sum_entry->ofs_in_node = 0;
> > > > > +				sum_entry++;
> > > > > +			} else {
> > > > > +				err = -EIO;
> > > > > +			}
> > > > > +
> > > > > +			list_del(&page->lru);
> > > > > +			unlock_page(page);
> > > > > +			__free_pages(page, 0);
> > > > > +		}
> > > > >  	}
> > > > > -	unlock_page(page);
> > > > > -out:
> > > > > -	__free_pages(page, 0);
> > > > > -	return 0;
> > > > > +	return err;
> > > > >  }
> > > > >
> > > > >  static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
> > > >
> > > > --
> > > > Jaegeuk Kim
> > > > Samsung
> > >
> > 
> > --
> > Jaegeuk Kim
> > Samsung
> 

-- 
Jaegeuk Kim
Samsung

