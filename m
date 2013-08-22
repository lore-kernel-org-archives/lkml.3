Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3HVSRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:17:04 -0400
Received: from a9-97.smtp-out.amazonses.com ([54.240.9.97]:40906 "EHLO
	a9-97.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579Ab3HVSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:17:01 -0400
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 14:17:01 EDT
Date: Thu, 22 Aug 2013 18:00:56 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] slab: use __GFP_COMP flag for allocating slab
 pages
In-Reply-To: <1377161065-30552-10-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140a72fb556-3269e81c-8829-4c26-a57f-c1bb7e40977b-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-10-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.22-54.240.9.97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> If we use 'struct page' of first page as 'struct slab', there is no
> advantage not to use __GFP_COMP. So use __GFP_COMP flag for all the cases.

Ok that brings it in line with SLUB and SLOB.

> @@ -2717,17 +2701,8 @@ static void slab_put_obj(struct kmem_cache *cachep, struct slab *slabp,
>  static void slab_map_pages(struct kmem_cache *cache, struct slab *slab,
>  			   struct page *page)
>  {
> -	int nr_pages;
> -
> -	nr_pages = 1;
> -	if (likely(!PageCompound(page)))
> -		nr_pages <<= cache->gfporder;
> -
> -	do {
> -		page->slab_cache = cache;
> -		page->slab_page = slab;
> -		page++;
> -	} while (--nr_pages);
> +	page->slab_cache = cache;
> +	page->slab_page = slab;
>  }

And saves some processing.

