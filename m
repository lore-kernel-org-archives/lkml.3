Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab3LHXiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 18:38:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9009 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab3LHXiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 18:38:13 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-f3-52a502e42dd0
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1386545831.2101.67.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 3/3 V2] f2fs: introduce f2fs_cache_node_page()
 to add page into node_inode cache
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 09 Dec 2013 08:37:11 +0900
In-reply-to: <000501cef263$1c57e710$5507b530$@samsung.com>
References: <000501cef263$1c57e710$5507b530$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zA90nTEuDDC7/FbX43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH2wC62guMiFV3n
	DrA2ME4V6GLk5JAQMJG4+3UZK4QtJnHh3nq2LkYuDiGBZYwSy1bPZIMp2nViDytEYjqjxL6b
	h9hBErwCghI/Jt9jAbGZBdQlJs1bxAxhi0gcb74JFdeWWLbwNTNE8ytGie59G9ggmnUkzs2f
	wwhiCwsUSmyb28HUxcjBwQbUsHm/AUhYSEBR4u3+u2DXiQgoSfyav4gVYmamxJzXk1lBylkE
	VCU+XOcECXMKWElMnTuBGaLVUuLrinawE/gFRCUOL9zODPGLksTu9k52kHMkBE6xS2y9PIsJ
	JMEiICDxbfIhFpCZEgKyEpsOQNVLShxccYNlAqPkLCQfz0Ly8SwkH89C8vECRpZVjKKpBckF
	xUnpRUZ6xYm5xaV56XrJ+bmbGCER2reD8eYB60OMyUDrJzJLiSbnAyM8ryTe0NjMyMLUxNTY
	yNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwzm1Quu8mIS/wa8W6TVOu
	/OHkW1EqXRvoZ/5MdmF+2J23j4MYljX4cb7VSlKyrjp4IJ1hchGX5Zs1Fxt5Ej33e3xUcmH4
	oFjXtluNoW5pisOsI/tkX/z9YqS72WplTzIX04yQ4wumrdJSutHMGzU75urrfNbpIZoxjVF6
	ky2vV3nLJnZ9dj+ixFKckWioxVxUnAgANES0wOYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQd0nTEuDDJo+Clr8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xY1XSfuWCjSMXmbZNZGhj/83cxcnJICJhI7DqxhxXCFpO4cG89WxcjF4eQ
	wHRGiX03D7GDJHgFBCV+TL7H0sXIwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxgluvdtYIOo15E4
	N38OI4gtLFAosW1uBxNIL5uAtsTm/QYgYSEBRYm3+++C7RURUJL4NX8RK8TMTIk5ryezgpSz
	CKhKfLjOCRLmFLCSmDp3AjNEq6XE1xXtLCA2v4CoxOGF25khzleS2N3eyT6BUWgWkqNnIRw9
	C8nRCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Iz6R2MqxosDjEKcDAq8fDe2LE4
	SIg1say4MvcQowQHs5IIr9KJJUFCvCmJlVWpRfnxRaU5qcWHGJOB7p7ILCWanA9MM3kl8YbG
	JmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwGjKycja3ztvSnJm97L3
	fMZmVdrXOVy8Q6dNm3+v3zloriHH677MP7sOZv5hVmMOfFFlMKf778zUGQUlfIpPGxyLp7XI
	LBIJ3RG26LB/2W3Zja91pn3/uHaG0c85l/YYvop7K5ibUmxx+oux3fvpMaEhC9apSdqmz5qX
	OuHI2gC32a8EXwdUKyuxFGckGmoxFxUnAgCd0fdRKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-06 (금), 17:10 +0800, Chao Yu:
> This patch introduces f2fs_cache_node_page(), in this function, page which is
> readed ahead will be copy to node_inode's mapping cache.
> It will avoid rereading these node pages.
> 
> change log:
>  o check validity of grabbed page suggested by Jaegeuk Kim.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 099f06f..3ff98fa 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1600,6 +1600,39 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
>  	return 0;
>  }
>  
> +/*
> + * f2fs_cache_node_page() copy updated page data to node_inode cache page.
> + */
> +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> +						nid_t nid)
> +{
> +	struct address_space *mapping = sbi->node_inode->i_mapping;
> +	struct page *npage;


What I meant for the validity was to check the block address to figure
out this node page is up-to-date or not.
IOW, something like this.

  get_node_info(sbi, nid, &ni);
 
  if (ni.blk_addr != current block address))
    goto out;

  npage = grab_cache_page(mapping, nid);
  if (unlikely(!npage))
    return;

  if (unlikely(PageUptodate(npage))) {
    f2fs_put_page(npage, 1);
    return;
  }
  memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);

  SetPageUptodate(npage);
  f2fs_put_page(npage, 1);
out:
  return;
 
> +
> +	npage = find_get_page(mapping, nid);
> +	if (unlikely(npage && PageUptodate(npage))) {
> +		f2fs_put_page(npage, 0);
> +		return;
> +	}
> +	f2fs_put_page(npage, 0);
> +
> +	npage = grab_cache_page(mapping, nid);
> +	if (unlikely(!npage))
> +		return;
> +
> +	if (unlikely(PageUptodate(npage))) {
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
> @@ -1633,6 +1666,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  				sum_entry->version = 0;
>  				sum_entry->ofs_in_node = 0;
>  				sum_entry++;
> +				f2fs_cache_node_page(sbi, page,
> +					le32_to_cpu(rn->footer.nid));
>  			} else {
>  				err = -EIO;
>  			}

-- 
Jaegeuk Kim
Samsung

