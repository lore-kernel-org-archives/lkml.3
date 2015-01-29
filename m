Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbbA2QcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 11:32:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbbA2QcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 11:32:04 -0500
Date: Thu, 29 Jan 2015 10:46:52 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'david@fromorbit.com'" <david@fromorbit.com>,
        "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs:change kmem_free to use generic kvfree()
Message-ID: <20150129154652.GK17652@laptop.bfoster>
References: <35FD53F367049845BC99AC72306C23D1044A02027DFF@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1044A02027DFF@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 02:08:47PM +0800, Wang, Yalin wrote:
> Change kmem_free to use kvfree() generic function,
> remove the duplicated code.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---

Looks good...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/kmem.c | 10 ----------
>  fs/xfs/kmem.h |  5 ++++-
>  2 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 53e95b2..a7a3a63 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -91,16 +91,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  	return ptr;
>  }
>  
> -void
> -kmem_free(const void *ptr)
> -{
> -	if (!is_vmalloc_addr(ptr)) {
> -		kfree(ptr);
> -	} else {
> -		vfree(ptr);
> -	}
> -}
> -
>  void *
>  kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
>  	     xfs_km_flags_t flags)
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 64db0e5..cc6b768 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -63,7 +63,10 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
>  extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
> -extern void  kmem_free(const void *);
> +static inline void  kmem_free(const void *ptr)
> +{
> +	kvfree(ptr);
> +}
>  
>  
>  extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
> -- 
> 2.2.2
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
