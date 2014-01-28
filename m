Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaA1TZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:25:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34373 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaA1TZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:25:23 -0500
Date: Tue, 28 Jan 2014 11:24:49 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-58b46da336a9312b2e21bb576d1c2c484dbf6257@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1390860228-21539-9-git-send-email-riel@redhat.com>
References: <1390860228-21539-9-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Rename variables in task_numa_fault(
 )
Git-Commit-ID: 58b46da336a9312b2e21bb576d1c2c484dbf6257
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:24:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58b46da336a9312b2e21bb576d1c2c484dbf6257
Gitweb:     http://git.kernel.org/tip/58b46da336a9312b2e21bb576d1c2c484dbf6257
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 27 Jan 2014 17:03:47 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 15:03:19 +0100

sched/numa: Rename variables in task_numa_fault()

We track both the node of the memory after a NUMA fault, and the node
of the CPU on which the fault happened. Rename the local variables in
task_numa_fault to make things more explicit.

Suggested-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Link: http://lkml.kernel.org/r/1390860228-21539-9-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4c44990..d5832c3 100644
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
 
