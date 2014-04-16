Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaDPEet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:34:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9167 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaDPEd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:33:27 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-3d-534e081564a4
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v2 5/7] arm64: Add 4 levels of page tables definition with 4KB
 pages
Date: Wed, 16 Apr 2014 13:33:25 +0900
Message-id: <004501cf592d$01b05f10$05111d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ZK3T6FSOgwxHLTk68QaR665F9WQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zQ11RDr9ggzkzpS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	473ljAVXVSpuPTzB3MC4VK6LkZNDQsBEYmfjA1YIW0ziwr31bF2MXBxCAssYJS78eM4KU7Tx
	/lJGEFtIYDqjxLcbQhBFfxgler91sYAk2AQ0JR7d7WEHSYgI7GCUmLx2ESuIwyzwkFHi59v9
	zCBVwgJhEsebToCNZRFQlZjSMZcJxOYVsJTYeXYWG4QtKPFj8j2wqcwCWhLrdx5ngrDlJTav
	ecsMcZKCxI6zr4FO4gDapiexd7EVRImIxL4X7xhB9koIdHJIHDt0lRlil4DEt8mHWEDqJQRk
	JTYdgBojKXFwxQ2WCYxis5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5y
	fu4mRkhUT9zBeP+A9SHGZKD1E5mlRJPzgUkhryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYE2/dC2jK22zsa8XFKrff44B+2RuJi+8XG63IW/t6
	nq265PVHR8NYrUNZjnB4TnZLkPP6nZ6672+nVXx6vOWP3PCi4AN9phGdUn7//HVWJvx2y2Lh
	3KL0yitzxQfPbA1fQR/+5ry/WxVkva+xPnv/XLZ9wbw5N6+xSycsm8DKuG1arftMv7NKLMUZ
	iYZazEXFiQAedskUAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQV1RDr9gg/6FYhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4xY+O95YwFV1Uqbj08wdzAuFSui5GTQ0LARGLj/aWMELaY
	xIV769lAbCGB6YwS324IdTFyAdl/GCV6v3WxgCTYBDQlHt3tYQdJiAjsYJSYvHYRK4jDLPCQ
	UeLn2/3MIFXCAmESx5tOsILYLAKqElM65jKB2LwClhI7z85ig7AFJX5Mvgc2lVlAS2L9zuNM
	ELa8xOY1b5khTlKQ2HH2NdB5HEDb9CT2LraCKBGR2PfiHeMERoFZSCbNQjJpFpJJs5C0LGBk
	WcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnDKeSe9gXNVgcYhRgINRiYd3Zo5vsBBrYllx
	Ze4hRgkOZiUR3i9fgEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xneSXxhsYmZkaWRmYW
	Ribm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGFvo3uS24bmv6FSmVLm+Q6z/zyvu
	/3D28qtTbiZ/lSY/+P+NYWFX53y1gM7dJhapEsc35sn2vz7I7X2olTFQX0M4925OoMH8ZAn5
	jMIPuoXcB0IaxKMsX6qJeRyfWy9R85/v3rubGxqiIiMEgzudjl07r/6jLvJ3o9DK+Z+50s51
	FgVdO3BPiaU4I9FQi7moOBEAWVbKAl0DAAA=
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


