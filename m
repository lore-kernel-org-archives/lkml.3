Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaCZLWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:50 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:39895 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaCZLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/14] hrtimer: remove clock_was_set_delayed() from hrtimer.h
Date: Wed, 26 Mar 2014 16:51:16 +0530
Message-Id: <7f1d2271c0f37dab9e446767880b8b9759750d50.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock_was_set_delayed() is called from only hrtimer.c and so should be marked
static. Along with that its declaration and dummy definition must be removed
from hrtimer.h.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/hrtimer.h | 5 -----
 kernel/hrtimer.c        | 3 ++-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 17c08ca..6f524db 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -288,8 +288,6 @@ extern void hrtimer_peek_ahead_timers(void);
 # define MONOTONIC_RES_NSEC	HIGH_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
 
-extern void clock_was_set_delayed(void);
-
 #else
 
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
@@ -310,9 +308,6 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 {
 	return 0;
 }
-
-static inline void clock_was_set_delayed(void) { }
-
 #endif
 
 extern void clock_was_set(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e6e1255..1e4eedb 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -715,7 +715,7 @@ static DECLARE_WORK(hrtimer_work, clock_was_set_work);
  * Called from timekeeping and resume code to reprogramm the hrtimer
  * interrupt device on all cpus.
  */
-void clock_was_set_delayed(void)
+static void clock_was_set_delayed(void)
 {
 	schedule_work(&hrtimer_work);
 }
@@ -732,6 +732,7 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
 static inline void retrigger_next_event(void *arg) { }
+static inline void clock_was_set_delayed(void) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
-- 
1.7.12.rc2.18.g61b472e

