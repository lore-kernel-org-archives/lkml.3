Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab3GRXYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:24:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58771 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777Ab3GRXVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:39 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v4 12/17] clocksource: samsung_pwm_timer: Switch to sched_clock_register()
Date: Thu, 18 Jul 2013 16:21:25 -0700
Message-Id: <1374189690-10810-13-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/samsung_pwm_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index 584b547..09e8bc7 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -310,7 +310,7 @@ static void __iomem *samsung_timer_reg(void)
  * this wraps around for now, since it is just a relative time
  * stamp. (Inspired by U300 implementation.)
  */
-static u32 notrace samsung_read_sched_clock(void)
+static u64 notrace samsung_read_sched_clock(void)
 {
 	void __iomem *reg = samsung_timer_reg();
 
@@ -337,7 +337,7 @@ static void __init samsung_clocksource_init(void)
 	samsung_time_setup(pwm.source_id, pwm.tcnt_max);
 	samsung_time_start(pwm.source_id, true);
 
-	setup_sched_clock(samsung_read_sched_clock,
+	sched_clock_register(samsung_read_sched_clock,
 						pwm.variant.bits, clock_rate);
 
 	ret = clocksource_mmio_init(reg, "samsung_clocksource_timer",
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

