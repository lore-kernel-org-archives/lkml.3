Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaJBQof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:44:35 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42171 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaJBQod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:44:33 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: akpm@linux-foundation.org, jcmvbkbc@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: highmem remove 3 errors
Date: Thu,  2 Oct 2014 17:44:22 +0100
Message-Id: <1412268262-4827-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pointers should be foo *bar or (foo *)

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/highmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 123bcd3..996c1d8 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -130,7 +130,7 @@ unsigned int nr_free_highpages (void)
 static int pkmap_count[LAST_PKMAP];
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
-pte_t * pkmap_page_table;
+pte_t *pkmap_page_table;
 
 /*
  * Most architectures have no use for kmap_high_get(), so let's abstract
@@ -291,7 +291,7 @@ void *kmap_high(struct page *page)
 	pkmap_count[PKMAP_NR(vaddr)]++;
 	BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
 	unlock_kmap();
-	return (void*) vaddr;
+	return (void *)vaddr;
 }
 
 EXPORT_SYMBOL(kmap_high);
@@ -318,7 +318,7 @@ void *kmap_high_get(struct page *page)
 		pkmap_count[PKMAP_NR(vaddr)]++;
 	}
 	unlock_kmap_any(flags);
-	return (void*) vaddr;
+	return (void *)vaddr;
 }
 #endif
 
-- 
1.9.1

