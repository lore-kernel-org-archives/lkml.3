Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3LFJNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:13:39 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:46762 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3LFJMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:12:34 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 4/6] sched/numa: use wrapper function task_node to get node which task is on 
Date: Fri,  6 Dec 2013 17:12:14 +0800
Message-Id: <1386321136-27538-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386321136-27538-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386321136-27538-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120609-3864-0000-0000-00000B66F420
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use wrapper function task_node to get node which task is on.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 56bcc0c..e0b1063 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1216,7 +1216,7 @@ static int task_numa_migrate(struct task_struct *p)
 	 * elsewhere, so there is no point in (re)trying.
 	 */
 	if (unlikely(!sd)) {
-		p->numa_preferred_nid = cpu_to_node(task_cpu(p));
+		p->numa_preferred_nid = task_node(p);
 		return -EINVAL;
 	}
 
@@ -1283,7 +1283,7 @@ static void numa_migrate_preferred(struct task_struct *p)
 	p->numa_migrate_retry = jiffies + HZ;
 
 	/* Success if task is already running on preferred CPU */
-	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
+	if (task_node(p) == p->numa_preferred_nid)
 		return;
 
 	/* Otherwise, try migrate to a CPU on the preferred node */
-- 
1.7.7.6

