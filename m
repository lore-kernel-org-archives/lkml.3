Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaFXIef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:34:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36240 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaFXIeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:34:31 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend] sched/core: fix formatting issues in sched_can_stop_tick()
Date: Tue, 24 Jun 2014 14:04:12 +0530
Message-Id: <afb781733e4a9ffbced5eb9fd25cc0aa5c6ffd7a.1403596966.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <dd818d296fd51c3fc5fb24c5decf048e9b6eba1e.1397535766.git.viresh.kumar@linaro.org>
References: <dd818d296fd51c3fc5fb24c5decf048e9b6eba1e.1397535766.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_can_stop_tick() is using 7 spaces instead of 8 spaces or a 'tab' at the
beginning of few lines. Which doesn't align well with the Coding Guidelines.

Also remove local variable 'rq' as it is used at only one place and we can
directly use this_rq() instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Rebased again against tip/master ..

 kernel/sched/core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f3063c..866d840 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -736,19 +736,15 @@ static inline bool got_nohz_idle_kick(void)
 #ifdef CONFIG_NO_HZ_FULL
 bool sched_can_stop_tick(void)
 {
-       struct rq *rq;
-
-       rq = this_rq();
-
 	/*
 	 * More than one running task need preemption.
 	 * nr_running update is assumed to be visible
 	 * after IPI is sent from wakers.
 	 */
-       if (rq->nr_running > 1)
-               return false;
+	if (this_rq()->nr_running > 1)
+		return false;
 
-       return true;
+	return true;
 }
 #endif /* CONFIG_NO_HZ_FULL */
 
-- 
2.0.0.rc2

