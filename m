Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaDOAab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:30:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30225 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaDOAa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:30:29 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-47-534c7da20162
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
 <20140414151333.GA29654@linaro.org>
In-reply-to: <20140414151333.GA29654@linaro.org>
Subject: Re: [PATCH 7/8] arm64: mm: Implement 4 levels of translation tables
Date: Tue, 15 Apr 2014 09:30:26 +0900
Message-id: <001501cf5841$e58f5c50$b0ae14f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQILdni68u70DkxPk4mJeDBA1L/NRAGceXZlmoym5NA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zse6iWp9gg0uLLCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	xVv7gtY2xopdzyawNTD2ZHYxcnJICJhIHLl1hBXCFpO4cG89WxcjF4eQwDJGiRmr1rHDFC1b
	tZUJIjGdUWLj5a9gHUICfxglJuyMB7HZBDQlHt3tAWsQEdCROHmtjRWkgVmgg1niRt9SJoiG
	eIkV/+6A2ZwCBhIzptwEs4UFfCRuLv8C1swioCrxa+t3MJtXwFJi388zbBC2oMSPyfdYQGxm
	AS2J9TuPM0HY8hKb17xlhrhUQWLH2deMEEdYSbSvPcwKUSMise/FO0aQgyQE5nJIbJy5E2qZ
	gMS3yYeAhnIAJWQlNh2AmiMpcXDFDZYJjBKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqR
	qV5xYm5xaV66XnJ+7iZGSBKYuIPx/gHrQ4zJQOsnMkuJJucDk0heSbyhsZmRhamJqbGRuaUZ
	acJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCGCdgZJacHch7+YC4nkrdR/dCs
	pAPhxQ/npi1cL7TxYfLv6zft13xPvhv7Ypng3GZjF95J65Z387i9SPNd5HBg4mRXttellv+P
	yp59ET2pxvfZ/sVl/6beW6ghOvPTH5Pgw8ycHx8sXcxyRdC0P+1dyiH567cnL7se3FHql/9U
	+1HB7CvKIUvMlFiKMxINtZiLihMBZYosFBgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQd1FtT7BBg+uG1j8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjBdv7Qta2xgrdj2bwNbA2JPZxcjJISFgIrFs1VYmCFtM
	4sK99WxdjFwcQgLTGSU2Xv7KCpIQEvjDKDFhZzyIzSagKfHobg87iC0ioCNx8lobK0gDs0AH
	s8SNvqVMEA3xEiv+3QGzOQUMJGZMuQlmCwv4SNxc/gWsmUVAVeLX1u9gNq+ApcS+n2fYIGxB
	iR+T77GA2MwCWhLrdx5ngrDlJTavecsMcamCxI6zrxkhjrCSaF97mBWiRkRi34t3jBMYhWYh
	GTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwinkmvYNxVYPFIUYB
	DkYlHt4J77yDhVgTy4orcw8xSnAwK4nwvk72CRbiTUmsrEotyo8vKs1JLT7EmAz06URmKdHk
	fGD6yyuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRu1m33lS
	3u9LsreYn11hLLH5auz3T7JOBSsbT7u1xc9Sv/CpXu3ljoIOmfp1Sc1f73SoSMhIs649tach
	5dCmUoOXVxIkSy1E77yO4Zox6dhppuKXGlHnHq+/tHyxo4dT8B6HkkkLjBZHeiXpLDyyKfAG
	m6fa5zabSfFvjl/6FdS3Z/Hn69fyOpRYijMSDbWYi4oTAf2onkd1AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 12:14 AM, Steve Capper wrote:
> On Mon, Apr 14, 2014 at 04:41:07PM +0900, Jungseok Lee wrote:
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
> >
> > References
> > ----------
> > [1]: Principle of ARM Memory Maps, White Paper, Issue C
> >
> 
> Hi Jungseok,
> I've given this a quick run on the Fast Model with huge pages, and it passed the libhugetlbfs test
> suite.

It sounds good.

> Some comments/suggestions below...

I really thank you.

> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm64/Kconfig                     |    7 +++++
> >  arch/arm64/include/asm/page.h          |    4 ++-
> >  arch/arm64/include/asm/pgalloc.h       |   20 ++++++++++++++
> >  arch/arm64/include/asm/pgtable-hwdef.h |    8 ++++--
> >  arch/arm64/include/asm/pgtable.h       |   44 +++++++++++++++++++++++++++++--
> >  arch/arm64/include/asm/tlb.h           |    8 ++++++
> >  arch/arm64/kernel/head.S               |   45 ++++++++++++++++++++++++++++++--
> >  arch/arm64/kernel/traps.c              |    5 ++++
> >  arch/arm64/mm/fault.c                  |    1 +
> >  arch/arm64/mm/mmu.c                    |   14 +++++++++-
> >  10 files changed, 148 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig index
> > 431acbc..7f5270b 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -184,12 +184,19 @@ config ARM64_3_LEVELS
> >  	help
> >  	  This feature enables 3 levels of translation tables.
> >
> > +config ARM64_4_LEVELS
> > +	bool "4 level"
> > +	depends on ARM64_4K_PAGES
> > +	help
> > +	  This feature enables 4 levels of translation tables.
> > +
> >  endchoice
> >
> >  config ARM64_VA_BITS
> >  	int "Virtual address space size"
> >  	range 39 39 if ARM64_4K_PAGES && ARM64_3_LEVELS
> >  	range 42 42 if ARM64_64K_PAGES && ARM64_2_LEVELS
> > +	range 48 48 if ARM64_4K_PAGES && ARM64_4_LEVELS
> >  	help
> >  	  This feature is determined by a combination of page size and
> >  	  level of translation tables.
> > diff --git a/arch/arm64/include/asm/page.h
> > b/arch/arm64/include/asm/page.h index 268e53d..83b5289 100644
> > --- a/arch/arm64/include/asm/page.h
> > +++ b/arch/arm64/include/asm/page.h
> > @@ -35,8 +35,10 @@
> >
> >  #ifdef CONFIG_ARM64_2_LEVELS
> >  #include <asm/pgtable-2level-types.h> -#else
> > +#elif defined(CONFIG_ARM64_3_LEVELS)
> >  #include <asm/pgtable-3level-types.h>
> > +#else
> > +#include <asm/pgtable-4level-types.h>
> >  #endif
> >
> >  extern void __cpu_clear_user_page(void *p, unsigned long user); diff
> > --git a/arch/arm64/include/asm/pgalloc.h
> > b/arch/arm64/include/asm/pgalloc.h
> > index 4829837..8d745fa 100644
> > --- a/arch/arm64/include/asm/pgalloc.h
> > +++ b/arch/arm64/include/asm/pgalloc.h
> > @@ -26,6 +26,26 @@
> >
> >  #define check_pgt_cache()		do { } while (0)
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +
> > +static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned
> > +long addr) {
> > +	return (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT); }
> > +
> > +static inline void pud_free(struct mm_struct *mm, pud_t *pud) {
> > +	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
> > +	free_page((unsigned long)pud);
> > +}
> > +
> > +static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd,
> > +pud_t *pud) {
> > +	set_pgd(pgd, __pgd(__pa(pud) | PUD_TYPE_TABLE));
> 
> Perhaps instead use PGD_TYPE_TABLE?

pud_populate uses PMD_TYPE_TABLE. That is why I choose PUD_TYPE_TABLE
instead of PGD_TYPE_TABLE.

> > +}
> > +
> > +#endif  /* CONFIG_ARM64_4_LEVELS */
> > +
> >  #ifndef CONFIG_ARM64_2_LEVELS
> >
> >  static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned
> > long addr) diff --git a/arch/arm64/include/asm/pgtable-hwdef.h
> > b/arch/arm64/include/asm/pgtable-hwdef.h
> > index 9cd86c6..03ad81b 100644
> > --- a/arch/arm64/include/asm/pgtable-hwdef.h
> > +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> > @@ -18,8 +18,10 @@
> >
> >  #ifdef CONFIG_ARM64_2_LEVELS
> >  #include <asm/pgtable-2level-hwdef.h> -#else
> > +#elif defined(CONFIG_ARM64_3_LEVELS)
> >  #include <asm/pgtable-3level-hwdef.h>
> > +#else
> > +#include <asm/pgtable-4level-hwdef.h>
> >  #endif
> >
> >  /*
> > @@ -27,7 +29,9 @@
> >   *
> >   * Level 1 descriptor (PUD).
> >   */
> > -
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +#define PUD_TYPE_TABLE		(_AT(pudval_t, 3) << 0)
> 
> I would be tempted to instead define:
>  +#define PGD_TYPE_TABLE		(_AT(pgdval_t, 3) << 0)
> And have that under "Level 0 descriptor (PGD)". There shouldn't be any need for an #ifdef block.

In fact, #ifdef block can be removed without any changes because only
pud_populate function this macro. I will remove it in the next version.

> > +#endif
> >  #define PUD_TABLE_BIT		(_AT(pgdval_t, 1) << 1)
> >
> >  /*
> > diff --git a/arch/arm64/include/asm/pgtable.h
> > b/arch/arm64/include/asm/pgtable.h
> > index a64ce5e..713811d 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -35,7 +35,11 @@
> >   * VMALLOC and SPARSEMEM_VMEMMAP ranges.
> >   */
> >  #define VMALLOC_START		(UL(0xffffffffffffffff) << VA_BITS)
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  #define VMALLOC_END		(PAGE_OFFSET - UL(0x400000000) - SZ_64K)
> > +#else
> > +#define VMALLOC_END		(PAGE_OFFSET - UL(0x40000000000) - SZ_64K)
> 
> Can we not compute VMALLOC_END explicitly based on VA bits, rather than have these constants?

The constants come from vmemmap size including future use (8GB+8GB).
I don't change it since I cannot catch up why constant is used instead of macro.
I think that Catalin's comment is needed at this point.

> > +#endif
> >
> >  #define vmemmap			((struct page *)(VMALLOC_END + SZ_64K))
> >
> > @@ -44,12 +48,16 @@
> >  #ifndef __ASSEMBLY__
> >  extern void __pte_error(const char *file, int line, unsigned long
> > val);  extern void __pmd_error(const char *file, int line, unsigned
> > long val);
> > +extern void __pud_error(const char *file, int line, unsigned long
> > +val);
> >  extern void __pgd_error(const char *file, int line, unsigned long
> > val);
> >
> >  #define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
> >  #ifndef CONFIG_ARM64_2_LEVELS
> >  #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
> >  #endif
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +#define pud_ERROR(pud)		__pud_error(__FILE__, __LINE__, pud_val(pud))
> > +#endif
> >  #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
> >
> >  /*
> > @@ -344,6 +352,30 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
> >
> >  #endif	/* CONFIG_ARM64_2_LEVELS */
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +
> > +#define pgd_none(pgd)		(!pgd_val(pgd))
> > +#define pgd_bad(pgd)		(!(pgd_val(pgd) & 2))
> > +#define pgd_present(pgd)	(pgd_val(pgd))
> > +
> > +static inline void set_pgd(pud_t *pgdp, pud_t pgd)
> 
> The types are incorrect, this will generate a compile error if you enable STRICT_MM_TYPECHECKS.

You're right. I will fix it.

> > +{
> > +	*pgdp = pgd;
> > +	dsb();
> > +}
> > +
> > +static inline void pgd_clear(pgd_t *pgdp) {
> > +	set_pgd(pgdp, __pgd(0));
> > +}
> > +
> > +static inline pud_t *pgd_page_vaddr(pgd_t pgd) {
> > +	return __va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK); }
> > +
> > +#endif  /* CONFIG_ARM64_4_LEVELS */
> > +
> >  /* to find an entry in a page-table-directory */
> >  #define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
> >
> > @@ -352,6 +384,14 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
> >  /* to find an entry in a kernel page-table-directory */
> >  #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +#define pud_index(addr)		(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> > +static inline pud_t *pud_offset(pgd_t *pgd, unsigned long addr) {
> > +	return (pud_t *)pgd_page_vaddr(*pgd) + pud_index(addr); } #endif
> > +
> >  /* Find an entry in the second-level page table.. */  #ifndef
> > CONFIG_ARM64_2_LEVELS
> >  #define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
> > @@ -380,8 +420,8 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t
> > newprot)  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];  extern pgd_t
> > idmap_pg_dir[PTRS_PER_PGD];
> >
> > -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> > -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> > +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> > +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
> 
> This change also affects <4 levels of paging too?

You're right.

An original code can cover 2 levels as allocating 3 * PAGE_SIZE.
My intention is to avoid #ifdef block since additional use of 4KB or
64KB is not critical under 64-bit system which might have enough RAM.
If not, however, it would be good to add #ifdef block.

Please correct me if I am wrong.

> >
> >  /*
> >   * Encode and decode a swap entry:
> > diff --git a/arch/arm64/include/asm/tlb.h
> > b/arch/arm64/include/asm/tlb.h index df378b2..dedfb04 100644
> > --- a/arch/arm64/include/asm/tlb.h
> > +++ b/arch/arm64/include/asm/tlb.h
> > @@ -99,5 +99,13 @@ static inline void __pmd_free_tlb(struct mmu_gather
> > *tlb, pmd_t *pmdp,  }  #endif
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +static inline void __pud_free_tlb(struct mmu_gather *tlb, pmd_t *pudp,
> > +				  unsigned long addr)
> > +{
> > +	tlb_add_flush(tlb, addr);
> > +	tlb_remove_page(tlb, virt_to_page(pudp)); } #endif
> >
> >  #endif
> > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S index
> > 0fd5650..0b0b16a 100644
> > --- a/arch/arm64/kernel/head.S
> > +++ b/arch/arm64/kernel/head.S
> 
> A comment above this line needs to also be changed?
> 
> > @@ -46,8 +46,8 @@
> >  #error KERNEL_RAM_VADDR must start at 0xXXX80000  #endif
> >
> > -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> > -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> > +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> > +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
> 
> Again, this affects <4 levels of paging.

Please refer to the above comment.

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
> 
> So we essentially need an extra page for PUD mappings for both the idmap and swapper mappings. Could
> the logic of create_pgd_entry be adapted to call create_pud_entry for 4levels? That way a lot of
> #ifdefs can be eliminated.

You're right. I will revise it.

> >
> >  	/*
> >  	 * Since the page tables have been populated with non-cacheable diff
> > --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c index
> > 0484e81..16d5ee5 100644
> > --- a/arch/arm64/kernel/traps.c
> > +++ b/arch/arm64/kernel/traps.c
> > @@ -336,6 +336,11 @@ void __pmd_error(const char *file, int line, unsigned long val)
> >  	pr_crit("%s:%d: bad pmd %016lx.\n", file, line, val);  }
> >
> > +void __pud_error(const char *file, int line, unsigned long val) {
> > +	pr_crit("%s:%d: bad pud %016lx.\n", file, line, val); }
> > +
> >  void __pgd_error(const char *file, int line, unsigned long val)  {
> >  	pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val); diff --git
> > a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c index c23751b..ed4a343
> > 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -61,6 +61,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
> >  			break;
> >
> >  		pud = pud_offset(pgd, addr);
> > +		printk(", *pud=%016llx", pud_val(*pud));
> >  		if (pud_none(*pud) || pud_bad(*pud))
> >  			break;
> >
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c index
> > 6b7e895..321f569 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -222,9 +222,17 @@ static void __init alloc_init_pmd(pud_t *pud,
> > unsigned long addr,  static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
> >  				  unsigned long end, unsigned long phys)  {
> > -	pud_t *pud = pud_offset(pgd, addr);
> > +	pud_t *pud;
> >  	unsigned long next;
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	if (pgd_none(*pgd) || pgd_bad(*pgd)) {
> > +		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
> > +		pgd_populate(&init_mm, pgd, pud);
> > +	}
> > +#endif
> 
> We don't need this #ifdef block, as pgd_none and pgd_bad should be zero when we have fewer than 4
> levels.
> > +
> > +	pud = pud_offset(pgd, addr);
> >  	do {
> >  		next = pud_addr_end(addr, end);
> >  		alloc_init_pmd(pud, addr, next, phys); @@ -274,7 +282,11 @@ static
> > void __init map_mem(void)
> >  	 * gives us PGDIR_SIZE memory starting from PHYS_OFFSET (which must be
> >  	 * aligned to 2MB as per Documentation/arm64/booting.txt).
> >  	 */
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	limit = PHYS_OFFSET + PGDIR_SIZE;
> > +#else
> > +	limit = PHYS_OFFSET + PUD_SIZE;
> > +#endif
> 
> I think it would be better to define a constant like MEMBLOCK_INITIAL_LIMIT, then define that per page
> level. That way the ifdef block can be avoided and the intent of the code is a little clearer too.

Since only 1GB is available in case of 4KB page system, we can change it neatly as
introducing a new #define statement.

I will define it in the next version.

Best Regards
Jungseok Lee

