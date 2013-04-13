Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3DMA2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:28:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37756 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab3DMA1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:27:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,466,1363158000"; 
   d="scan'208";a="38215029"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCHv2 2/4] ARM: arch_timers: Pass clock event to set_mode callback
Date: Fri, 12 Apr 2013 17:27:41 -0700
Message-Id: <1365812863-5367-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1365812863-5367-1-git-send-email-sboyd@codeaurora.org>
References: <1365812863-5367-1-git-send-email-sboyd@codeaurora.org>
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
index 2abb861..545891b 100644
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

