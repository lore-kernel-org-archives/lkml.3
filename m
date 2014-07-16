Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaGPVFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:59825 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaGPVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:57 -0400
Message-Id: <20140716205056.025006231@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 45/64] timekeeping: Remove monotonic_to_bootbased
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-remove-monotonic-to-bootbased.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |    1 -
 kernel/time/timekeeping.c   |   15 ---------------
 2 files changed, 16 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -27,7 +27,6 @@ struct timespec __current_kernel_time(vo
  */
 struct timespec get_monotonic_coarse(void);
 extern void getrawmonotonic(struct timespec *ts);
-extern void monotonic_to_bootbased(struct timespec *ts);
 extern void get_monotonic_boottime(struct timespec *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
 
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1570,21 +1570,6 @@ void get_monotonic_boottime(struct times
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
-/**
- * monotonic_to_bootbased - Convert the monotonic time to boot based.
- * @ts:		pointer to the timespec to be converted
- */
-void monotonic_to_bootbased(struct timespec *ts)
-{
-	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 ts64;
-
-	ts64 = timespec_to_timespec64(*ts);
-	ts64 = timespec64_add(ts64, tk->total_sleep_time);
-	*ts = timespec64_to_timespec(ts64);
-}
-EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
-
 unsigned long get_seconds(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;


