Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaA0WE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:04:29 -0500
Received: from shelob.surriel.com ([74.92.59.67]:58596 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaA0WE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:04:27 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, peterz@infradead.org, mgorman@suse.de,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: [PATCH 8/9] numa,sched: rename variables in task_numa_fault
Date: Mon, 27 Jan 2014 17:03:47 -0500
Message-Id: <1390860228-21539-9-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1390860228-21539-1-git-send-email-riel@redhat.com>
References: <1390860228-21539-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

We track both the node of the memory after a NUMA fault, and the node
of the CPU on which the fault happened. Rename the local variables in
task_numa_fault to make things more explicit.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Suggested-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eb32b3e..54408e4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1735,11 +1735,11 @@ void task_numa_free(struct task_struct *p)
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
-void task_numa_fault(int last_cpupid, int node, int pages, int flags)
+void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 {
 	struct task_struct *p = current;
 	bool migrated = flags & TNF_MIGRATED;
-	int this_node = task_node(current);
+	int cpu_node = task_node(current);
 	int priv;
 
 	if (!numabalancing_enabled)
@@ -1794,8 +1794,8 @@ void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 	if (migrated)
 		p->numa_pages_migrated += pages;
 
-	p->numa_faults_buffer_memory[task_faults_idx(node, priv)] += pages;
-	p->numa_faults_buffer_cpu[task_faults_idx(this_node, priv)] += pages;
+	p->numa_faults_buffer_memory[task_faults_idx(mem_node, priv)] += pages;
+	p->numa_faults_buffer_cpu[task_faults_idx(cpu_node, priv)] += pages;
 	p->numa_faults_locality[!!(flags & TNF_FAULT_LOCAL)] += pages;
 }
 
-- 
1.8.4.2

