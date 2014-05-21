Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaEUULu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:11:50 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42717 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaEUULs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:11:48 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Gioh Kim <gioh.kim@lge.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: Re: [RFC PATCH] arm: dma-mapping: fallback allocation for cma failure
In-Reply-To: <537C5EA3.20709@lge.com>
Organization: http://mina86.com/
References: <537AEEDB.2000001@lge.com> <20140520065222.GB8315@js1304-P5Q-DELUXE> <xa1t1tvo1fas.fsf@mina86.com> <537C5EA3.20709@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140521:hannes@cmpxchg.org::yWXgUcNsTlMxV9Ab:000000000000000000000000000000000000000000001fb
X-Hashcash: 1:20:140521:linux-mm@kvack.org::5U2O1CaxlbsSA0UG:000000000000000000000000000000000000000000005kV
X-Hashcash: 1:20:140521:mgorman@suse.de::13wLcTH/NW4j0ccr:000MiY
X-Hashcash: 1:20:140521:iamjoonsoo.kim@lge.com::8i9DSZ+Vxp9RD/Vp:00000000000000000000000000000000000000016dM
X-Hashcash: 1:20:140521:gunho.lee@lge.com::KMYCBsMV1dM+IOml:000000000000000000000000000000000000000000001fyy
X-Hashcash: 1:20:140521:heesub.shin@samsung.com::EXgS7cox6rkHjXk/:000000000000000000000000000000000000001Huc
X-Hashcash: 1:20:140521:linux-kernel@vger.kernel.org::c95NugOZU2i99A4y:0000000000000000000000000000000002Drl
X-Hashcash: 1:20:140521:chanho.min@lge.com::mDHzZ4wxAYlOINq/:00000000000000000000000000000000000000000003Xgi
X-Hashcash: 1:20:140521:gioh.kim@lge.com::JyZhNGNuyryzL47b:05m4U
X-Hashcash: 1:20:140521:m.szyprowski@samsung.com::bVqDEQfFRvJK7Ant:0000000000000000000000000000000000000BqVs
Date: Wed, 21 May 2014 10:11:43 -1000
Message-ID: <xa1td2f699j4.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21 2014, Gioh Kim <gioh.kim@lge.com> wrote:
> Date: Tue, 20 May 2014 14:16:20 +0900
> Subject: [PATCH] arm: dma-mapping: add checking cma area initialized
>
> If CMA is turned on and CMA size is set to zero, kernel should
> behave as if CMA was not enabled at compile time.
> Every dma allocation should check existence of cma area
> before requesting memory.
>
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Some minor comments.  Also, I'd love for someone more experienced with
ARM to take a look at this as well.

> ---
>   arch/arm/mm/dma-mapping.c |   12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 18e98df..61f7b93 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -379,7 +379,7 @@ static int __init atomic_pool_init(void)
>          unsigned long *bitmap;
>          struct page *page;
>          struct page **pages;
> -       void *ptr;
> +       void *ptr = NULL;

This is unnecessary any more.

>          int bitmap_size = BITS_TO_LONGS(nr_pages) * sizeof(long);
>
>          bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> @@ -390,12 +390,13 @@ static int __init atomic_pool_init(void)
>          if (!pages)
>                  goto no_pages;
>
> -       if (IS_ENABLED(CONFIG_DMA_CMA))
> +       if (IS_ENABLED(CONFIG_DMA_CMA) && dma_contiguous_default_area)

+	if (dev_get_cma_area(NULL))

dev_get_cma_area returns NULL if !IS_ENABLED(CONFIG_DMA_CMA) so there's
no need to check it explicitly.  And with NULL argument,
deg_get_cma_area returns the default area.

>                  ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
>                                                atomic_pool_init);
>          else
>                  ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
>                                             atomic_pool_init);
> +
>          if (ptr) {
>                  int i;
>
> @@ -669,6 +670,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>          u64 mask = get_coherent_dma_mask(dev);
>          struct page *page = NULL;
>          void *addr;
> +       struct cma *cma = dev_get_cma_area(dev);
>
>   #ifdef CONFIG_DMA_API_DEBUG
>          u64 limit = (mask + 1) & ~mask;
> @@ -701,7 +703,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>                  addr = __alloc_simple_buffer(dev, size, gfp, &page);
>          else if (!(gfp & __GFP_WAIT))
>                  addr = __alloc_from_pool(size, &page);
> -       else if (!IS_ENABLED(CONFIG_DMA_CMA))
> +       else if (!IS_ENABLED(CONFIG_DMA_CMA) || !cma)

Like above, just do:

+	else if (!dev_get_cma_area(dev))

This will also allow to drop the “cma” variable above.

>                  addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
>          else
>                  addr = __alloc_from_contiguous(dev, size, prot, &page, caller);
> @@ -780,6 +782,7 @@ static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
>                             bool is_coherent)
>   {
>          struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
> +       struct cma *cma = dev_get_cma_area(dev);
>
>          if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
>                  return;
> @@ -790,7 +793,7 @@ static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
>                  __dma_free_buffer(page, size);
>          } else if (__free_from_pool(cpu_addr, size)) {
>                  return;
> -       } else if (!IS_ENABLED(CONFIG_DMA_CMA)) {
> +       } else if (!IS_ENABLED(CONFIG_DMA_CMA) || !cma) {

Ditto.

>                  __dma_free_remap(cpu_addr, size);
>                  __dma_free_buffer(page, size);
>          } else {
> @@ -798,6 +801,7 @@ static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
>                   * Non-atomic allocations cannot be freed with IRQs disabled
>                   */
>                  WARN_ON(irqs_disabled());
> +

Unrelated change.

>                  __free_from_contiguous(dev, page, cpu_addr, size);
>          }
>   }
> --
> 1.7.9.5

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
