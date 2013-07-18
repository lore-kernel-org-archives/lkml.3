Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895Ab3GRXXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:23:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58810 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934805Ab3GRXVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Jingchang Lu <b35083@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v4 16/17] clocksource: vf_pit_timer: Switch to sched_clock_register()
Date: Thu, 18 Jul 2013 16:21:29 -0700
Message-Id: <1374189690-10810-17-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Jingchang Lu <b35083@freescale.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/vf_pit_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index 587e020..02821b0 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -52,7 +52,7 @@ static inline void pit_irq_acknowledge(void)
 	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
 }
 
-static unsigned int pit_read_sched_clock(void)
+static u64 pit_read_sched_clock(void)
 {
 	return __raw_readl(clksrc_base + PITCVAL);
 }
@@ -64,7 +64,7 @@ static int __init pit_clocksource_init(unsigned long rate)
 	__raw_writel(~0UL, clksrc_base + PITLDVAL);
 	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
 
-	setup_sched_clock(pit_read_sched_clock, 32, rate);
+	sched_clock_register(pit_read_sched_clock, 32, rate);
 	return clocksource_mmio_init(clksrc_base + PITCVAL, "vf-pit", rate,
 			300, 32, clocksource_mmio_readl_down);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

