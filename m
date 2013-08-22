Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3HVH72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:59:28 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55240 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3HVH71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:59:27 -0400
Message-ID: <5215C4D8.4040403@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:59:20 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/11] sched/cleanup: remove the extra parm of retrigger_next_event()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-4790-0000-0000-000009EB6835
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parm 'arg' has not been used, remove it to make code clean.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/hrtimer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 383319b..1abca37 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -678,7 +678,7 @@ static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
  *
  * Called with interrupts disabled via on_each_cpu()
  */
-static void retrigger_next_event(void *arg)
+static void retrigger_next_event(void)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
 
@@ -717,7 +717,7 @@ static int hrtimer_switch_to_hres(void)
 
 	tick_setup_sched_timer();
 	/* "Retrigger" the interrupt to get things going */
-	retrigger_next_event(NULL);
+	retrigger_next_event();
 	local_irq_restore(flags);
 	return 1;
 }
@@ -751,7 +751,7 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 	return 0;
 }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
-static inline void retrigger_next_event(void *arg) { }
+static inline void retrigger_next_event(void) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -787,7 +787,7 @@ void hrtimers_resume(void)
 		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
 
 	/* Retrigger on the local CPU */
-	retrigger_next_event(NULL);
+	retrigger_next_event();
 	/* And schedule a retrigger for all others */
 	clock_was_set_delayed();
 }
-- 
1.7.9.5

