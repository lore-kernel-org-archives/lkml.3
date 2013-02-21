Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3BUWvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:51:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:53412 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3BUWvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:38 -0500
Message-Id: <20130221224230.824200459@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 2/8] timekeeping: Make jiffies_lock internal
References: <20130221220147.719832397@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-make-jiffies-lock-internal.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of the timekeeping core needs that lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/jiffies.h     |    1 -
 kernel/time/tick-internal.h |    2 ++
 kernel/time/timekeeping.c   |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/jiffies.h
===================================================================
--- linux-2.6.orig/include/linux/jiffies.h
+++ linux-2.6/include/linux/jiffies.h
@@ -75,7 +75,6 @@ extern int register_refined_jiffies(long
  */
 extern u64 __jiffy_data jiffies_64;
 extern unsigned long volatile __jiffy_data jiffies;
-extern seqlock_t jiffies_lock;
 
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void);
Index: linux-2.6/kernel/time/tick-internal.h
===================================================================
--- linux-2.6.orig/kernel/time/tick-internal.h
+++ linux-2.6/kernel/time/tick-internal.h
@@ -4,6 +4,8 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
+extern seqlock_t jiffies_lock;
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
 
 #define TICK_DO_TIMER_NONE	-1
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -23,6 +23,7 @@
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
 
+#include "tick-internal.h"
 
 static struct timekeeper timekeeper;
 


