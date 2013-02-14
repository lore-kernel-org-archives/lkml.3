Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3BNFvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:51:19 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62764 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3BNFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:49 -0500
X-AuditID: 9c93016f-b7b1fae000006419-1b-511c7abe1247
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/8] sched: explicitly cpu_idle_type checking in rebalance_domains()
Date: Thu, 14 Feb 2013 14:48:35 +0900
Message-Id: <1360820921-2513-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
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
index 6f72851..0c6aaf6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5515,10 +5515,10 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
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

