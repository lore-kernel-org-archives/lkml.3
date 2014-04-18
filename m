Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaDRDmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:42:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27434 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaDRDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:42:45 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-9c-53509f334c2a
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Marc Zyngier'" <marc.zyngier@arm.com>
Cc: "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        sungjinn.chung@samsung.com, kvmarm@lists.cs.columbia.edu,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>
References: <004701cf592d$053b3380$0fb19a80$@samsung.com>
 <878ur4w3vu.fsf@approximate.cambridge.arm.com>
In-reply-to: <878ur4w3vu.fsf@approximate.cambridge.arm.com>
Subject: Re: [PATCH v2 7/7] arm64: KVM: Implement 4 levels of translation
 tables for HYP and stage2
Date: Fri, 18 Apr 2014 12:42:42 +0900
Message-id: <000b01cf5ab8$412a0970$c37e1c50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJiudm0SdQDtk5M1eTkkNJpzvYu2QDZMvSFmekxwVA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zka7x/IBgg3WrJC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	/PKFTAWfPSpaOqYzNzB2WHQxcnBICJhInN3g28XICWSKSVy4t56ti5GLQ0hgGaPEhOYnzBAJ
	E4nt54+zQCQWMUosafnICOH8YZSY2LuNHaSKTUBT4tHdHjBbBMj+2PMUbBSzQA+zxI/Tx1hA
	EkICWRIbGy8zgticAtYSP458B4sLC6RKLPl/lR3kJBYBVYnb/8Hm8ApYStyYfYIZwhaU+DH5
	Hlg5s4CWxPqdx5kgbHmJzWveQl2qILHj7GtGiBusJLZt+c4KUSMise/FO0aImrkcEk33jUBs
	FgEBiW+TD7FAQkJWYtMBqDGSEgdX3GCZwCgxC8nmWUg2z0KyeRaSDQsYWVYxiqYWJBcUJ6UX
	GeoVJ+YWl+al6yXn525ihCSA3h2Mtw9YH2JMBlo/kVlKNDkfmEDySuINjc2MLExNTI2NzC3N
	SBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRrdzW5zjT17b8m8nPjh+MZN7B
	+uJV2PHP1bMTtz6fMHOtf0Wu8ltj6yUyb1rYIw+8up4Tu+dIw/tHTLX3HH4ILf2g0+7NuNTy
	cMHp0D32mx//9GM1PxEeGpL76K7u4lSdrhP/F3oIzbrt9enQ3/MnzNzc698Hfzu7X1DSwK31
	9dE/53exed4yUWIpzkg01GIuKk4EAFpt49UWAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAV3j+QHBBhN/CFn8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjPPLFzIVfPaoaOmYztzA2GHRxcjJISFgIrH9/HEWCFtM
	4sK99WxdjFwcQgKLGCWWtHxkhHD+MEpM7N3GDlLFJqAp8ehuD5gtAmR/7HkK1sEs0MMs8eP0
	MbBRQgJZEhsbLzOC2JwC1hI/jnwHiwsLpEos+X8VqJmDg0VAVeL2f7A5vAKWEjdmn2CGsAUl
	fky+B1bOLKAlsX7ncSYIW15i85q3zBCXKkjsOPuaEeIGK4ltW76zQtSISOx78Y5xAqPQLCSj
	ZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4xz6R3MK5qsDjEKMDB
	qMTDe+Grf7AQa2JZcWXuIUYJDmYlEV7l0oBgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4H
	pr+8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDMu7lhWqrU
	GYOPejWu080qN2y5/uWB16lTynt5hLetc3K7ELc15N+FGd9DxGQXvmif8D3t0uen+8pF5jzK
	qDS9H2X+6vbXVVlLj6u7sEZ6Gd8wPtVy727ku18fhX9OW/lpl1uUxG6dnN1vb0SrTpp0POdX
	hdJhfx6N/tsPb7o9MHmunHg4xemzgRJLcUaioRZzUXEiAA2xq7B1AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 17, 2014 9:13 PM, Marc Zyngier wrote:
> On Wed, Apr 16 2014 at  5:33:31 am BST, Jungseok Lee <jays.lee@samsung.com> wrote:
> > This patch adds 4 levels of translation tables implementation for both
> > HYP and stage2. A combination of 4KB + 4 levels host and 4KB + 4
> > levels guest can run on ARMv8 architecture as introducing this feature.
> 
> Just to be sure: have you tested it with asymetric configurations (4kB host, 64kB guest, and the
> oposite configuration)?

Dear Marc

Yes, I've tested all asymmetric configurations using 4K+3Level, 4K+4Level
and 64K+2Level. I will add all test configurations in the commit message
from the next version.

> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm/include/asm/kvm_mmu.h   |   10 +++++
> >  arch/arm/kvm/mmu.c               |   88 +++++++++++++++++++++++++++++++++-----
> >  arch/arm64/include/asm/kvm_arm.h |   20 +++++++++
> >  arch/arm64/include/asm/kvm_mmu.h |   10 +++++
> >  4 files changed, 117 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm/include/asm/kvm_mmu.h
> > b/arch/arm/include/asm/kvm_mmu.h index 5c7aa3c..6f7906e 100644
> > --- a/arch/arm/include/asm/kvm_mmu.h
> > +++ b/arch/arm/include/asm/kvm_mmu.h
> > @@ -37,6 +37,11 @@
> >   */
> >  #define TRAMPOLINE_VA		UL(CONFIG_VECTORS_BASE)
> >
> > +/*
> > + * NUM_OBJS depends on the number of page table translation levels
> > +*/
> > +#define NUM_OBJS		2
> 
> I'm afraid this is way too generic. Use something along the lines of MMU_CACHE_MIN_PAGES, that makes
> it obvious what we're talking about.

Okay, I will change it.

> > +
> >  #ifndef __ASSEMBLY__
> >
> >  #include <asm/cacheflush.h>
> > @@ -94,6 +99,11 @@ static inline void kvm_clean_pgd(pgd_t *pgd)
> >  	clean_dcache_area(pgd, PTRS_PER_S2_PGD * sizeof(pgd_t));  }
> >
> > +static inline void kvm_clean_pmd(pmd_t *pmd) {
> > +	clean_dcache_area(pmd, PTRS_PER_PMD * sizeof(pmd_t)); }
> > +
> >  static inline void kvm_clean_pmd_entry(pmd_t *pmd)  {
> >  	clean_pmd_entry(pmd);
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c index
> > 80bb1e6..7fc9e55 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -388,13 +388,44 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
> >  	return 0;
> >  }
> >
> > +static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
> > +				   unsigned long end, unsigned long pfn,
> > +				   pgprot_t prot)
> > +{
> > +	pud_t *pud;
> > +	pmd_t *pmd;
> > +	unsigned long addr, next;
> > +
> > +	addr = start;
> > +	do {
> > +		pud = pud_offset(pgd, addr);
> > +
> > +		if (pud_none_or_clear_bad(pud)) {
> > +			pmd = pmd_alloc_one(NULL, addr);
> > +			if (!pmd) {
> > +				kvm_err("Cannot allocate Hyp pmd\n");
> > +				return -ENOMEM;
> > +			}
> > +			pud_populate(NULL, pud, pmd);
> > +			get_page(virt_to_page(pud));
> > +			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
> > +		}
> > +
> > +		next = pud_addr_end(addr, end);
> > +
> > +		create_hyp_pmd_mappings(pud, addr, next, pfn, prot);
> > +		pfn += (next - addr) >> PAGE_SHIFT;
> > +	} while (addr = next, addr != end);
> > +
> > +	return 0;
> > +}
> > +
> >  static int __create_hyp_mappings(pgd_t *pgdp,
> >  				 unsigned long start, unsigned long end,
> >  				 unsigned long pfn, pgprot_t prot)  {
> >  	pgd_t *pgd;
> >  	pud_t *pud;
> > -	pmd_t *pmd;
> >  	unsigned long addr, next;
> >  	int err = 0;
> >
> > @@ -403,22 +434,23 @@ static int __create_hyp_mappings(pgd_t *pgdp,
> >  	end = PAGE_ALIGN(end);
> >  	do {
> >  		pgd = pgdp + pgd_index(addr);
> > -		pud = pud_offset(pgd, addr);
> >
> > -		if (pud_none_or_clear_bad(pud)) {
> > -			pmd = pmd_alloc_one(NULL, addr);
> > -			if (!pmd) {
> > -				kvm_err("Cannot allocate Hyp pmd\n");
> > +		if (pgd_none(*pgd)) {
> > +			pud = pud_alloc_one(NULL, addr);
> > +			if (!pud) {
> > +				kvm_err("Cannot allocate Hyp pud\n");
> >  				err = -ENOMEM;
> >  				goto out;
> >  			}
> > -			pud_populate(NULL, pud, pmd);
> > -			get_page(virt_to_page(pud));
> > -			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
> > +			pgd_populate(NULL, pgd, pud);
> > +			get_page(virt_to_page(pgd));
> > +			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
> >  		}
> >
> >  		next = pgd_addr_end(addr, end);
> > -		err = create_hyp_pmd_mappings(pud, addr, next, pfn, prot);
> > +
> > +		err = create_hyp_pud_mappings(pgd, addr, next, pfn, prot);
> > +
> >  		if (err)
> >  			goto out;
> >  		pfn += (next - addr) >> PAGE_SHIFT; @@ -563,6 +595,24 @@ void
> > kvm_free_stage2_pgd(struct kvm *kvm)
> >  	kvm->arch.pgd = NULL;
> >  }
> >
> > +static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> > +			     phys_addr_t addr)
> > +{
> > +	pgd_t *pgd;
> > +	pud_t *pud;
> > +
> > +	pgd = kvm->arch.pgd + pgd_index(addr);
> > +	if (pgd_none(*pgd)) {
> > +		if (!cache)
> > +			return NULL;
> > +		pud = mmu_memory_cache_alloc(cache);
> > +		pgd_populate(NULL, pgd, pud);
> > +		get_page(virt_to_page(pgd));
> > +	}
> > +
> > +	return pud_offset(pgd, addr);
> > +}
> > +
> >  static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> >  			     phys_addr_t addr)
> >  {
> > @@ -617,6 +667,22 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> >  	pmd_t *pmd;
> >  	pte_t *pte, old_pte;
> >
> > +	pud_t *pud;
> > +
> > +	/* Create stage-2 page table mapping - Level 0 */
> > +	pud = stage2_get_pud(kvm, cache, addr);
> > +	if (!pud)
> > +		return 0;
> > +
> > +	if (pud_none(*pud)) {
> > +		if (!cache)
> > +			return 0;
> > +		pmd = mmu_memory_cache_alloc(cache);
> > +		kvm_clean_pmd(pmd);
> > +		pud_populate(NULL, pud, pmd);
> > +		get_page(virt_to_page(pud));
> > +	}
> > +
> >  	/* Create stage-2 page table mapping - Level 1 */
> >  	pmd = stage2_get_pmd(kvm, cache, addr);
> >  	if (!pmd) {
> > @@ -675,7 +741,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
> >  		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
> >
> > -		ret = mmu_topup_memory_cache(&cache, 2, 2);
> > +		ret = mmu_topup_memory_cache(&cache, NUM_OBJS, NUM_OBJS);
> >  		if (ret)
> >  			goto out;
> >  		spin_lock(&kvm->mmu_lock);
> > diff --git a/arch/arm64/include/asm/kvm_arm.h
> > b/arch/arm64/include/asm/kvm_arm.h
> > index 3d69030..295eda6 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -117,9 +117,11 @@
> >  #define VTCR_EL2_IRGN0_MASK	(3 << 8)
> >  #define VTCR_EL2_IRGN0_WBWA	(1 << 8)
> >  #define VTCR_EL2_SL0_MASK	(3 << 6)
> > +#define VTCR_EL2_SL0_LVL0	(2 << 6)
> >  #define VTCR_EL2_SL0_LVL1	(1 << 6)
> >  #define VTCR_EL2_T0SZ_MASK	0x3f
> >  #define VTCR_EL2_T0SZ_40B	24
> > +#define VTCR_EL2_T0SZ_48B	16
> 
> How about having
> #define	VTCR_EL2_TOSZ(bits)	(64 - (bits))
> and using that everywhere?

It sounds good. I will fix it.

> >
> >  #ifdef CONFIG_ARM64_64K_PAGES
> >  /*
> > @@ -134,6 +136,7 @@
> >  				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
> >  #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
> >  #else
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  /*
> >   * Stage2 translation configuration:
> >   * 40bits output (PS = 2)
> > @@ -145,10 +148,27 @@
> >  				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> >  				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
> >  #define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
> > +#else
> > +/*
> > + * Stage2 translation configuration:
> > + * 40bits output (PS = 2)
> > + * 48bits input  (T0SZ = 16)
> > + * 4kB pages (TG0 = 0)
> > + * 4 level page tables (SL = 2)
> > + */
> > +#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
> > +				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> > +				 VTCR_EL2_SL0_LVL0 | VTCR_EL2_T0SZ_48B)
> > +#define VTTBR_X		(29 - VTCR_EL2_T0SZ_48B)
> > +#endif
> >  #endif
> >
> >  #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  #define VTTBR_BADDR_MASK  (((1LLU << (40 - VTTBR_X)) - 1) <<
> > VTTBR_BADDR_SHIFT)
> > +#else
> > +#define VTTBR_BADDR_MASK  (((1LLU << (48 - VTTBR_X)) - 1) <<
> > +VTTBR_BADDR_SHIFT) #endif
> 
> Have a global #define for the number of output bits, and unify these two definitions.

Okay, I will introduce a new macro for output bits.

> >  #define VTTBR_VMID_SHIFT  (48LLU)
> >  #define VTTBR_VMID_MASK	  (0xffLLU << VTTBR_VMID_SHIFT)
> >
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h
> > b/arch/arm64/include/asm/kvm_mmu.h
> > index 7d29847..f7fb2d0 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -41,6 +41,15 @@
> >   */
> >  #define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
> >
> > +/*
> > + * NUM_OBJS depends on the number of page table translation levels
> > +*/ #ifndef CONFIG_ARM64_4_LEVELS
> > +#define NUM_OBJS		2
> > +#else
> > +#define NUM_OBJS		3
> > +#endif
> 
> What about 64kB pages with two levels? Only one page should be necessary.

Okay, I will add it.

I really thank you for the comments.

Best Regards
Jungseok Lee

