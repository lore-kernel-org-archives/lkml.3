Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaBUHhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:37:48 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:39193 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaBUHhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:37:47 -0500
Message-ID: <1392968254.3039.19.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] mm: update comment in unmap_single_vma()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, davidlohr@hp.com
Date: Thu, 20 Feb 2014 23:37:34 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

The described issue now occurs inside mmap_region().
And unfortunately is still valid.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 95009f9..c90df25 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1320,9 +1320,9 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 			 * It is undesirable to test vma->vm_file as it
 			 * should be non-null for valid hugetlb area.
 			 * However, vm_file will be NULL in the error
-			 * cleanup path of do_mmap_pgoff. When
+			 * cleanup path of mmap_region. When
 			 * hugetlbfs ->mmap method fails,
-			 * do_mmap_pgoff() nullifies vma->vm_file
+			 * mmap_region() nullifies vma->vm_file
 			 * before calling this function to clean up.
 			 * Since no pte has actually been setup, it is
 			 * safe to do nothing in this case.
-- 
1.8.1.4



