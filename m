Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3HFIjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:39:10 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57619 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3HFIgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:36:48 -0400
X-AuditID: 9c930179-b7c53ae000000457-a5-5200b59c3041
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 1/3] sched: remove one division operation in find_buiest_queue()
Date: Tue,  6 Aug 2013 17:36:41 +0900
Message-Id: <1375778203-31343-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove one division operation in find_buiest_queue().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9565645..52898dc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4968,7 +4968,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
+	unsigned long busiest_load = 0, busiest_power = SCHED_POWER_SCALE;
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
@@ -4999,10 +4999,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_POWER_SCALE) / power;
-
-		if (wl > max_load) {
-			max_load = wl;
+		if (wl * busiest_power > busiest_load * power) {
+			busiest_load = wl;
+			busiest_power = power;
 			busiest = rq;
 		}
 	}
-- 
1.7.9.5

