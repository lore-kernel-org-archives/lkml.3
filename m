Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3LJJUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:20:15 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36882 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3LJJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:20:02 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 10/12] sched/numa: fix record hinting faults check
Date: Tue, 10 Dec 2013 17:19:33 +0800
Message-Id: <1386667175-19952-10-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121009-5140-0000-0000-00000447CFBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust numa_scan_period in task_numa_placement, depending on how much useful
work the numa code can do. The local faults and remote faults should be used
to check if there is record hinting faults instead of local faults and shared
faults. This patch fix it.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 90b9b88..d51b8c3 100644
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
1.7.7.6

