Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaAOTBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:01:55 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:7139 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaAOTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:01:53 -0500
Message-ID: <1389812509.4971.34.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH -next] sched/numa: document CLONE_VM behavior
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Date: Wed, 15 Jan 2014 11:01:49 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

The changelog for Rik's "sched/numa: Stay on the same node if CLONE_VM" patch
serves well documented in the code.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/sched/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f45fd5..a2d690c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1743,10 +1743,16 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 #ifdef CONFIG_NUMA_BALANCING
 	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
-		p->mm->numa_next_scan = jiffies + msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
 		p->mm->numa_scan_seq = 0;
+		p->mm->numa_next_scan = jiffies +
+			msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
 	}
 
+	/*
+	 * A newly spawned thread should stay on the same NUMA node as its
+	 * parent. This prevents processes from being "torn" across multiple
+	 * NUMA nodes every time they spawn a new thread.
+	 */
 	if (clone_flags & CLONE_VM)
 		p->numa_preferred_nid = current->numa_preferred_nid;
 	else
-- 
1.8.1.4



