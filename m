Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbaAFW4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:56:25 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50638 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaAFW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:56:20 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource: arch_timer: Set dynamic irq affinity on mmio clockevent
Date: Mon,  6 Jan 2014 14:56:17 -0800
Message-Id: <1389048977-13502-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the CLOCK_EVT_FEAT_DYNIRQ flag on the memory mapped
clockevent so that we save power by waking up the CPU with the
next event when this timer is used in broadcast mode.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/arm_arch_timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 95fb944e15ee..57e823c44d2a 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -277,6 +277,7 @@ static void __arch_timer_setup(unsigned type,
 			clk->set_next_event = arch_timer_set_next_event_phys;
 		}
 	} else {
+		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;
 		clk->name = "arch_mem_timer";
 		clk->rating = 400;
 		clk->cpumask = cpu_all_mask;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

