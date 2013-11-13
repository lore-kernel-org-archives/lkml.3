Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab3KMQ5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:57:25 -0500
Received: from kanga.kvack.org ([205.233.56.17]:51038 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758963Ab3KMQ5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:57:18 -0500
Date: Wed, 13 Nov 2013 11:57:17 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] aio: checking for NULL instead of IS_ERR
Message-ID: <20131113165717.GB13840@kvack.org>
References: <20131113074940.GG25541@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113074940.GG25541@elgon.mountain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:49:40AM +0300, Dan Carpenter wrote:
> alloc_anon_inode() returns an ERR_PTR(), it doesn't return NULL.
> 
> Fixes: 71ad7490c1f3 ('rework aio migrate pages to use aio fs')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for spotting this.

Acked-by: Benjamin LaHaise <bcrl@kvack.org>

		-ben

> diff --git a/fs/aio.c b/fs/aio.c
> index bf8d080..699f53e 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -164,8 +164,8 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
>  	struct file *file;
>  	struct path path;
>  	struct inode *inode = alloc_anon_inode(aio_mnt->mnt_sb);
> -	if (!inode)
> -		return ERR_PTR(-ENOMEM);
> +	if (IS_ERR(inode))
> +		return ERR_CAST(inode);
>  
>  	inode->i_mapping->a_ops = &aio_ctx_aops;
>  	inode->i_mapping->private_data = ctx;

-- 
"Thought is the essence of where you are now."
