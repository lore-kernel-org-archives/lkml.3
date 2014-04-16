Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaDPEf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:35:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10374 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaDPEdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:33:17 -0400
X-AuditID: cbfee68e-b7f566d000002344-c7-534e080b1232
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v2 2/7] arm64: Decouple page size from level of translation
 tables
Date: Wed, 16 Apr 2014 13:33:15 +0900
Message-id: <004201cf592c$fbb83420$f3289c60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ZKzwtuObvr1xjQzCWGlQ5URGHuw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zA11uDr9gg+cLZCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	8fL/jAUPdSreztrF3sDYq9rFyMkhIWAi0TxzDhOELSZx4d56ti5GLg4hgWWMEk+PXmGEKepY
	uogdIjGdUaL76zUWCOcPo8ShXe3MIFVsApoSj+72gFWJCOxglJi8dhEriMMs8JBR4ufb/WBV
	wgIhEou2dwMlODhYBFQlei/LgoR5BSwl2tYtY4SwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYt
	M8RJChI7zr4GqxcR0JPYf/wfM0SNiMS+F+8YQfZKCHRySDybdARsEIuAgMS3yYdYQPZKCMhK
	bDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT8
	3E2MkLju28F484D1IcZkoPUTmaVEk/OBaSGvJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTCG9gnNnS5//c2b03tfn06fNiPv48ygvadUfL+VlF6Q
	84oXfKn58fmeZaXq0Y5rLWwqAp7tWfS7matmh7b+u6rXB1f98qt4K8Vy7ILH1KQ1C9MLmINf
	XlmhvvpF5u9QXc2z81NXyho2RSpornm2/Kp9iCXX3Ivu+5vWP27f0qR1pL86Ut+c626BEktx
	RqKhFnNRcSIAfvX04AEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQV1uDr9gg19LxSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxuPl/xkLHupUvJ21i72BsVe1i5GTQ0LARKJj6SJ2CFtM
	4sK99WxdjFwcQgLTGSW6v15jgXD+MEoc2tXODFLFJqAp8ehuDztIQkRgB6PE5LWLWEEcZoGH
	jBI/3+4HqxIWCJFYtL0bKMHBwSKgKtF7WRYkzCtgKdG2bhkjhC0o8WPyPRYQm1lAS2L9zuNM
	ELa8xOY1b5khTlKQ2HH2NVi9iICexP7j/5ghakQk9r14xziBUWAWklGzkIyahWTULCQtCxhZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ41n0jsYVzVYHGIU4GBU4uGdmeMbLMSaWFZc
	mXuIUYKDWUmE98sXoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnAxNaXkm8obGJmZGlkZmF
	kYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwtv2/rfFatTz6D6eC3Eqe126hYhIS
	D/8eya/fu9zsW+e+X3o7DZd1mKQey9nzwvWcmVrQVY4daQ4veCUuOlqe+ufi8uNJGvfXws9B
	Wjedv9ZPfzmR68PBB02iV4Kea1hvvGitcdU08ti+lN/Tt+r/eTflBfPZhc/9qj4JfnkmI+GS
	djPw/0oXQyWW4oxEQy3mouJEAJClEYNeAwAA
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


