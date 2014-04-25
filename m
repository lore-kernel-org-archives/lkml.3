Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaDYF1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:27:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37479 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaDYF1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:27:53 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-8d-5359f256172a
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Steve Capper'" <steve.capper@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
References: <000701cf5adc$1aa35350$4fe9f9f0$@samsung.com>
 <20140423160149.GA2895@linaro.org>
In-reply-to: <20140423160149.GA2895@linaro.org>
Subject: Re: [PATCH v3 6/7] arm64: mm: Implement 4 levels of translation tables
Date: Fri, 25 Apr 2014 14:27:45 +0900
Message-id: <016601cf6047$1917fa20$4b47ee60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEwOLV2T7J4c6AXE+OM9P/BYKiiCgHvV63/nFCWh0A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+ZsW7Yp8hgg6Pb2C3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	55QbLAXHbSseLvjG1sC4S7+LkZNDQsBE4t/0pYwQtpjEhXvr2boYuTiEBJYxSvT//c0CUzRv
	3iZ2iMQiRom+z5NYIJw/jBK/tmxlB6liE9CUeHS3B8wWEdCROHmtjRXEZhboYJboOQA2SUgg
	TmL/6jVgcU4BfYkzU1+C1QsL+EscOXYaaDUHB4uAqsTinwUgYV4BS4mfBw+yQtiCEj8m32OB
	GKklsX7ncSYIW15i85q3zBCHKkjsOPuaEeIEK4m210uh6kUk9r14xwhys4TATA6JLw09YM0s
	AgIS3yYfYgHZKyEgK7HpANQcSYmDK26wTGCUmIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPS
	i0z0ihNzi0vz0vWS83M3MUJSwIQdjPcOWB9iTAZaP5FZSjQ5H5hC8kriDY3NjCxMTUyNjcwt
	zUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcdnMmGcxB+4IsHyI2HjrJEtn
	Yk7Yp+YlIjmGuz5Ld9uKP70c+Mxa7whz6EyG7oeb2Yt3iM8JnsYmMCcnS77ubP0iqZmeW45P
	3DlF1uNNY/hEnRi7v9Iv1u3ynbUqf5vmjlRpuQyBdMb5OSu/vWT6cq9wYozD5quuT/bd8NvI
	99nnb5hd0L8H05RYijMSDbWYi4oTAXFJM8wXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd2wT5HBBg+mMFr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjJ9TbrAUHLeteLjgG1sD4y79LkZODgkBE4l58zaxQ9hi
	EhfurWfrYuTiEBJYxCjR93kSC4Tzh1Hi15atYFVsApoSj+72gNkiAjoSJ6+1sYLYzAIdzBI9
	B1hAbCGBOIn9q9eAxTkF9CXOTH0JVi8s4C9x5NhpoA0cHCwCqhKLfxaAhHkFLCV+HjzICmEL
	SvyYfI8FYqSWxPqdx5kgbHmJzWveMkMcqiCx4+xrRogTrCTaXi+FqheR2PfiHeMERqFZSEbN
	QjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnGCeSe9gXNVgcYhRgINR
	iYd3gmxksBBrYllxZe4hRgkOZiURXuVVQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OBya/
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgVPmzUKBTgfXz
	1U3159edCA80ENVTsRRK/LbtvG6igP3ONWfbch0kHs3fnlrYuOP2LvU3XZ9rDcMuztizn+e0
	yJQAbZf2n9GnUgx2zHz7f98y7gPX+W/8Cz3/7IXk9A1viv3FNuxyqJqX5DyxcdO+sjlrdppY
	JDGsOP7C83f9I4UipYiC7td7OJRYijMSDbWYi4oTAY7MC310AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 1:02 AM, Steve Capper wrote:
> On Fri, Apr 18, 2014 at 04:59:20PM +0900, Jungseok Lee wrote:
> > This patch implements 4 levels of translation tables since 3 levels of
> > page tables with 4KB pages cannot support 40-bit physical address
> > space described in [1] due to the following issue.
> >
> > It is a restriction that kernel logical memory map with 4KB + 3 levels
> > (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
> > 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
> > mapping for this region in map_mem function since __phys_to_virt for
> > this region reaches to address overflow.
> >
> > If SoC design follows the document, [1], over 32GB RAM would be placed
> > from 544GB. Even 64GB system is supposed to use the region from 544GB
> > to 576GB for only 32GB RAM. Naturally, it would reach to enable 4
> > levels of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> >
> > However, it is recommended 4 levels of page table should be only
> > enabled if memory map is too sparse or there is about 512GB RAM.
> 
> Hello Jungseok,
> A few comments can be found inline...

Hi Steve, The comments are very helpful. Thanks.

[ ... ]

> > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S index
> > 0fd5650..f313a7a 100644
> > --- a/arch/arm64/kernel/head.S
> > +++ b/arch/arm64/kernel/head.S
> > @@ -37,8 +37,8 @@
> >
> >  /*
> >   * swapper_pg_dir is the virtual address of the initial page table.
> > We place
> > - * the page tables 3 * PAGE_SIZE below KERNEL_RAM_VADDR. The
> > idmap_pg_dir has
> > - * 2 pages and is placed below swapper_pg_dir.
> > + * the page tables 4 * PAGE_SIZE below KERNEL_RAM_VADDR. The
> > + idmap_pg_dir has
> > + * 3 pages and is placed below swapper_pg_dir.
> >   */
> >  #define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
> >
> > @@ -46,8 +46,8 @@
> >  #error KERNEL_RAM_VADDR must start at 0xXXX80000  #endif
> >
> > -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> > -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> > +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> > +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
> >
> >  	.globl	swapper_pg_dir
> >  	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
> > @@ -371,16 +371,29 @@ ENDPROC(__calc_phys_offset)
> >
> >  /*
> >   * Macro to populate the PGD for the corresponding block entry in the
> > next
> > - * level (tbl) for the given virtual address.
> > + * levels (tbl1 and tbl2) for the given virtual address.
> >   *
> > - * Preserves:	pgd, tbl, virt
> > + * Preserves:	pgd, tbl1, tbl2, virt
> 
> tbl1 and tbl2 are *not* preserved for 4 level. tbl1 is bumped up one page to make space for the pud,
> then fed into create_block_mapping later.

Your logic can be extended to 3 levels.
In an original code, tbl is fed into create_block_mapping.
That is why I've written them down as "preserves".

I will fix it in the next version.

> >   * Corrupts:	tmp1, tmp2
> >   */
> > -	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2
> > +	.macro	create_pgd_entry, pgd, tbl1, tbl2, virt, tmp1, tmp2
> >  	lsr	\tmp1, \virt, #PGDIR_SHIFT
> >  	and	\tmp1, \tmp1, #PTRS_PER_PGD - 1	// PGD index
> > -	orr	\tmp2, \tbl, #3			// PGD entry table type
> > +	orr	\tmp2, \tbl1, #3		// PGD entry table type
> >  	str	\tmp2, [\pgd, \tmp1, lsl #3]
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	ldr	\tbl2, =FIXADDR_TOP
> > +	cmp	\tbl2, \virt
> 
> Do we need this extra logic? See my other comment below where the fixed mapping is placed down.
> 
> > +	add	\tbl2, \tbl1, #PAGE_SIZE
> > +	b.ne	1f
> > +	add	\tbl2, \tbl2, #PAGE_SIZE
> > +1:
> > +	lsr	\tmp1, \virt, #PUD_SHIFT
> > +	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
> > +	orr	\tmp2, \tbl2, #3		// PUD entry table type
> > +	str	\tmp2, [\tbl1, \tmp1, lsl #3]
> > +	mov	\tbl1, \tbl2
> > +#endif
> 
> It may be easier to read to have a create_pud_entry macro too?

Okay. I will write a create_pud_entry macro.

> >  	.endm
> >
> >  /*
> > @@ -444,7 +457,7 @@ __create_page_tables:
> >  	add	x0, x25, #PAGE_SIZE		// section table address
> >  	ldr	x3, =KERNEL_START
> >  	add	x3, x3, x28			// __pa(KERNEL_START)
> > -	create_pgd_entry x25, x0, x3, x5, x6
> > +	create_pgd_entry x25, x0, x1, x3, x5, x6
> >  	ldr	x6, =KERNEL_END
> >  	mov	x5, x3				// __pa(KERNEL_START)
> >  	add	x6, x6, x28			// __pa(KERNEL_END)
> > @@ -455,7 +468,7 @@ __create_page_tables:
> >  	 */
> >  	add	x0, x26, #PAGE_SIZE		// section table address
> >  	mov	x5, #PAGE_OFFSET
> > -	create_pgd_entry x26, x0, x5, x3, x6
> > +	create_pgd_entry x26, x0, x1, x5, x3, x6
> >  	ldr	x6, =KERNEL_END
> >  	mov	x3, x24				// phys offset
> >  	create_block_map x0, x7, x3, x5, x6
> > @@ -480,8 +493,11 @@ __create_page_tables:
> >  	 * Create the pgd entry for the fixed mappings.
> >  	 */
> >  	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
> > -	add	x0, x26, #2 * PAGE_SIZE		// section table address
> > -	create_pgd_entry x26, x0, x5, x6, x7
> > +	add	x0, x26, #PAGE_SIZE
> > +#ifndef CONFIG_ARM64_4_LEVELS
> > +	add	x0, x0, #PAGE_SIZE
> > +#endif
> 
> This is overly complicated. For <4 levels we set x0 to be:
> ttbr1 + 2*PAGE_SIZE. For 4-levels, we set x0 to be ttbr1 + PAGE_SIZE, then inside the create_pgd_entry
> macro, we check the VA for FIXADDR_TOP then add another PAGE_SIZE. This is presumably done so the same
> PUD is used for the swapper block map and the FIXADDR map.
> 
> If you assume that the PUD always follows the PGD for 4-levels, then you can remove this #ifdef and
> the conditional VA logic in set_pgd_entry. To make the logic simpler for <4 levels, you could call
> create_pud_entry in the middle of create_pgd_entry, then put down the actual pgd after.

Okay, I will revise it in an easy and neat way.

> > +	create_pgd_entry x26, x0, x1, x5, x6, x7
> >
> 
> So before this patch we have the following created by
> __create_page_tables:
> 
> +========================+ <--- TEXT_OFFSET + PHYS_OFFSET
> | FIXADDR (pmd or pte)   |
> +------------------------+
> | block map (pmd or pte) |
> +------------------------+
> | PGDs for swapper       |
> +========================+ <--- TTBR1 swapper_pg_dir
> | block map for idmap    |
> +------------------------+
> | PGDs for idmap         |
> +------------------------+ <--- TTBR0 idmap_pg_dir
> 
> 
> After the patch, for 4 levels activated we have:
> +========================+ <--- TEXT_OFFSET + PHYS_OFFSET
> | FIXADDR (ptes)         |
> +------------------------+
> | block map (ptes)       |
> +------------------------+
> | PUDs for swapper       |
> +------------------------+
> | PGDs for swapper       |
> +========================+ <--- TTBR1 swapper_pg_dir
> | block map for idmap    |
> +------------------------+
> | PUDs for idmap         |
> +------------------------+
> | PGDs for idmap         |
> +------------------------+ <--- TTBR0 idmap_pg_dir
> 
> and without 4 levels activated we have:
> +========================+ <--- TEXT_OFFSET + PHYS_OFFSET
> | ZERO BYTES             |
> +------------------------+
> | FIXADDR (pmd or pte)   |
> +------------------------+
> | block map (pmd or pte) |
> +------------------------+
> | PGDs for swapper       |
> +========================+ <--- TTBR1 swapper_pg_dir
> | ZERO BYTES             |
> +------------------------+
> | block map for idmap    |
> +------------------------+
> | PGDs for idmap         |
> +------------------------+ <--- TTBR0 idmap_pg_dir
> 
> This is a pity as we are potentially throwing away 128KB.
> I would recommend only extending the sizes of IDMAP_DIR_SIZE and SWAPPER_DIR_SIZE if necessary.

Yes, you're right.
I will introduce #ifdef statements for their size adjustment.

Best Regards
Jungseok Lee

