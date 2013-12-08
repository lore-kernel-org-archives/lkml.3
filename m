Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3LHGUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 01:20:21 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59184 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3LHGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 01:20:19 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 12/12] sched/numa: drop local 'ret' in task_numa_migrate()
Date: Sun,  8 Dec 2013 14:14:53 +0800
Message-Id: <1386483293-15354-12-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120806-4790-0000-0000-00000BB2A1DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_numa_migrate() has two locals called "ret". Fix it all up.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df8b677..3159ca7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1257,7 +1257,7 @@ static int task_numa_migrate(struct task_struct *p)
 	p->numa_scan_period = task_scan_min(p);
 
 	if (env.best_task == NULL) {
-		int ret = migrate_task_to(p, env.best_cpu);
+		ret = migrate_task_to(p, env.best_cpu);
 		return ret;
 	}
 
-- 
1.7.5.4

