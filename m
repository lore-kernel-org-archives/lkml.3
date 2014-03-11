Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaCKWky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:40:54 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61760 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbaCKWkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:40:53 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 01/17] clocksource: arch_timer: Set dynamic irq affinity on mmio clockevent
Date: Tue, 11 Mar 2014 23:40:37 +0100
Message-Id: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <531F8FAC.2040902@linaro.org>
References: <531F8FAC.2040902@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Set the CLOCK_EVT_FEAT_DYNIRQ flag on the memory mapped
clockevent so that we save power by waking up the CPU with the
next event when this timer is used in broadcast mode.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/arm_arch_timer.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 95fb944..57e823c 100644
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
1.7.9.5

