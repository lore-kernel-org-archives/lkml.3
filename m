Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbaGSAos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:44:48 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:46293 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219AbaGSAog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:44:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 06/10] nohz: Define meaningful symbol for nohz full timekeeper
Date: Sat, 19 Jul 2014 02:44:17 +0200
Message-Id: <1405730661-9355-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nohz full timekeeper is always CPU 0. Lets add it to the list of
special tick_do_timer_cpu symbols for more self explanatory code.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 7ab92b1..6b592a8 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -10,6 +10,7 @@ extern seqlock_t jiffies_lock;
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
 
+#define TICK_DO_TIMER_DEFAULT	0
 #define TICK_DO_TIMER_NONE	-1
 #define TICK_DO_TIMER_BOOT	-2
 
-- 
1.8.3.1

