Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaKTGFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:05:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22431 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaKTGFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:05:36 -0500
X-AuditID: cbfee68f-f791c6d000004834-82-546d84a60336
Date: Thu, 20 Nov 2014 15:04:10 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: call flush_dcache_page when the page
	was updated
Message-id: <20141120060410.GB3117@lcm>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2LSobusJTfEYNZEPosn62cxW1xa5G6x
	Z+9JFovLu+awObB4bFrVyeaxe8FnJo/Pm+QCmKO4bFJSczLLUov07RK4MpZfusxc0CZT8aft
	GFsD4yLxLkZODgkBE4npG/6wQNhiEhfurWfrYuTiEBJYyiix9PYqdpiieWcnsUMkFjFKnJ+3
	AarqJ6NEf9sh1i5GDg4WAVWJfwcCQBrYBLQk2k+vBZsqIqAicWjRZbBBzAKZEhP6X4DZwgIx
	EtteXWYGsXkF1CU2N+9mA7GFBBwlpi16zgYRF5T4MfkeC0SvlsT6nceZIGxpiUd/Z4DN4RRw
	kujt38oIYosC7ZpychvYbRICi9glJrX+YAVJsAgISHybfIgF5E4JAVmJTQeYIR6TlDi44gbL
	BEaxWUjWzUKybhaSdQsYmVcxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBMbQ6X/P+ncw3j1g
	fYhRgINRiYeXwyw3RIg1say4MvcQoynQFROZpUST84GRmlcSb2hsZmRhamJqbGRuaaYkzrtQ
	6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZZca9T//zERO0e9bWpmp2NdUnqmbZnxp6V
	6z+0PnzjWHcgwrT9Lf8aoe4JPyzXRarPWJnmLyDTYh5rZM+sYNVgmVl0TnpXHE+rL8+yG8fs
	5K7JWPUKXeKX2eI84WH+0UtqYq7Rbfsy5k5Ja78s9SA8Uu7PzcONmhpPq+X9Nsm5dgt99VBO
	VGIpzkg01GIuKk4EAK/UHWicAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd1lLbkhBle3cVk8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix/NJl5oI2mYo/bcfYGhgXiXcxcnJICJhIzDs7iR3CFpO4cG89WxcjF4eQ
	wCJGifPzNkA5Pxkl+tsOsXYxcnCwCKhK/DsQANLAJqAl0X56LQuILSKgInFo0WWwQcwCmRIT
	+l+A2cICMRLbXl1mBrF5BdQlNjfvZgOxhQQcJaYtes4GEReU+DH5HgtEr5bE+p3HmSBsaYlH
	f2eAzeEUcJLo7d/KCGKLAu2acnIb2wRGgVlI2mchaZ+FpH0BI/MqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOAIfSa9g3FVg8UhRgEORiUe3gSL3BAh1sSy4srcQ4wSHMxKIryfKoFCvCmJ
	lVWpRfnxRaU5qcWHGE2BgTGRWUo0OR+YPPJK4g2NTcyMLI3MLIxMzM2VxHkPtloHCgmkJ5ak
	ZqemFqQWwfQxcXBKNTDWPTR8nGLFwxBz32sH0/RYhkpLk5htAvumq+t2RSRJ3dh+ILcxM0e+
	/rrIuWbDp6cuhmjsMQhyffVhFa+PKBf/+V8ng3O0Fc6FxmRP85rE2H/aSUsqZcEvrp1x6t0m
	Bd9vytV0OZrG1+9r+3zgPSfP/wcRL5lM6nXs39cEvq8Su5/1+4R9qhJLcUaioRZzUXEiAHFv
	MqDmAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

We should call flush_dcache_page before kunmap because the purpose of the cache flush is to address aliasing problem related to virtual address.

On Wed, Nov 19, 2014 at 02:35:08PM -0800, Jaegeuk Kim wrote:
> Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/dir.c    | 7 ++++++-
>  fs/f2fs/inline.c | 4 +++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 5a49995..312fbfc 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -287,8 +287,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
>  	f2fs_wait_on_page_writeback(page, type);
>  	de->ino = cpu_to_le32(inode->i_ino);
>  	set_de_type(de, inode);
> -	if (!f2fs_has_inline_dentry(dir))
> +	if (!f2fs_has_inline_dentry(dir)) {
>  		kunmap(page);
> +		flush_dcache_page(page);
> +	}
>  	set_page_dirty(page);
>  	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
>  	mark_inode_dirty(dir);
> @@ -366,6 +368,7 @@ static int make_empty_dir(struct inode *inode,
>  	do_make_empty_dir(inode, parent, &d);
>  
>  	kunmap_atomic(dentry_blk);
> +	flush_dcache_page(dentry_page);
>  
>  	set_page_dirty(dentry_page);
>  	f2fs_put_page(dentry_page, 1);
> @@ -579,6 +582,7 @@ fail:
>  		clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
>  	}
>  	kunmap(dentry_page);
> +	flush_dcache_page(dentry_page);
>  	f2fs_put_page(dentry_page, 1);
>  	return err;
>  }
> @@ -661,6 +665,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
>  			NR_DENTRY_IN_BLOCK,
>  			0);
>  	kunmap(page); /* kunmap - pair of f2fs_find_entry */
> +	flush_dcache_page(page);
>  	set_page_dirty(page);
>  
>  	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> index f26fb87..8b7cc51 100644
> --- a/fs/f2fs/inline.c
> +++ b/fs/f2fs/inline.c
> @@ -45,8 +45,8 @@ void read_inline_data(struct page *page, struct page *ipage)
>  	src_addr = inline_data_addr(ipage);
>  	dst_addr = kmap_atomic(page);
>  	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
> -	flush_dcache_page(page);
>  	kunmap_atomic(dst_addr);
> +	flush_dcache_page(page);
>  	SetPageUptodate(page);
>  }
>  
> @@ -107,6 +107,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
>  	dst_addr = kmap_atomic(page);
>  	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
>  	kunmap_atomic(dst_addr);
> +	flush_dcache_page(page);
>  	SetPageUptodate(page);
>  no_update:
>  	/* write data page to try to make data consistent */
> @@ -358,6 +359,7 @@ static int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
>  					NR_INLINE_DENTRY * F2FS_SLOT_LEN);
>  
>  	kunmap_atomic(dentry_blk);
> +	flush_dcache_page(page);
>  	SetPageUptodate(page);
>  	set_page_dirty(page);
>  
> -- 
> 2.1.1
> 
> 
> ------------------------------------------------------------------------------
> Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> with Interactivity, Sharing, Native Excel Exports, App Integration & more
> Get technology previously reserved for billion-dollar corporations, FREE
> http://pubads.g.doubleclick.net/gampad/clk?id=157005751&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
