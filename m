Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbaELJlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:41:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26449 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaELJk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:40:57 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-cd-5370971fedfd
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v6 4/7] arm64: Add 4 levels of page tables definition with 4KB
 pages
Date: Mon, 12 May 2014 18:40:47 +0900
Message-id: <000301cf6dc6$40bec4f0$c23c4ed0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9tw0Dvsu2TL3m8REun/RFVIdJ16A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zI1356QXBBg+6FCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	85k5zAWz1Sr2NSxjbmC8Lt/FyMkhIWAisa7hLDOELSZx4d56NhBbSGAZo8Sx+/UwNW3Hl7B0
	MXIBxRcxSuxaOYcNwvnDKNF/YQ8LSBWbgKbEo7s97CAJEYEdjBKT1y5iBXGYBR4ySvx8ux9o
	BzuHsECYxI1wkHoWAVWJ07dXgW3jFbCUaFzXDGULSvyYfA9sJrOAlsT6nceZIGx5ic1r3kJd
	qiCx4+xrRhBbREBP4snf84wQNSIS+168YwRZKyHQySHRv+MJG8QyAYlvkw8BDeUASshKbDoA
	NUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2M
	kJieuIPx/gHrQ4zJQOsnMkuJJucDU0JeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTDuX2LCrXrr9ZFWx2iDb7st1mzKk9m2pfNCgvOWi5Y8gsHK
	6TNNb37V8zguleM481DIooX1vKLnr32+GH7ZwVu0tS/splt07VqzWXlP9349uTDt7LGmDLfP
	1zzWx/3+V12ax39T71lWxcTTMoz33b3tZ/38n3f39ou3RwJeivW06CkbXA1cwbBTiaU4I9FQ
	i7moOBEAO2JIdP8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jAV356QXBBquXSFv8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjM1n5jAXzFar2NewjLmB8bp8FyMnh4SAiUTb8SUsELaY
	xIV769m6GLk4hAQWMUrsWjkHyvnDKNF/YQ9YFZuApsSjuz3sIAkRgR2MEpPXLmIFcZgFHjJK
	/Hy7n7mLkZ1DWCBM4kY4SD2LgKrE6dur2EBsXgFLicZ1zVC2oMSPyffAZjILaEms33mcCcKW
	l9i85i0zxEUKEjvOvmYEsUUE9CSe/D3PCFEjIrHvxTvGCYwCs5CMmoVk1Cwko2YhaVnAyLKK
	UTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhlPJPawbiyweIQowAHoxIP7weGgmAh1sSy4src
	Q4wSHMxKIrwinUAh3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgems7ySeENjEzMjSyMzCyMT
	c3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYKyYtf7VLcfziRdU7ENm98TGfpx0warD
	+oSrj9w6aeMPBed3XMn17vf8F35mQmtEhaHeWpWKCOafpTufvLApO8kiKv5X4kTh6W18Jz3s
	9114mPaoXj595bIVBc56S/f+4Q/eE7K8g7nx3AubpiuRzNM9joe+zfKUC+hb/iH2ascrN56F
	0/RedyqxFGckGmoxFxUnAgDSZrQjXQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds hardware definition and types for 4 levels of
translation tables with 4KB pages.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/pgtable-4level-hwdef.h |   50 +++++++++++++++++
 arch/arm64/include/asm/pgtable-4level-types.h |   71 +++++++++++++++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 arch/arm64/include/asm/pgtable-4level-hwdef.h
 create mode 100644 arch/arm64/include/asm/pgtable-4level-types.h

diff --git a/arch/arm64/include/asm/pgtable-4level-hwdef.h b/arch/arm64/include/asm/pgtable-4level-hwdef.h
new file mode 100644
index 0000000..0ec84e2
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable-4level-hwdef.h
@@ -0,0 +1,50 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_4LEVEL_HWDEF_H
+#define __ASM_PGTABLE_4LEVEL_HWDEF_H
+
+#define PTRS_PER_PTE		512
+#define PTRS_PER_PMD		512
+#define PTRS_PER_PUD		512
+#define PTRS_PER_PGD		512
+
+/*
+ * PGDIR_SHIFT determines the size a top-level page table entry can map.
+ */
+#define PGDIR_SHIFT		39
+#define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_MASK		(~(PGDIR_SIZE-1))
+
+/*
+ * PUD_SHIFT determines the size the second level page table entry can map.
+ */
+#define PUD_SHIFT		30
+#define PUD_SIZE		(_AC(1, UL) << PUD_SHIFT)
+#define PUD_MASK		(~(PUD_SIZE-1))
+
+/*
+ * PMD_SHIFT determines the size the third level page table entry can map.
+ */
+#define PMD_SHIFT		21
+#define PMD_SIZE		(_AC(1, UL) << PMD_SHIFT)
+#define PMD_MASK		(~(PMD_SIZE-1))
+
+/*
+ * section address mask and size definitions.
+ */
+#define SECTION_SHIFT		21
+#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
+#define SECTION_MASK		(~(SECTION_SIZE-1))
+
+#endif
diff --git a/arch/arm64/include/asm/pgtable-4level-types.h b/arch/arm64/include/asm/pgtable-4level-types.h
new file mode 100644
index 0000000..7ad8dd2
--- /dev/null
+++ b/arch/arm64/include/asm/pgtable-4level-types.h
@@ -0,0 +1,71 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PGTABLE_4LEVEL_TYPES_H
+#define __ASM_PGTABLE_4LEVEL_TYPES_H
+
+#include <asm/types.h>
+
+typedef u64 pteval_t;
+typedef u64 pmdval_t;
+typedef u64 pudval_t;
+typedef u64 pgdval_t;
+
+#undef STRICT_MM_TYPECHECKS
+
+#ifdef STRICT_MM_TYPECHECKS
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { pteval_t pte; } pte_t;
+typedef struct { pmdval_t pmd; } pmd_t;
+typedef struct { pudval_t pud; } pud_t;
+typedef struct { pgdval_t pgd; } pgd_t;
+typedef struct { pteval_t pgprot; } pgprot_t;
+
+#define pte_val(x)	((x).pte)
+#define pmd_val(x)	((x).pmd)
+#define pud_val(x)	((x).pud)
+#define pgd_val(x)	((x).pgd)
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) } )
+#define __pmd(x)	((pmd_t) { (x) } )
+#define __pud(x)	((pud_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)	((pgprot_t) { (x) } )
+
+#else	/* !STRICT_MM_TYPECHECKS */
+
+typedef pteval_t pte_t;
+typedef pmdval_t pmd_t;
+typedef pudval_t pud_t;
+typedef pgdval_t pgd_t;
+typedef pteval_t pgprot_t;
+
+#define pte_val(x)	(x)
+#define pmd_val(x)	(x)
+#define pud_val(x)	(x)
+#define pgd_val(x)	(x)
+#define pgprot_val(x)	(x)
+
+#define __pte(x)	(x)
+#define __pmd(x)	(x)
+#define __pud(x)	(x)
+#define __pgd(x)	(x)
+#define __pgprot(x)	(x)
+
+#endif /* STRICT_MM_TYPECHECKS */
+
+#endif /* __ASM_PGTABLE_4LEVEL_TYPES_H */
-- 
1.7.10.4


