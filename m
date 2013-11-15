Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3KOXt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:49:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43473 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3KOXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:48:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, Stuart Menefy <stuart.menefy@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 1/4] clocksource: arm_global_timer: Switch to sched_clock_register()
Date: Fri, 15 Nov 2013 15:48:32 -0800
Message-Id: <1384559315-18699-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface. While we're here increase the number of bits that
sched_clock can handle to 64 to make full use of the counter.

Cc: Stuart Menefy <stuart.menefy@st.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/arm_global_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index c639b1a..0fc31d0 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -202,7 +202,7 @@ static struct clocksource gt_clocksource = {
 };
 
 #ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
-static u32 notrace gt_sched_clock_read(void)
+static u64 notrace gt_sched_clock_read(void)
 {
 	return gt_counter_read();
 }
@@ -217,7 +217,7 @@ static void __init gt_clocksource_init(void)
 	writel(GT_CONTROL_TIMER_ENABLE, gt_base + GT_CONTROL);
 
 #ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
-	setup_sched_clock(gt_sched_clock_read, 32, gt_clk_rate);
+	sched_clock_register(gt_sched_clock_read, 64, gt_clk_rate);
 #endif
 	clocksource_register_hz(&gt_clocksource, gt_clk_rate);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

