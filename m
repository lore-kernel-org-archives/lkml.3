Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaD2E70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:59:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64241 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbaD2E7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:59:22 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-0c-535f31a86e08
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v4 2/7] arm64: Decouple page size from level of translation
 tables
Date: Tue, 29 Apr 2014 13:59:20 +0900
Message-id: <000201cf6367$c8084440$5818ccc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jZUcR0muBCVVlRbiAXvDR/9l02A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zI90VhvHBBt1LzSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	8c61bAV7dCtmv//C3MB4T7WLkYNDQsBEYs9byy5GTiBTTOLCvfVsXYxcHEICyxglnm3cwAaR
	MJFofbecESKxiFHi3JU37BDOH0aJ/Z172EGq2AQ0JR7d7QFLiAjsYJSYvHYRK4jDLPCQUeLn
	2/3MIFXCAiES25a/ZQGxWQRUJU5d+g3WzStgKTHv2GZmCFtQ4sfke2A1zAJaEut3HmeCsOUl
	Nq95ywxxk4LEjrOvGUFsEQE9iYnnW9khakQk9r14xwhR08kh8X+KCsQuAYlvkw+xQPwsK7Hp
	ANQYSYmDK26wTGAUm4Vk8ywkm2ch2TwLyYYFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3
	MUKieuIOxvsHrA8xJgOtn8gsJZqcD0wKeSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8s
	Sc1OTS1ILYovKs1JLT7EyMTBKdXAWPZrhnSUojiz2JWLmccdkx7pFPLYOT559iq1Y3Nd9+rM
	lCvOkqLn6lNKTr31E1h6cGfOCtfJy7591uCYtWZuJLvG4zdJPpV9jFmrFye7qjIkPV92xKli
	+a2EJHPBdWzTAm+ZPEz17a7Li3GZFPvm486jPwOdeDeUTpm499CCkILt4me9p9stVGIpzkg0
	1GIuKk4EAA8t0gsAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAd0VhvHBBst3GFj8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjMc717IV7NGtmP3+C3MD4z3VLkZODgkBE4nWd8sZIWwx
	iQv31rN1MXJxCAksYpQ4d+UNO4Tzh1Fif+cedpAqNgFNiUd3e8ASIgI7GCUmr13ECuIwCzxk
	lPj5dj8zSJWwQIjEtuVvWUBsFgFViVOXfoN18wpYSsw7tpkZwhaU+DH5HlgNs4CWxPqdx5kg
	bHmJzWveMkPcpCCx4+xrsPtEBPQkJp5vZYeoEZHY9+Id4wRGgVlIRs1CMmoWklGzkLQsYGRZ
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcNp5J72Bc1WBxiFGAg1GJh7cjJi5YiDWxrLgy
	9xCjBAezkggvh2Z8sBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnA1NaXkm8obGJmZGlkZmF
	kYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwlqQ4XhaZ9PvenLXCH0y4JsZOnn/8
	W21aWqZ7jlx9+udUl/u9Yp5s+9Tv+3+tX2ryQuogY9Vp5SexL05/jr/T0N/Iy3z9LmtB4eXX
	8yTr3ueYZ+jkhMU9/vZMVGnNg4hJuVst/l7vTEw7IauZIsd7JFDkftuCHdkLefeezisODRL9
	232SI1BLiaU4I9FQi7moOBEA3MPNC18DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch separates page size from level of translation tables in
configuration. It facilitates introduction of different options,
such as 4KB + 4 levels, 16KB + 4 levels and 64KB + 3 levels, easily.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@linaro.org>
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
index e759af5..c7f5d65 100644
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
index 80e2c08..bc19101 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -91,7 +91,7 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	tlb_remove_page(tlb, pte);
 }
 
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifndef CONFIG_ARM64_2_LEVELS
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
 				  unsigned long addr)
 {
-- 
1.7.10.4


