Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbaELJko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:40:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10577 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaELJkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:40:40 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-1b-53709716ea0d
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v6 2/7] arm64: Introduce VA_BITS and translation level options
Date: Mon, 12 May 2014 18:40:38 +0900
Message-id: <000101cf6dc6$3b93d510$b2bb7f30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9twwujTth5CjMFR0Cb4QqX0JnnTw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zI12x6QXBBmsXm1r8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	1s2L2Av6zCvunZrG3sD4VreLkZNDQsBE4viVhawQtpjEhXvr2boYuTiEBJYxShy584kFpujK
	vzksEIlFjBLXfq2BqvrDKLHo5Q82kCo2AU2JR3d72EESIgI7GCUmr13ECuIwCzxklPj5dj8z
	SJWwgJ/EuflPwRayCKhK/P20FczmFbCUWNd7iBnCFpT4Mfke2G5mAS2J9TuPM0HY8hKb17xl
	hrhJQWLH2deMILaIgJ7Eu3/LWCFqRCT2vXjHCFHTySFxd186xC4BiW+TDwHN5ACKy0psOgA1
	RlLi4IobLBMYxWYh2TwLyeZZSDbPQrJhASPLKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYyQ
	uO7fwXj3gPUhxmSg9ROZpUST84FpIa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MM7nyeZQTDmxUYGjqOfb19OB82MPf5+dKnf5qLpW4f8nO4pO
	+G5xZvv6TOTKaYOLPJamOumLv0zfPsVe+suWWZNK4wQMpFWTpJv/i+3aLX29VmfB//ScI7pX
	OfyyI58YM+wuvV5ru8NZ59LJlpj7nfmMnPYu4WtvTngf8clBYEJY+n+nCOb7NUosxRmJhlrM
	RcWJAHh7QBIBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAV2x6QXBBqdaDCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxtbNi9gL+swr7p2axt7A+Fa3i5GTQ0LAROLKvzksELaY
	xIV769m6GLk4hAQWMUpc+7UGyvnDKLHo5Q82kCo2AU2JR3d72EESIgI7GCUmr13ECuIwCzxk
	lPj5dj8zSJWwgJ/EuflPWUFsFgFVib+ftoLZvAKWEut6DzFD2IISPybfA9vNLKAlsX7ncSYI
	W15i85q3zBA3KUjsOPuaEcQWEdCTePdvGStEjYjEvhfvGCcwCsxCMmoWklGzkIyahaRlASPL
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgtPFMegfjqgaLQ4wCHIxKPLwfGAqChVgTy4or
	cw8xSnAwK4nwnpwIFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YErLK4k3NDYxM7I0MrMw
	MjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGZktjUe4A3awdJ242qW9+MkmtWjrS
	8/y3WRpOcnZxrdq/7nAuSQ3QWN40T0Xe6YvO7Rb3dtOqQ6kbnkltb3ttsWVlb0bC8e7K4vbp
	k4y2RwV8zZXuZHN/yP6bOyApjENwW0pahqxZdO8Zj7SQox4vRa0/9v06JH7AkDv6WmhUr+aL
	1PO7ZyixFGckGmoxFxUnAgB/UQ7CXwMAAA==
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
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
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
index 9a5b5fe..9a28cbe 100644
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
+	  Allows choosing one of multiple possible virtual address
+	  space sizes. The level of translation table is determined by
+	  a combination of page size and virtual address space size.
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
index 955e8c5..c7c603b 100644
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
index e4c60d6..4a350af 100644
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
@@ -324,7 +324,7 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
  */
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
 
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifndef CONFIG_ARM64_2_LEVELS
 
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		(!(pud_val(pud) & 2))
@@ -346,7 +346,7 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
 	return __va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
 }
 
-#endif	/* CONFIG_ARM64_64K_PAGES */
+#endif	/* CONFIG_ARM64_2_LEVELS */
 
 /* to find an entry in a page-table-directory */
 #define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
@@ -357,7 +357,7 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
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


