Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaEGFyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:54:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52946 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaEGFyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:54:05 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-68-5369ca7acf9d
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Christoffer Dall'" <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000601cf64e5$dadfc460$909f4d20$@samsung.com>
 <20140506104925.GC3066@lvm>
In-reply-to: <20140506104925.GC3066@lvm>
Subject: Re: [PATCH v5 6/6] arm64: KVM: Implement 4 levels of translation
 tables for HYP and stage2
Date: Wed, 07 May 2014 14:54:02 +0900
Message-id: <001f01cf69b8$bf6bb680$3e432380$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFJ4kTvM4Bj753qKoU/3B8k12a8xwEcKfpVnDbI39A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+ZsW7VqcxggwczZCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	zcwNLAVHAyv+fX/G2sA4366LkZNDQsBE4uvhA+wQtpjEhXvr2boYuTiEBJYxSlz8cYkZpmhq
	91pmiMQiRon1y44xQTh/GCUO7VrFBFLFJqAp8ehuD9goEaCOz/fmgY1iFnjLJPF7xzSwhJBA
	uMTtVe1gNqeAhsS+NesZQWxhgVSJW42tYDaLgKrEh0m/2UBsXgFLiS2bzrJD2IISPybfYwGx
	mQW0JDZva2KFsOUlNq95C3WqgsSOs68ZIY6wkji2dxMzRI2IxL4X7xhBDpIQmMshcfr7QRaI
	ZQIS3yYfArI5gBKyEpsOQM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9
	yFSvODG3uDQvXS85P3cTIyQNTNzBeP+A9SHGZKD1E5mlRJPzgWkkryTe0NjMyMLUxNTYyNzS
	jDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY3W2eB1/0551k+ynAVdD2GvPf
	MMndl+VY2rX9xfovCdgxsrOuZ75n7OF3r/B/h4CP7dEF8rdYSxnq099sS5l2tFzBs+viwhbp
	DIEN+mrBO76fEJJj2M38bnrb+VvzivM+pt9/+V0y/Zdq+NM5hz+u3s1SdI9BZs4x9hk7nORn
	zbi4cJXx7P+SSizFGYmGWsxFxYkAdsDj0RkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd2qU5nBBhOviVr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjDczN7AUHA2s+Pf9GWsD43y7LkZODgkBE4mp3WuZIWwx
	iQv31rN1MXJxCAksYpRYv+wYE4Tzh1Hi0K5VTCBVbAKaEo/u9rCD2CJA3Z/vzQPrYBZ4yyTx
	e8c0sISQQLjE7VXtYDangIbEvjXrGUFsYYFUiVuNrWA2i4CqxIdJv9lAbF4BS4ktm86yQ9iC
	Ej8m32MBsZkFtCQ2b2tihbDlJTaveQt1qoLEjrOvGSGOsJI4tncTM0SNiMS+F+8YJzAKzUIy
	ahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAk80x6B+OqBotDjAIc
	jEo8vBZvM4KFWBPLiitzDzFKcDArifDa7MsMFuJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8
	YALMK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGiyAmL4aF
	7UZz9x5scm+5nv4gf4bmjrtP3zVu+hF5aEeLTZPNZM/zp1a+DXzjECFo0zxXhyln7ZNO8/67
	Ry/8WNGx2TPjY9iLm4I7sztjYwRaDy3wm3Fj79S2He9rH7859umpxuY9O0IqvA9xHblTtVDb
	9MJVY+3jWnxLxT+0isTmZ71ReOmmocRSnJFoqMVcVJwIAIXoN492AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 06, 2014 7:49 PM, Christoffer Dall wrote:
> On Thu, May 01, 2014 at 11:34:19AM +0900, Jungseok Lee wrote:
> > This patch adds 4 levels of translation tables implementation for both
> > HYP and stage2.
> >
> > Both symmetric and asymmetric configurations for page size and
> > translation levels are are validated on Fast Models:
> >
> >  1) 4KB  + 3 levels guest on 4KB  + 3 levels host
> >
> >  2) 4KB  + 4 levels guest on 4KB  + 3 levels host
> >
> >  3) 64KB + 2 levels guest on 4KB  + 3 levels host
> >
> >  4) 4KB  + 3 levels guest on 4KB  + 4 levels host
> >
> >  5) 4KB  + 4 levels guest on 4KB  + 4 levels host
> >
> >  6) 64KB + 2 levels guest on 4KB  + 4 levels host
> >
> >  7) 4KB  + 3 levels guest on 64KB + 2 levels host
> >
> >  8) 4KB  + 4 levels guest on 64KB + 2 levels host
> >
> >  9) 64KB + 2 levels guest on 64KB + 2 levels host
> >
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm/include/asm/kvm_mmu.h   |   10 +++++
> >  arch/arm/kvm/mmu.c               |   88 +++++++++++++++++++++++++++++++++-----
> >  arch/arm64/include/asm/kvm_arm.h |   34 ++++++++++++---
> >  arch/arm64/include/asm/kvm_mmu.h |   12 ++++++
> >  4 files changed, 127 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/arm/include/asm/kvm_mmu.h
> > b/arch/arm/include/asm/kvm_mmu.h index 5c7aa3c..31eaaa6 100644
> > --- a/arch/arm/include/asm/kvm_mmu.h
> > +++ b/arch/arm/include/asm/kvm_mmu.h
> > @@ -37,6 +37,11 @@
> >   */
> >  #define TRAMPOLINE_VA		UL(CONFIG_VECTORS_BASE)
> >
> > +/*
> > + * MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
> > + */
> > +#define MMU_CACHE_MIN_PAGES	2
> > +
> 
> I would prefer this was KVM_MMU_CACHE_MIN_PAGES

Okay, I will change it.

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
> > 80bb1e6..3ffbdfb 100644
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
> 
> super nit: this whitespacing looks weird

Okay, I will fix it.

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
> > @@ -614,9 +664,24 @@ static int stage2_set_pmd_huge(struct kvm *kvm,
> > struct kvm_mmu_memory_cache  static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache
> *cache,
> >  			  phys_addr_t addr, const pte_t *new_pte, bool iomap)  {
> > +	pud_t *pud;
> >  	pmd_t *pmd;
> >  	pte_t *pte, old_pte;
> >
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
> 
> Now we are doing this work twice, here and in stage2_get_pmd.  Can you not simply call stage2_get_pmd()
> from stage2_get_pud() and get rid of this code?

You're right. I will fix it.

> >  	/* Create stage-2 page table mapping - Level 1 */
> >  	pmd = stage2_get_pmd(kvm, cache, addr);
> >  	if (!pmd) {
> > @@ -675,7 +740,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
> >  		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
> >
> > -		ret = mmu_topup_memory_cache(&cache, 2, 2);
> > +		ret = mmu_topup_memory_cache(&cache, MMU_CACHE_MIN_PAGES,
> > +					     MMU_CACHE_MIN_PAGES);
> >  		if (ret)
> >  			goto out;
> >  		spin_lock(&kvm->mmu_lock);
> > diff --git a/arch/arm64/include/asm/kvm_arm.h
> > b/arch/arm64/include/asm/kvm_arm.h
> > index 3d69030..29c9c25 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -117,9 +117,10 @@
> >  #define VTCR_EL2_IRGN0_MASK	(3 << 8)
> >  #define VTCR_EL2_IRGN0_WBWA	(1 << 8)
> >  #define VTCR_EL2_SL0_MASK	(3 << 6)
> > +#define VTCR_EL2_SL0_LVL0	(2 << 6)
> >  #define VTCR_EL2_SL0_LVL1	(1 << 6)
> >  #define VTCR_EL2_T0SZ_MASK	0x3f
> > -#define VTCR_EL2_T0SZ_40B	24
> > +#define VTCR_EL2_T0SZ(bits)	(64 - (bits))
> >
> >  #ifdef CONFIG_ARM64_64K_PAGES
> >  /*
> > @@ -129,11 +130,14 @@
> >   * 64kB pages (TG0 = 1)
> >   * 2 level page tables (SL = 1)
> >   */
> > +#define VTTBR_OUTPUT_BITS	40
> 
> This is confusing, because the PS field is populated at runtime in arch/arm64/kvm/hyp-init.S and
> depends on the PARange field in ID_AA64MMFR0_EL1.

VTTBR_OUTPUT_BITS is not used to set PS field in VCTR_EL2.

> So the existing code actually looks wrong to me in that we will generate a Stage-2 translation fault
> for all IPAs > 2^40 on systems with >40 bits physical address space.  (Which will also be the case
> after this patch).

I agree. This part should be changed based on ID_AA64MMFR0_EL1.

> >  #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
> >  				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> > -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
> > -#define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
> > +				 VTCR_EL2_SL0_LVL1 | \
> > +				 VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
> > +#define VTTBR_X		(38 - VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
> 
> I spent hours trying to remember how to make sense of these hard-coded numbers, and failed.

Hmm.... Since VTTBR_X is used to calculate SHIFT value.
In other words, 38 might come from a combination of PA size and page size.
Am I right?

> Now when you're adding yet another one, please add an explanation on how to decode the VTTBR_X and why
> it all adds up as it should.

Okay, I will add an explanation on it.

> >  #else
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  /*
> >   * Stage2 translation configuration:
> >   * 40bits output (PS = 2)
> > @@ -141,14 +145,32 @@
> >   * 4kB pages (TG0 = 0)
> >   * 3 level page tables (SL = 1)
> >   */
> > +#define VTTBR_OUTPUT_BITS	40
> >  #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
> >  				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> > -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
> > -#define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
> > +				 VTCR_EL2_SL0_LVL1 | \
> > +				 VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
> > +#define VTTBR_X		(37 - VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
> > +#else
> > +/*
> > + * Stage2 translation configuration:
> > + * 40bits output (PS = 2)
> > + * 48bits input  (T0SZ = 16)
> > + * 4kB pages (TG0 = 0)
> > + * 4 level page tables (SL = 2)
> > + */
> > +#define VTTBR_OUTPUT_BITS	48
> 
> You're defining output bits to 48, but your comment says 40 bits output, and 48 bits input here.

I will fix it.
BTW, I think that the comment should have been dropped in the commit,
87366d8cf7b3f6dc34633938aa8766e5a390ce33, since, as you mentioned,
PS is supposed to be determined in runtime.

- Jungseok Lee

