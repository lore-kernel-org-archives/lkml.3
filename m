Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab3GRXZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:25:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58730 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934644Ab3GRXVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:37 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH v4 07/17] clocksource: bcm2835: Switch to sched_clock_register()
Date: Thu, 18 Jul 2013 16:21:20 -0700
Message-Id: <1374189690-10810-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32 bit sched_clock interface now supports 64 bits. Upgrade to
the 64 bit function to allow us to remove the 32 bit registration
interface.

Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/bcm2835_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index 07ea7ce..26ed331 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -49,7 +49,7 @@ struct bcm2835_timer {
 
 static void __iomem *system_clock __read_mostly;
 
-static u32 notrace bcm2835_sched_read(void)
+static u64 notrace bcm2835_sched_read(void)
 {
 	return readl_relaxed(system_clock);
 }
@@ -110,7 +110,7 @@ static void __init bcm2835_timer_init(struct device_node *node)
 		panic("Can't read clock-frequency");
 
 	system_clock = base + REG_COUNTER_LO;
-	setup_sched_clock(bcm2835_sched_read, 32, freq);
+	sched_clock_register(bcm2835_sched_read, 32, freq);
 
 	clocksource_mmio_init(base + REG_COUNTER_LO, node->name,
 		freq, 300, 32, clocksource_mmio_readl_up);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

