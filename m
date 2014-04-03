Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaDCMPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 08:15:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:33208 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946AbaDCMO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:14:59 -0400
X-IronPort-AV: E=Sophos;i="4.97,786,1389715200"; 
   d="scan'208";a="28833412"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] sched: fix tracepoint in scheduler.
Date: Thu, 3 Apr 2014 20:12:48 +0800
Message-ID: <1396527168-3929-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function set_task_cpu(), if cpu == new_cpu,
there is no migration happen. But current trace point
will raise a migration trace event.

This patch change trace point to right place,
only when migration really happen, an event will
be threw out.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9cae286..6708aff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -998,9 +998,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 #endif
 
-	trace_sched_migrate_task(p, new_cpu);
-
 	if (task_cpu(p) != new_cpu) {
+		trace_sched_migrate_task(p, new_cpu);
 		if (p->sched_class->migrate_task_rq)
 			p->sched_class->migrate_task_rq(p, new_cpu);
 		p->se.nr_migrations++;
-- 
1.8.2.1

