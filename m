Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3J2Knq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:43:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab3J2Kno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:43:44 -0400
Date: Tue, 29 Oct 2013 03:43:07 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-0255d491848032f6c601b6410c3b8ebded3a37b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        stable@kernel.org, aarcange@redhat.com, srikar@linux.vnet.ibm.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, stable@kernel.org, aarcange@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1381141781-10992-10-git-send-email-mgorman@suse.de>
References: <1381141781-10992-10-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mm:
  Account for a THP NUMA hinting update as one PTE update
Git-Commit-ID: 0255d491848032f6c601b6410c3b8ebded3a37b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 03:43:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0255d491848032f6c601b6410c3b8ebded3a37b1
Gitweb:     http://git.kernel.org/tip/0255d491848032f6c601b6410c3b8ebded3a37b1
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:47 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 11:38:17 +0100

mm: Account for a THP NUMA hinting update as one PTE update

A THP PMD update is accounted for as 512 pages updated in vmstat.  This is
large difference when estimating the cost of automatic NUMA balancing and
can be misleading when comparing results that had collapsed versus split
THP. This patch addresses the accounting issue.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-10-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mprotect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index a3af058..412ba2b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -148,7 +148,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 				split_huge_page_pmd(vma, addr, pmd);
 			else if (change_huge_pmd(vma, pmd, addr, newprot,
 						 prot_numa)) {
-				pages += HPAGE_PMD_NR;
+				pages++;
 				continue;
 			}
 			/* fall through */
