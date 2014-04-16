Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaDPEdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:33:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38031 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaDPEdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:33:33 -0400
X-AuditID: cbfee68e-b7f566d000002344-c9-534e081b691d
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v2 7/7] arm64: KVM: Implement 4 levels of translation tables
 for HYP and stage2
Date: Wed, 16 Apr 2014 13:33:31 +0900
Message-id: <004701cf592d$053b3380$0fb19a80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ZK52OkQEYYnUmRy6odt0KFSA2rg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfV1pDr9gg/+vDC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	9OSJzAWtNhVXVk1gbGBsM+hi5OSQEDCR2Lj6KRuELSZx4d56IJuLQ0hgGaPEnTdbWWCKXm/d
	xwqRmM4o8b6nB6rqD6PE5g2HmEGq2AQ0JR7d7WEHSYgI7GCUmLx2EVgLs8BDRomfb/eDVQkL
	JErMWP4TqJ2Dg0VAVWLffHWQMK+ApcSkjkYmCFtQ4sfke2CrmQW0JNbvPM4EYctLbF7zlhni
	JAWJHWdfM4LYIgJ6Eme6N7BD1IhI7HvxjhFkr4RAJ4fEp/YzYINYBAQkvk0+xAKyV0JAVmLT
	Aag5khIHV9xgmcAoNgvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+du
	YoTEdd8OxpsHrA8xJgOtn8gsJZqcD0wLeSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qB0fpu8f5zHezC86V+mxg9frJqXbNqRsXyAodHt02qy3oc
	9vlttNKdmPqPv3fBcROJ+b4TlHzTmbfGLsrPMrpdHGZff3zl/xWb3nL8De97cJ5Va757p+Vt
	qcvMnIfu1mcui8hlznGPkDHgK4gxlru84M/1y1pm69X/nd+2JbhJM7Hz1P6PYqEXlFiKMxIN
	tZiLihMBkyRY2AEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQV1pDr9gg/75OhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4x4/TkicwFrTYVV1ZNYGxgbDPoYuTkkBAwkXi9dR8rhC0m
	ceHeerYuRi4OIYHpjBLve3qgnD+MEps3HGIGqWIT0JR4dLeHHSQhIrCDUWLy2kWsIA6zwENG
	iZ9v94NVCQskSsxY/hOonYODRUBVYt98dZAwr4ClxKSORiYIW1Dix+R7LCA2s4CWxPqdx5kg
	bHmJzWveMkOcpCCx4+xrRhBbREBP4kz3BnaIGhGJfS/eMU5gFJiFZNQsJKNmIRk1C0nLAkaW
	VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBSeOZ9A7GVQ0WhxgFOBiVeHhn5vgGC7EmlhVX
	5h5ilOBgVhLh/fIFKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wISWVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUsDIq5G5db0xUycnq3ni3E9P6yozb7Ml
	zIp7N7ntoqNRrsy975eCWyyyFm7Rma3zSOLOqY8WD3l2P1t/MqTa3OK61+H+kwqrmMvYfz/8
	02S89W+0JKtRemNJMeMmt4i8T1faDiv8yjhZ2WmomfTIwmht9ZQn95cmLd6503+ucpXj1qsu
	6/4n/JZXYinOSDTUYi4qTgQAu1/jSl4DAAA=
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
 arch/arm/include/asm/kvm_mmu.h   |   10 +++++
 arch/arm/kvm/mmu.c               |   88 +++++++++++++++++++++++++++++++++-----
 arch/arm64/include/asm/kvm_arm.h |   20 +++++++++
 arch/arm64/include/asm/kvm_mmu.h |   10 +++++
 4 files changed, 117 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 5c7aa3c..6f7906e 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -37,6 +37,11 @@
  */
 #define TRAMPOLINE_VA		UL(CONFIG_VECTORS_BASE)
 
+/*
+ * NUM_OBJS depends on the number of page table translation levels
+ */
+#define NUM_OBJS		2
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
index 80bb1e6..7fc9e55 100644
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
@@ -617,6 +667,22 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	pmd_t *pmd;
 	pte_t *pte, old_pte;
 
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
+
 	/* Create stage-2 page table mapping - Level 1 */
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	if (!pmd) {
@@ -675,7 +741,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
 		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
 
-		ret = mmu_topup_memory_cache(&cache, 2, 2);
+		ret = mmu_topup_memory_cache(&cache, NUM_OBJS, NUM_OBJS);
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
index 7d29847..f7fb2d0 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -41,6 +41,15 @@
  */
 #define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
 
+/*
+ * NUM_OBJS depends on the number of page table translation levels
+ */
+#ifndef CONFIG_ARM64_4_LEVELS
+#define NUM_OBJS		2
+#else
+#define NUM_OBJS		3
+#endif
+
 #ifdef __ASSEMBLY__
 
 /*
@@ -107,6 +116,7 @@ static inline bool kvm_is_write_fault(unsigned long esr)
 }
 
 static inline void kvm_clean_pgd(pgd_t *pgd) {}
+static inline void kvm_clean_pmd(pmd_t *pmd) {}
 static inline void kvm_clean_pmd_entry(pmd_t *pmd) {}
 static inline void kvm_clean_pte(pte_t *pte) {}
 static inline void kvm_clean_pte_entry(pte_t *pte) {}
-- 
1.7.10.4


