Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3LIFUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:20:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29319 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3LIFUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:20:49 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7fd26d000003f7b-6f-52a5532f9b04
Content-transfer-encoding: 8BIT
Message-id: <1386566386.2101.99.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 3/3 V2] f2fs: introduce f2fs_cache_node_page()
 to add page into node_inode cache
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 09 Dec 2013 14:19:46 +0900
In-reply-to: <000901cef484$97536b10$c5fa4130$@samsung.com>
References: <000501cef263$1c57e710$5507b530$@samsung.com>
 <1386545831.2101.67.camel@kjgkr> <000901cef484$97536b10$c5fa4130$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zA1394KVBBrtmylj8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypjeLFiwQ7Fi9nG+
	BsYOqS5GTg4JAROJmzuOsELYYhIX7q1n62Lk4hASWMYo8XdDLwtM0dGLj1khEosYJSZuPAmW
	4BUQlPgx+R6QzcHBLCAvceRSNkiYWUBdYtK8RcwQ9a8YJWYs72GHqNeRuHHwNFivsEChxJk1
	exhBetkEtCU27zcACQsJKEq83X8X7CARASWJX/MXsULMzJSY83oymM0ioCqxeOV3MJtTwEri
	wfubUEd3MUqcfbmcESTBLyAqcXjhdmaIB5Qkdrd3soMUSQgcYpe4tvgdM8QkAYlvkw+BPSAh
	ICux6QBUvaTEwRU3WCYwSsxC8uYshDdnIXlzASPzKkbR1ILkguKk9CJTveLE3OLSvHS95Pzc
	TYyQaJu4g/H+AetDjMlAGycyS4km5wOjNa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGLXP20XrtLZMzPy8fUuK3+uPGiIv9t7Q33AxJdbplKl6
	keTOVa9fdJ4qdwo9GKQwZV/y+iyjtZ922Ac+qtOTqI/n2HvOvq7b6MaVpaYHc596vGZOF9X4
	ee9x2SYH1gMe5SFvPqmWSVhNfSH787batX/JYfoxS3TKb6T9Cf/jdMJs3q8Xk0LfHlViKc5I
	NNRiLipOBABXfZq4zAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV394KVBBmdeiFv8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yY3ixYsEOxYvZxvgbGDqkuRk4OCQETiaMXH7NC2GISF+6tZ+ti5OIQEljE
	KDFx40kWkASvgKDEj8n3gGwODmYBeYkjl7JBwswC6hKT5i1ihqh/xSgxY3kPO0S9jsSNg6fB
	eoUFCiXOrNnDCNLLJqAtsXm/AUhYSEBR4u3+u2B7RQSUJH7NX8QKMTNTYs7ryWA2i4CqxOKV
	38FsTgEriQfvb0Ld1sUocfblckaQBL+AqMThhduZIR5Qktjd3sk+gVFoFpKzZyGcPQvJ2QsY
	mVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfyM6kdjCsbLA4xCnAwKvHwrmBdGiTEmlhW
	XJl7iFGCg1lJhFfpxJIgId6UxMqq1KL8+KLSnNTiQ4zJQJdPZJYSTc4Hppm8knhDYxMzI0sj
	MwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamA0FQm7mPNn1h0Lph07V1m8apnF
	636+46aUSP6BfTzLtzHHnv/e8orFZ+tPz6RDSsenFqosjd9s0J/6gLu2YYZibdgCDcNDX+cV
	5qx5uKK+6FHDrZ+nLRtmsOWeVHBOvZI8xTnrwZwJR9+0aXc877q6NJBZouCpvhq7YKOsX7zx
	LeU99wuPB5xRYinOSDTUYi4qTgQA+ZVlkSkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-09 (월), 10:14 +0800, Chao Yu:
> Hi,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Monday, December 09, 2013 7:37 AM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH 3/3 V2] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> > 
> > 2013-12-06 (금), 17:10 +0800, Chao Yu:
> > > This patch introduces f2fs_cache_node_page(), in this function, page which is
> > > readed ahead will be copy to node_inode's mapping cache.
> > > It will avoid rereading these node pages.
> > >
> > > change log:
> > >  o check validity of grabbed page suggested by Jaegeuk Kim.
> > >
> > > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/node.c |   35 +++++++++++++++++++++++++++++++++++
> > >  1 file changed, 35 insertions(+)
> > >
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 099f06f..3ff98fa 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1600,6 +1600,39 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > >  	return 0;
> > >  }
> > >
> > > +/*
> > > + * f2fs_cache_node_page() copy updated page data to node_inode cache page.
> > > + */
> > > +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> > > +						nid_t nid)
> > > +{
> > > +	struct address_space *mapping = sbi->node_inode->i_mapping;
> > > +	struct page *npage;
> > 
> > 
> > What I meant for the validity was to check the block address to figure
> > out this node page is up-to-date or not.
> > IOW, something like this.
> 
> Yes, you're right.
> 
> So, how about the this one?
> ---
>  fs/f2fs/node.c |   39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 099f06f..3e7a336 100644
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
> +	if (!npage)

	if (unlikely(!npage))

Could you submit a v3?
Thanks,

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

