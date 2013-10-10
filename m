Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3JJSGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:06:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:24829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab3JJSGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="391219882"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 02/34] cris: fix potential NULL-pointer dereference
Date: Thu, 10 Oct 2013 21:05:27 +0300
Message-Id: <1381428359-14843-3-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing check for memory allocation fail.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/include/asm/pgalloc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/cris/include/asm/pgalloc.h b/arch/cris/include/asm/pgalloc.h
index 6da975db11..d9504d38c2 100644
--- a/arch/cris/include/asm/pgalloc.h
+++ b/arch/cris/include/asm/pgalloc.h
@@ -32,6 +32,8 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long addres
 {
 	struct page *pte;
 	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	if (!pte)
+		return NULL;
 	pgtable_page_ctor(pte);
 	return pte;
 }
-- 
1.8.4.rc3

