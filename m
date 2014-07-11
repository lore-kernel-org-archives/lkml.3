Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaGKNo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:44:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:56116 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaGKNo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:26 -0400
Message-Id: <20140711133706.783033580@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 18/55] timekeeping;
 Use ktime_t based data for ktime_get_boottime()
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-use-ktime-based-for-ktime-get-boottime.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |   12 +++++++++++-
 kernel/time/timekeeping.c   |   17 -----------------
 2 files changed, 11 insertions(+), 18 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -108,7 +108,6 @@ enum tk_offsets {
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_with_offset(enum tk_offsets offs);
-extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
 extern ktime_t ktime_get_clocktai(void);
 
@@ -120,6 +119,17 @@ static inline ktime_t ktime_get_real(voi
 	return ktime_get_with_offset(TK_OFFS_REAL);
 }
 
+/**
+ * ktime_get_boottime - Returns monotonic time since boot in ktime_t format
+ *
+ * This is similar to CLOCK_MONTONIC/ktime_get, but also includes the
+ * time spent in suspend.
+ */
+static inline ktime_t ktime_get_boottime(void)
+{
+	return ktime_get_with_offset(TK_OFFS_BOOT);
+}
+
 /*
  * RTC specific
  */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1570,23 +1570,6 @@ void get_monotonic_boottime(struct times
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
 /**
- * ktime_get_boottime - Returns monotonic time since boot in a ktime
- *
- * Returns the monotonic time since boot in a ktime
- *
- * This is similar to CLOCK_MONTONIC/ktime_get, but also
- * includes the time spent in suspend.
- */
-ktime_t ktime_get_boottime(void)
-{
-	struct timespec ts;
-
-	get_monotonic_boottime(&ts);
-	return timespec_to_ktime(ts);
-}
-EXPORT_SYMBOL_GPL(ktime_get_boottime);
-
-/**
  * monotonic_to_bootbased - Convert the monotonic time to boot based.
  * @ts:		pointer to the timespec to be converted
  */


