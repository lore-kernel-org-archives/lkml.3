Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaBKPBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:01:10 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:34197 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaBKPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:01:08 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched/fair: Remove idle_balance() declaration in sched.h
Date: Tue, 11 Feb 2014 16:01:04 +0100
Message-Id: <1392130864-4416-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle_balance() function is called within a #ifdef CONFIG_SMP section.

Remove its declaration in sched.h for !CONFIG_SMP because it is pointless.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/sched.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bf34c2..0eda78b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1168,12 +1168,6 @@ extern int idle_balance(struct rq *this_rq);
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
-#else	/* CONFIG_SMP */
-
-static inline void idle_balance(int cpu, struct rq *rq)
-{
-}
-
 #endif
 
 extern void sysrq_sched_debug_show(void);
-- 
1.7.9.5

