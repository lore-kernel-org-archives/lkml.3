Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3EMT5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:57:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41464 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3EMT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:56:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363158000"; 
   d="scan'208";a="46763854"
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCHv3 2/4] clocksource: arch_timer: Pass clock event to set_mode callback
Date: Mon, 13 May 2013 12:56:35 -0700
Message-Id: <1368474997-10859-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0.dirty
In-Reply-To: <1368474997-10859-1-git-send-email-sboyd@codeaurora.org>
References: <1368474997-10859-1-git-send-email-sboyd@codeaurora.org>
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

