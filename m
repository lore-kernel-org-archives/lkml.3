Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab3JPPew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:34:52 -0400
Received: from a14-29.smtp-out.amazonses.com ([54.240.14.29]:44143 "EHLO
	a14-29.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534Ab3JPPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:34:51 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2013 11:34:51 EDT
Date: Wed, 16 Oct 2013 15:27:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2 01/15] slab: correct pfmemalloc check
In-Reply-To: <1381913052-23875-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000141c1e16001-26ccfd98-51ee-4ca6-8ddf-61abd491dea8-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1381913052-23875-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.16-54.240.14.29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Joonsoo Kim wrote:

> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -930,7 +930,8 @@ static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
>  {
>  	if (unlikely(pfmemalloc_active)) {
>  		/* Some pfmemalloc slabs exist, check if this is one */
> -		struct page *page = virt_to_head_page(objp);
> +		struct slab *slabp = virt_to_slab(objp);
> +		struct page *page = virt_to_head_page(slabp->s_mem);
>  		if (PageSlabPfmemalloc(page))

I hope the compiler optimizes this code correctly because virt_to_slab
already does one virt_to_head_page()?

Otherwise this looks fine.
