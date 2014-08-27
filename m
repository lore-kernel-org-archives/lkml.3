Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936053AbaH0Xhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:37:36 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:58842 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935743AbaH0Xhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:37:35 -0400
Date: Wed, 27 Aug 2014 18:37:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/slab: use percpu allocator for cpu cache
In-Reply-To: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408271827010.26560@gentwo.org>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One minor nit. Otherwise

Acked-by: Christoph Lameter <cl@linux.com>

On Thu, 21 Aug 2014, Joonsoo Kim wrote:

> @@ -2041,56 +1982,63 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
>  	return left_over;
>  }
>
> +static int alloc_kmem_cache_cpus(struct kmem_cache *cachep, int entries,
> +				int batchcount)
> +{
> +	cachep->cpu_cache = __alloc_kmem_cache_cpus(cachep, entries,
> +							batchcount);
> +	if (!cachep->cpu_cache)
> +		return 1;
> +
> +	return 0;
> +}

Do we really need this trivial function? It doesnt do anything useful as
far as I can tell.
