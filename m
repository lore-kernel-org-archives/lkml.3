Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaIORHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:07:55 -0400
Received: from verein.lst.de ([213.95.11.211]:33183 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbaIORHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:07:52 -0400
Date: Mon, 15 Sep 2014 19:07:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build failure after merge of the nfs tree
Message-ID: <20140915170749.GB23433@lst.de>
References: <20140915170453.0e8d4e85@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915170453.0e8d4e85@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen!

Trond, can you just pick up the patch?  Considered it:

Reviewed-by: Christoph Hellwig <hch@lst.de>

On Mon, Sep 15, 2014 at 05:04:53PM +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> fs/nfs/blocklayout/extent_tree.c: In function 'ext_tree_prepare_commit':
> fs/nfs/blocklayout/extent_tree.c:540:3: error: implicit declaration of function '__vmalloc' [-Werror=implicit-function-declaration]
>    start_p = __vmalloc(buffer_size, GFP_NOFS, PAGE_KERNEL);
>    ^
> fs/nfs/blocklayout/extent_tree.c:540:11: warning: assignment makes pointer from integer without a cast
>    start_p = __vmalloc(buffer_size, GFP_NOFS, PAGE_KERNEL);
>            ^
> 
> Caused by commit 34dc93c2fc04 ("pnfs/blocklayout: allocate separate
> pages for the layoutcommit payload").
> 
> I added the following fix patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 15 Sep 2014 17:01:32 +1000
> Subject: [PATCH] pnfs/blocklayout: include vmalloc.h for __vmalloc
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/nfs/blocklayout/extent_tree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/nfs/blocklayout/extent_tree.c b/fs/nfs/blocklayout/extent_tree.c
> index 93193616205a..31d0b5e53dfd 100644
> --- a/fs/nfs/blocklayout/extent_tree.c
> +++ b/fs/nfs/blocklayout/extent_tree.c
> @@ -2,6 +2,8 @@
>   * Copyright (c) 2014 Christoph Hellwig.
>   */
>  
> +#include <linux/vmalloc.h>
> +
>  #include "blocklayout.h"
>  
>  #define NFSDBG_FACILITY		NFSDBG_PNFS_LD
> -- 
> 2.1.0
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


---end quoted text---
