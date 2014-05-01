Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaEACef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:34:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38141 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaEACec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:34:32 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-9a-5361b2a9c381
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v5 5/6] arm64: mm: Implement 4 levels of translation tables
Date: Thu, 01 May 2014 11:34:16 +0900
Message-id: <000501cf64e5$d92ae870$8b80b950$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9k4jRviA4ds4hyQ+aDmuCHVyEVcQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfd2VmxKDDZ7fErX4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6M
	tztmsxZMKq34OLWLpYFxbXwXIyeHhICJxN5lhxghbDGJC/fWs3UxcnEICSxjlGhfdI4dpmj/
	9ptMEIlFjBJ3Hs5mhnD+MEo0bvjAClLFJqAp8ehuDztIQkRgB6PE5LWLWEEcZoGHjBI/3+4H
	auHgEBbwlmicJQLSwCKgKvFk3noWEJtXwFJi0c79ULagxI/J98BsZgEtifU7jzNB2PISm9e8
	ZYY4SUFix9nXYHeLCOhJvPqwiB2iRkRi34t3jCB7JQQ6OSQO/H3ADLFMQOLb5EMsIDdICMhK
	bDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT8
	3E2MkLju3cF4+4D1IcZkoPUTmaVEk/OBaSGvJN7Q2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLp
	iSWp2ampBalF8UWlOanFhxiZODilGhinFOz983CD/LFj9hvkBadL900Rc9o6u3azwWm31Zcy
	Ws7/n9mi+rj8+uqTy7R48pPWl+QeWrD39s2eR0Gm75hOPX/9u2rniX8LJh/fEMJ/Nk0jYVvj
	twcLZxeFXmOpL5TW7BSpaM4pC5pqf1XE8n+NodeT3J61Sx5/CFmqcfhqlF7Yd0Muc4VlSizF
	GYmGWsxFxYkAxh2w9AEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAd2VmxKDDQ5P5Lf4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygS5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGW93zGYtmFRa8XFqF0sD49r4LkZODgkBE4n9228yQdhi
	EhfurWfrYuTiEBJYxChx5+FsZgjnD6NE44YPrCBVbAKaEo/u9rCDJEQEdjBKTF67iBXEYRZ4
	yCjx8+1+oBYODmEBb4nGWSIgDSwCqhJP5q1nAbF5BSwlFu3cD2ULSvyYfA/MZhbQkli/8zgT
	hC0vsXnNW2aIkxQkdpx9zQhiiwjoSbz6sIgdokZEYt+Ld4wTGAVmIRk1C8moWUhGzULSsoCR
	ZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNJ4JrWDcWWDxSFGAQ5GJR7eCWyJwUKsiWXF
	lbmHGCU4mJVEeIPXAIV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5jQ8kriDY1NzIwsjcws
	jEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB8fQ+Pe2yV0nbH90W0pcLn7Ng/zJj
	q0VdLzT8gx6cf35yz77VM0orXm8Vm3sxINrgtf4nreVPvhxJ4nf6sDu1vK9sBVvdL97Ab1dd
	ut45flS45n1oh/LDs9KRxS3Gi0XVHlrtW3dlakyE6/2iU5tTXdXfOa/fXplwpzxdY7uRtKnW
	y7Dzos1/NZVYijMSDbWYi4oTAQjx7d9eAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements 4 levels of translation tables since 3 levels
of page tables with 4KB pages cannot support 40-bit physical address
space described in [1] due to the following issue.

It is a restriction that kernel logical memory map with 4KB + 3 levels
(0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
mapping for this region in map_mem function since __phys_to_virt for
this region reaches to address overflow.

If SoC design follows the document, [1], over 32GB RAM would be placed
from 544GB. Even 64GB system is supposed to use the region from 544GB
to 576GB for only 32GB RAM. Naturally, it would reach to enable 4 levels
of page tables to avoid hacking __virt_to_phys and __phys_to_virt.

However, it is recommended 4 levels of page table should be only enabled
if memory map is too sparse or there is about 512GB RAM.

References
----------
[1]: Principles of ARM Memory Maps, White Paper, Issue C

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm64/Kconfig                     |    8 ++++++
 arch/arm64/include/asm/memblock.h      |    6 +++++
 arch/arm64/include/asm/page.h          |    4 ++-
 arch/arm64/include/asm/pgalloc.h       |   20 ++++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h |    6 +++--
 arch/arm64/include/asm/pgtable.h       |   45 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/tlb.h           |    9 +++++++
 arch/arm64/kernel/head.S               |   46 +++++++++++++++++++++++++-------
 arch/arm64/kernel/traps.c              |    5 ++++
 arch/arm64/mm/fault.c                  |    1 +
 arch/arm64/mm/mmu.c                    |   16 ++++++++---
 11 files changed, 150 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b438540..3e49671 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -182,12 +182,17 @@ config ARM64_VA_BITS_42
 	bool "42-bit"
 	depends on ARM64_64K_PAGES
 
+config ARM64_VA_BITS_48
+	bool "48-bit"
+	depends on ARM64_4K_PAGES
+
 endchoice
 
 config ARM64_VA_BITS
 	int
 	default 39 if ARM64_VA_BITS_39
 	default 42 if ARM64_VA_BITS_42
+	default 48 if ARM64_VA_BITS_48
 
 config ARM64_2_LEVELS
 	def_bool y if ARM64_64K_PAGES && ARM64_VA_BITS_42
@@ -195,6 +200,9 @@ config ARM64_2_LEVELS
 config ARM64_3_LEVELS
 	def_bool y if ARM64_4K_PAGES && ARM64_VA_BITS_39
 
+config ARM64_4_LEVELS
+	def_bool y if ARM64_4K_PAGES && ARM64_VA_BITS_48
+
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff --git a/arch/arm64/include/asm/memblock.h b/arch/arm64/include/asm/memblock.h
index 6afeed2..e4ac8bf 100644
--- a/arch/arm64/include/asm/memblock.h
+++ b/arch/arm64/include/asm/memblock.h
@@ -16,6 +16,12 @@
 #ifndef __ASM_MEMBLOCK_H
 #define __ASM_MEMBLOCK_H
 
+#ifndef CONFIG_ARM64_4_LEVELS
+#define MEMBLOCK_INITIAL_LIMIT	PGDIR_SIZE
+#else
+#define MEMBLOCK_INITIAL_LIMIT	PUD_SIZE
+#endif
+
 extern void arm64_memblock_init(void);
 
 #endif
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 268e53d..83b5289 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -35,8 +35,10 @@
 
 #ifdef CONFIG_ARM64_2_LEVELS
 #include <asm/pgtable-2level-types.h>
-#else
+#elif defined(CONFIG_ARM64_3_LEVELS)
 #include <asm/pgtable-3level-types.h>
+#else
+#include <asm/pgtable-4level-types.h>
 #endif
 
 extern void __cpu_clear_user_page(void *p, unsigned long user);
diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 4829837..8d745fa 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -26,6 +26,26 @@
 
 #define check_pgt_cache()		do { } while (0)
 
+#ifdef CONFIG_ARM64_4_LEVELS
+
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
+}
+
+static inline void pud_free(struct mm_struct *mm, pud_t *pud)
+{
+	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
+	free_page((unsigned long)pud);
+}
+
+static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
+{
+	set_pgd(pgd, __pgd(__pa(pud) | PUD_TYPE_TABLE));
+}
+
+#endif  /* CONFIG_ARM64_4_LEVELS */
+
 #ifndef CONFIG_ARM64_2_LEVELS
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 9cd86c6..ba30053 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -18,8 +18,10 @@
 
 #ifdef CONFIG_ARM64_2_LEVELS
 #include <asm/pgtable-2level-hwdef.h>
-#else
+#elif defined(CONFIG_ARM64_3_LEVELS)
 #include <asm/pgtable-3level-hwdef.h>
+#else
+#include <asm/pgtable-4level-hwdef.h>
 #endif
 
 /*
@@ -27,7 +29,7 @@
  *
  * Level 1 descriptor (PUD).
  */
-
+#define PUD_TYPE_TABLE		(_AT(pudval_t, 3) << 0)
 #define PUD_TABLE_BIT		(_AT(pgdval_t, 1) << 1)
 
 /*
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a64ce5e..b27cc426 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -35,7 +35,11 @@
  * VMALLOC and SPARSEMEM_VMEMMAP ranges.
  */
 #define VMALLOC_START		(UL(0xffffffffffffffff) << VA_BITS)
+#ifndef CONFIG_ARM64_4_LEVELS
 #define VMALLOC_END		(PAGE_OFFSET - UL(0x400000000) - SZ_64K)
+#else
+#define VMALLOC_END		(PAGE_OFFSET - UL(0x40000000000) - SZ_64K)
+#endif
 
 #define vmemmap			((struct page *)(VMALLOC_END + SZ_64K))
 
@@ -44,12 +48,16 @@
 #ifndef __ASSEMBLY__
 extern void __pte_error(const char *file, int line, unsigned long val);
 extern void __pmd_error(const char *file, int line, unsigned long val);
+extern void __pud_error(const char *file, int line, unsigned long val);
 extern void __pgd_error(const char *file, int line, unsigned long val);
 
 #define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
 #ifndef CONFIG_ARM64_2_LEVELS
 #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
 #endif
+#ifdef CONFIG_ARM64_4_LEVELS
+#define pud_ERROR(pud)		__pud_error(__FILE__, __LINE__, pud_val(pud))
+#endif
 #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
 
 /*
@@ -344,6 +352,30 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
 
 #endif	/* CONFIG_ARM64_2_LEVELS */
 
+#ifdef CONFIG_ARM64_4_LEVELS
+
+#define pgd_none(pgd)		(!pgd_val(pgd))
+#define pgd_bad(pgd)		(!(pgd_val(pgd) & 2))
+#define pgd_present(pgd)	(pgd_val(pgd))
+
+static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
+{
+	*pgdp = pgd;
+	dsb();
+}
+
+static inline void pgd_clear(pgd_t *pgdp)
+{
+	set_pgd(pgdp, __pgd(0));
+}
+
+static inline pud_t *pgd_page_vaddr(pgd_t pgd)
+{
+	return __va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
+}
+
+#endif  /* CONFIG_ARM64_4_LEVELS */
+
 /* to find an entry in a page-table-directory */
 #define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 
@@ -352,6 +384,14 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
+#ifdef CONFIG_ARM64_4_LEVELS
+#define pud_index(addr)		(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+static inline pud_t *pud_offset(pgd_t *pgd, unsigned long addr)
+{
+	return (pud_t *)pgd_page_vaddr(*pgd) + pud_index(addr);
+}
+#endif
+
 /* Find an entry in the second-level page table.. */
 #ifndef CONFIG_ARM64_2_LEVELS
 #define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
@@ -380,8 +420,13 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 
+#ifdef CONFIG_ARM64_4_LEVELS
+#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
+#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
+#else
 #define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
 #define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
+#endif
 
 /*
  * Encode and decode a swap entry:
diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index bc19101..086112b 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -100,6 +100,15 @@ static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
 }
 #endif
 
+#ifdef CONFIG_ARM64_4_LEVELS
+static inline void __pud_free_tlb(struct mmu_gather *tlb, pmd_t *pudp,
+				  unsigned long addr)
+{
+	tlb_add_flush(tlb, addr);
+	tlb_remove_page(tlb, virt_to_page(pudp));
+}
+#endif
+
 static inline void __tlb_remove_pmd_tlb_entry(struct mmu_gather *tlb, pmd_t *pmdp,
 						unsigned long address)
 {
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 0fd5650..03ec424 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -37,8 +37,9 @@
 
 /*
  * swapper_pg_dir is the virtual address of the initial page table. We place
- * the page tables 3 * PAGE_SIZE below KERNEL_RAM_VADDR. The idmap_pg_dir has
- * 2 pages and is placed below swapper_pg_dir.
+ * the page tables 3 * PAGE_SIZE (2 or 3 levels) or 4 * PAGE_SIZE (4 levels)
+ * below KERNEL_RAM_VADDR. The idmap_pg_dir has 2 pages (2 or 3 levels) or
+ * 3 pages (4 levels) and is placed below swapper_pg_dir.
  */
 #define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
 
@@ -46,8 +47,13 @@
 #error KERNEL_RAM_VADDR must start at 0xXXX80000
 #endif
 
+#ifdef CONFIG_ARM64_4_LEVELS
+#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
+#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
+#else
 #define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
 #define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
+#endif
 
 	.globl	swapper_pg_dir
 	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
@@ -370,16 +376,38 @@ ENDPROC(__calc_phys_offset)
 	.quad	PAGE_OFFSET
 
 /*
+ * Macro to populate the PUD for the corresponding block entry in the next
+ * level (tbl) for the given virtual address in case of 4levels.
+ */
+	.macro	create_pud_entry, pgd, tbl, virt, pud, tmp1, tmp2
+#ifdef CONFIG_ARM64_4_LEVELS
+	add	\tbl, \tbl, #PAGE_SIZE		// bump tbl 1 page up.
+						// to make room for pud
+	add	\pud, \pgd, #PAGE_SIZE		// pgd points to pud which
+						// follows pgd
+	lsr	\tmp1, \virt, #PUD_SHIFT
+	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
+	orr	\tmp2, \tbl, #3			// PUD entry table type
+	str	\tmp2, [\pud, \tmp1, lsl #3]
+#else
+	mov	\pud, \tbl
+#endif
+	.endm
+
+/*
  * Macro to populate the PGD for the corresponding block entry in the next
  * level (tbl) for the given virtual address.
  *
- * Preserves:	pgd, tbl, virt
- * Corrupts:	tmp1, tmp2
+ * Preserves:	pgd, virt
+ * Corrupts:	tmp1, tmp2, tmp3
+ * Returns:	tbl -> page where block mappings can be placed
+ *	(changed to make room for pud with 4levels, preserved otherwise)
  */
-	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2
+	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2, tmp3
+	create_pud_entry \pgd, \tbl, \virt, \tmp3, \tmp1, \tmp2
 	lsr	\tmp1, \virt, #PGDIR_SHIFT
 	and	\tmp1, \tmp1, #PTRS_PER_PGD - 1	// PGD index
-	orr	\tmp2, \tbl, #3			// PGD entry table type
+	orr	\tmp2, \tmp3, #3		// PGD entry table type
 	str	\tmp2, [\pgd, \tmp1, lsl #3]
 	.endm
 
@@ -444,7 +472,7 @@ __create_page_tables:
 	add	x0, x25, #PAGE_SIZE		// section table address
 	ldr	x3, =KERNEL_START
 	add	x3, x3, x28			// __pa(KERNEL_START)
-	create_pgd_entry x25, x0, x3, x5, x6
+	create_pgd_entry x25, x0, x3, x1, x5, x6
 	ldr	x6, =KERNEL_END
 	mov	x5, x3				// __pa(KERNEL_START)
 	add	x6, x6, x28			// __pa(KERNEL_END)
@@ -455,7 +483,7 @@ __create_page_tables:
 	 */
 	add	x0, x26, #PAGE_SIZE		// section table address
 	mov	x5, #PAGE_OFFSET
-	create_pgd_entry x26, x0, x5, x3, x6
+	create_pgd_entry x26, x0, x5, x1, x3, x6
 	ldr	x6, =KERNEL_END
 	mov	x3, x24				// phys offset
 	create_block_map x0, x7, x3, x5, x6
@@ -481,7 +509,7 @@ __create_page_tables:
 	 */
 	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
 	add	x0, x26, #2 * PAGE_SIZE		// section table address
-	create_pgd_entry x26, x0, x5, x6, x7
+	create_pgd_entry x26, x0, x5, x1, x6, x7
 
 	/*
 	 * Since the page tables have been populated with non-cacheable
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 268ce96..237757d 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -336,6 +336,11 @@ void __pmd_error(const char *file, int line, unsigned long val)
 	pr_crit("%s:%d: bad pmd %016lx.\n", file, line, val);
 }
 
+void __pud_error(const char *file, int line, unsigned long val)
+{
+	pr_crit("%s:%d: bad pud %016lx.\n", file, line, val);
+}
+
 void __pgd_error(const char *file, int line, unsigned long val)
 {
 	pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c23751b..ed4a343 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -61,6 +61,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 			break;
 
 		pud = pud_offset(pgd, addr);
+		printk(", *pud=%016llx", pud_val(*pud));
 		if (pud_none(*pud) || pud_bad(*pud))
 			break;
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6b7e895..4d29332 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -32,6 +32,7 @@
 #include <asm/setup.h>
 #include <asm/sizes.h>
 #include <asm/tlb.h>
+#include <asm/memblock.h>
 #include <asm/mmu_context.h>
 
 #include "mm.h"
@@ -222,9 +223,15 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
 				  unsigned long end, unsigned long phys)
 {
-	pud_t *pud = pud_offset(pgd, addr);
+	pud_t *pud;
 	unsigned long next;
 
+	if (pgd_none(*pgd) || pgd_bad(*pgd)) {
+		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
+		pgd_populate(&init_mm, pgd, pud);
+	}
+
+	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
 		alloc_init_pmd(pud, addr, next, phys);
@@ -271,10 +278,11 @@ static void __init map_mem(void)
 	 * memory addressable from the initial direct kernel mapping.
 	 *
 	 * The initial direct kernel mapping, located at swapper_pg_dir,
-	 * gives us PGDIR_SIZE memory starting from PHYS_OFFSET (which must be
-	 * aligned to 2MB as per Documentation/arm64/booting.txt).
+	 * gives us PGDIR_SIZE (2 and 3 levels) or PUD_SIZE (4 levels) memory
+	 * starting from PHYS_OFFSET (which must be aligned to 2MB as per
+	 * Documentation/arm64/booting.txt).
 	 */
-	limit = PHYS_OFFSET + PGDIR_SIZE;
+	limit = PHYS_OFFSET + MEMBLOCK_INITIAL_LIMIT;
 	memblock_set_current_limit(limit);
 
 	/* map all the memory banks */
-- 
1.7.10.4


