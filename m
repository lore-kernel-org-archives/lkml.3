Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaFCM6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:58:48 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58429 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaFCM6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:58:47 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Move enum CPU_[xxx_]IDLE to private sched.h
Date: Tue,  3 Jun 2014 14:59:05 +0200
Message-Id: <1401800345-29468-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different enum CPU_IDLE, CPU_NOT_IDLE, CPU_NEWLY_IDLE and
CPU_MAX_IDLE_TYPES are only used in kernel/sched/fair.c and
kernel/sched/stats.c.

Move their definitions in the private 'sched.h' file located in the
same place than the files above.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/linux/sched.h |    7 -------
 kernel/sched/sched.h  |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f91d00..d561501 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -846,13 +846,6 @@ static inline int sched_info_on(void)
 #endif
 }
 
-enum cpu_idle_type {
-	CPU_IDLE,
-	CPU_NOT_IDLE,
-	CPU_NEWLY_IDLE,
-	CPU_MAX_IDLE_TYPES
-};
-
 /*
  * Increase resolution of cpu_power calculations
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 600e229..118a859 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -23,6 +23,13 @@ extern atomic_long_t calc_load_tasks;
 extern long calc_load_fold_active(struct rq *this_rq);
 extern void update_cpu_load_active(struct rq *this_rq);
 
+enum cpu_idle_type {
+	CPU_IDLE,
+	CPU_NOT_IDLE,
+	CPU_NEWLY_IDLE,
+	CPU_MAX_IDLE_TYPES
+};
+
 /*
  * Helpers for converting nanosecond timing to jiffy resolution
  */
-- 
1.7.9.5

