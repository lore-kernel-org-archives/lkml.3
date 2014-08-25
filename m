Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaHYP3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:29:23 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:50923 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046AbaHYP3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:29:21 -0400
Date: Mon, 25 Aug 2014 10:29:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/slab: support slab merge
In-Reply-To: <1408608675-20420-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408251028420.27302@gentwo.org>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com> <1408608675-20420-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Joonsoo Kim wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index 09b060e..a1cc1c9 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2052,6 +2052,26 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
>  	return 0;
>  }
>
> +unsigned long kmem_cache_flags(unsigned long object_size,
> +	unsigned long flags, const char *name,
> +	void (*ctor)(void *))
> +{
> +	return flags;
> +}
> +
> +struct kmem_cache *
> +__kmem_cache_alias(const char *name, size_t size, size_t align,
> +		   unsigned long flags, void (*ctor)(void *))
> +{
> +	struct kmem_cache *cachep;
> +
> +	cachep = find_mergeable(size, align, flags, name, ctor);
> +	if (cachep)
> +		cachep->refcount++;
> +
> +	return cachep;
> +}
> +

These could be commonized as well. Make refcount a common field and then
the same function can be used for both caches.

