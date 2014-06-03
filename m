Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaFCG4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:56:12 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41463 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaFCG4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:56:09 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC PATCH 1/3] CMA: generalize CMA reserved area management functionality
In-Reply-To: <1401757919-30018-2-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1401757919-30018-1-git-send-email-iamjoonsoo.kim@lge.com> <1401757919-30018-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140603:linux-kernel@vger.kernel.org::ygOmb0ri/hIhkPpw:00000000000000000000000000000000007uV
X-Hashcash: 1:20:140603:gregkh@linuxfoundation.org::5bHTdcE70WlcXvAv:000000000000000000000000000000000000LpV
X-Hashcash: 1:20:140603:aneesh.kumar@linux.vnet.ibm.com::825PAsKIeJMTvjig:0000000000000000000000000000000dMC
X-Hashcash: 1:20:140603:akpm@linux-foundation.org::4oB48EFoZdwwZmu3:0000000000000000000000000000000000000Weg
X-Hashcash: 1:20:140603:pbonzini@redhat.com::WmYaGlsoTmWk8cva:0000000000000000000000000000000000000000000pX9
X-Hashcash: 1:20:140603:linux-mm@kvack.org::nBYToyVTSR7kJLRX:00000000000000000000000000000000000000000002A56
X-Hashcash: 1:20:140603:paulus@samba.org::cMlsphLLxo9ERxTn:03IxI
X-Hashcash: 1:20:140603:kvm@vger.kernel.org::Wf4kpJmTQU2dqKmW:0000000000000000000000000000000000000000002U+Z
X-Hashcash: 1:20:140603:kvm-ppc@vger.kernel.org::ihF1XYdkwiAMVsQT:000000000000000000000000000000000000002XLw
X-Hashcash: 1:20:140603:m.szyprowski@samsung.com::1uu18eN4j0DgdCBS:00000000000000000000000000000000000003Cmi
X-Hashcash: 1:20:140603:iamjoonsoo.kim@lge.com::q63dQwxXsNJVpI9U:0000000000000000000000000000000000000004i7v
X-Hashcash: 1:20:140603:linuxppc-dev@lists.ozlabs.org::B2Y53XiAbxtlG6ef:000000000000000000000000000000002R81
X-Hashcash: 1:20:140603:iamjoonsoo.kim@lge.com::XEl6koU40R78+g5c:00000000000000000000000000000000000000038Wl
X-Hashcash: 1:20:140603:agraf@suse.de::8/POYYueEYk/b8Sv:00009b2Y
X-Hashcash: 1:20:140603:minchan@kernel.org::yfKe8F6yRY/fmiTW:00000000000000000000000000000000000000000007g53
X-Hashcash: 1:20:140603:gleb@kernel.org::0UiyOz03xEKHigwB:00EtrA
X-Hashcash: 1:20:140603:linux-arm-kernel@lists.infradead.org::Gum6SITVDjLeKAYn:0000000000000000000000000FLPm
X-Hashcash: 1:20:140603:benh@kernel.crashing.org::HCtn4P5RBSHoHOXY:0000000000000000000000000000000000000Fa2D
X-Hashcash: 1:20:140603:linux@arm.linux.org.uk::Q/1Fnaaec7a75e4N:000000000000000000000000000000000000000HLyX
Date: Tue, 03 Jun 2014 08:56:00 +0200
Message-ID: <xa1tzjhujxbz.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03 2014, Joonsoo Kim wrote:
> Currently, there are two users on CMA functionality, one is the DMA
> subsystem and the other is the kvm on powerpc. They have their own code
> to manage CMA reserved area even if they looks really similar.
> From my guess, it is caused by some needs on bitmap management. Kvm side
> wants to maintain bitmap not for 1 page, but for more size. Eventually it
> use bitmap where one bit represents 64 pages.
>
> When I implement CMA related patches, I should change those two places
> to apply my change and it seem to be painful to me. I want to change
> this situation and reduce future code management overhead through
> this patch.
>
> This change could also help developer who want to use CMA in their
> new feature development, since they can use CMA easily without
> copying & pasting this reserved area management code.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Some small comments below, but in general

Acked-by: Michal Nazarewicz <mina86@mina86.com>

>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> new file mode 100644
> index 0000000..60ba06f
> --- /dev/null
> +++ b/include/linux/cma.h
> @@ -0,0 +1,28 @@
> +/*
> + * Contiguous Memory Allocator
> + *
> + * Copyright LG Electronics Inc., 2014
> + * Written by:
> + *	Joonsoo Kim <iamjoonsoo.kim@lge.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License or (at your optional) any later version of the license.
> + *

Superfluous empty comment line.

Also, I'm not certain whether this copyright notice is appropriate here,
but that's another story.

> + */
> +
> +#ifndef __CMA_H__
> +#define __CMA_H__
> +
> +struct cma;
> +
> +extern struct page *cma_alloc(struct cma *cma, unsigned long count,
> +				unsigned long align);
> +extern bool cma_release(struct cma *cma, struct page *pages,
> +				unsigned long count);
> +extern int __init cma_declare_contiguous(phys_addr_t size, phys_addr_t base,
> +				phys_addr_t limit, phys_addr_t alignment,
> +				unsigned long bitmap_shift, bool fixed,
> +				struct cma **res_cma);
> +#endif

> diff --git a/mm/cma.c b/mm/cma.c
> new file mode 100644
> index 0000000..0dae88d
> --- /dev/null
> +++ b/mm/cma.c
> @@ -0,0 +1,329 @@

> +static int __init cma_activate_area(struct cma *cma)
> +{
> +	int max_bitmapno = cma_bitmap_max_no(cma);
> +	int bitmap_size = BITS_TO_LONGS(max_bitmapno) * sizeof(long);
> +	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
> +	unsigned i = cma->count >> pageblock_order;
> +	struct zone *zone;
> +
> +	pr_debug("%s()\n", __func__);
> +	if (!cma->count)
> +		return 0;

Alternatively:

+	if (!i)
+		return 0;

> +
> +	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> +	if (!cma->bitmap)
> +		return -ENOMEM;
> +
> +	WARN_ON_ONCE(!pfn_valid(pfn));
> +	zone = page_zone(pfn_to_page(pfn));
> +
> +	do {
> +		unsigned j;
> +
> +		base_pfn = pfn;
> +		for (j = pageblock_nr_pages; j; --j, pfn++) {
> +			WARN_ON_ONCE(!pfn_valid(pfn));
> +			/*
> +			 * alloc_contig_range requires the pfn range
> +			 * specified to be in the same zone. Make this
> +			 * simple by forcing the entire CMA resv range
> +			 * to be in the same zone.
> +			 */
> +			if (page_zone(pfn_to_page(pfn)) != zone)
> +				goto err;
> +		}
> +		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
> +	} while (--i);
> +
> +	mutex_init(&cma->lock);
> +	return 0;
> +
> +err:
> +	kfree(cma->bitmap);
> +	return -EINVAL;
> +}

> +static int __init cma_init_reserved_areas(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < cma_area_count; i++) {
> +		int ret = cma_activate_area(&cma_areas[i]);
> +
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

Or even:

static int __init cma_init_reserved_areas(void)
{
	int i, ret = 0;
	for (i = 0; !ret && i < cma_area_count; ++i)
		ret = cma_activate_area(&cma_areas[i]);
	return ret;
}

> +int __init cma_declare_contiguous(phys_addr_t size, phys_addr_t base,
> +				phys_addr_t limit, phys_addr_t alignment,
> +				unsigned long bitmap_shift, bool fixed,
> +				struct cma **res_cma)
> +{
> +	struct cma *cma = &cma_areas[cma_area_count];

Perhaps it would make sense to move this initialisation to the far end
of this function?

> +	int ret = 0;
> +
> +	pr_debug("%s(size %lx, base %08lx, limit %08lx, alignment %08lx)\n",
> +			__func__, (unsigned long)size, (unsigned long)base,
> +			(unsigned long)limit, (unsigned long)alignment);
> +
> +	/* Sanity checks */
> +	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
> +		pr_err("Not enough slots for CMA reserved regions!\n");
> +		return -ENOSPC;
> +	}
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	/*
> +	 * Sanitise input arguments.
> +	 * CMA area should be at least MAX_ORDER - 1 aligned. Otherwise,
> +	 * CMA area could be merged into other MIGRATE_TYPE by buddy mechanism
> +	 * and CMA property will be broken.
> +	 */
> +	alignment >>= PAGE_SHIFT;
> +	alignment = PAGE_SIZE << max3(MAX_ORDER - 1, pageblock_order,
> +						(int)alignment);
> +	base = ALIGN(base, alignment);
> +	size = ALIGN(size, alignment);
> +	limit &= ~(alignment - 1);
> +	/* size should be aligned with bitmap_shift */
> +	BUG_ON(!IS_ALIGNED(size >> PAGE_SHIFT, 1 << cma->bitmap_shift));

cma->bitmap_shift is not yet initialised thus the above line should be:

	BUG_ON(!IS_ALIGNED(size >> PAGE_SHIFT, 1 << bitmap_shift));

> +
> +	/* Reserve memory */
> +	if (base && fixed) {
> +		if (memblock_is_region_reserved(base, size) ||
> +		    memblock_reserve(base, size) < 0) {
> +			ret = -EBUSY;
> +			goto err;
> +		}
> +	} else {
> +		phys_addr_t addr = memblock_alloc_range(size, alignment, base,
> +							limit);
> +		if (!addr) {
> +			ret = -ENOMEM;
> +			goto err;
> +		} else {
> +			base = addr;
> +		}
> +	}
> +
> +	/*
> +	 * Each reserved area must be initialised later, when more kernel
> +	 * subsystems (like slab allocator) are available.
> +	 */
> +	cma->base_pfn = PFN_DOWN(base);
> +	cma->count = size >> PAGE_SHIFT;
> +	cma->bitmap_shift = bitmap_shift;
> +	*res_cma = cma;
> +	cma_area_count++;
> +
> +	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> +		(unsigned long)base);

Doesn't this message end up being: “cma: CMA: reserved …”? pr_fmt adds
“cma:” at the beginning, doesn't it?  So we should probably drop “CMA:”
here.

> +
> +	return 0;
> +
> +err:
> +	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
> +	return ret;
> +}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
