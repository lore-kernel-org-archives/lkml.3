Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaJTKMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:12:32 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64810 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaJTKLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:11:49 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Minchan Kim <minchan@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v17 6/7] arm64: add pmd_[dirty|mkclean] for THP
Date: Mon, 20 Oct 2014 19:12:03 +0900
Message-Id: <1413799924-17946-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1413799924-17946-1-git-send-email-minchan@kernel.org>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
overwrite of the contents since MADV_FREE syscall is called for
THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Steve Capper <steve.capper@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6d81471183ee..effc859084bc 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -275,10 +275,12 @@ void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
+#define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_wrprotect(pmd)	pte_pmd(pte_wrprotect(pmd_pte(pmd)))
 #define pmd_mksplitting(pmd)	pte_pmd(pte_mkspecial(pmd_pte(pmd)))
 #define pmd_mkold(pmd)		pte_pmd(pte_mkold(pmd_pte(pmd)))
 #define pmd_mkwrite(pmd)	pte_pmd(pte_mkwrite(pmd_pte(pmd)))
+#define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 #define pmd_mkdirty(pmd)	pte_pmd(pte_mkdirty(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mknotpresent(pmd)	(__pmd(pmd_val(pmd) & ~PMD_TYPE_MASK))
-- 
2.0.0

