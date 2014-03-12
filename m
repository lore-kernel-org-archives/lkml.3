Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaCLVxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:53:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaCLVxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:53:36 -0400
Date: Wed, 12 Mar 2014 22:53:34 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] fs/isofs/inode.c add __init to init_inodecache()
Message-ID: <20140312215334.GA13675@quack.suse.cz>
References: <20140310220148.df8c4583466ec55ca4db53e1@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310220148.df8c4583466ec55ca4db53e1@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-03-14 22:01:48, Fabian Frederick wrote:
> init_inodecache is only called by __init init_iso9660_fs
  Thanks. I've merged the patch to my tree.

								Honza

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/isofs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index 4a9e10e..7df1914 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -93,7 +93,7 @@ static void init_once(void *foo)
>  	inode_init_once(&ei->vfs_inode);
>  }
>  
> -static int init_inodecache(void)
> +static int __init init_inodecache(void)
>  {
>  	isofs_inode_cachep = kmem_cache_create("isofs_inode_cache",
>  					sizeof(struct iso_inode_info),
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
