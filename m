Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaFFOwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:52:22 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:60187 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbaFFOwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:52:21 -0400
Date: Fri, 6 Jun 2014 09:52:17 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
In-Reply-To: <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1406060949430.32229@gentwo.org>
References: <cover.1402060096.git.vdavydov@parallels.com> <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Vladimir Davydov wrote:

> @@ -740,7 +740,8 @@ static void start_cpu_timer(int cpu)
>  	}
>  }
>
> -static struct array_cache *alloc_arraycache(int node, int entries,
> +static struct array_cache *alloc_arraycache(struct kmem_cache *cachep,
> +					    int node, int entries,
>  					    int batchcount, gfp_t gfp)
>  {
>  	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);

If you pass struct kmem_cache * into alloc_arraycache then we do not need
to pass entries or batchcount because they are available in struct
kmem_cache.

Otherwise this patch looks a bit too large to me. Simplify a bit?

