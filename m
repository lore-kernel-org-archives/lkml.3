Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3LJJ1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:27:41 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57029 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3LJJUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:20:10 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 12/12] sched/numa: fix two local 'ret' in task_numa_migrate()
Date: Tue, 10 Dec 2013 17:19:35 +0800
Message-Id: <1386667175-19952-12-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121009-2000-0000-0000-00000EDC7A42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_numa_migrate() has two locals called "ret". Fix it all up.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5ff86ec..73bc543 100644
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
1.7.7.6

