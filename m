Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaLRTUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:20:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46433 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLRTUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:20:20 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org
Cc: Gregory Fong <gregory.0xf0@gmail.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: cma: add functions for getting allocation info
In-Reply-To: <1418854236-25140-1-git-send-email-gregory.0xf0@gmail.com>
Organization: http://mina86.com/
References: <1418854236-25140-1-git-send-email-gregory.0xf0@gmail.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141218:linux-mm@kvack.org::gXyLtuL0U34vBFwg:000000000000000000000000000000000000000000007ap
X-Hashcash: 1:20:141218:weijie.yang@samsung.com::D58jXhEj9JlLkmxA:000000000000000000000000000000000000000Oyn
X-Hashcash: 1:20:141218:laurent.pinchart+renesas@ideasonboard.com::QHTtmPhT6t7typn6:0000000000000000000023RA
X-Hashcash: 1:20:141218:gregory.0xf0@gmail.com::qK1ZVSNei3cvRIfC:0000000000000000000000000000000000000003nWT
X-Hashcash: 1:20:141218:lauraa@codeaurora.org::HRr6sJEsJJnKViUq:000000000000000000000000000000000000000041/n
X-Hashcash: 1:20:141218:linux-kernel@vger.kernel.org::b0LLhsTUtCuaErtr:0000000000000000000000000000000002yoZ
X-Hashcash: 1:20:141218:aneesh.kumar@linux.vnet.ibm.com::s+w5zZ3WjqiIolKL:0000000000000000000000000000004SQt
X-Hashcash: 1:20:141218:iamjoonsoo.kim@lge.com::yE2vG2h3/CtMyh+R:0000000000000000000000000000000000000005979
X-Hashcash: 1:20:141218:akpm@linux-foundation.org::yLLgCsUvp+Em09Uw:0000000000000000000000000000000000006IKg
X-Hashcash: 1:20:141218:gregory.0xf0@gmail.com::QD7jsKV/BmuJOTo7:00000000000000000000000000000000000000092wz
X-Hashcash: 1:20:141218:m.szyprowski@samsung.com::ANZbl5I0Ttiz/3/8:0000000000000000000000000000000000000IIXF
Date: Thu, 18 Dec 2014 20:20:13 +0100
Message-ID: <xa1th9wssr2q.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17 2014, Gregory Fong <gregory.0xf0@gmail.com> wrote:
> These functions allow for retrieval of information on what is allocated from
> within a given CMA region.  It can be useful to know the number of distinct
> contiguous allocations and where in the region those allocations are located.
>
> Based on an initial version by Marc Carino <marc.ceeeee@gmail.com> in a driver
> that used the CMA bitmap directly; this instead moves the logic into the core
> CMA API.
>
> Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
> ---
> This has been really useful for us to determine allocation information for a
> CMA region.  We have had a separate driver that might not be appropriate for
> upstream, but allowed using a user program to run CMA unit tests to verify that
> allocations end up where they we would expect.  This addition would allow for
> that without needing to expose the CMA bitmap.  Wanted to put this out there to
> see if anyone else would be interested, comments and suggestions welcome.

I don't like it at all.  For example, cma_get_alloc_info has O(n^2)
complexity if one wishes to get information about all allocation.
Furthermore, it's prone to race conditions.  If all you need this for is
debugging and testing, why not have user space parse output of dmesg?
With debug messages enabled, CMA prints ranges it allocated and testing
tool can figure out CMA's behaviour based on that.

>  include/linux/cma.h |  3 ++
>  mm/cma.c            | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 94 insertions(+)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index a93438b..bc676e5 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -25,6 +25,9 @@ extern int __init cma_declare_contiguous(phys_addr_t base,
>  extern int cma_init_reserved_mem(phys_addr_t base,
>  					phys_addr_t size, int order_per_bit,
>  					struct cma **res_cma);
> +extern int cma_get_alloc_info(struct cma *cma, int index, phys_addr_t *base,
> +		phys_addr_t *size);
>  extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
> +extern int cma_get_alloc_count(struct cma *cma);
>  extern bool cma_release(struct cma *cma, struct page *pages, int count);
>  #endif
> diff --git a/mm/cma.c b/mm/cma.c
> index f891762..fc9a04a 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -447,3 +447,94 @@ bool cma_release(struct cma *cma, struct page *pages, int count)
>  
>  	return true;
>  }
> +
> +enum cma_scan_type {
> +	GET_NUM_ALLOCS,
> +	GET_ALLOC_INFO,
> +};
> +
> +struct cma_scan_bitmap_res {
> +	int index;             /* index of allocation (input) */
> +	unsigned long offset;  /* offset into bitmap */
> +	unsigned long size;    /* size in bits */
> +	int num_allocs;        /* number of allocations */
> +};
> +
> +static int cma_scan_bitmap(struct cma *cma, enum cma_scan_type op,
> +		struct cma_scan_bitmap_res *res)
> +{
> +	unsigned long i = 0, pos_head = 0, pos_tail;
> +	int count = 0, head_found = 0;
> +
> +	if (!cma)
> +		return -EFAULT;
> +
> +	/* Count the number of contiguous chunks */
> +	do {
> +		if (head_found) {
> +			pos_tail = find_next_zero_bit(cma->bitmap, cma->count,
> +						      i);
> +
> +			if (op == GET_ALLOC_INFO && count == res->index) {
> +				res->offset = pos_head;
> +				res->size = pos_tail - pos_head;
> +				return 0;
> +			}
> +			count++;
> +
> +			head_found = 0;
> +			i = pos_tail + 1;
> +
> +		} else {
> +			pos_head = find_next_bit(cma->bitmap, cma->count, i);
> +			i = pos_head + 1;
> +			head_found = 1;
> +		}
> +	} while (i < cma->count);
> +
> +	if (op == GET_NUM_ALLOCS) {
> +		res->num_allocs = count;
> +		return 0;
> +	} else {
> +		return -EINVAL;
> +	}
> +}
> +
> +/**
> + * cma_get_alloc_info() - Get info on the requested allocation
> + * @cma:   Contiguous memory region for which the allocation is performed.
> + * @index: Index of the allocation to get info for
> + * @base:  Base address of the allocation
> + * @size:  Size of the allocation in bytes
> + *
> + * Return: 0 on success, negative on failure
> + */
> +int cma_get_alloc_info(struct cma *cma, int index, phys_addr_t *base,
> +		phys_addr_t *size)
> +{
> +	struct cma_scan_bitmap_res res;
> +	int ret;
> +
> +	res.index = index;
> +	ret = cma_scan_bitmap(cma, GET_ALLOC_INFO, &res);
> +	if (ret)
> +		return ret;
> +
> +	*base = cma_get_base(cma) + PFN_PHYS(res.offset << cma->order_per_bit);
> +	*size = PFN_PHYS(res.size << cma->order_per_bit);
> +	return 0;
> +}
> +
> +/**
> + * cma_get_alloc_count() - Get number of allocations
> + * @cma:   Contiguous memory region for which the allocation is performed.
> + *
> + * Return: number of allocations on success, negative on failure
> + */
> +int cma_get_alloc_count(struct cma *cma)
> +{
> +	struct cma_scan_bitmap_res res;
> +	int ret = cma_scan_bitmap(cma, GET_NUM_ALLOCS, &res);
> +
> +	return (ret < 0) ? ret : res.num_allocs;
> +}
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
