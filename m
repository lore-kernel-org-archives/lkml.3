Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbbA1URI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:17:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:57091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbbA1URD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:17:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,481,1418112000"; 
   d="scan'208";a="643837208"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 4/4] mm: do not add nr_pmds into mm_struct if PMD is folded
Date: Wed, 28 Jan 2015 15:17:44 +0200
Message-Id: <1422451064-109023-5-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everything seems in place. We can now include <asm/pgtable.h> in
<linux/mm_struct.h>.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm_struct.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mm_struct.h b/include/linux/mm_struct.h
index 0a233c232a39..1759bed3dc61 100644
--- a/include/linux/mm_struct.h
+++ b/include/linux/mm_struct.h
@@ -8,6 +8,7 @@
 #include <linux/uprobes.h>
 
 #include <asm/mmu.h>
+#include <asm/pgtable.h>
 
 struct kioctx_table;
 struct vm_area_struct;
@@ -54,7 +55,9 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	atomic_long_t nr_ptes;			/* PTE page table pages */
+#if !__PAGETABLE_PMD_FOLDED
 	atomic_long_t nr_pmds;			/* PMD page table pages */
+#endif
 	int map_count;				/* number of VMAs */
 
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
-- 
2.1.4

