Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaFKMO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:14:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaFKMO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:14:57 -0400
Date: Wed, 11 Jun 2014 14:14:54 +0200
From: Jan Kara <jack@suse.cz>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] fs/ext2/super.c: Drop memory allocation cast
Message-ID: <20140611121454.GE3661@quack.suse.cz>
References: <20140610144118.GA3255@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610144118.GA3255@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-06-14 20:11:18, Himangi Saraogi wrote:
> Drop cast on the result of kmem_cache_alloc.
> 
> The semantic patch that makes this change is as follows:
> 
> // <smpl>
> @@
> type T;
> @@
> 
> - (T *)
>   (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
>    kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
  Merged to my tree. Thanks!

								Honza
> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 3750031..b88edc0 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -161,7 +161,7 @@ static struct kmem_cache * ext2_inode_cachep;
>  static struct inode *ext2_alloc_inode(struct super_block *sb)
>  {
>  	struct ext2_inode_info *ei;
> -	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
> +	ei = kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
>  	if (!ei)
>  		return NULL;
>  	ei->i_block_alloc_info = NULL;
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
