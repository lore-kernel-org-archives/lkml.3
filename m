Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaGKOBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:01:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:56052 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaGKNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:08 -0400
Message-Id: <20140711133705.740823080@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 06/55] ktime: Change ktime_set() to take 64bit seconds value
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=jstultz-tk-696511b.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

In order to support dates past 2038 on 32bit systems, ktime_set()
needs to handle 64bit second values.

[ tglx: Removed the BITS_PER_LONG check ]

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/ktime.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: tip/include/linux/ktime.h
===================================================================
--- tip.orig/include/linux/ktime.h
+++ tip/include/linux/ktime.h
@@ -47,13 +47,12 @@ typedef union ktime ktime_t;		/* Kill th
  *
  * Return: The ktime_t representation of the value.
  */
-static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
+static inline ktime_t ktime_set(const s64 secs, const unsigned long nsecs)
 {
-#if (BITS_PER_LONG == 64)
 	if (unlikely(secs >= KTIME_SEC_MAX))
 		return (ktime_t){ .tv64 = KTIME_MAX };
-#endif
-	return (ktime_t) { .tv64 = (s64)secs * NSEC_PER_SEC + (s64)nsecs };
+
+	return (ktime_t) { .tv64 = secs * NSEC_PER_SEC + (s64)nsecs };
 }
 
 /* Subtract two ktime_t variables. rem = lhs -rhs: */


