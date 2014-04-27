Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaD0Dho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 23:37:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22419 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaD0Dhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 23:37:41 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-60-535c7b83e86e
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
Date: Sun, 27 Apr 2014 12:37:35 +0900
Message-id: <000f01cf61ca$099017c0$1cb04740$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEwOLV2T7J4c6AXE+OM9P/BYKiiCgHvV63/nFOcTGA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zvm5zdUywwc1eYYu/k46xW7xf1sNo
	8eL1P0aLo/8WMlr0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBZ/7/xjs1gxbxmbxYcZKxkd
	eDzWzFvD6PH71yRGjzvX9rB5nN+0htlj85J6j74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4MrY
	fPk/a8F0i4rOv5oNjPO0uxg5OSQETCQ+XZ3MCmGLSVy4t56ti5GLQ0hgGaPEuaU7mWGKrrzd
	yQqRWMQo8fXrDXYI5w+jxIT/38Da2QQ0JR7d7WEHsUUEdCROXmsDizMLdDBL9BxgAbGFBOIk
	9q9eAxbnFNCXODP1JVi9sIC/xJFjp4FWc3CwCKhKNN/jAzF5BSwldm9OAangFRCU+DH5HgvE
	RC2J9TuPM0HY8hKb17yFulNBYsfZ14wgrSICVhKtXcUQJSIS+168YwS5WEJgLofE1S8fweaw
	CAhIfJt8iAWkXkJAVmLTAagxkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCel
	FxnqFSfmFpfmpesl5+duYoREf+8OxtsHrA8xJgOtn8gsJZqcD0weeSXxhsZmRhamJqbGRuaW
	ZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqPTWn8fo6vusK6cjZ/lFNlUq
	ztoxh/XZ6sMsS/u8+KPey0764Xeq3fFUYhSL/VHhm3m3aqqfCLL922AU1pxqWV561KP3j+8U
	jsuX3Cb+n2Yp/1bgQ78fs09WfPYpPQGOj7qe2gLFM2Ln5vw6/TbD2GTinsiL9lb773+p35Y5
	u9hzxpcXm0svKrEUZyQaajEXFScCAA2w6ogUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAd3m6phgg09NvBZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4xY/Pl/6wF0y0qOv9qNjDO0+5i5OSQEDCRuPJ2JyuELSZx
	4d56ti5GLg4hgUWMEl+/3mCHcP4wSkz4/w2sik1AU+LR3R52EFtEQEfi5LU2sDizQAezRM8B
	FhBbSCBOYv/qNWBxTgF9iTNTX4LVCwv4Sxw5dhpoAwcHi4CqRPM9PhCTV8BSYvfmFJAKXgFB
	iR+T77FATNSSWL/zOBOELS+xec1bZog7FSR2nH3NCNIqImAl0dpVDFEiIrHvxTvGCYxCs5BM
	moVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi1PJPawbiyweIQowAH
	oxIP7wLJmGAh1sSy4srcQ4wSHMxKIrydXkAh3pTEyqrUovz4otKc1OJDjMlAb05klhJNzgem
	vbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYDRepHv6SGj1
	4hOflN+I/GkIurqOiXX7/BAL7rsHDzBdyhas3ZM9U8CBM4L5FMfvyzdmdQfsSQmtPDHvQmnV
	nF0ej68cvHaDl+Pzgwu2W7z33/p35qnEkjv+j/PuBF55ar3k9X2vmRezWFOtNxSenSz0LaFJ
	TVs2zOxTVoZAYNDiwq4zTnPP30tTYinOSDTUYi4qTgQAo66fDnEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 1:02 AM, Steve Capper wrote:
> On Fri, Apr 18, 2014 at 04:59:20PM +0900, Jungseok Lee wrote:

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
> 
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
> 
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

Is it too complicated to understand the logic?

1) For <4 levels:
PAGE_SIZE is added for FIXADDR map and x0 is passed to create pgd entry.
2) For =4 levels:
PAGE_SIZE is added in the create_pgd_entry macro since FIXADDR map info
is needed to create pud entry.

However, I agree that the code should be revised if other people feel
like it is a labyrinthine logic.

> If you assume that the PUD always follows the PGD for 4-levels, then you can remove this #ifdef and
> the conditional VA logic in set_pgd_entry. To make the logic simpler for <4 levels, you could call
> create_pud_entry in the middle of create_pgd_entry, then put down the actual pgd after.

create_pud_entry should distinguish block map from FIXADDR map although
PUD always follows the PGD in case of 4 levels. If we would like to avoid
unnecessary #ifdef, the conditional logic should be introduced in create_
pgd_entry macro.

I cannot find the "best" way even though I've tried to figure it out.
I would like to find out the most clear and self-descriptive expression.

Could you give an idea on how to remove both conditional VA logic and #ifdef?

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

This is definitely helpful to understand head.S.
It would be good to add these figures to Documentation or comments.

Best Regards
Jungseok Lee

