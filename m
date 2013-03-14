Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010Ab3CNRx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:53:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:52023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934579Ab3CNRtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="279559773"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2, RFC 06/30] thp, mm: basic defines for transparent huge page cache
Date: Thu, 14 Mar 2013 19:50:11 +0200
Message-Id: <1363283435-7666-7-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/huge_mm.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ee1c244..a54939c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -64,6 +64,10 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 #define HPAGE_PMD_MASK HPAGE_MASK
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
+#define HPAGE_CACHE_ORDER      (HPAGE_SHIFT - PAGE_CACHE_SHIFT)
+#define HPAGE_CACHE_NR         (1L << HPAGE_CACHE_ORDER)
+#define HPAGE_CACHE_INDEX_MASK (HPAGE_CACHE_NR - 1)
+
 extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
 #define transparent_hugepage_enabled(__vma)				\
@@ -181,6 +185,10 @@ extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vm
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
+#define HPAGE_CACHE_ORDER      ({ BUILD_BUG(); 0; })
+#define HPAGE_CACHE_NR         ({ BUILD_BUG(); 0; })
+#define HPAGE_CACHE_INDEX_MASK ({ BUILD_BUG(); 0; })
+
 #define hpage_nr_pages(x) 1
 
 #define transparent_hugepage_enabled(__vma) 0
-- 
1.7.10.4

