Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaDRH7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:59:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26695 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaDRH7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:18 -0400
X-AuditID: cbfee690-b7f266d00000287c-db-5350db545ba2
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v3 5/7] arm64: Add 4 levels of page tables definition with 4KB
 pages
Date: Fri, 18 Apr 2014 16:59:16 +0900
Message-id: <000601cf5adc$18490fa0$48db2ee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9a1L5T2RBXDhkORcaxK/sKOQpTZA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zI92Q2wHBBjcWqln8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	xnvLGQuuqlTceniCuYFxqVwXIweHhICJRNOhoC5GTiBTTOLCvfVsXYxcHEICyxglXtxeywSR
	MJGYd+0BmC0kMJ1R4uBFe4iiP4wSLWsfgiXYBDQlHt3tYQdJiAjsYJSYvHYRK4jDLPCQUeLn
	2/3MIFXCAmESR8/OBetgEVCVOL96NZjNK2ApsW/Zf2YIW1Dix+R7LCA2s4CWxPqdx5kgbHmJ
	zWveMkOcpCCx4+xrRhBbREBP4sR/mHoRiX0v3jFC1LRySNw+IACxS0Di2+RDLBAvy0psOgA1
	RlLi4IobLBMYxWYh2TwLyeZZSDbPQrJhASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQ
	mJ6wg/HeAetDjMlA6ycyS4km5wNTQl5JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MCo9OMj79N+tK5b9bBl7YpRU2RPf/RcVPKLBaZgfKnVopo+7
	qzOzgXHhN8Ujp2aV1W09s5BlZeD66MKZVkuvHdTeeyD9enO22Ns5j2J7Wk83pHGc2Zf+YkmN
	mvWTvdobdzfu8FgyY8/2iWaJpVzZM3/sdC4+PHdWpP0cn+k6B5ob2ljnr6s9/E6JpTgj0VCL
	uag4EQAGJVj6/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQd2Q2wHBBg/3KFr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjI33ljMWXFWpuPXwBHMD41K5LkZODgkBE4l51x4wQdhi
	EhfurWcDsYUEpjNKHLxo38XIBWT/YZRoWfsQrIhNQFPi0d0edpCEiMAORonJaxexgjjMAg8Z
	JX6+3c8MUiUsECZx9OxcsA4WAVWJ86tXg9m8ApYS+5b9Z4awBSV+TL7HAmIzC2hJrN95nAnC
	lpfYvOYtM8RJChI7zr5mBLFFBPQkTvyHqReR2PfiHeMERoFZSEbNQjJqFpJRs5C0LGBkWcUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnDSeSe1gXNlgcYhRgINRiYdXQC8gWIg1say4MvcQ
	owQHs5IIr3IpUIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgQktryTe0NjEzMjSyMzCyMTc
	nDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoY97CFHU930bdfysn6/btTxeUtzUFx+pLP
	95iXPZ/Hu/Xt82esD46+T9YomrXg/HKv53dMWWwVSuu6r/zWOjWnUOP1Xs8lz53t9NgaMkXt
	Psgt2Ni3I3Rq89qXXPfSlu/rmpvn/Syr6XlZ1A3rdIeqAubOSwJJVxhrv2bt8y2an+eiZHTb
	Y42wEktxRqKhFnNRcSIA4eu/8F4DAAA=
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


