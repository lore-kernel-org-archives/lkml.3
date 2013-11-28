Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3K1F5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 00:57:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33666 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab3K1F5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 00:57:40 -0500
X-AuditID: cbfee61a-b7f316d000007e34-bd-5296db53da3c
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
 <1385530195.2417.22.camel@kjgkr> <002f01ceeb46$8758b9a0$960a2ce0$@samsung.com>
 <1385540365.2417.28.camel@kjgkr> <003001ceebd9$07157380$15405a80$@samsung.com>
 <1385609608.2417.38.camel@kjgkr>
In-reply-to: <1385609608.2417.38.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for
 restore_node_summary
Date: Thu, 28 Nov 2013 13:56:43 +0800
Message-id: <003101ceebfe$bab50890$301f19b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLo/dmhZfpHUVdsz0A5xHDiq3ZS0QHeqe7fAe9aYegCtYwBoQJLzP1jAnAH0cuXq/deUA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd3g29OCDGa+4LG4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujC8ty1kK
	HrlUdL1by97AuMuoi5GTQ0LAROLe9itsELaYxIV764FsLg4hgUWMEu3/X7NAOD8YJVp3rgOr
	YhNQkVje8Z8JxBYRkJaY9WkeWBGzwGxGiZ4vzxhBEkIC/xglfrzWAbE5BXQlbs9oAYsLC0RL
	vHvUww5iswioShz8ehYszitgKdFxeSmULSjxY/I9oKEcQEPVJaZMyQUJMwtoSzx5d4EV4lIF
	iR1nXzNC3BAhMW12FytEjbjExiO3WCYwCs1CMmkWwqRZSCbNQtKxgJFlFaNoakFyQXFSeq6h
	XnFibnFpXrpecn7uJkZwDDyT2sG4ssHiEKMAB6MSD6+EzrQgIdbEsuLK3EOMEhzMSiK8CsVA
	Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYxqZo7xs++t
	PGYqmqb25pk45wn1qk8Rx/+pV+nu8PjO1XjPjOvH74V3AvYunbryvOln598bj2xs09mt8n1S
	dN5hXqEfv7rqX+hlK7xR1l6b3ewR1pKgd3GltbrsMYe26/bGxR9OZaRH/7h6PXfN9+qKfcb6
	e64Inpu/dSnrtF8HAzJv+zN6G7EpsRRnJBpqMRcVJwIARGepj30CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Thursday, November 28, 2013 11:33 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; '谭姝'
> Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> 
> Hi,
> 
> 2013-11-28 (목), 09:26 +0800, Chao Yu:
> > Hi Kim,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Wednesday, November 27, 2013 4:19 PM
> > > To: Chao Yu
> > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; '谭姝'
> > > Subject: RE: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> > >
> > > Hi,
> > >
> > > 2013-11-27 (수), 15:58 +0800, Chao Yu:
> > > > Hi Kim,
> > > >
> > > > > -----Original Message-----
> > > > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > > > Sent: Wednesday, November 27, 2013 1:30 PM
> > > > > To: Chao Yu
> > > > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > > > > Subject: Re: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for restore_node_summary
> > > > >
> > > > > Hi Chao,
> > > > >
> > > > > It seems that we already have a readahed function for node pages,
> > > > > ra_node_page().
> > > > > So, we don't make a page list for this, but can use the node_inode's
> > > > > page cache.
> > > >
> > > > So you mean it's waste to release page list with updated data after we
> > > > finish work in restore_node_summary, right?
> > >
> > > Right.
> >
> > So how about add all pages of page list to node_inode's address space by
> > add_to_page_cache_lru() with arg sum_entry->nid?
> 
> I don't think it's proper way to use add_to_page_cache_lru() directly.

This is the way used in VM readahead(i.e. read_pages/mpage_readpages/
read_cache_pages).
So what you worry about is that using lonely add_to_page_cache_lru()
may cause exception, is it?

> 
> >
> > >
> > > >
> > > > >
> > > > > So how about writing ra_node_pages() which use the node_inode's page
> > > > > cache?
> > > >
> > > > Hmm, so ra_node_pages is introduced for read node_inode's pages which are
> > > > logical contiguously? and it also could take place of ra_node_page?
> > >
> > > Ah. The ra_node_page() read a node page ahead for a given node id.
> > > So it doesn't match exactly between ra_node_page() and ra_node_pages()
> > > that I suggested.
> > > So how about reading node pages and then caching some of them in the
> > > page cache, node_inode's address space?
> >
> > Got it,
> > If we do not use the method above, we should search the NAT for nid number
> > as the index of node_inode's page by the specified node page blkaddr, that costs
> > a lot.
> > How do you think?
> 
> 1. grab_cache_page(node_footer->nid);
> 2. memcpy();
> 3. SetPageUptodate();
> 4. f2fs_put_page();

It could be.

This make ra_node_pages() synchronized, because we should read node_footer->nid
from updated node page before we cache node pages, and we will still use page list to
pass the updated page.

Why not introduce f2fs_cache_node_pages() include your code to cache node pages after
ra_node_pages()?

Thanks,
Yu

> 
> Thanks,
> 
> >
> > >
> > > Thanks,
> > >
> > > >
> > > >
> > > > >
> > > > > Thanks,
> > > > >
> > > > > 2013-11-22 (금), 15:48 +0800, Chao Yu:
> > > > > > If cp has no CP_UMOUNT_FLAG, we will read all pages in whole node segment
> > > > > > one by one, it makes low performance. So let's merge contiguous pages and
> > > > > > readahead for better performance.
> > > > > >
> > > > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > > > ---
> > > > > >  fs/f2fs/node.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
> > > > > >  1 file changed, 63 insertions(+), 26 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > > > > index 4ac4150..81e704a 100644
> > > > > > --- a/fs/f2fs/node.c
> > > > > > +++ b/fs/f2fs/node.c
> > > > > > @@ -1572,47 +1572,84 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> > > > > >  	return 0;
> > > > > >  }
> > > > > >
> > > > > > +/*
> > > > > > + * ra_sum_pages() merge contiguous pages into one bio and submit.
> > > > > > + * these pre-readed pages are linked in pages list.
> > > > > > + */
> > > > > > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > > > > > +				int start, int nrpages)
> > > > > > +{
> > > > > > +	struct page *page;
> > > > > > +	int page_idx = start;
> > > > > > +
> > > > > > +	for (; page_idx < start + nrpages; page_idx++) {
> > > > > > +		/* alloc temporal page for read node summary info*/
> > > > > > +		page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > > > > +		if (!page) {
> > > > > > +			struct page *tmp;
> > > > > > +			list_for_each_entry_safe(page, tmp, pages, lru) {
> > > > > > +				list_del(&page->lru);
> > > > > > +				unlock_page(page);
> > > > > > +				__free_pages(page, 0);
> > > > > > +			}
> > > > > > +			return -ENOMEM;
> > > > > > +		}
> > > > > > +
> > > > > > +		lock_page(page);
> > > > > > +		page->index = page_idx;
> > > > > > +		list_add_tail(&page->lru, pages);
> > > > > > +	}
> > > > > > +
> > > > > > +	list_for_each_entry(page, pages, lru)
> > > > > > +		submit_read_page(sbi, page, page->index, READ_SYNC);
> > > > > > +
> > > > > > +	f2fs_submit_read_bio(sbi, READ_SYNC);
> > > > > > +	return 0;
> > > > > > +}
> > > > > > +
> > > > > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > > > > >  			unsigned int segno, struct f2fs_summary_block *sum)
> > > > > >  {
> > > > > >  	struct f2fs_node *rn;
> > > > > >  	struct f2fs_summary *sum_entry;
> > > > > > -	struct page *page;
> > > > > > +	struct page *page, *tmp;
> > > > > >  	block_t addr;
> > > > > > -	int i, last_offset;
> > > > > > -
> > > > > > -	/* alloc temporal page for read node */
> > > > > > -	page = alloc_page(GFP_NOFS | __GFP_ZERO);
> > > > > > -	if (!page)
> > > > > > -		return -ENOMEM;
> > > > > > -	lock_page(page);
> > > > > > +	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > > > > > +	int i, last_offset, nrpages, err = 0;
> > > > > > +	LIST_HEAD(page_list);
> > > > > >
> > > > > >  	/* scan the node segment */
> > > > > >  	last_offset = sbi->blocks_per_seg;
> > > > > >  	addr = START_BLOCK(sbi, segno);
> > > > > >  	sum_entry = &sum->entries[0];
> > > > > >
> > > > > > -	for (i = 0; i < last_offset; i++, sum_entry++) {
> > > > > > -		/*
> > > > > > -		 * In order to read next node page,
> > > > > > -		 * we must clear PageUptodate flag.
> > > > > > -		 */
> > > > > > -		ClearPageUptodate(page);
> > > > > > +	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
> > > > > >
> > > > > > -		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
> > > > > > -			goto out;
> > > > > > +		nrpages = min(last_offset - i, bio_blocks);
> > > > > > +		/* read ahead node pages */
> > > > > > +		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > > > > +		if (err)
> > > > > > +			return err;
> > > > > >
> > > > > > -		lock_page(page);
> > > > > > -		rn = F2FS_NODE(page);
> > > > > > -		sum_entry->nid = rn->footer.nid;
> > > > > > -		sum_entry->version = 0;
> > > > > > -		sum_entry->ofs_in_node = 0;
> > > > > > -		addr++;
> > > > > > +		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > > > > > +
> > > > > > +			lock_page(page);
> > > > > > +			if(PageUptodate(page)) {
> > > > > > +				rn = F2FS_NODE(page);
> > > > > > +				sum_entry->nid = rn->footer.nid;
> > > > > > +				sum_entry->version = 0;
> > > > > > +				sum_entry->ofs_in_node = 0;
> > > > > > +				sum_entry++;
> > > > > > +			} else {
> > > > > > +				err = -EIO;
> > > > > > +			}
> > > > > > +
> > > > > > +			list_del(&page->lru);
> > > > > > +			unlock_page(page);
> > > > > > +			__free_pages(page, 0);
> > > > > > +		}
> > > > > >  	}
> > > > > > -	unlock_page(page);
> > > > > > -out:
> > > > > > -	__free_pages(page, 0);
> > > > > > -	return 0;
> > > > > > +	return err;
> > > > > >  }
> > > > > >
> > > > > >  static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
> > > > >
> > > > > --
> > > > > Jaegeuk Kim
> > > > > Samsung
> > > >
> > >
> > > --
> > > Jaegeuk Kim
> > > Samsung
> >
> 
> --
> Jaegeuk Kim
> Samsung

