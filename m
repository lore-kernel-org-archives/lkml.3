Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527Ab3HHOA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:00:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965349Ab3HHOA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:00:56 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 12/27] sched: numa: Correct adjustment of numa_scan_period
Date: Thu,  8 Aug 2013 15:00:24 +0100
Message-Id: <1375970439-5111-13-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375970439-5111-1-git-send-email-mgorman@suse.de>
References: <1375970439-5111-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa_scan_period is in milliseconds, not jiffies. Properly placed pages
slow the scanning rate but adding 10 jiffies to numa_scan_period means
that the rate scanning slows depends on HZ which is confusing. Get rid
of the jiffies_to_msec conversion and treat it as ms.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2908b4e..d77bb32 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -914,7 +914,7 @@ void task_numa_fault(int node, int pages, bool migrated)
 			p->numa_scan_period_max = task_scan_max(p);
 
 		p->numa_scan_period = min(p->numa_scan_period_max,
-			p->numa_scan_period + jiffies_to_msecs(10));
+			p->numa_scan_period + 10);
 	}
 
 	task_numa_placement(p);
-- 
1.8.1.4

