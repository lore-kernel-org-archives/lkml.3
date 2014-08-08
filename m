Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaHHOeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:34:17 -0400
Received: from relay.variantweb.net ([104.131.199.242]:53323 "EHLO
	relay.variantweb.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755320AbaHHOeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:34:14 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2014 10:34:14 EDT
Date: Fri, 8 Aug 2014 09:23:54 -0500
From: Seth Jennings <sjennings@variantweb.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/zpool: use prefixed module loading
Message-ID: <20140808142354.GA32313@cerebellum.variantweb.net>
References: <20140808075316.GA21919@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808075316.GA21919@www.outflux.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 12:53:16AM -0700, Kees Cook wrote:
> To avoid potential format string expansion via module parameters,
> do not use the zpool type directly in request_module() without a
> format string. Additionally, to avoid arbitrary modules being loaded
> via zpool API (e.g. via the zswap_zpool_type module parameter) add a
> "zpool-" prefix to the requested module, as well as module aliases for
> the existing zpool types (zbud and zsmalloc).

I didn't know that request_module() did string expansion.
Thanks for the fix!

Acked-by: Seth Jennings <sjennings@variantweb.net>

> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  mm/zbud.c     | 1 +
>  mm/zpool.c    | 2 +-
>  mm/zsmalloc.c | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/zbud.c b/mm/zbud.c
> index a05790b1915e..aa74f7addab1 100644
> --- a/mm/zbud.c
> +++ b/mm/zbud.c
> @@ -619,3 +619,4 @@ module_exit(exit_zbud);
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Seth Jennings <sjenning@linux.vnet.ibm.com>");
>  MODULE_DESCRIPTION("Buddy Allocator for Compressed Pages");
> +MODULE_ALIAS("zpool-zbud");
> diff --git a/mm/zpool.c b/mm/zpool.c
> index e40612a1df00..739cdf0d183a 100644
> --- a/mm/zpool.c
> +++ b/mm/zpool.c
> @@ -150,7 +150,7 @@ struct zpool *zpool_create_pool(char *type, gfp_t gfp, struct zpool_ops *ops)
>  	driver = zpool_get_driver(type);
>  
>  	if (!driver) {
> -		request_module(type);
> +		request_module("zpool-%s", type);
>  		driver = zpool_get_driver(type);
>  	}
>  
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 4e2fc83cb394..36af729eb3f6 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1199,3 +1199,4 @@ module_exit(zs_exit);
>  
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
> +MODULE_ALIAS("zpool-zsmalloc");
> -- 
> 1.9.1
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
