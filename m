Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3BFC0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:26:52 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55427 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab3BFC0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:26:51 -0500
Date: Tue, 5 Feb 2013 18:28:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH v2] zsmalloc: Add Kconfig for enabling PTE method
Message-ID: <20130206022854.GA1681@kroah.com>
References: <1360117028-5625-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360117028-5625-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:17:08AM +0900, Minchan Kim wrote:
> diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
> index 9084565..232b3b6 100644
> --- a/drivers/staging/zsmalloc/Kconfig
> +++ b/drivers/staging/zsmalloc/Kconfig
> @@ -8,3 +8,15 @@ config ZSMALLOC
>  	  non-standard allocator interface where a handle, not a pointer, is
>  	  returned by an alloc().  This handle must be mapped in order to
>  	  access the allocated space.
> +
> +config PGTABLE_MAPPING
> +        bool "Use page table mapping to access allocations that span two pages"

No tabs?

Please also put "ZSmalloc somewhere in the text here, otherwise it
really doesn't make much sense when seeing it in a menu.

> +        depends on ZSMALLOC
> +        default n

That's the default, so it can be dropped.

> +        help
> +	  By default, zsmalloc uses a copy-based object mapping method to access
> +	  allocations that span two pages. However, if a particular architecture
> +	  performs VM mapping faster than copying, then you should select this.
> +	  This causes zsmalloc to use page table mapping rather than copying
> +	  for object mapping. You can check speed with zsmalloc benchmark[1].
> +	  [1] https://github.com/spartacus06/zsmalloc

Care to specify exactly _what_ architectures this should be set for or
not?  That will help the distros out a lot in determining if this should
be enabled or not.

> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 06f73a9..2c1805c 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -207,6 +207,7 @@ struct zs_pool {
>  	struct size_class size_class[ZS_SIZE_CLASSES];
>  
>  	gfp_t flags;	/* allocation flags used when growing pool */
> +
>  };
>  
>  /*

Why add this extra line?

thanks,

greg k-h
