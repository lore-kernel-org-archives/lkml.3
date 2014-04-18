Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaDRH7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:59:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13878 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaDRH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:09 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-26-5350db4bb7b5
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v3 2/7] arm64: Decouple page size from level of translation
 tables
Date: Fri, 18 Apr 2014 16:59:07 +0900
Message-id: <000301cf5adc$1309d470$391d7d50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9a1H+Goz3LrREMRiqRIL/QFCA9dA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zQ13v2wHBBmt2G1v8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	4+X/GQse6lS8nbWLvYGxV7WLkYNDQsBE4uPOzC5GTiBTTOLCvfVsILaQwDJGiUvdmhBxE4nW
	U1tZuxi5gOKLGCV+vJnNBOH8ASravYcdpIpNQFPi0d0edpCEiMAORonJaxeBtTALPGSU+Pl2
	PzNIlbBAiMSm5f1gO1gEVCWOH73NBGLzClhKfHp/hQXCFpT4MfkemM0soCWxfudxJghbXmLz
	mrfMEDcpSOw4+5oRxBYR0JOYvGAnK0SNiMS+F+8YQRZLCHRySGzf8YYRYpmAxLfJh1ggfpaV
	2HQAao6kxMEVN1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFhnrFibnFpXnpesn5
	uZsYIVHdu4Px9gHrQ4zJQOsnMkuJJucDk0JeSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTDGm589/JB125y8WCWWSNYPSkvtfdNaxG5u9uW90FJX
	FrDh5bkPkx71XNENmFuVcflGTMCBe/EqRjb+J1qLz6xMuCHCfj3omiKrwpf763+JJmZNO1Kt
	IlVzRnOWree9VJtFj+cuZuFnedn423ym6J3Q2Ymbl3fUvb00b852b+0fPX2lt7aYrlVUYinO
	SDTUYi4qTgQAvBL3FQADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAV3v2wHBBvfO6Fr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjMfL/zMWPNSpeDtrF3sDY69qFyMnh4SAiUTrqa2sELaY
	xIV769m6GLk4hAQWMUr8eDObCcL5wyhxafcedpAqNgFNiUd3e9hBEiICOxglJq9dxAriMAs8
	ZJT4+XY/M0iVsECIxKbl/WwgNouAqsTxo7eZQGxeAUuJT++vsEDYghI/Jt8Ds5kFtCTW7zzO
	BGHLS2xe85YZ4iYFiR1nXzOC2CICehKTF+xkhagRkdj34h3jBEaBWUhGzUIyahaSUbOQtCxg
	ZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZw2nkntYFzZYHGIUYCDUYmHV0AvIFiINbGs
	uDL3EKMEB7OSCK9yKVCINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84EpLa8k3tDYxMzI0sjM
	wsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGNUmawd4r88IWXnh2ea630oLiwR2
	emyXjRI5VyJ9vv7oviOrGULVSlOZ0wK3X7huWvc3aeobvXVfFO1c9kXEqYTHWF+/F3Jj9uoH
	M5f4FRyfLG5+zCJFTahmclKzuZgN49flz/SZlHL3vt4g0ZjzP1PMsfDmucnFBg+VNhTm3ww1
	mHv6xMO3NUosxRmJhlrMRcWJADRIoTpfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch separates page size from level of translation tables in
configuration. It facilitates introduction of different options,
such as 4KB + 4 levels, 16KB + 4 levels and 64KB + 3 levels, easily.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm64/Kconfig                     |   36 +++++++++++++++++++++++++++++++-
 arch/arm64/include/asm/page.h          |    2 +-
 arch/arm64/include/asm/pgalloc.h       |    4 ++--
 arch/arm64/include/asm/pgtable-hwdef.h |    2 +-
 arch/arm64/include/asm/pgtable.h       |    8 +++----
 arch/arm64/include/asm/tlb.h           |    2 +-
 6 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..1a2faf9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -144,14 +144,48 @@ endmenu
 
 menu "Kernel Features"
 
+choice
+	prompt "Page size"
+	default ARM64_4K_PAGES
+	help
+	  Allows page size.
+
+config ARM64_4K_PAGES
+	bool "4KB"
+	help
+	  This feature enables 4KB pages support.
+
 config ARM64_64K_PAGES
-	bool "Enable 64KB pages support"
+	bool "64KB"
 	help
 	  This feature enables 64KB pages support (4KB by default)
 	  allowing only two levels of page tables and faster TLB
 	  look-up. AArch32 emulation is not available when this feature
 	  is enabled.
 
+endchoice
+
+choice
+	prompt "Level of translation tables"
+	default ARM64_3_LEVELS if ARM64_4K_PAGES
+	default ARM64_2_LEVELS if ARM64_64K_PAGES
+	help
+	  Allows level of translation tables.
+
+config ARM64_2_LEVELS
+	bool "2 level"
+	depends on ARM64_64K_PAGES
+	help
+	  This feature enables 2 levels of translation tables.
+
+config ARM64_3_LEVELS
+	bool "3 level"
+	depends on ARM64_4K_PAGES
+	help
+	  This feature enables 3 levels of translation tables.
+
+endchoice
+
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 46bf666..268e53d 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -33,7 +33,7 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_ARM64_64K_PAGES
+#ifdef CONFIG_ARM64_2_LEVELS
 #include <asm/pgtable-2level-types.h>
 #else
 #include <asm/pgtable-3level-types.h>
diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 9bea6e7..4829837 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -26,7 +26,7 @@
 
 #define check_pgt_cache()		do { } while (0)
 
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifndef CONFIG_ARM64_2_LEVELS
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
@@ -44,7 +44,7 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 	set_pud(pud, __pud(__pa(pmd) | PMD_TYPE_TABLE));
 }
 
-#endif	/* CONFIG_ARM64_64K_PAGES */
+#endif	/* CONFIG_ARM64_2_LEVELS */
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 5fc8a66..9cd86c6 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -16,7 +16,7 @@
 #ifndef __ASM_PGTABLE_HWDEF_H
 #define __ASM_PGTABLE_HWDEF_H
 
-#ifdef CONFIG_ARM64_64K_PAGES
+#ifdef CONFIG_ARM64_2_LEVELS
 #include <asm/pgtable-2level-hwdef.h>
 #else
 #include <asm/pgtable-3level-hwdef.h>
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 90c811f..a64ce5e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -47,7 +47,7 @@ extern void __pmd_error(const char *file, int line, unsigned long val);
 extern void __pgd_error(const char *file, int line, unsigned long val);
 
 #define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifndef CONFIG_ARM64_2_LEVELS
 #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
 #endif
 #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
@@ -320,7 +320,7 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
  */
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
 
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifndef CONFIG_ARM64_2_LEVELS
 
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		(!(pud_val(pud) & 2))
@@ -342,7 +342,7 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
 	return __va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
 }
 
-#endif	/* CONFIG_ARM64_64K_PAGES */
+#endif	/* CONFIG_ARM64_2_LEVELS */
 
 /* to find an entry in a page-table-directory */
 #define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
@@ -353,7 +353,7 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
 /* Find an entry in the second-level page table.. */
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifndef CONFIG_ARM64_2_LEVELS
 #define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)
 {
diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index 72cadf5..df378b2 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -90,7 +90,7 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	tlb_remove_page(tlb, pte);
 }
 
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifndef CONFIG_ARM64_2_LEVELS
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
 				  unsigned long addr)
 {
-- 
1.7.10.4


