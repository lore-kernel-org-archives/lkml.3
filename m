Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3LHGZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 01:25:43 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34918 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3LHGZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 01:25:42 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 11/12] sched/numa: drop unnecessary variable in task_weight
Date: Sun,  8 Dec 2013 14:14:52 +0800
Message-Id: <1386483293-15354-11-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120806-9574-0000-0000-00000AEE81C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop unnecessary total_faults variable in function task_weight to unify
task_weight and group_weight.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 942e67b..df8b677 100644
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
1.7.5.4

