Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3JJSLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:11:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:11059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab3JJSGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="417347983"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 17/34] ia64: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:42 +0300
Message-Id: <1381428359-14843-18-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/include/asm/pgalloc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/pgalloc.h b/arch/ia64/include/asm/pgalloc.h
index 96a8d927db..5767cdfc08 100644
--- a/arch/ia64/include/asm/pgalloc.h
+++ b/arch/ia64/include/asm/pgalloc.h
@@ -91,7 +91,10 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long addr)
 	if (!pg)
 		return NULL;
 	page = virt_to_page(pg);
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		quicklist_free(0, NULL, pg);
+		return NULL;
+	}
 	return page;
 }
 
-- 
1.8.4.rc3

