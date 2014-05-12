Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaELJrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:47:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11972 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaELJrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:47:43 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-af-537098bda1fa
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [RESEND PATCH v6 7/7] arm64: KVM: Implement 4 levels of translation
 tables for
Date: Mon, 12 May 2014 18:47:41 +0900
Message-id: <000701cf6dc7$379ba360$a6d2ea20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9txrb0cxfvcg8qSU+sNgphF9Hbmg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zA929MwqCDY7f0rH4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6M
	pis/GAu6nSsaGyayNDDuN+1i5OSQEDCRuLjyECuELSZx4d56ti5GLg4hgWWMEodfLWCCKTr3
	cT8rRGI6o8TLF5uZIJw/jBJLZjeDVbEJaEo8utvDDpIQEdjBKDF57SKwFmaBh4wSP9/uZwap
	EhaIlNi09hcLiM0ioCpx5/YURhCbV8BS4tme5+wQtqDEj8n3wGqYBbQk1u88zgRhy0tsXvOW
	GeImBYkdZ1+D9YoI6Enc7T/JBlEjIrHvxTtGkMUSAr0cEseP7meHWCYg8W3yIaChHEAJWYlN
	B6DmSEocXHGDZQKj2Cwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7
	iRES2RN3MN4/YH2IMRlo/URmKdHkfGBiyCuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1RUpCQQHpi
	SWp2ampBalF8UWlOavEhRiYOTqkGxtkPnxbNFOMv2fP/2FNHRwNnsdCH/8Ob3K1PXhDxzTop
	c1eNydl76XL563P5padrWXK9OGfUJGYUeX1J+ortUlytjjvmHVse8HBCW+TmlVd8bNJyXor9
	jl52eLa/VUyt7FP/DTGxpWoLdxYzleS+2c3SeXwZO2fVumePdC3q3q2qmlh5N2+OrhJLcUai
	oRZzUXEiADGszFACAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd29MwqCDbrnq1n8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjKYrPxgLup0rGhsmsjQw7jftYuTkkBAwkTj3cT8rhC0m
	ceHeerYuRi4OIYHpjBIvX2xmgnD+MEosmd3MBFLFJqAp8ehuDztIQkRgB6PE5LWLWEEcZoGH
	jBI/3+5nBqkSFoiU2LT2FwuIzSKgKnHn9hRGEJtXwFLi2Z7n7BC2oMSPyffAapgFtCTW7zzO
	BGHLS2xe85YZ4iYFiR1nX4P1igjoSdztP8kGUSMise/FO8YJjAKzkIyahWTULCSjZiFpWcDI
	sopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOG08k97BuKrB4hCjAAejEg/vB4aCYCHWxLLi
	ytxDjBIczEoivCcnAoV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5jS8kriDY1NzIwsjcws
	jEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcWvolMkV+31n3rGbu4DTJ0t39a/N
	yi+fODD1PHm/rFti/ovkHcpxVzov/l5wSSWF0S2g32rtspXqVisvHuG44rl1ocZFY+1g9crX
	Te78/Hka3Xv+i9kvy8+JrD582Pem2uKoH+tdZt+qn694o+K5vPOON2c29649f+v8uecbGG78
	LSzdOMm2tlSJpTgj0VCLuag4EQDOsi3+XwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 4 levels of translation tables implementation for both
HYP and stage2.

Both symmetric and asymmetric configurations for page size and translation
levels are are validated on Fast Models:

 1) 4KB  + 3 levels guest on 4KB  + 4 levels host
 2) 4KB  + 4 levels guest on 4KB  + 4 levels host
 3) 64KB + 2 levels guest on 4KB  + 4 levels host
 4) 4KB  + 3 levels guest on 64KB + 2 levels host
 5) 4KB  + 4 levels guest on 64KB + 2 levels host
 6) 64KB + 2 levels guest on 64KB + 2 levels host

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
Please ignore the previous patch since it has a critical error
on KVM_MMU_CACHE_MIN_PAGES.
---
 arch/arm/include/asm/kvm_mmu.h   |   10 +++++
 arch/arm/kvm/arm.c               |    8 ++++
 arch/arm/kvm/mmu.c               |   77 ++++++++++++++++++++++++++++++++------
 arch/arm64/include/asm/kvm_arm.h |   12 ++++++
 arch/arm64/include/asm/kvm_mmu.h |   12 ++++++
 5 files changed, 108 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 5c7aa3c..36b9835 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -37,6 +37,11 @@
  */
 #define TRAMPOLINE_VA		UL(CONFIG_VECTORS_BASE)
 
+/*
+ * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
+ */
+#define KVM_MMU_CACHE_MIN_PAGES	2
+
 #ifndef __ASSEMBLY__
 
 #include <asm/cacheflush.h>
@@ -94,6 +99,11 @@ static inline void kvm_clean_pgd(pgd_t *pgd)
 	clean_dcache_area(pgd, PTRS_PER_S2_PGD * sizeof(pgd_t));
 }
 
+static inline void kvm_clean_pmd(pmd_t *pmd)
+{
+	clean_dcache_area(pmd, PTRS_PER_PMD * sizeof(pmd_t));
+}
+
 static inline void kvm_clean_pmd_entry(pmd_t *pmd)
 {
 	clean_pmd_entry(pmd);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9f19f2c..0785291 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -473,11 +473,19 @@ static int set_vttbr_baddr_mask(void)
 	 * 21 <= T0SZ <= 30 is valid under 3 level of translation tables
 	 * 30 <= T0SZ <= 39 is valid under 2 level of translation tables
 	 */
+#ifdef CONFIG_ARM64_3_LEVELS
 	if (t0sz <= 20) {
 		kvm_err("Cannot support %d-bit address space\n", 64 - t0sz);
 		return -EINVAL;
 	}
 	vttbr_x = 37 - t0sz;
+#else
+	if (t0sz <= 15) {
+		kvm_err("Cannot support %d-bit address space\n", 64 - t0sz);
+		return -EINVAL;
+	}
+	vttbr_x = 28 - t0sz;
+#endif
 #endif
 	vttbr_baddr_mask = (((1LLU << (48 - vttbr_x)) - 1) << (vttbr_x - 1));
 #endif
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 16f8049..6e2a0b0 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -390,13 +390,44 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
 	return 0;
 }
 
+static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
+				   unsigned long end, unsigned long pfn,
+				   pgprot_t prot)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+	unsigned long addr, next;
+
+	addr = start;
+	do {
+		pud = pud_offset(pgd, addr);
+
+		if (pud_none_or_clear_bad(pud)) {
+			pmd = pmd_alloc_one(NULL, addr);
+			if (!pmd) {
+				kvm_err("Cannot allocate Hyp pmd\n");
+				return -ENOMEM;
+			}
+			pud_populate(NULL, pud, pmd);
+			get_page(virt_to_page(pud));
+			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
+		}
+
+		next = pud_addr_end(addr, end);
+
+		create_hyp_pmd_mappings(pud, addr, next, pfn, prot);
+		pfn += (next - addr) >> PAGE_SHIFT;
+	} while (addr = next, addr != end);
+
+	return 0;
+}
+
 static int __create_hyp_mappings(pgd_t *pgdp,
 				 unsigned long start, unsigned long end,
 				 unsigned long pfn, pgprot_t prot)
 {
 	pgd_t *pgd;
 	pud_t *pud;
-	pmd_t *pmd;
 	unsigned long addr, next;
 	int err = 0;
 
@@ -405,22 +436,21 @@ static int __create_hyp_mappings(pgd_t *pgdp,
 	end = PAGE_ALIGN(end);
 	do {
 		pgd = pgdp + pgd_index(addr);
-		pud = pud_offset(pgd, addr);
 
-		if (pud_none_or_clear_bad(pud)) {
-			pmd = pmd_alloc_one(NULL, addr);
-			if (!pmd) {
-				kvm_err("Cannot allocate Hyp pmd\n");
+		if (pgd_none(*pgd)) {
+			pud = pud_alloc_one(NULL, addr);
+			if (!pud) {
+				kvm_err("Cannot allocate Hyp pud\n");
 				err = -ENOMEM;
 				goto out;
 			}
-			pud_populate(NULL, pud, pmd);
-			get_page(virt_to_page(pud));
-			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
+			pgd_populate(NULL, pgd, pud);
+			get_page(virt_to_page(pgd));
+			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
 		}
 
 		next = pgd_addr_end(addr, end);
-		err = create_hyp_pmd_mappings(pud, addr, next, pfn, prot);
+		err = create_hyp_pud_mappings(pgd, addr, next, pfn, prot);
 		if (err)
 			goto out;
 		pfn += (next - addr) >> PAGE_SHIFT;
@@ -565,6 +595,24 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	kvm->arch.pgd = NULL;
 }
 
+static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+			     phys_addr_t addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+
+	pgd = kvm->arch.pgd + pgd_index(addr);
+	if (pgd_none(*pgd)) {
+		if (!cache)
+			return NULL;
+		pud = mmu_memory_cache_alloc(cache);
+		pgd_populate(NULL, pgd, pud);
+		get_page(virt_to_page(pgd));
+	}
+
+	return pud_offset(pgd, addr);
+}
+
 static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			     phys_addr_t addr)
 {
@@ -616,9 +664,15 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte, bool iomap)
 {
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte, old_pte;
 
+	/* Create stage-2 page table mapping - Level 0 */
+	pud = stage2_get_pud(kvm, cache, addr);
+	if (!pud)
+		return 0;
+
 	/* Create stage-2 page table mapping - Level 1 */
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	if (!pmd) {
@@ -677,7 +731,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
 		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
 
-		ret = mmu_topup_memory_cache(&cache, 2, 2);
+		ret = mmu_topup_memory_cache(&cache, KVM_MMU_CACHE_MIN_PAGES,
+						KVM_MMU_CACHE_MIN_PAGES);
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8dbef70..ac796d0 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -114,6 +114,7 @@
 #define VTCR_EL2_IRGN0_MASK	(3 << 8)
 #define VTCR_EL2_IRGN0_WBWA	(1 << 8)
 #define VTCR_EL2_SL0_MASK	(3 << 6)
+#define VTCR_EL2_SL0_LVL0	(2 << 6)
 #define VTCR_EL2_SL0_LVL1	(1 << 6)
 #define VTCR_EL2_T0SZ_MASK	0x3f
 #define VTCR_EL2_T0SZ(bits)	(64 - (bits))
@@ -128,6 +129,7 @@
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
 				 VTCR_EL2_SL0_LVL1)
 #else
+#ifdef CONFIG_ARM64_3_LEVELS
 /*
  * Stage2 translation configuration:
  * 4kB pages (TG0 = 0)
@@ -136,6 +138,16 @@
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
 				 VTCR_EL2_SL0_LVL1)
+#else
+/*
+ * Stage2 translation configuration:
+ * 4kB pages (TG0 = 0)
+ * 4 level page tables (SL = 2)
+ */
+#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
+				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
+				 VTCR_EL2_SL0_LVL0)
+#endif
 #endif
 
 #define VTTBR_VMID_SHIFT  (48LLU)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7d29847..778bf42 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -41,6 +41,17 @@
  */
 #define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
 
+/*
+ * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
+ */
+#ifdef CONFIG_ARM64_2_LEVELS
+#define KVM_MMU_CACHE_MIN_PAGES	1
+#elif defined(CONFIG_ARM64_3_LEVELS)
+#define KVM_MMU_CACHE_MIN_PAGES	2
+#else
+#define KVM_MMU_CACHE_MIN_PAGES	3
+#endif
+
 #ifdef __ASSEMBLY__
 
 /*
@@ -107,6 +118,7 @@ static inline bool kvm_is_write_fault(unsigned long esr)
 }
 
 static inline void kvm_clean_pgd(pgd_t *pgd) {}
+static inline void kvm_clean_pmd(pmd_t *pmd) {}
 static inline void kvm_clean_pmd_entry(pmd_t *pmd) {}
 static inline void kvm_clean_pte(pte_t *pte) {}
 static inline void kvm_clean_pte_entry(pte_t *pte) {}
-- 
1.7.10.4


