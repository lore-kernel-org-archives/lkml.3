Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaDOEZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:25:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51530 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDOEZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:25:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2] sched/core: fix formatting issues in sched_can_stop_tick()
Date: Tue, 15 Apr 2014 09:55:40 +0530
Message-Id: <dd818d296fd51c3fc5fb24c5decf048e9b6eba1e.1397535766.git.viresh.kumar@linaro.org>
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
V1->V2: Rebased over:

https://lkml.org/lkml/2014/3/19/456

 kernel/sched/core.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1fadf61..3a4bb63 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -666,19 +666,15 @@ static inline bool got_nohz_idle_kick(void)
 #ifdef CONFIG_NO_HZ_FULL
 bool sched_can_stop_tick(void)
 {
-       struct rq *rq;
-
-       rq = this_rq();
-
-       /*
-	* More than one running task need preemption.
-	* nr_running update is assumed to be visible
-	* after IPI is sent from wakers.
-	*/
-       if (rq->nr_running > 1)
-               return false;
+	/*
+	 * More than one running task need preemption.
+	 * nr_running update is assumed to be visible
+	 * after IPI is sent from wakers.
+	 */
+	if (this_rq()->nr_running > 1)
+		return false;
 
-       return true;
+	return true;
 }
 #endif /* CONFIG_NO_HZ_FULL */
 
-- 
1.7.12.rc2.18.g61b472e

