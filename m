Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3JJSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:16:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:26345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab3JJSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="408987092"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 05/34] mm: allow pgtable_page_ctor() to fail
Date: Thu, 10 Oct 2013 21:05:30 +0300
Message-Id: <1381428359-14843-6-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change pgtable_page_ctor() return type from void to bool.
Returns true, if initialization is successful and false otherwise.

Current implementation never fails, but it will change later.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 75735f6171..f6467032a9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1254,10 +1254,11 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 #define pte_lockptr(mm, pmd)	({(void)(pmd); &(mm)->page_table_lock;})
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
-static inline void pgtable_page_ctor(struct page *page)
+static inline bool pgtable_page_ctor(struct page *page)
 {
 	pte_lock_init(page);
 	inc_zone_page_state(page, NR_PAGETABLE);
+	return true;
 }
 
 static inline void pgtable_page_dtor(struct page *page)
-- 
1.8.4.rc3

