Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab3BUWwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:52:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:53436 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab3BUWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:40 -0500
Message-Id: <20130221224231.105416300@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 6/8] timekeeping: Delay update of clock->cycle_last
References: <20130221220147.719832397@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-delay-clock-cycle-last-update.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For calculating the new timekeeper values store the new cycle_last
value in the timekeeper and update the clock->cycle_last just when we
actually update the new values.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -1120,7 +1120,7 @@ static cycle_t logarithmic_accumulation(
 
 	/* Accumulate one shifted interval */
 	offset -= interval;
-	tk->clock->cycle_last += interval;
+	tk->cycle_last += interval;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
 	accumulate_nsecs_to_secs(tk);
@@ -1235,6 +1235,8 @@ static void update_wall_time(void)
 	 */
 	accumulate_nsecs_to_secs(tk);
 
+	/* Update clock->cycle_last with the new value */
+	clock->cycle_last = tk->cycle_last;
 	timekeeping_update(tk, false);
 
 out:


