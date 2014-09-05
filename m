Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaIEAoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:44:08 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:65041 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbaIEAoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:44:06 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 5 Sep 2014 09:44:55 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, mm-commits@vger.kernel.org
Subject: Re: +
 mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
 added to -mm tree
Message-ID: <20140905004455.GA23894@js1304-P5Q-DELUXE>
References: <54076ec4.SXX1dzKOV7x8UJki%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54076ec4.SXX1dzKOV7x8UJki%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 12:40:52PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: fix kmemcheck.c build errors
> has been added to the -mm tree.  Its filename is
>      mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Randy Dunlap <rdunlap@infradead.org>
> Subject: mm: fix kmemcheck.c build errors
> 
> Add header files to fix kmemcheck.c build errors:
> 
> ../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
> ../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type
> 
> ../mm/slab.h: In function 'cache_from_obj':
> ../mm/slab.h:283:2: error: implicit declaration of function 'memcg_kmem_enabled' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/kmemcheck.c |    1 +
>  mm/slab.h      |    2 ++
>  2 files changed, 3 insertions(+)
> 
> diff -puN mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2 mm/kmemcheck.c
> --- a/mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2
> +++ a/mm/kmemcheck.c
> @@ -2,6 +2,7 @@
>  #include <linux/mm_types.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> +#include "slab.h"
>  #include <linux/kmemcheck.h>
>  
>  void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
> diff -puN mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2 mm/slab.h
> --- a/mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2
> +++ a/mm/slab.h
> @@ -268,6 +268,8 @@ static inline void memcg_uncharge_slab(s
>  }
>  #endif
>  
> +#include <linux/memcontrol.h>
> +
>  static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
>  {
>  	struct kmem_cache *cachep;

Hello, Andrew.

Could you take another fix instead of this?
This also make build failure if CONFIG_MEMCG_KMEM=y.
Please see following patch I sent.

https://lkml.org/lkml/2014/8/31/148

The only difference is position of memcontrol.h header.

Thanks.
