Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaFKX7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:35991 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaFKX7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:15 -0400
Message-Id: <20140611234606.764810535@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 01/13] acct: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=acct-use-ktime-get.patch
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
 kernel/acct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/acct.c
===================================================================
--- linux.orig/kernel/acct.c
+++ linux/kernel/acct.c
@@ -484,7 +484,7 @@ static void do_acct_process(struct bsd_a
 	strlcpy(ac.ac_comm, current->comm, sizeof(ac.ac_comm));
 
 	/* calculate run_time in nsec*/
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	run_time = (u64)uptime.tv_sec*NSEC_PER_SEC + uptime.tv_nsec;
 	run_time -= (u64)current->group_leader->start_time.tv_sec * NSEC_PER_SEC
 		       + current->group_leader->start_time.tv_nsec;


