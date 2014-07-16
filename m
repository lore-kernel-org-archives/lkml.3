Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaGPVEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:59720 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaGPVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:31 -0400
Message-Id: <20140716205054.540963163@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 28/64] timekeeping: Provide ktime_get[*]_ns() helpers
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-provide-ktime-get-ns.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of code converts either timespecs or ktime_t to
nanoseconds. Provide helper functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -145,6 +145,21 @@ static inline ktime_t ktime_mono_to_real
 	return ktime_mono_to_any(mono, TK_OFFS_REAL);
 }
 
+static inline u64 ktime_get_ns(void)
+{
+	return ktime_to_ns(ktime_get());
+}
+
+static inline u64 ktime_get_real_ns(void)
+{
+	return ktime_to_ns(ktime_get_real());
+}
+
+static inline u64 ktime_get_boot_ns(void)
+{
+	return ktime_to_ns(ktime_get_boottime());
+}
+
 /*
  * RTC specific
  */


