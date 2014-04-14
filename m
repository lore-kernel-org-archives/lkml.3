Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaDNQSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:18:52 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47674 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaDNQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:18:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] sched/core: fix formatting issues in sched_can_stop_tick()
Date: Mon, 14 Apr 2014 21:47:41 +0530
Message-Id: <6c3484ccb8220d0c58db1cbd9c929fc8d83005fd.1397492119.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_can_stop_tick() was using 7 spaces instead of 8 spaces or a 'tab' at the
beginning of each line. Which doesn't align with the Coding Guidelines.

Also it removes the *rq variable as it was used at only one place and hence we
can directly use this_rq() instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
I don't think rq = tihs_rq() has to be done before smp_mb(), in case yes sorry
for this patch :(

 kernel/sched/core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..13299c5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -666,18 +666,14 @@ static inline bool got_nohz_idle_kick(void)
 #ifdef CONFIG_NO_HZ_FULL
 bool sched_can_stop_tick(void)
 {
-       struct rq *rq;
-
-       rq = this_rq();
-
-       /* Make sure rq->nr_running update is visible after the IPI */
-       smp_rmb();
+	/* Make sure rq->nr_running update is visible after the IPI */
+	smp_rmb();
 
-       /* More than one running task need preemption */
-       if (rq->nr_running > 1)
-               return false;
+	/* More than one running task need preemption */
+	if (this_rq()->nr_running > 1)
+		return false;
 
-       return true;
+	return true;
 }
 #endif /* CONFIG_NO_HZ_FULL */
 
-- 
1.7.12.rc2.18.g61b472e

