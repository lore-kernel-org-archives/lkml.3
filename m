Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3JJSGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:06:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:50321 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab3JJSGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="373062543"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 03/34] m32r: fix potential NULL-pointer dereference
Date: Thu, 10 Oct 2013 21:05:28 +0300
Message-Id: <1381428359-14843-4-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing check for memory allocation fail.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/include/asm/pgalloc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/m32r/include/asm/pgalloc.h b/arch/m32r/include/asm/pgalloc.h
index 0fc7361989..ac4208bcc5 100644
--- a/arch/m32r/include/asm/pgalloc.h
+++ b/arch/m32r/include/asm/pgalloc.h
@@ -43,6 +43,8 @@ static __inline__ pgtable_t pte_alloc_one(struct mm_struct *mm,
 {
 	struct page *pte = alloc_page(GFP_KERNEL|__GFP_ZERO);
 
+	if (!pte)
+		return NULL;
 	pgtable_page_ctor(pte);
 	return pte;
 }
-- 
1.8.4.rc3

