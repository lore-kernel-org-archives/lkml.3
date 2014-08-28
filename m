Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936085AbaH1BtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:49:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21208 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaH1Bs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:48:59 -0400
X-AuditID: cbfee690-f79ce6d00000115a-3e-53fe8a881f1c
Date: Thu, 28 Aug 2014 10:47:36 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: reposition unlock_new_inode to prevent
 accessing invalid inode
Message-id: <20140828014736.GA6808@lcm>
References: <009101cfc119$8e7a5a00$ab6f0e00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <009101cfc119$8e7a5a00$ab6f0e00$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+ZsW5H179gg3NPdC3+N31ks3iyfhaz
	xaVF7haXd81hc2Dx2LSqk81j94LPTB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVcbxnNmvB
	I+mK2cdOMjcwtol1MXJySAiYSFw7/JQJwhaTuHBvPVsXIxeHkMAyRom1CxcywRXNPsEOkZgO
	lLj3jREkISTwk1FizWtLEJtFQFWibdZuZhCbTUBLov30WhYQW0RASeLX/EWsIDazQI7EkvP9
	QEM5OIQF0iSWzOEDCfMKqEtcW/CWGWKkpcTHBe8YIeKCEj8m32OBaNWSWL/zOBOELS3x6O8M
	dhCbU8BK4um0TrDxogIqElNObgN7QEJgHbvE+2/9TBC3CUh8m3yIBWSvhICsxKYDzBB/SUoc
	XHGDZQKj2Cwk62YhWTcLyboFjMyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MUJiacIOxnsH
	rA8xCnAwKvHwzkj4FyzEmlhWXJl7iNEU6IqJzFKiyfnAiM0riTc0NjOyMDUxNTYytzRTEud9
	LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj0LZ7Dxn3nIoPfzwpzrf19ZMHxfHKbX5t
	Ny7ftNqvmJj1Lb1s6crNImsWbzJ4wH996pQ3J7cHPeeaa8i5gl2q9V3SL/srFW+alkZ3uP1d
	s+/brC22LyZH6f3Yuemxrz2/1DEOBb/mcpdsXd1/gmVc175IeFa7+5vlm4TJKq48UJBRr7PM
	yTVHiaU4I9FQi7moOBEACnvnIaACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jQd2Orn/BBnP/aFr8b/rIZvFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMeN4z2zWgkfSFbOPnWRuYGwT62Lk5JAQMJG4NvsEO4QtJnHh3nq2
	LkYuDiGB6YwSa+99YwRJCAn8ZJRY89oSxGYRUJVom7WbGcRmE9CSaD+9lgXEFhFQkvg1fxEr
	iM0skCOx5Hw/UxcjB4ewQJrEkjl8IGFeAXWJawveMkOMtJT4uOAdI0RcUOLH5HssEK1aEut3
	HmeCsKUlHv2dAXYbp4CVxNNpnWDjRQVUJKac3MY2gVFgFpL2WUjaZyFpX8DIvIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOFKfSe1gXNlgcYhRgINRiYfXIe5fsBBrYllxZe4hRgkOZiUR
	3nSQEG9KYmVValF+fFFpTmrxIUZTYGBMZJYSTc4HJpG8knhDYxMzI0sjMwsjE3NzJXHeA63W
	gUIC6YklqdmpqQWpRTB9TBycUg2MbI76edsWLMvZEiFbq31gfzHP5IkCqxwOdKvHXDoiFGJo
	vOm0pCz7hQTe0z3dX/YbL4rprv147O7t856L1RcvD/Nb4fCxNfb82qLtlmXWDVniMw5YSZ34
	GMUkzXe9pP1nadGxU8+yk861WDXnzOkyFTX9Ux/i9Npw/mLZxqC70RMW1m3dXfxZiaU4I9FQ
	i7moOBEA4Ohk9uoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

I agree it's correct unlock_new_inode should be located after make_bad_inode.

About this scenario,
I think we should check some condition if this could be occured;
A inode allocated newly could be victim by gc thread.
Then, f2fs_iget called by Thread A have to fail because we handled it as
bad_inode in Thread B. However, f2fs_iget could still get inode.
How about check it using is_bad_inode() in f2fs_iget.

Thanks,

On Tue, Aug 26, 2014 at 06:35:29PM +0800, Chao Yu wrote:
> As the race condition on the inode cache, following scenario can appear:
> [Thread a]				[Thread b]
> 					->f2fs_mkdir
> 					  ->f2fs_add_link
> 					    ->__f2fs_add_link
> 					      ->init_inode_metadata failed here
> ->gc_thread_func
>   ->f2fs_gc
>     ->do_garbage_collect
>       ->gc_data_segment
>         ->f2fs_iget
>           ->iget_locked
>             ->wait_on_inode
> 					  ->unlock_new_inode
>         ->move_data_page
> 					  ->make_bad_inode
> 					  ->iput
> 
> When we fail in create/symlink/mkdir/mknod/tmpfile, the new allocated inode
> should be set as bad to avoid being accessed by other thread. But in above
> scenario, it allows f2fs to access the invalid inode before this inode was set
> as bad.
> This patch fix the potential problem, and this issue was found by code review.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/namei.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 6b53ce9..845f1be 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -134,8 +134,8 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  	return 0;
>  out:
>  	clear_nlink(inode);
> -	unlock_new_inode(inode);
>  	make_bad_inode(inode);
> +	unlock_new_inode(inode);
>  	iput(inode);
>  	alloc_nid_failed(sbi, ino);
>  	return err;
> @@ -267,8 +267,8 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
>  	return err;
>  out:
>  	clear_nlink(inode);
> -	unlock_new_inode(inode);
>  	make_bad_inode(inode);
> +	unlock_new_inode(inode);
>  	iput(inode);
>  	alloc_nid_failed(sbi, inode->i_ino);
>  	return err;
> @@ -308,8 +308,8 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  out_fail:
>  	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
>  	clear_nlink(inode);
> -	unlock_new_inode(inode);
>  	make_bad_inode(inode);
> +	unlock_new_inode(inode);
>  	iput(inode);
>  	alloc_nid_failed(sbi, inode->i_ino);
>  	return err;
> @@ -354,8 +354,8 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
>  	return 0;
>  out:
>  	clear_nlink(inode);
> -	unlock_new_inode(inode);
>  	make_bad_inode(inode);
> +	unlock_new_inode(inode);
>  	iput(inode);
>  	alloc_nid_failed(sbi, inode->i_ino);
>  	return err;
> @@ -688,8 +688,8 @@ release_out:
>  out:
>  	f2fs_unlock_op(sbi);
>  	clear_nlink(inode);
> -	unlock_new_inode(inode);
>  	make_bad_inode(inode);
> +	unlock_new_inode(inode);
>  	iput(inode);
>  	alloc_nid_failed(sbi, inode->i_ino);
>  	return err;
> -- 
> 2.0.0.421.g786a89d
> 
> 
> 
> ------------------------------------------------------------------------------
> Slashdot TV.  
> Video for Nerds.  Stuff that matters.
> http://tv.slashdot.org/
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
