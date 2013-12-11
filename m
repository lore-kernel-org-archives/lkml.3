Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3LKAul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:50:41 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50460 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3LKAuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:50:25 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v5 8/8] sched/numa: drop unnecessary variable in task_weight
Date: Wed, 11 Dec 2013 08:50:01 +0800
Message-Id: <1386723001-25408-9-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386723001-25408-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386723001-25408-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121100-5140-0000-0000-000004487B35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop unnecessary total_faults variable in function task_weight to unify
task_weight and group_weight.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f507e12..5c54837 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -947,17 +947,10 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
  */
 static inline unsigned long task_weight(struct task_struct *p, int nid)
 {
-	unsigned long total_faults;
-
-	if (!p->numa_faults)
-		return 0;
-
-	total_faults = p->total_numa_faults;
-
-	if (!total_faults)
+	if (!p->numa_faults || !p->total_numa_faults)
 		return 0;
 
-	return 1000 * task_faults(p, nid) / total_faults;
+	return 1000 * task_faults(p, nid) / p->total_numa_faults;
 }
 
 static inline unsigned long group_weight(struct task_struct *p, int nid)
-- 
1.7.7.6

