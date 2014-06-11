Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaFKX7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:35986 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaFKX7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:14 -0400
Message-Id: <20140611234606.840900621@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 02/13] tsacct: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=tsacct-use-ktime-get.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/tsacct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/tsacct.c
===================================================================
--- linux.orig/kernel/tsacct.c
+++ linux/kernel/tsacct.c
@@ -38,7 +38,7 @@ void bacct_add_tsk(struct user_namespace
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
 	/* calculate task elapsed time in timespec */
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	ts = timespec_sub(uptime, tsk->start_time);
 	/* rebase elapsed time to usec (should never be negative) */
 	ac_etime = timespec_to_ns(&ts);


