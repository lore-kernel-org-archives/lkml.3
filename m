Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3LHGQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 01:16:13 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41144 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3LHGPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 01:15:23 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 09/12] sched/numa: fix task scan rate adjustment
Date: Sun,  8 Dec 2013 14:14:50 +0800
Message-Id: <1386483293-15354-9-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120806-4790-0000-0000-00000BB29FC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 04bb2f947 (sched/numa: Adjust scan rate in task_numa_placement) calculate
period_slot which should be used as base value of scan rate increase if remote
access dominate. However, current codes forget to use it, this patch fix it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7073c76..b077f1b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1358,7 +1358,7 @@ static void update_task_scan_period(struct task_struct *p,
 		 */
 		period_slot = DIV_ROUND_UP(diff, NUMA_PERIOD_SLOTS);
 		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
-		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
+		diff = (period_slot * ratio) / NUMA_PERIOD_SLOTS;
 	}
 
 	p->numa_scan_period = clamp(p->numa_scan_period + diff,
-- 
1.7.5.4

