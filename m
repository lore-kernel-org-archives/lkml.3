Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab3BUWvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:51:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:53408 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3BUWvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:37 -0500
Message-Id: <20130221224230.765526400@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 1/8] timekeeping: Calc stuff once
References: <20130221220147.719832397@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-do-not-calc-crap-over-and-over.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate the cycle interval shifted value once. No functional change,
just makes the code more readable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -1102,15 +1102,16 @@ static inline void accumulate_nsecs_to_s
 static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 						u32 shift)
 {
+	cycle_t interval = tk->cycle_interval << shift;
 	u64 raw_nsecs;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
-	if (offset < tk->cycle_interval<<shift)
+	if (offset < interval)
 		return offset;
 
 	/* Accumulate one shifted interval */
-	offset -= tk->cycle_interval << shift;
-	tk->clock->cycle_last += tk->cycle_interval << shift;
+	offset -= interval;
+	tk->clock->cycle_last += interval;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
 	accumulate_nsecs_to_secs(tk);


