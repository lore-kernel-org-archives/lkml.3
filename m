Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaDNJZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:25:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27374 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaDNJY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:24:57 -0400
X-AuditID: cbfee690-b7f266d00000287c-66-534ba9670234
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Steve Capper'" <steve.capper@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        kgene.kim@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
References: <000501cf57b4$e57e8e80$b07bab80$@samsung.com>
 <20140414091424.GA14204@linaro.org>
In-reply-to: <20140414091424.GA14204@linaro.org>
Subject: Re: [PATCH 7/8] arm64: mm: Implement 4 levels of translation tables
Date: Mon, 14 Apr 2014 18:24:55 +0900
Message-id: <000c01cf57c3$65afc110$310f4330$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQILdni68u70DkxPk4mJeDBA1L/NRAHzx3Zxmoj5pSA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+ZsW76Su9ggyvTdCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	w54brAUXNSpurp7E2sA4Sb6LkZNDQsBE4smBT4wQtpjEhXvr2boYuTiEBJYxSrx/uJ0Vpujg
	7utMEIlFjBKN075AOX8YJSbd+soEUsUmoCnx6G4PO4gtIqAjcfJaGytIEbNAB7PEjb6lYEVC
	AvESyy82g43lFDCQONj3kwXEFhbwkbi5/AtYM4uAqsSGyRPBbuIVsJQ4u6oFyhaU+DH5Hlg9
	s4CWxPqdx5kgbHmJzWveMkOcqiCx4+xrRogjrCSunrvFClEjIrHvxTtGkIMkBOZySOxuvskI
	sUxA4tvkQ0BDOYASshKbDkDNkZQ4uOIGywRGiVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgp
	vchErzgxt7g0L10vOT93EyMkDUzYwXjvgPUhxmSg9ROZpUST84FpJK8k3tDYzMjC1MTU2Mjc
	0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGAU06r7sfKMuWSG8fnKk8r37
	ZZe+PM96fH3/9UPFU305ww86S+XoWR9QVbU1tf4/l7+IN5zX/zOTSsC2vrS1So0cNw4z1Kcq
	tzhrfrXYtPTN8QzeNbs2OpnPttV1mmT2vGO53baf9j93sM8QMmksaHljP/H3HY5z+6+q/mxz
	2MHkNKHtRSinkRJLcUaioRZzUXEiACrWRK8ZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd30ld7BBh071Sz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxoc9N1gLLmpU3Fw9ibWBcZJ8FyMnh4SAicTB3deZIGwx
	iQv31rN1MXJxCAksYpRonPaFCcL5wygx6dZXsCo2AU2JR3d72EFsEQEdiZPX2lhBipgFOpgl
	bvQtBSsSEoiXWH6xmRXE5hQwkDjY95MFxBYW8JG4ufwLWDOLgKrEhskTGUFsXgFLibOrWqBs
	QYkfk++B1TMLaEms33mcCcKWl9i85i0zxKkKEjvOvmaEOMJK4uq5W6wQNSIS+168Y5zAKDQL
	yahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCk8wzqR2MKxssDjEK
	cDAq8fB2zPEOFmJNLCuuzD3EKMHBrCTCuy3DK1iINyWxsiq1KD++qDQntfgQYzLQpxOZpUST
	84EJMK8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGENn3ArY
	f2riikLO1EdpGjUObYdYrsUf0TJ9ppnQL+Sk7r3cVXdC0LcLvkm659unppsqsZzk0yyTXXlh
	m/yx0z/0DryJzjykOvdtFkvAjFKmqhl/SlLF39iV/2dKuOex51rN6sWMXLFz6yp2MC+unxF4
	JOxA1AK+iXsq9kUuYg8LLc1PW5rVr8RSnJFoqMVcVJwIAKV211Z2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 14, 2014 6:14 PM, Steve Capper wrote:
> On Mon, Apr 13, 2014 at 04:41:07PM +0900, Jungseok Lee wrote:
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
> Hi,
> So I thought I'd apply this series and have a play, this patch doesn't apply cleanly for me, please
> see below why...

This pathset is based on 3.15-rc1.

> [ ... ]
> 
> > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S index
> > 0fd5650..0b0b16a 100644
> > --- a/arch/arm64/kernel/head.S
> > +++ b/arch/arm64/kernel/head.S
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
> > @@ -384,6 +384,20 @@ ENDPROC(__calc_phys_offset)
> >  	.endm
> >
> >  /*
> > + * Macro to populate the PUD for the corresponding block entry in the
> > +next
> > + * level (tbl) for the given virtual address.
> > + *
> > + * Preserves:	pud, tbl, virt
> > + * Corrupts:	tmp1, tmp2
> > + */
> > +	.macro create_pud_entry, pud, tbl, virt, tmp1, tmp2
> > +	lsr	\tmp1, \virt, #PUD_SHIFT
> > +	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
> > +	orr	\tmp2, \tbl, #3			// PUD entry table type
> > +	str	\tmp2, [\pud, \tmp1, lsl #3]
> > +	.endm
> > +
> > +/*
> >   * Macro to populate block entries in the page table for the start..end
> >   * virtual range (inclusive).
> >   *
> > @@ -445,10 +459,18 @@ __create_page_tables:
> >  	ldr	x3, =KERNEL_START
> >  	add	x3, x3, x28			// __pa(KERNEL_START)
> 
> I don't think we have C++ style comments in the kernel. Also, I can't see any references to
> =KERNEL_START in arch/arm64/kernel/head.S (from 3.14 down).

C++ style comments are prevalent in arch/arm64/kernel/head.S. I've followed the
code style written previously.

You can see this change in the commit, ea8c2e1124457f266f82effc3e6558552527943a).
It's title is "arm64: Extend the idmap to the whole kernel image".

> >  	create_pgd_entry x25, x0, x3, x5, x6
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	add	x1, x0, #PAGE_SIZE
> > +	create_pud_entry x0, x1, x3, x5, x6
> > +#endif
> >  	ldr	x6, =KERNEL_END
> >  	mov	x5, x3				// __pa(KERNEL_START)
> >  	add	x6, x6, x28			// __pa(KERNEL_END)
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	create_block_map x0, x7, x3, x5, x6
> > +#else
> > +	create_block_map x1, x7, x3, x5, x6
> > +#endif
> >
> >  	/*
> >  	 * Map the kernel image (starting with PHYS_OFFSET).
> > @@ -456,9 +478,17 @@ __create_page_tables:
> >  	add	x0, x26, #PAGE_SIZE		// section table address
> >  	mov	x5, #PAGE_OFFSET
> >  	create_pgd_entry x26, x0, x5, x3, x6
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	add	x1, x0, #PAGE_SIZE
> > +	create_pud_entry x0, x1, x3, x5, x6
> > +#endif
> >  	ldr	x6, =KERNEL_END
> >  	mov	x3, x24				// phys offset
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	create_block_map x0, x7, x3, x5, x6
> > +#else
> > +	create_block_map x1, x7, x3, x5, x6
> > +#endif
> >
> >  	/*
> >  	 * Map the FDT blob (maximum 2MB; must be within 512MB of @@ -474,14
> > +504,25 @@ __create_page_tables:
> >  	add	x5, x5, x6			// __va(FDT blob)
> >  	add	x6, x5, #1 << 21		// 2MB for the FDT blob
> >  	sub	x6, x6, #1			// inclusive range
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	create_block_map x0, x7, x3, x5, x6
> > +#else
> > +	create_block_map x1, x7, x3, x5, x6
> > +#endif
> >  1:
> >  	/*
> >  	 * Create the pgd entry for the fixed mappings.
> >  	 */
> >  	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	add	x0, x26, #2 * PAGE_SIZE		// section table address
> >  	create_pgd_entry x26, x0, x5, x6, x7
> > +#else
> > +	add	x0, x26, #PAGE_SIZE
> > +	create_pgd_entry x26, x0, x5, x6, x7
> > +	add	x1, x0, #2 * PAGE_SIZE
> > +	create_pud_entry x0, x1, x5, x6, x7
> > +#endif
> >
> >  	/*
> >  	 * Since the page tables have been populated with non-cacheable
> 
> What tree is this series based on?

This series is based on 3.15-rc1.

Thanks
Jungseok Lee

