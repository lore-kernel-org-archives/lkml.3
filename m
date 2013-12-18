Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3LRKdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:33:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab3LRKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:33:40 -0500
Date: Wed, 18 Dec 2013 02:32:58 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-de1b301a19754778ddd9f908d266ffe1c010b2cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1386833006-6600-2-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386833006-6600-2-git-send-email-liwanp@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Use wrapper function task_node to get node which task is on
Git-Commit-ID: de1b301a19754778ddd9f908d266ffe1c010b2cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:33:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de1b301a19754778ddd9f908d266ffe1c010b2cf
Gitweb:     http://git.kernel.org/tip/de1b301a19754778ddd9f908d266ffe1c010b2cf
Author:     Wanpeng Li <liwanp@linux.vnet.ibm.com>
AuthorDate: Thu, 12 Dec 2013 15:23:24 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:24:39 +0100

sched/numa: Use wrapper function task_node to get node which task is on

Use wrapper function task_node to get node which task is on.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1386833006-6600-2-git-send-email-liwanp@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 2 +-
 kernel/sched/fair.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 5c34d18..374fe04 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -139,7 +139,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
 #ifdef CONFIG_NUMA_BALANCING
-	SEQ_printf(m, " %d", cpu_to_node(task_cpu(p)));
+	SEQ_printf(m, " %d", task_node(p));
 #endif
 #ifdef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, " %s", task_group_path(task_group(p)));
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fcb6c17..ebdb08b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1202,7 +1202,7 @@ static int task_numa_migrate(struct task_struct *p)
 	 * elsewhere, so there is no point in (re)trying.
 	 */
 	if (unlikely(!sd)) {
-		p->numa_preferred_nid = cpu_to_node(task_cpu(p));
+		p->numa_preferred_nid = task_node(p);
 		return -EINVAL;
 	}
 
@@ -1269,7 +1269,7 @@ static void numa_migrate_preferred(struct task_struct *p)
 	p->numa_migrate_retry = jiffies + HZ;
 
 	/* Success if task is already running on preferred CPU */
-	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
+	if (task_node(p) == p->numa_preferred_nid)
 		return;
 
 	/* Otherwise, try migrate to a CPU on the preferred node */
