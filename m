Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaEACeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:34:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38116 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaEACd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:33:59 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-ab-5361b29501f3
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v5 2/6] arm64: Introduce VA_BITS and translation level options
Date: Thu, 01 May 2014 11:33:56 +0900
Message-id: <000201cf64e5$cd3366a0$679a33e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9k4boK7z1GEWCpQS6p8e5Uv6cNKQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zY92pmxKDDa71iFn8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	pzUN7AX/TSvmvzVvYHyr08XIySEhYCKxr+0aE4QtJnHh3nq2LkYuDiGBZYwS377MYoMp6nn6
	nREiMZ1RonPxfVYI5w+jxPUZN9hBqtgENCUe3e1hB0mICOxglJi8dhFYFbPAQ0aJn2/3M4NU
	CQv4Sbz+9RxsIYuAqsSZWyBzOTh4BSwl7u7iAAnzCghK/Jh8jwXEZhbQkli/8zgThC0vsXnN
	W2aIkxQkdpx9zQhiiwjoSVzc/IcNokZEYt+Ld2CnSgj0ckh8PvGZHWKXgMS3yYdYQHZJCMhK
	bDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT8
	3E2MkKju38F494D1IcZkoPUTmaVEk/OBSSGvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTD65HGGcWUY/xQL8H1efcC4pCP7+6uf2ixON7u9X5bI
	CGh+VBWblfggimPlzo3e0/s0jq+smbc1wW5xxudFfv6854M3VfpX2Pfv2dHZpX/iofwVnS9T
	HXQVVPd8uOS6Veaebeb7g+WXohw2zFN6svybharmAx79I34qKglfE+baLelf15VzzEOJpTgj
	0VCLuag4EQCFiUFJAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQd2pmxKDDWatFbD4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygS5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGZ/WNLAX/DetmP/WvIHxrU4XIyeHhICJRM/T74wQtpjE
	hXvr2boYuTiEBKYzSnQuvs8K4fxhlLg+4wY7SBWbgKbEo7s97CAJEYEdjBKT1y4Cq2IWeMgo
	8fPtfmaQKmEBP4nXv54zgdgsAqoSZ26B7ODg4BWwlLi7iwMkzCsgKPFj8j0WEJtZQEti/c7j
	TBC2vMTmNW+ZIU5SkNhx9jXYeSICehIXN/9hg6gRkdj34h3jBEaBWUhGzUIyahaSUbOQtCxg
	ZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwynkntYFzZYHGIUYCDUYmHdwJbYrAQa2JZ
	cWXuIUYJDmYlEd7gNUAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgems7ySeENjEzMjSyMz
	CyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYKz5OK1uy6xbGZfucSdJRYV67J5Y
	fsyoMv/1V+YgtUVvohUqaw4ck95V/f9iMW/5xVqbSRs5oyZdOJCpwZda98z0tOOtjZb/m/eZ
	H7fO/Crhw6GzMUflUP/V16vv9xomrtSaqyLF9mTWjOkcVjtOz78l8m/jOXO9O93c/71qF0VM
	ChG8ZMsYdlGJpTgj0VCLuag4EQBVqHWvXQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds virtual address space size and a level of translation
tables to kernel configuration. It facilicates introduction of
different MMU options, such as 4KB + 4 levels, 16KB + 4 levels and
64KB + 3 levels, easily.

The idea is based on the discussion with Catalin Marinas:
http://www.spinics.net/linux/lists/arm-kernel/msg319552.html

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm64/Kconfig                     |   45 +++++++++++++++++++++++++++++++-
 arch/arm64/include/asm/memory.h        |    6 +----
 arch/arm64/include/asm/page.h          |    2 +-
 arch/arm64/include/asm/pgalloc.h       |    4 +--
 arch/arm64/include/asm/pgtable-hwdef.h |    2 +-
 arch/arm64/include/asm/pgtable.h       |    8 +++---
 arch/arm64/include/asm/tlb.h           |    2 +-
 7 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e759af5..b438540 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -144,14 +144,57 @@ endmenu
 
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
+	prompt "Virtual address space size"
+	default ARM64_VA_BITS_39 if ARM64_4K_PAGES
+	default ARM64_VA_BITS_42 if ARM64_64K_PAGES
+	help
+	  Allows virtual address space size. A level of translation tables
+	  is determined by a combination of page size and virtual address
+	  space size.
+
+config ARM64_VA_BITS_39
+	bool "39-bit"
+	depends on ARM64_4K_PAGES
+
+config ARM64_VA_BITS_42
+	bool "42-bit"
+	depends on ARM64_64K_PAGES
+
+endchoice
+
+config ARM64_VA_BITS
+	int
+	default 39 if ARM64_VA_BITS_39
+	default 42 if ARM64_VA_BITS_42
+
+config ARM64_2_LEVELS
+	def_bool y if ARM64_64K_PAGES && ARM64_VA_BITS_42
+
+config ARM64_3_LEVELS
+	def_bool y if ARM64_4K_PAGES && ARM64_VA_BITS_39
+
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index e94f945..f6e7480 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -41,11 +41,7 @@
  * The module space lives between the addresses given by TASK_SIZE
  * and PAGE_OFFSET - it must be within 128MB of the kernel text.
  */
-#ifdef CONFIG_ARM64_64K_PAGES
-#define VA_BITS			(42)
-#else
-#define VA_BITS			(39)
-#endif
+#define VA_BITS			(CONFIG_ARM64_VA_BITS)
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
 #define MODULES_END		(PAGE_OFFSET)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
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


