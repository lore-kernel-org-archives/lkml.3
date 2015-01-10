Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbbAJAet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:34:49 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35232 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbbAJAeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:34:46 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 09/10] sparc: Convert to using clocksource_register_hz()
Date: Fri,  9 Jan 2015 16:34:27 -0800
Message-Id: <1420850068-27828-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While cleaning up some clocksource code, I noticed the
time_32 impelementation uses the hz2mult helper, but
doesn't use the clocksource_register_hz() method.

I don't believe the sparc clocksource is a default
clocksource, so we shouldn't need to self-define
the mult/shift pair.

So convert the time_32.c implementation to use
clocksource_register_hz().

Untested.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/sparc/kernel/time_32.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index a31c0c8..18147a5 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -181,17 +181,13 @@ static struct clocksource timer_cs = {
 	.rating	= 100,
 	.read	= timer_cs_read,
 	.mask	= CLOCKSOURCE_MASK(64),
-	.shift	= 2,
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static __init int setup_timer_cs(void)
 {
 	timer_cs_enabled = 1;
-	timer_cs.mult = clocksource_hz2mult(sparc_config.clock_rate,
-	                                    timer_cs.shift);
-
-	return __clocksource_register(&timer_cs);
+	return clocksource_register_hz(&timer_cs, sparc_config.clock_rate);
 }
 
 #ifdef CONFIG_SMP
-- 
1.9.1

