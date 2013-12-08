Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3LHGQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 01:16:09 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37971 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3LHGPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 01:15:22 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 10/12] sched/numa: fix record hinting faults check
Date: Sun,  8 Dec 2013 14:14:51 +0800
Message-Id: <1386483293-15354-10-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120806-2674-0000-0000-00000BCED5F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust numa_scan_period in task_numa_placement, depending on how much useful
work the numa code can do. The local faults and remote faults should be used
to check if there is record hinting faults instead of local faults and shared
faults. This patch fix it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b077f1b3..942e67b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1322,7 +1322,7 @@ static void update_task_scan_period(struct task_struct *p,
 	 * completely idle or all activity is areas that are not of interest
 	 * to automatic numa balancing. Scan slower
 	 */
-	if (local + shared == 0) {
+	if (local + remote == 0) {
 		p->numa_scan_period = min(p->numa_scan_period_max,
 			p->numa_scan_period << 1);
 
-- 
1.7.5.4

