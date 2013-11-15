Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3KOXsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:48:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43449 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3KOXsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:48:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH 2/4] clocksource: cadence_ttc_timer: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:48:33 -0800
Message-Id: <1384559315-18699-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/cadence_ttc_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4b..b865b4e 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -158,7 +158,7 @@ static cycle_t __ttc_clocksource_read(struct clocksource *cs)
 				TTC_COUNT_VAL_OFFSET);
 }
 
-static u32 notrace ttc_sched_clock_read(void)
+static u64 notrace ttc_sched_clock_read(void)
 {
 	return __raw_readl(ttc_sched_clock_val_reg);
 }
@@ -306,7 +306,7 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	}
 
 	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
-	setup_sched_clock(ttc_sched_clock_read, 16,
+	sched_clock_register(ttc_sched_clock_read, 16,
 			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

