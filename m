Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423570Ab3FURja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:39:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52068 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423424Ab3FURj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:39:26 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCHv3/RESEND 2/4] clocksource: arch_timer: Pass clock event to set_mode callback
Date: Fri, 21 Jun 2013 10:39:19 -0700
Message-Id: <1371836361-20574-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371836361-20574-1-git-send-email-sboyd@codeaurora.org>
References: <1371836361-20574-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't any reason why we don't pass the event here and we'll
need it in the near future for memory mapped arch timers anyway.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/arm_arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 053d846..220da0c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -140,7 +140,7 @@ static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
 
 	clk->cpumask = cpumask_of(smp_processor_id());
 
-	clk->set_mode(CLOCK_EVT_MODE_SHUTDOWN, NULL);
+	clk->set_mode(CLOCK_EVT_MODE_SHUTDOWN, clk);
 
 	clockevents_config_and_register(clk, arch_timer_rate,
 					0xf, 0x7fffffff);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

