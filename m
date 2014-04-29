Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaD2FA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:00:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19660 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaD2FAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:00:22 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-31-535f31e4180d
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v4 7/7] arm64: KVM: Implement 4 levels of translation tables
 for HYP and stage2
Date: Tue, 29 Apr 2014 14:00:20 +0900
Message-id: <000801cf6367$eba20940$c2e61bc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jZaWETSPLucO2Q/eYHs+LSEkw+Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zY90nhvHBBru36Fr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	sVObmAtOe1S0vN3N2sD43bKLkYNDQsBEYvFSiy5GTiBTTOLCvfVsXYxcHEICyxglWpYuYYJI
	mEjs+/2MGSIxnVHi4KtbUFV/GCUabx1iBaliE9CUeHS3hx0kISKwg1Fi8tpFrCAOs8BDRomf
	b/czg+wTFkiU2LwlHKSBRUBVonNdAzuIzStgKXHj+EooW1Dix+R7LCA2s4CWxPqdx5kgbHmJ
	zWveMkOcpCCx4+xrRhBbREBP4ujP3VA1IhL7XrxjBNkrIdDKIdE4eQsbxDIBiW+TD7FA/Cwr
	sekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLz
	czcxQqJ6wg7GewesDzEmA62fyCwlmpwPTAp5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cDI7XOSKf4X48wjR5keprT7tOh5JRVKrVjXU7NHaJLP
	s23fzjyd8W3RTvM5bnrTG249W/w4em2z69Fjh96FPFVfd3ZRx73e5YtdhRk/LJ3mm5qffihm
	I9sz0RDh6zOu/f/WYPn91Ude9dJlF+wu2i7QCyh+8myPe9Onjyv3iQVG1k8QzNo5TTNtvRJL
	cUaioRZzUXEiAJz3xkEAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQd0nhvHBBqvmq1v8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjGOnNjEXnPaoaHm7m7WB8btlFyMnh4SAicS+38+YIWwx
	iQv31rN1MXJxCAlMZ5Q4+OoWlPOHUaLx1iFWkCo2AU2JR3d72EESIgI7GCUmr13ECuIwCzxk
	lPj5dj/QLA4OYYFEic1bwkEaWARUJTrXNbCD2LwClhI3jq+EsgUlfky+xwJiMwtoSazfeZwJ
	wpaX2LzmLdRJChI7zr5mBLFFBPQkjv7cDVUjIrHvxTvGCYwCs5CMmoVk1Cwko2YhaVnAyLKK
	UTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhpPJPewbiqweIQowAHoxIPb0dMXLAQa2JZcWXu
	IUYJDmYlEd5Yg/hgId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJrS8knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamAMjtdX+/u6e7t4T5LTrqP8lm1WPX/2
	a6sEmC5evLHW8/ctduWsf5wqb11aaqylHfRsd082enJB+7iTRW1D89agp9dqo873PO48+JOz
	7NX+mXOD+HONvEsTHRPDfC3uq7V/6zMuFbR765uva9hRen6OWWrJfPV/jW/jXmScnhndn/E+
	8EzdbiWW4oxEQy3mouJEALdzlbNeAwAA
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

 1) 4KB  + 3 levels guest on 4KB  + 3 levels host

 2) 4KB  + 4 levels guest on 4KB  + 3 levels host

 3) 64KB + 2 levels guest on 4KB  + 3 levels host

 4) 4KB  + 3 levels guest on 4KB  + 4 levels host

 5) 4KB  + 4 levels guest on 4KB  + 4 levels host

 6) 64KB + 2 levels guest on 4KB  + 4 levels host

 7) 4KB  + 3 levels guest on 64KB + 2 levels host

 8) 4KB  + 4 levels guest on 64KB + 2 levels host

 9) 64KB + 2 levels guest on 64KB + 2 levels host

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm/include/asm/kvm_mmu.h   |   10 +++++
 arch/arm/kvm/mmu.c               |   88 +++++++++++++++++++++++++++++++++-----
 arch/arm64/include/asm/kvm_arm.h |   34 ++++++++++++---
 arch/arm64/include/asm/kvm_mmu.h |   12 ++++++
 4 files changed, 127 insertions(+), 17 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 5c7aa3c..31eaaa6 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -37,6 +37,11 @@
  */
 #define TRAMPOLINE_VA		UL(CONFIG_VECTORS_BASE)
 
+/*
+ * MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
+ */
+#define MMU_CACHE_MIN_PAGES	2
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
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 80bb1e6..3ffbdfb 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -388,13 +388,44 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
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
 
@@ -403,22 +434,23 @@ static int __create_hyp_mappings(pgd_t *pgdp,
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
+
+		err = create_hyp_pud_mappings(pgd, addr, next, pfn, prot);
+
 		if (err)
 			goto out;
 		pfn += (next - addr) >> PAGE_SHIFT;
@@ -563,6 +595,24 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
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
@@ -614,9 +664,24 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
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
+	if (pud_none(*pud)) {
+		if (!cache)
+			return 0;
+		pmd = mmu_memory_cache_alloc(cache);
+		kvm_clean_pmd(pmd);
+		pud_populate(NULL, pud, pmd);
+		get_page(virt_to_page(pud));
+	}
+
 	/* Create stage-2 page table mapping - Level 1 */
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	if (!pmd) {
@@ -675,7 +740,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
 		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
 
-		ret = mmu_topup_memory_cache(&cache, 2, 2);
+		ret = mmu_topup_memory_cache(&cache, MMU_CACHE_MIN_PAGES,
+					     MMU_CACHE_MIN_PAGES);
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3d69030..29c9c25 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -117,9 +117,10 @@
 #define VTCR_EL2_IRGN0_MASK	(3 << 8)
 #define VTCR_EL2_IRGN0_WBWA	(1 << 8)
 #define VTCR_EL2_SL0_MASK	(3 << 6)
+#define VTCR_EL2_SL0_LVL0	(2 << 6)
 #define VTCR_EL2_SL0_LVL1	(1 << 6)
 #define VTCR_EL2_T0SZ_MASK	0x3f
-#define VTCR_EL2_T0SZ_40B	24
+#define VTCR_EL2_T0SZ(bits)	(64 - (bits))
 
 #ifdef CONFIG_ARM64_64K_PAGES
 /*
@@ -129,11 +130,14 @@
  * 64kB pages (TG0 = 1)
  * 2 level page tables (SL = 1)
  */
+#define VTTBR_OUTPUT_BITS	40
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
-#define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
+				 VTCR_EL2_SL0_LVL1 | \
+				 VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
+#define VTTBR_X		(38 - VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
 #else
+#ifndef CONFIG_ARM64_4_LEVELS
 /*
  * Stage2 translation configuration:
  * 40bits output (PS = 2)
@@ -141,14 +145,32 @@
  * 4kB pages (TG0 = 0)
  * 3 level page tables (SL = 1)
  */
+#define VTTBR_OUTPUT_BITS	40
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
-#define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
+				 VTCR_EL2_SL0_LVL1 | \
+				 VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
+#define VTTBR_X		(37 - VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
+#else
+/*
+ * Stage2 translation configuration:
+ * 40bits output (PS = 2)
+ * 48bits input  (T0SZ = 16)
+ * 4kB pages (TG0 = 0)
+ * 4 level page tables (SL = 2)
+ */
+#define VTTBR_OUTPUT_BITS	48
+#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
+				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
+				 VTCR_EL2_SL0_LVL0 | \
+				 VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
+#define VTTBR_X		(29 - VTCR_EL2_T0SZ(VTTBR_OUTPUT_BITS))
+#endif
 #endif
 
 #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
-#define VTTBR_BADDR_MASK  (((1LLU << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
+#define VTTBR_BADDR_SIZE  (1LLU << (VTTBR_OUTPUT_BITS - VTTBR_X))
+#define VTTBR_BADDR_MASK  ((VTTBR_BADDR_SIZE - 1) << VTTBR_BADDR_SHIFT)
 #define VTTBR_VMID_SHIFT  (48LLU)
 #define VTTBR_VMID_MASK	  (0xffLLU << VTTBR_VMID_SHIFT)
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7d29847..72bf9ab 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -41,6 +41,17 @@
  */
 #define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
 
+/*
+ * MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
+ */
+#ifdef CONFIG_ARM64_2_LEVELS
+#define MMU_CACHE_MIN_PAGES	1
+#elif defined(CONFIG_ARM64_3_LEVELS)
+#define MMU_CACHE_MIN_PAGES	2
+#else
+#define MMU_CACHE_MIN_PAGES	3
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


