Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab3KAU6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:58:13 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:10992 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230Ab3KAU6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:58:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoGAGoVdFJ5LOn3/2dsb2JhbABZgweDPL1AgR4XdIIlAQEFOhwjEAgDGAklDwUlAyETiAa9NRaPQgeELgOUK4NeikWHRYM6KA
Date: Sat, 2 Nov 2013 07:58:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bpm@sgi.com, elder@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: simplify kmem_{zone_}zalloc
Message-ID: <20131101205803.GQ4446@dastard>
References: <52738187.1000807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52738187.1000807@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 06:25:11PM +0800, Gu Zheng wrote:
> Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
> kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
> in order to avoid the setting to zero step.
> 
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/xfs/kmem.c |   14 ++------------
>  fs/xfs/kmem.h |    7 ++++++-
>  2 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index a02cfb9..d56fcc9 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -65,12 +65,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>  void *
>  kmem_zalloc(size_t size, xfs_km_flags_t flags)
>  {
> -	void	*ptr;
> -
> -	ptr = kmem_alloc(size, flags);
> -	if (ptr)
> -		memset((char *)ptr, 0, (int)size);
> -	return ptr;
> +	return kmem_alloc(size, flags | KM_ZERO);
>  }
>  
>  void *
> @@ -132,10 +127,5 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>  void *
>  kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>  {
> -	void	*ptr;
> -
> -	ptr = kmem_zone_alloc(zone, flags);
> -	if (ptr)
> -		memset((char *)ptr, 0, kmem_cache_size(zone));
> -	return ptr;
> +	return kmem_zone_alloc(zone, flags | KM_ZERO);
>  }

These functions should be made static inline functions in kmem.h
seeing as they are now just a simple wrapper.

Otherwise it's a nice cleanup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
