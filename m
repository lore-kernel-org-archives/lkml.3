Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab3JGKaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:30:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3JGK3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:29:51 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 09/63] mm: Account for a THP NUMA hinting update as one PTE update
Date: Mon,  7 Oct 2013 11:28:47 +0100
Message-Id: <1381141781-10992-10-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381141781-10992-1-git-send-email-mgorman@suse.de>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A THP PMD update is accounted for as 512 pages updated in vmstat.  This is
large difference when estimating the cost of automatic NUMA balancing and
can be misleading when comparing results that had collapsed versus split
THP. This patch addresses the accounting issue.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mprotect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 94722a4..2bbb648 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -145,7 +145,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 				split_huge_page_pmd(vma, addr, pmd);
 			else if (change_huge_pmd(vma, pmd, addr, newprot,
 						 prot_numa)) {
-				pages += HPAGE_PMD_NR;
+				pages++;
 				continue;
 			}
 			/* fall through */
-- 
1.8.4

