Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3HVHyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:54:38 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45129 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3HVHyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:54:37 -0400
Message-ID: <5215C3B5.8020401@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:54:29 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 05/11] sched/cleanup: remove the extra parm of wakeup_gran()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-4790-0000-0000-000009EB6368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parm 'curr' has not been used, remove it to make code clean.

CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a925e17..05643d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3536,7 +3536,7 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 #endif /* CONFIG_SMP */
 
 static unsigned long
-wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
+wakeup_gran(struct sched_entity *se)
 {
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
@@ -3578,7 +3578,7 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 	if (vdiff <= 0)
 		return -1;
 
-	gran = wakeup_gran(curr, se);
+	gran = wakeup_gran(se);
 	if (vdiff > gran)
 		return 1;
 
-- 
1.7.9.5

