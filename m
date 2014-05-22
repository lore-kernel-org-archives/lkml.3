Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaEVDWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:22:51 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48415 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaEVDWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:22:49 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Gioh Kim <gioh.kim@lge.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: Re: [RFC PATCH] arm: dma-mapping: fallback allocation for cma failure
In-Reply-To: <537D4CBB.80305@lge.com>
Organization: http://mina86.com/
References: <537AEEDB.2000001@lge.com> <20140520065222.GB8315@js1304-P5Q-DELUXE> <xa1t1tvo1fas.fsf@mina86.com> <537C5EA3.20709@lge.com> <xa1td2f699j4.fsf@mina86.com> <537D4CBB.80305@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140522:mgorman@suse.de::xgkCYYH5pFC69cBw:0009eg
X-Hashcash: 1:20:140522:gioh.kim@lge.com::vliQwWvd1ikxXd92:01Bgf
X-Hashcash: 1:20:140522:chanho.min@lge.com::Fvcz9BF8gwSO8S0h:00000000000000000000000000000000000000000002bQ7
X-Hashcash: 1:20:140522:m.szyprowski@samsung.com::TreAU8y92n7f4R96:00000000000000000000000000000000000004BYo
X-Hashcash: 1:20:140522:linux-mm@kvack.org::syqphmH0KyV9wmeI:00000000000000000000000000000000000000000004X8X
X-Hashcash: 1:20:140522:iamjoonsoo.kim@lge.com::+frBX7QJn1iRmdff:0000000000000000000000000000000000000005W4N
X-Hashcash: 1:20:140522:hannes@cmpxchg.org::DfuVsc9tjVBELuuF:00000000000000000000000000000000000000000007CC+
X-Hashcash: 1:20:140522:gunho.lee@lge.com::3EjBQgEFEHlESrJM:000000000000000000000000000000000000000000008OU0
X-Hashcash: 1:20:140522:linux-kernel@vger.kernel.org::RDr53GUGhtSSKuS9:000000000000000000000000000000000AoI2
X-Hashcash: 1:20:140522:heesub.shin@samsung.com::jKpYENZ8dENx9LTW:00000000000000000000000000000000000000FR8J
Date: Wed, 21 May 2014 17:22:44 -1000
Message-ID: <xa1tmweajy4b.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22 2014, Gioh Kim <gioh.kim@lge.com> wrote:
> I appreciate your comments.
> The previous patch was ugly. But now it's beautiful! Just 3 lines!
>
> I'm not familiar with kernel patch process.
> Can I have your name at Signed-off-by: line?
> What tag do I have to write your name in?

My Signed-off-by line does not apply in this case.
Documentation/SubmittingPatches describes what Signed-off-by means.

I've added Acked-by below.  You may want to resend this patch using
“git-send-email”.

> --------------------------------- 8< ----------------------------------------------
>  From 135c986cfaa5a7291519308b3d47e58bf9f5af25 Mon Sep 17 00:00:00 2001
> From: Gioh Kim <gioh.kim@lge.com>
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

Acked-by: Michal Nazarewicz <mina86@mina86.com>

But like before, if someone with more ARM knowledge could take a look at
it, it would be awesome.

> ---
>   arch/arm/mm/dma-mapping.c |    7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 18e98df..9173a13 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -390,12 +390,13 @@ static int __init atomic_pool_init(void)
>          if (!pages)
>                  goto no_pages;
>
> -       if (IS_ENABLED(CONFIG_DMA_CMA))
> +       if (dev_get_cma_area(NULL))
>                  ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
>                                                atomic_pool_init);
>          else
>                  ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
>                                             atomic_pool_init);
> +
>          if (ptr) {
>                  int i;
>
> @@ -701,7 +702,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>                  addr = __alloc_simple_buffer(dev, size, gfp, &page);
>          else if (!(gfp & __GFP_WAIT))
>                  addr = __alloc_from_pool(size, &page);
> -       else if (!IS_ENABLED(CONFIG_DMA_CMA))
> +       else if (!dev_get_cma_area(dev))
>                  addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
>          else
>                  addr = __alloc_from_contiguous(dev, size, prot, &page, caller);
> @@ -790,7 +791,7 @@ static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
>                  __dma_free_buffer(page, size);
>          } else if (__free_from_pool(cpu_addr, size)) {
>                  return;
> -       } else if (!IS_ENABLED(CONFIG_DMA_CMA)) {
> +       } else if (!dev_get_cma_area(dev)) {
>                  __dma_free_remap(cpu_addr, size);
>                  __dma_free_buffer(page, size);
>          } else {
> --
> 1.7.9.5

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
