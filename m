Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832Ab3GRXVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:21:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58748 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717Ab3GRXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:38 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v4 06/17] sched_clock: Remove sched_clock_func() hook
Date: Thu, 18 Jul 2013 16:21:19 -0700
Message-Id: <1374189690-10810-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody is using sched_clock_func() anymore now that sched_clock
supports up to 64 bits. Remove the hook so that new code only
uses sched_clock_register().

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/sched_clock.h | 2 --
 kernel/time/sched_clock.c   | 9 +--------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index eca7abe..cddf0c2 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -18,6 +18,4 @@ extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
 extern void sched_clock_register(u64 (*read)(void), int bits,
 				 unsigned long rate);
 
-extern unsigned long long (*sched_clock_func)(void);
-
 #endif
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 3aa83ba..659c59a 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -63,7 +63,7 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long notrace sched_clock_32(void)
+unsigned long long notrace sched_clock(void)
 {
 	u64 epoch_ns;
 	u64 epoch_cyc;
@@ -176,13 +176,6 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	sched_clock_register(read_sched_clock_32_wrapper, bits, rate);
 }
 
-unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
-
-unsigned long long notrace sched_clock(void)
-{
-	return sched_clock_func();
-}
-
 void __init sched_clock_postinit(void)
 {
 	/*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

