Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3LLAMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:12:47 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33312 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3LLAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:12:39 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v7 4/4] sched/numa: fix period_slot recalculation
Date: Thu, 12 Dec 2013 08:12:23 +0800
Message-Id: <1386807143-15994-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386807143-15994-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386807143-15994-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121200-1618-0000-0000-0000051EBC94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v3 -> v4:
  * remove period_slot recalculation

The original code is as intended and was meant to scale the difference
between the NUMA_PERIOD_THRESHOLD and local/remote ratio when adjusting
the scan period. The period_slot recalculation can be dropped.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d93c86f..c962167 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1356,7 +1356,6 @@ static void update_task_scan_period(struct task_struct *p,
 		 * scanning faster if shared accesses dominate as it may
 		 * simply bounce migrations uselessly
 		 */
-		period_slot = DIV_ROUND_UP(diff, NUMA_PERIOD_SLOTS);
 		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
 		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
 	}
-- 
1.8.3.2

