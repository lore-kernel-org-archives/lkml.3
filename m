Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaLXMcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:32:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:39291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbaLXMXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432964931"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 14/38] blackfin: drop pte_file()
Date: Wed, 24 Dec 2014 14:22:22 +0200
Message-Id: <1419423766-114457-15-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Steven Miao <realmz6@gmail.com>
---
 arch/blackfin/include/asm/pgtable.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/blackfin/include/asm/pgtable.h b/arch/blackfin/include/asm/pgtable.h
index 0b049019eba7..b88a1558b0b9 100644
--- a/arch/blackfin/include/asm/pgtable.h
+++ b/arch/blackfin/include/asm/pgtable.h
@@ -45,11 +45,6 @@ extern void paging_init(void);
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-static inline int pte_file(pte_t pte)
-{
-	return 0;
-}
-
 #define set_pte(pteptr, pteval) (*(pteptr) = pteval)
 #define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
 
-- 
2.1.3

