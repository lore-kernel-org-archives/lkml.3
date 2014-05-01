Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaEACe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:34:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26357 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaEACeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:34:22 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-79-5361b2a58740
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v5 4/6] arm64: Add 4 levels of page tables definition with 4KB
 pages
Date: Thu, 01 May 2014 11:34:12 +0900
Message-id: <000401cf64e5$d6c18990$84449cb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9k4hhznX/GBvnpSzeaJXTQqhk8KA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zY92lmxKDDb69EbD4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6M
	zv2zWQs2qFacWHmbpYHxm1wXIyeHhICJxLa7ExghbDGJC/fWs3UxcnEICSxjlLj6vpMdpmjF
	jNXsEInpjBKP365mAUkICfxhlPh02Q3EZhPQlHh0twesSERgB6PE5LWLWEEcZoGHjBI/3+5n
	7mLk4BAWCJO41FgF0sAioCqxbPtPsA28ApYSa9r/MkLYghI/Jt8DW8AsoCWxfudxJghbXmLz
	mrfMEBcpSOw4+5oRZKSIgJ7E8ee6ECUiEvtevGMEWSsh0Msh8e7pKlaIXQIS3yYfYgGplxCQ
	ldh0AGqMpMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ
	+bmbGCEx3buD8fYB60OMyUDrJzJLiSbnA1NCXkm8obGZkYWpiamxkbmlGWnCSuK8SQ+TgoQE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwWmS0uBYElitPf9Mk/v4e//YtD/v7b079Md/ETOdB
	jXPInad5X9Pemm9KXCeYadOeXbH5OsdF8d71x+Tcklx+v92mPaXptVSj5HOtu34V1nv+RDZ6
	XX7p8ep98HTdzsiFz0J3LHlZpjdpTpbbijO8k2RrXniEvHhxfn/QzwQ1f+kr/ulLjSefVWIp
	zkg01GIuKk4EAD9QaZr/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQd2lmxKDDfa18Vj8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjM79s1kLNqhWnFh5m6WB8ZtcFyMnh4SAicSKGavZIWwx
	iQv31rN1MXJxCAlMZ5R4/HY1C0hCSOAPo8Sny24gNpuApsSjuz3sIEUiAjsYJSavXcQK4jAL
	PGSU+Pl2P3MXIweHsECYxKXGKpAGFgFViWXbf4Jt4BWwlFjT/pcRwhaU+DH5HtgCZgEtifU7
	jzNB2PISm9e8ZYa4SEFix9nXjCAjRQT0JI4/14UoEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQs
	YGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcMJ5J7WBc2WBxiFGAg1GJh3cCW2KwEGti
	WXFl7iFGCQ5mJRHe4DVAId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJrO8knhDYxMzI0sj
	MwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamBUnJSYHz5vp0jFxl/iBqdSBYTi
	OCXNju1wuhzD/PpY1WLeprjW4i3F97KkvzZvOcr+3/6PVdrkpeYtFlKJHxRuM87Jr9/58eLb
	9n9xQc5uvFeOdE07rNe0wt9h59rQt+9cJruvCrbX0KnUNGxkfDrz8+mfT/YoZOWl1K08e2bu
	jsp3Jez7kvqVWIozEg21mIuKEwFNp7ppXAMAAA==
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


