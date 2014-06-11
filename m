Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaFKX72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:36034 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaFKX7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:19 -0400
Message-Id: <20140611234607.518619845@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 10/13] time: Remove do_posix_clock_monotonic_gettime() 
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=time-remove-cruft.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts().

No more users. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux/include/linux/time.h
===================================================================
--- linux.orig/include/linux/time.h
+++ linux/include/linux/time.h
@@ -157,7 +157,6 @@ extern void do_gettimeofday(struct timev
 extern int do_settimeofday(const struct timespec *tv);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
-#define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,


