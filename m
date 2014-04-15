Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaDOAp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:45:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33693 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaDOAp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:45:27 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-f8-534c81259037
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Marc Zyngier'" <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
References: <000601cf57b4$e93b9680$bbb2c380$@samsung.com>
 <534C08C3.1080705@arm.com>
In-reply-to: <534C08C3.1080705@arm.com>
Subject: Re: [PATCH 8/8] arm64: KVM: Implement 4 levels of translation tables
 for HYP and stage2
Date: Tue, 15 Apr 2014 09:45:25 +0900
Message-id: <001801cf5843$fd7a7d70$f86f7850$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDLAW24GdkrUCMIH0Mtm7MYM4QxeQGcBYQBnQ2jOOA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zI13VRp9gg6tfjSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzeLDjJWMDtwea+at
	YfT4/WsSo8eda3vYPM5vWsPssXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlnH95h6Xg
	lEPFzi2dbA2MGw27GDk4JARMJD5e8+xi5AQyxSQu3FvP1sXIxSEksIxR4t7cz2wQCROJlXPu
	MUMkFjFK/Hg/gx3C+cMosX1ZExNIFZuApsSjuz3sILYIkP2x5ynYKGaBr0wSN37tBBslJBAm
	se17GyuIzSmgLtE35QcLiC0skCRx6dJ7JpCTWARUJdZs0QQJ8wpYSsxrncgOYQtK/Jh8D6yc
	WUBLYv3O40wQtrzE5jVvmSEuVZDYcfY1I8QNVhLTLm9gh6gRkdj34h0jRM1MDokZ/2xAbBYB
	AYlvkw+xQEJCVmLTAagxkhIHV9xgmcAoMQvJ5llINs9CsnkWkg0LGFlWMYqmFiQXFCelF5nq
	FSfmFpfmpesl5+duYoTE/cQdjPcPWB9iTAZaP5FZSjQ5H5g28kriDY3NjCxMTUyNjcwtzUgT
	VhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUWXtDn6mn/1sb1ey2c599LQnw/Wa
	iEZgNpuJh8iL3qM7lcT95nQ9Ubz5sOfumaOOK5UZth0tzdMsWu+fEbHCLX8b9701uQlqf1el
	dnSdvRV04f3Wh1cnTG0+qzLr8AXF9xmpCq4/TBu7J+6V+LWr5Ii/ediBiRkbXPd90Xkkmbt7
	4r8GXafsL0osxRmJhlrMRcWJAG9jhqgRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAV3VRp9ggzk/dCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzeLDjJWMDtwea+at
	YfT4/WsSo8eda3vYPM5vWsPssXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzDj/8g5LwSmHip1bOtkaGDcadjFyckgImEisnHOPGcIWk7hwbz1b
	FyMXh5DAIkaJH+9nsEM4fxglti9rYgKpYhPQlHh0t4cdxBYBsj/2PAXrYBb4yiRx49dONpCE
	kECYxLbvbawgNqeAukTflB8sILawQJLEpUvvgQZxcLAIqEqs2aIJEuYVsJSY1zqRHcIWlPgx
	+R5YObOAlsT6nceZIGx5ic1r3kJdqiCx4+xrRogbrCSmXd7ADlEjIrHvxTvGCYxCs5CMmoVk
	1Cwko2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzixPJPawbiyweIQowAHoxIP
	74R33sFCrIllxZW5hxglOJiVRHhfJ/sEC/GmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MOnl
	lcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANj4bQH3YylwmUu
	m/WSKvMvSvcu1+SZJG71Se/M/9vbJpydcvFYgXb4pP0hMdfS1Cad+c4s9L/0Y39l9qUuw/Xm
	Oz9nLrz04pyD0Y7PPouLoyc6z33/brPkKed/ecbcOprGFaWnuyQVzi/kZjGatTHCgqXA9MXu
	1431ez4/uLtl1ZyJ81Nnfc4vUmIpzkg01GIuKk4EAPntLmFwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 1:12 AM, Marc Zyngier wrote:
> On 14/04/14 08:41, Jungseok Lee wrote:
> > This patch adds 4 levels of translation tables implementation for both
> > HYP and stage2. A combination of 4KB + 4 levels host and 4KB + 4
> > levels guest can run on ARMv8 architecture as introducing this feature.
> >
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  arch/arm/kvm/mmu.c               |   96 +++++++++++++++++++++++++++++++++-----
> >  arch/arm64/include/asm/kvm_arm.h |   20 ++++++++
> >  arch/arm64/include/asm/kvm_mmu.h |    1 +
> >  3 files changed, 106 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c index
> > e0d4f24..6cf89ad 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -388,13 +388,46 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
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
> > +#ifdef CONFIG_ARM64_4_LEVELS
> >  	pud_t *pud;
> > -	pmd_t *pmd;
> > +#endif
> >  	unsigned long addr, next;
> >  	int err = 0;
> >
> > @@ -403,22 +436,25 @@ static int __create_hyp_mappings(pgd_t *pgdp,
> >  	end = PAGE_ALIGN(end);
> >  	do {
> >  		pgd = pgdp + pgd_index(addr);
> > -		pud = pud_offset(pgd, addr);
> >
> > -		if (pud_none_or_clear_bad(pud)) {
> > -			pmd = pmd_alloc_one(NULL, addr);
> > -			if (!pmd) {
> > -				kvm_err("Cannot allocate Hyp pmd\n");
> > +#ifdef CONFIG_ARM64_4_LEVELS
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
> > +#endif
> 
> Why do you need all these #ifdefs? The page table code should be able to cope with all the variations
> of presence/absence of pud/pmd (see how there is no code difference between 4kB (3 levels) and 64kB (2
> levels)).

Okay, I will remove it.

> >  		next = pgd_addr_end(addr, end);
> > -		err = create_hyp_pmd_mappings(pud, addr, next, pfn, prot);
> > +
> > +		err = create_hyp_pud_mappings(pgd, addr, next, pfn, prot);
> > +
> >  		if (err)
> >  			goto out;
> >  		pfn += (next - addr) >> PAGE_SHIFT; @@ -563,6 +599,26 @@ void
> > kvm_free_stage2_pgd(struct kvm *kvm)
> >  	kvm->arch.pgd = NULL;
> >  }
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache
> > +			     *cache, phys_addr_t addr)
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
> > +#endif
> 
> Same here.

Okay.

> >  static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache
> >  			     *cache, phys_addr_t addr)
> >  {
> > @@ -617,6 +673,24 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> >  	pmd_t *pmd;
> >  	pte_t *pte, old_pte;
> >
> > +#ifdef CONFIG_ARM64_4_LEVELS
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
> > +#endif
> > +
> 
> And here.

Okay.

> >  	/* Create stage-2 page table mapping - Level 1 */
> >  	pmd = stage2_get_pmd(kvm, cache, addr);
> >  	if (!pmd) {
> > @@ -675,7 +749,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
> >  		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
> >
> > -		ret = mmu_topup_memory_cache(&cache, 2, 2);
> > +		ret = mmu_topup_memory_cache(&cache, 3, 3);
> 
> It would be good to make this depend of the number of levels we're actually using (2, 3 or 4).

I will fix it in the next version.

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
> >  #define VTTBR_VMID_SHIFT  (48LLU)
> >  #define VTTBR_VMID_MASK	  (0xffLLU << VTTBR_VMID_SHIFT)
> >
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h
> > b/arch/arm64/include/asm/kvm_mmu.h
> > index 7d29847..ec76cf3 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -107,6 +107,7 @@ static inline bool kvm_is_write_fault(unsigned
> > long esr)  }
> >
> >  static inline void kvm_clean_pgd(pgd_t *pgd) {}
> > +static inline void kvm_clean_pmd(pud_t *pud) {}
> >  static inline void kvm_clean_pmd_entry(pmd_t *pmd) {}  static inline
> > void kvm_clean_pte(pte_t *pte) {}  static inline void
> > kvm_clean_pte_entry(pte_t *pte) {}
> >
> 
> You'll need to add the 32bit ARM equivalent once you've removed the #ifdefs.

Okay.

Best Regards
Jungseok Lee

