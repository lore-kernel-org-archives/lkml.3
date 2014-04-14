Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaDNHlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:41:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13906 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaDNHlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:41:02 -0400
X-AuditID: cbfee68e-b7f566d000002344-ba-534b910dd13a
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 6/8] arm64: Add 4 levels of page tables definition with 4KB
 pages
Date: Mon, 14 Apr 2014 16:41:01 +0900
Message-id: <000401cf57b4$e1d3d600$a57b8200$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XrYIpE6l0bqhnRku6TvBe10oqPQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zfV3eid7BBu+bJS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzeLDjJWMDtwea+at
	YfT4/WsSo8eda3vYPM5vWsPssXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlbLy3nLHg
	qkrFrYcnmBsYl8p1MXJwSAiYSKz4kNjFyAlkiklcuLeerYuRi0NIYBmjxPR3l1khEiYS51+9
	ZoVITGeU6H3wnh3C+cMo8WDbKyaQKjYBTYlHd3vAEiICOxglJq9dBNbCLHCCUWLpnbVgs4QF
	giWe//vODmKzCKhK7G5pAevmFbCU2LT9HQuELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZIW5S
	kNhx9jUjiC0ioCexbdVzNogaEYl9L94xgiyWEGjkkHhyYT0zxDIBiW+TD7FAPC0rsekA1BxJ
	iYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQqK5
	bwfjzQPWhxiTgdZPZJYSTc4HJoO8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cDo2riHwe228LLqyhnifcYGhy7dNRRS3lCqXuhs+Kvn/hvVdcW3
	/rqtuDl11fVjP3N5bnDszU+saAutt3rqV14i1vyYR8zAeudfnoqsjnXRhzSP8t4Njbd3enzp
	9U228OxKxbYJ/N6Hv608MfGDgROnMuu7PfZm29btiS6eoens+GrzS3HheFElluKMREMt5qLi
	RACNqsxF/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV3eid7BBnf2C1v8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WHGSsZHbg91sxb
	w+jx+9ckRo871/aweZzftIbZY/OSeo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmLHx3nLGgqsqFbcenmBuYFwq18XIySEhYCJx/tVrVghbTOLCvfVs
	XYxcHEIC0xkleh+8Z4dw/jBKPNj2igmkik1AU+LR3R6whIjADkaJyWsXsYI4zAInGCWW3lkL
	NktYIFji+b/v7CA2i4CqxO6WFrBuXgFLiU3b37FA2IISPybfA7OZBbQk1u88zgRhy0tsXvOW
	GeImBYkdZ18zgtgiAnoS21Y9Z4OoEZHY9+Id4wRGgVlIRs1CMmoWklGzkLQsYGRZxSiaWpBc
	UJyUnmukV5yYW1yal66XnJ+7iRGcLJ5J72Bc1WBxiFGAg1GJhzdhu2ewEGtiWXFl7iFGCQ5m
	JRHebRlewUK8KYmVValF+fFFpTmpxYcYk4E+ncgsJZqcD0xkeSXxhsYmZkaWRmYWRibm5qQJ
	K4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAmLKE8XFsetwe8fuJ817OrXP2UOHa7G29V15I
	R3/r1GPh/v/bfs/bw+vNuWI7t8+ZDx9b9n9UCNl4SK/AtzWjp3ZC3mndRdmXvCtSY9eb3TO+
	K7hj7flywWd7Ey/8ryy+2vH13M3U/aVdDBInmTRkzao12CVLw2dY/Th9n8eJb92+9/kOC1/c
	UWIpzkg01GIuKk4EAKRcFxFaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds hardware definition and types for 4 levels of
translation tables with 4KB pages.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
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


