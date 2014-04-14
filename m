Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaDNHpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:45:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39267 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaDNHkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:40:47 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-6c-534b90fe90ed
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 3/8] arm64: Decouple page size from level of translation
Date: Mon, 14 Apr 2014 16:40:45 +0900
Message-id: <000101cf57b4$d8b58be0$8a20a3a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XrRot2l7yTSCnR8CN1sj5R05VOQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zI91/E7yDDd6/5rT4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CV8Xj5f8aC
	hzoVb2ftYm9g7FXtYuTkkBAwkXjw4BUbhC0mceHeeiCbi0NIYBmjxNUVbWwwRRfbG9hBbCGB
	RYwSm9oMIIr+MEqcfvaTGSTBJqAp8ehuDztIQkRgB6PE5LWLWEEcZoETjBJL76xlBakSFvCQ
	mHZhMpDNwcEioCpxoicKJMwrYCnx5co+JghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yQ1yk
	ILHj7GtGEFtEQE/ix8OnbBA1IhL7XrxjBNkrIdDKIfH40wawBIuAgMS3yYdYQPZKCMhKbDoA
	NUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2M
	kFieuIPx/gHrQ4zJQOsnMkuJJucDU0FeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTCavuyPanSY+UZ05fyEOecLjqR9jTrtMOFkQvmyo0W6Z5fP
	XJedP5vL7Eik5sNvXzoePslxMCtmZrA8wBoY1RRWUnX5jK6TdOhzR89m0/DEDTONeOYu13o9
	5fKr2Yc0W9VWfplwelrIqbNVk521A2zdOGfE3Mj3/XxRQilwuZh+4v+Y04Zq22crsRRnJBpq
	MRcVJwIA/XKIzPsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAd1/E7yDDT7/ZrH4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKSSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePx8v+MBQ91Kt7O2sXewNir2sXIySEhYCJxsb2BHcIWk7hwbz0b
	iC0ksIhRYlObQRcjF5D9h1Hi9LOfzCAJNgFNiUd3e9hBEiICOxglJq9dxAriMAucYJRYemct
	K0iVsICHxLQLk4FsDg4WAVWJEz1RIGFeAUuJL1f2MUHYghI/Jt9jAbGZBbQk1u88zgRhy0ts
	XvOWGeIiBYkdZ18zgtgiAnoSPx4+ZYOoEZHY9+Id4wRGgVlIRs1CMmoWklGzkLQsYGRZxSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcKJ5J7WBc2WBxiFGAg1GJhzdhu2ewEGtiWXFl7iFG
	CQ5mJRHebRlewUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xieSXxhsYmZkaWRmYWRibm
	5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGHP5hamR8JQ0q8fPhR0M7vQ1Wa+1Walm
	Onf1hJPBjmKurbdqmbL4FuiI5S+/uaY0wUfh+smPhf9qzp9ac1laQV2FL6zKrHLXwlUfmqUj
	pkrelBQyeulYsOnb9PXsjR9T1q5itDlretK/Q3vKumMfy0+/2mW+5VBBodVBrl9/H884ucRd
	ZYvpZiWW4oxEQy3mouJEAGynFs9YAwAA
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


