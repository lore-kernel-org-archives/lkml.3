Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3K0IUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:20:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32125 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3K0IUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:20:21 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f7e6d00000477d-04-5295ab430a3c
Content-transfer-encoding: 8BIT
Message-id: <1385540365.2417.28.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for
 restore_node_summary
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Wed, 27 Nov 2013 17:19:25 +0900
In-reply-to: <002f01ceeb46$8758b9a0$960a2ce0$@samsung.com>
References: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
 <1385530195.2417.22.camel@kjgkr> <002f01ceeb46$8758b9a0$960a2ce0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zY13n1VODDN5cM7X43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxs5ZX9gL
	TmtX3PjWy9rAeFmhi5GTQ0LARGLb2knMELaYxIV769m6GLk4hASWMUqcWLmYHaboX9cxVhBb
	SGARo8T0hTYgNq+AoMSPyfdYuhg5OJgF5CWOXMoGCTMLqEtMmreIGWLOK0aJ7QevM0PU60hs
	utbABGILC0RLvHvUww7SyyagLbF5vwHEeEWJt/vvgq0SEVCS+DV/ESvIHGaB5YwSzyefYwFJ
	sAioSsz5PxvM5hSwkpj97CMLxLIuRome7WfBjuYXEJU4vHA71GdKErvbO9lBiiQELrFLXN+7
	BWqSgMS3yYfAPpAQkJXYdACqXlLi4IobLBMYJWYh+XMWwp+zkPy5gJF5FaNoakFyQXFSepGR
	XnFibnFpXrpecn7uJkZI7PXtYLx5wPoQYzLQxonMUqLJ+cDYzSuJNzQ2M7IwNTE1NjK3NCNN
	WEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjB4W1r5NL8u5v4vsTbv4ZcKXzBe5
	Rs82W2tvL4/l3BZ8/eqR67P51vBufNV4qWvZgaO5X04bzghbqHVlV8/qSZZn3JIvq9zanu5w
	LyDrloGF2+/Fp/54NiXvfTzhZbRCVt78T+nu6Qeu7bsjc8VJ2uliUku1T4Tt20XmEruWHVi4
	5tHOPy33OW8psRRnJBpqMRcVJwIAig+P/tMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAV3n1VODDGbcM7D43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bOWV/YC05rV9z41svawHhZoYuRk0NCwETiX9cxVghbTOLCvfVs
	ILaQwCJGiekLbUBsXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxFzFyMXUPkrRontB68z
	Q9TrSGy61sAEYgsLREu8e9TDDtLLJqAtsXm/AcR4RYm3+++CrRURUJL4NX8RK8gcZoHljBLP
	J59jAUmwCKhKzPk/G8zmFLCSmP3sIwvEsi5GiZ7tZ9lBEvwCohKHF25nhnhASWJ3eyf7BEah
	WUjunoVw9ywkdy9gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzZz6R2MK5ssDjEKMDB
	qMTDO+HylCAh1sSy4srcQ4wSHMxKIrw2PVODhHhTEiurUovy44tKc1KLDzEmA10+kVlKNDkf
	mHTySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFRgimZeVLO
	HrXNWvlvy/9Jsva6X3pZ5qT4SPP1zdr+0GsnX94U1V8eru+e/+WE9c9eydgEHUXzhcFqB97+
	Pv78vsDs0t31e6xqf3w8K6dUan2cw0s+qJDTpOu6tZ1f0cIfaTGPnvP+zSnOOK6t8PPX+hf8
	ohIdVcmpfq82rGdOfub0p0daoV6JpTgj0VCLuag4EQBgFgpvMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-27 (수), 15:58 +0800, Chao Yu:
> Hi Kim,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Wednesday, November 27, 2013 1:30 PM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > Subject: Re: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> > 
> > Hi Chao,
> > 
> > It seems that we already have a readahed function for node pages,
> > ra_node_page().
> > So, we don't make a page list for this, but can use the node_inode's
> > page cache.
> 
> So you mean it's waste to release page list with updated data after we
> finish work in restore_node_summary, right?

Right.

> 
> > 
> > So how about writing ra_node_pages() which use the node_inode's page
> > cache?
> 
> Hmm, so ra_node_pages is introduced for read node_inode's pages which are 
> logical contiguously? and it also could take place of ra_node_page?

Ah. The ra_node_page() read a node page ahead for a given node id.
So it doesn't match exactly between ra_node_page() and ra_node_pages()
that I suggested.
So how about reading node pages and then caching some of them in the
page cache, node_inode's address space?

Thanks,

> 
> 
> > 
> > Thanks,
> > 
> > 2013-11-22 (금), 15:48 +0800, Chao Yu:
> > > If cp has no CP_UMOUNT_FLAG, we will read all pages in whole node segment
> > > one by one, it makes low performance. So let's merge contiguous pages and
> > > readahead for better performance.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/node.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
> > >  1 file changed, 63 insertions(+), 26 deletions(-)
> > >
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 4ac4150..81e704a 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1572,47 +1572,84 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> > >  	return 0;
> > >  }
> > >
> > > +/*
> > > + * ra_sum_pages() merge contiguous pages into one bio and submit.
> > > + * these pre-readed pages are linked in pages list.
> > > + */
> > > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > > +				int start, int nrpages)
> > > +{
> > > +	struct page *page;
> > > +	int page_idx = start;
> > > +
> > > +	for (; page_idx < start + nrpages; page_idx++) {
> > > +		/* alloc temporal page for read node summary info*/
> > > +		page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > +		if (!page) {
> > > +			struct page *tmp;
> > > +			list_for_each_entry_safe(page, tmp, pages, lru) {
> > > +				list_del(&page->lru);
> > > +				unlock_page(page);
> > > +				__free_pages(page, 0);
> > > +			}
> > > +			return -ENOMEM;
> > > +		}
> > > +
> > > +		lock_page(page);
> > > +		page->index = page_idx;
> > > +		list_add_tail(&page->lru, pages);
> > > +	}
> > > +
> > > +	list_for_each_entry(page, pages, lru)
> > > +		submit_read_page(sbi, page, page->index, READ_SYNC);
> > > +
> > > +	f2fs_submit_read_bio(sbi, READ_SYNC);
> > > +	return 0;
> > > +}
> > > +
> > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  			unsigned int segno, struct f2fs_summary_block *sum)
> > >  {
> > >  	struct f2fs_node *rn;
> > >  	struct f2fs_summary *sum_entry;
> > > -	struct page *page;
> > > +	struct page *page, *tmp;
> > >  	block_t addr;
> > > -	int i, last_offset;
> > > -
> > > -	/* alloc temporal page for read node */
> > > -	page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > -	if (!page)
> > > -		return -ENOMEM;
> > > -	lock_page(page);
> > > +	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > > +	int i, last_offset, nrpages, err = 0;
> > > +	LIST_HEAD(page_list);
> > >
> > >  	/* scan the node segment */
> > >  	last_offset = sbi->blocks_per_seg;
> > >  	addr = START_BLOCK(sbi, segno);
> > >  	sum_entry = &sum->entries[0];
> > >
> > > -	for (i = 0; i < last_offset; i++, sum_entry++) {
> > > -		/*
> > > -		 * In order to read next node page,
> > > -		 * we must clear PageUptodate flag.
> > > -		 */
> > > -		ClearPageUptodate(page);
> > > +	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
> > >
> > > -		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
> > > -			goto out;
> > > +		nrpages = min(last_offset - i, bio_blocks);
> > > +		/* read ahead node pages */
> > > +		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > +		if (err)
> > > +			return err;
> > >
> > > -		lock_page(page);
> > > -		rn = F2FS_NODE(page);
> > > -		sum_entry->nid = rn->footer.nid;
> > > -		sum_entry->version = 0;
> > > -		sum_entry->ofs_in_node = 0;
> > > -		addr++;
> > > +		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > > +
> > > +			lock_page(page);
> > > +			if(PageUptodate(page)) {
> > > +				rn = F2FS_NODE(page);
> > > +				sum_entry->nid = rn->footer.nid;
> > > +				sum_entry->version = 0;
> > > +				sum_entry->ofs_in_node = 0;
> > > +				sum_entry++;
> > > +			} else {
> > > +				err = -EIO;
> > > +			}
> > > +
> > > +			list_del(&page->lru);
> > > +			unlock_page(page);
> > > +			__free_pages(page, 0);
> > > +		}
> > >  	}
> > > -	unlock_page(page);
> > > -out:
> > > -	__free_pages(page, 0);
> > > -	return 0;
> > > +	return err;
> > >  }
> > >
> > >  static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
> > 
> > --
> > Jaegeuk Kim
> > Samsung
> 

-- 
Jaegeuk Kim
Samsung

