Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab3CZGBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:01:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59821 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab3CZGA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:00:58 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-4f-51513997073e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 2/6] sched: explicitly cpu_idle_type checking in rebalance_domains()
Date: Tue, 26 Mar 2013 15:01:36 +0900
Message-Id: <1364277700-7509-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 88b8dac0, dst-cpu can be changed in load_balance(),
then we can't know cpu_idle_type of dst-cpu when load_balance()
return positive. So, add explicit cpu_idle_type checking.

Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f084069..9d693d0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5506,10 +5506,10 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
-				 * We've pulled tasks over so either we're no
-				 * longer idle.
+				 * We've pulled tasks over so either we may
+				 * be no longer idle.
 				 */
-				idle = CPU_NOT_IDLE;
+				idle = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
 		}
-- 
1.7.9.5

