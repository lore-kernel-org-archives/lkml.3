Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaD2GS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:18:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25398 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaD2GSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:18:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7f4e6d000004845-5e-535f442f94f8
Content-transfer-encoding: 8BIT
Message-id: <1398752174.13268.4.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in
 inode page when setattr
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 15:16:14 +0900
In-reply-to: <001801cf6370$e0553040$a0ff90c0$@samsung.com>
References: <001801cf6370$e0553040$a0ff90c0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zI119l/hgg/srJSz+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZezf8Yap4I9oxceV
	55gaGM8IdjFycEgImEjc2hTWxcgJZIpJXLi3nq2LkYtDSGAZo8TVc2uZIRImEpfvdjNDJBYx
	Slw7fQUswSsgKPFj8j0WkEHMAvISRy5lg4SZBdQlJs1bBFX/ilFi0veZUPU6ErumT2MEsYUF
	UiRmbT/PCtLLJqAtsXm/AUhYSEBR4u3+u6wgtoiAksSv+YtYIWZmStxrmgE2hkVAVeJ9x352
	kFZOASsgmwui1VJi6smlYCX8AqIShxduhzpfSWJ3eyc7yDkSAofYJRbfXc0GMUdA4tvkQyyQ
	cJCV2HQAql5S4uCKGywTGCVmIXlyFsKTs5A8uYCReRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+
	7iZGSKz17mC8fcD6EGMy0MaJzFKiyfnAWM0riTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbLEZfztM4wWpnlzlnlfJNF31mzeH7T5SUNkv375Jdt
	mKu0zX4J/6LeN2c9O+t+Sonp1iuJT4rzfVe8ce+lrrh9s9g2y4kqLetZYRv78mVkv47N5fUf
	ReSVVFrXKwv7qBw71Djt8c2Fnm+dt898pe13wZ7rAU+JUkDQPTFxmQ9ntY+puxcwciixFGck
	GmoxFxUnAgDkoRJnywIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV19l/hgg7k9Ihb/mz6yWVxa5G6x
	Z+9JFovLu+awObB47F7wmcmjb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS81My89JtlbyD453j
	Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgLYpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwnrGDP273jDVPBHtOLjynNMDYxnBLsYOTkkBEwkLt/tZoawxSQu3FvP1sXIxSEk
	sIhR4trpK2AJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP0rRolJ32dC1etI7Jo+
	jRHEFhZIkZi1/TwrSC+bgLbE5v0GIGEhAUWJt/vvsoLYIgJKEr/mL2KFmJkpca9pBtgYFgFV
	ifcd+9lBWjkFrIBsLohWS4mpJ5eClfALiEocXrgd6nwlid3tnewTGIVmITl6FsLRs5AcvYCR
	eRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCw/k97BuKrB4hCjAAejEg9vR0xcsBBrYllx
	Ze4hRgkOZiUR3nyr+GAh3pTEyqrUovz4otKc1OJDjMlAd09klhJNzgemmbySeENjEzMjSyMz
	CyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYBS/9/ZXw6b8bTemPEipnqZQ8Kbb
	Pv3avS8xtrfveZaq73rpcmhz/glZLdb75Ru1Wn6vuvE68VPu83OHlvnWMs5X1Vy/xaS6fpnA
	2sNzpa+fmmEzwUn+hEF0u6JvxRmT5Cs3XeVmZy5tKLQIPONmzS98hPG3grLrbm6uWT3R9Vmf
	Y65WHMtKd1BiKc5INNRiLipOBADYBZjeKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-29 (화), 14:03 +0800, Chao Yu:
> Previous we do not truncate inline data in inode page when setattr, so following
> case could still read the inline data which has already truncated:
> 
> 1.write inline data
> 2.ftruncate size to 0
> 3.ftruncate size to max inline data size
> 4.read from offset 0
> 
> This patch introduces truncate_inline_data() to fix this problem.
> 
> change log from v1:
>  o fix a bug and do not truncate first page data after truncate inline data.
> change log from v2:
>  o wait to writeback for inode page if it was already submitted.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/f2fs.h   |    1 +
>  fs/f2fs/file.c   |    3 +++
>  fs/f2fs/inline.c |   19 +++++++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 2b67679..676a2c6 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1410,5 +1410,6 @@ bool f2fs_may_inline(struct inode *);
>  int f2fs_read_inline_data(struct inode *, struct page *);
>  int f2fs_convert_inline_data(struct inode *, pgoff_t);
>  int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
> +void truncate_inline_data(struct inode *, u64);
>  int recover_inline_data(struct inode *, struct page *);
>  #endif
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index b9f4fbf..d97e5c4 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -369,6 +369,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
>  	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
>  	struct page *page;
>  
> +	if (f2fs_has_inline_data(inode))
> +		return truncate_inline_data(inode, from);
> +
>  	if (!offset)
>  		return;
>  
> diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> index 3258c7c..6a13997 100644
> --- a/fs/f2fs/inline.c
> +++ b/fs/f2fs/inline.c
> @@ -176,6 +176,25 @@ int f2fs_write_inline_data(struct inode *inode,
>  	return 0;
>  }
>  
> +void truncate_inline_data(struct inode *inode, u64 from)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +	struct page *ipage;
> +
> +	if (from >= MAX_INLINE_DATA)
> +		return;
> +
> +	ipage = get_node_page(sbi, inode->i_ino);
> +	if (IS_ERR(ipage))
> +		return;
> +
> +	f2fs_wait_on_page_writeback(ipage, NODE);

The get_node_page() triggers,
 grab_cache_page_write_begin()
  -> wait_for_stable_page()
     -> wait_on_page_writeback().

Any bugs in there?

> +	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
> +				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> +	set_page_dirty(ipage);
> +	f2fs_put_page(ipage, 1);
> +}
> +
>  int recover_inline_data(struct inode *inode, struct page *npage)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);

-- 
Jaegeuk Kim
Samsung

