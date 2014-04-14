Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaDNHlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:41:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50086 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaDNHlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:41:19 -0400
X-AuditID: cbfee68e-b7f566d000002344-60-534b9119b732
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 8/8] arm64: KVM: Implement 4 levels of translation tables for
 HYP and stage2
Date: Mon, 14 Apr 2014 16:41:13 +0900
Message-id: <000601cf57b4$e93b9680$bbb2c380$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XrcjxdxiUQSMMR2GY0OhDbB7QqA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zI13Jid7BBvNmGVv8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WHGSsZHbg91sxb
	w+jx+9ckRo871/aweZzftIbZY/OSeo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKWLb8BXvB
	KZOKnt0X2BoY/2t2MXJySAiYSJxfvI8NwhaTuHBvPZDNxSEksIxR4urKK+wwRdMPtDFCJBYx
	SuyYsQ6q6g+jxNGGBWDtbAKaEo/u9rCDJEQEdjBKTF67iBXEYRY4wSix9M5aIIeDQ1ggTmLh
	ak8Qk0VAVWJBgwRIL6+ApcSF6TNZIGxBiR+T74HZzAJaEut3HmeCsOUlNq95ywxxkYLEjrOv
	GUFsEQE9iWlLlkLViEjse/EO7FIJgUYOiWkrdrCCJFgEBCS+TT7EArJXQkBWYtMBqDmSEgdX
	3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihMRy3w7G
	mwesDzEmA62fyCwlmpwPTAV5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoHRzfmg7mP1sJk7fsybbhc46QbX564u/4X2DpUPP92/7LHe2W/1twQB
	6btbeuJtNjBPv3GwVLlLqCY31GxL54xnKUXJwlt6w1q8zgYtuXP0luD8+68ftXwXrtPOXuGb
	GvpTcnXZPO3Vi99ZvC42bN7MFNxwsXnCFFdNQ9mrEyVFlUKNVNcvFPuhxFKckWioxVxUnAgA
	DeOwVvsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAV3Jid7BBo/e6lr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WHGSsZHbg91sxb
	w+jx+9ckRo871/aweZzftIbZY/OSeo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmLFs+Qv2glMmFT27L7A1MP7X7GLk5JAQMJGYfqCNEcIWk7hwbz1b
	FyMXh5DAIkaJHTPWQTl/GCWONixgA6liE9CUeHS3hx0kISKwg1Fi8tpFrCAOs8AJRomld9YC
	ORwcwgJxEgtXe4KYLAKqEgsaJEB6eQUsJS5Mn8kCYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1b
	ZoiLFCR2nH0Ndp2IgJ7EtCVLoWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBCeKZ1I7GFc2WBxiFOBgVOLhTdjuGSzEmlhWXJl7iFGCg1lJ
	hHdbhlewEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucDk1heSbyhsYmZkaWRmYWRibk5acJK
	4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTDOYljrnXbtaMPd3Y8rb+uby61/Ofthc16tw5//
	1arhNW59J94dFwz7cX21jvuTi+lTDPJO7xY/e/hab8EZpmXu9qxulSvq0p0dF7hsFFNP3fxj
	W4wnw2dn9dXKxTuNlhTPfqGzzrVoWurTMw5v3shM/vWbMfWaWjrzyzfteRY1/vM/GCtOm6ul
	xFKckWioxVxUnAgAqa07yVgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 4 levels of translation tables implementation for both
HYP and stage2. A combination of 4KB + 4 levels host and 4KB + 4 levels
guest can run on ARMv8 architecture as introducing this feature.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm/kvm/mmu.c               |   96 +++++++++++++++++++++++++++++++++-----
 arch/arm64/include/asm/kvm_arm.h |   20 ++++++++
 arch/arm64/include/asm/kvm_mmu.h |    1 +
 3 files changed, 106 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index e0d4f24..6cf89ad 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -388,13 +388,46 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
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
+#ifdef CONFIG_ARM64_4_LEVELS
 	pud_t *pud;
-	pmd_t *pmd;
+#endif
 	unsigned long addr, next;
 	int err = 0;
 
@@ -403,22 +436,25 @@ static int __create_hyp_mappings(pgd_t *pgdp,
 	end = PAGE_ALIGN(end);
 	do {
 		pgd = pgdp + pgd_index(addr);
-		pud = pud_offset(pgd, addr);
 
-		if (pud_none_or_clear_bad(pud)) {
-			pmd = pmd_alloc_one(NULL, addr);
-			if (!pmd) {
-				kvm_err("Cannot allocate Hyp pmd\n");
+#ifdef CONFIG_ARM64_4_LEVELS
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
+#endif
 
 		next = pgd_addr_end(addr, end);
-		err = create_hyp_pmd_mappings(pud, addr, next, pfn, prot);
+
+		err = create_hyp_pud_mappings(pgd, addr, next, pfn, prot);
+
 		if (err)
 			goto out;
 		pfn += (next - addr) >> PAGE_SHIFT;
@@ -563,6 +599,26 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	kvm->arch.pgd = NULL;
 }
 
+#ifdef CONFIG_ARM64_4_LEVELS
+static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache
+			     *cache, phys_addr_t addr)
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
+#endif
+
 static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache
 			     *cache, phys_addr_t addr)
 {
@@ -617,6 +673,24 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	pmd_t *pmd;
 	pte_t *pte, old_pte;
 
+#ifdef CONFIG_ARM64_4_LEVELS
+	pud_t *pud;
+
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
+#endif
+
 	/* Create stage-2 page table mapping - Level 1 */
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	if (!pmd) {
@@ -675,7 +749,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
 		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
 
-		ret = mmu_topup_memory_cache(&cache, 2, 2);
+		ret = mmu_topup_memory_cache(&cache, 3, 3);
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3d69030..295eda6 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -117,9 +117,11 @@
 #define VTCR_EL2_IRGN0_MASK	(3 << 8)
 #define VTCR_EL2_IRGN0_WBWA	(1 << 8)
 #define VTCR_EL2_SL0_MASK	(3 << 6)
+#define VTCR_EL2_SL0_LVL0	(2 << 6)
 #define VTCR_EL2_SL0_LVL1	(1 << 6)
 #define VTCR_EL2_T0SZ_MASK	0x3f
 #define VTCR_EL2_T0SZ_40B	24
+#define VTCR_EL2_T0SZ_48B	16
 
 #ifdef CONFIG_ARM64_64K_PAGES
 /*
@@ -134,6 +136,7 @@
 				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
 #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
 #else
+#ifndef CONFIG_ARM64_4_LEVELS
 /*
  * Stage2 translation configuration:
  * 40bits output (PS = 2)
@@ -145,10 +148,27 @@
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
 				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
 #define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
+#else
+/*
+ * Stage2 translation configuration:
+ * 40bits output (PS = 2)
+ * 48bits input  (T0SZ = 16)
+ * 4kB pages (TG0 = 0)
+ * 4 level page tables (SL = 2)
+ */
+#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
+				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
+				 VTCR_EL2_SL0_LVL0 | VTCR_EL2_T0SZ_48B)
+#define VTTBR_X		(29 - VTCR_EL2_T0SZ_48B)
+#endif
 #endif
 
 #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
+#ifndef CONFIG_ARM64_4_LEVELS
 #define VTTBR_BADDR_MASK  (((1LLU << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
+#else
+#define VTTBR_BADDR_MASK  (((1LLU << (48 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
+#endif
 #define VTTBR_VMID_SHIFT  (48LLU)
 #define VTTBR_VMID_MASK	  (0xffLLU << VTTBR_VMID_SHIFT)
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7d29847..ec76cf3 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -107,6 +107,7 @@ static inline bool kvm_is_write_fault(unsigned long esr)
 }
 
 static inline void kvm_clean_pgd(pgd_t *pgd) {}
+static inline void kvm_clean_pmd(pud_t *pud) {}
 static inline void kvm_clean_pmd_entry(pmd_t *pmd) {}
 static inline void kvm_clean_pte(pte_t *pte) {}
 static inline void kvm_clean_pte_entry(pte_t *pte) {}
-- 
1.7.10.4


