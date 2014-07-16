Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaGPVQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:16:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:59716 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaGPVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:29 -0400
Message-Id: <20140716205054.452948712@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 27/64] timekeeping: Remove ktime_get_monotonic_offset()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-remove-ktime_get_monotonic_offset.patch
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
 kernel/time/timekeeping.c   |   18 ------------------
 2 files changed, 19 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -108,7 +108,6 @@ enum tk_offsets {
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_with_offset(enum tk_offsets offs);
-extern ktime_t ktime_get_monotonic_offset(void);
 extern ktime_t ktime_mono_to_any(ktime_t tmono, enum tk_offsets offs);
 
 /**
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1708,24 +1708,6 @@ ktime_t ktime_get_update_offsets_now(kti
 #endif
 
 /**
- * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
- */
-ktime_t ktime_get_monotonic_offset(void)
-{
-	struct timekeeper *tk = &tk_core.timekeeper;
-	unsigned long seq;
-	struct timespec64 wtom;
-
-	do {
-		seq = read_seqcount_begin(&tk_core.seq);
-		wtom = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&tk_core.seq, seq));
-
-	return timespec64_to_ktime(wtom);
-}
-EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
-
-/**
  * do_adjtimex() - Accessor function to NTP __do_adjtimex function
  */
 int do_adjtimex(struct timex *txc)


