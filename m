Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3LJJUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:20:13 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57017 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3LJJT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:19:59 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 09/12] sched/numa: fix period_slot recalculation
Date: Tue, 10 Dec 2013 17:19:32 +0800
Message-Id: <1386667175-19952-9-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121009-1618-0000-0000-0000051C9732
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v3 -> v4:
  * remove period_slot recalculation

The original code is as intended and was meant to scale the difference
between the NUMA_PERIOD_THRESHOLD and local/remote ratio when adjusting
the scan period. The period_slot recalculation can be dropped.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7073c76..90b9b88 100644
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
1.7.7.6

