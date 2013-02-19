Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab3BSL44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:56:56 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:38290 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3BSL4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:56:55 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fat: instead of constant number, use the i_blkbits of struct inode to calculate the number of blocks
References: <1361274638-9534-1-git-send-email-hyc.lee@gmail.com>
Date: Tue, 19 Feb 2013 20:56:51 +0900
In-Reply-To: <1361274638-9534-1-git-send-email-hyc.lee@gmail.com> (Hyeoncheol
	Lee's message of "Tue, 19 Feb 2013 20:50:38 +0900")
Message-ID: <87obfgy0sc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hyeoncheol Lee <hyc.lee@gmail.com> writes:

> To calculate the number of blocks from the number of clusters,
> use the i_blkbits of struct inode instead of 9.
>
> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
> ---
>  fs/fat/misc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index 6d93360..ccdf663 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
> @@ -156,7 +156,7 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
>  			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
>  		fat_cache_inval_inode(inode);
>  	}
> -	inode->i_blocks += nr_cluster << (sbi->cluster_bits - 9);
> +	inode->i_blocks += nr_cluster << (sbi->cluster_bits - inode->i_blkbits);

No. Unit of ->i_blocks is 512bytes always. So, 9 is right number.

>  
>  	return 0;
>  }

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
