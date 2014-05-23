Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaEWKmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:42:52 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34741 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaEWKmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:42:47 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] clocksource: marco: Fix the affinity set for local timer of CPU1
Date: Fri, 23 May 2014 12:42:59 +0200
Message-Id: <1400841780-7119-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <537F2589.5050807@linaro.org>
References: <537F2589.5050807@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhiwu Song <Zhiwu.Song@csr.com>

irqchip will reject the affinity set to CPUs which is not online
yet. but in the CPU1 wakeup stage, OS only sets CPU1 to be online
after local timer is set, so that causes the irq_set_affinity not
work. this patch moves to irq_force_affinity() for the low level
boot stage.

Signed-off-by: Zhiwu Song <Zhiwu.Song@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/timer-marco.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index b52e1c0..7f5374d 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -199,7 +199,7 @@ static int sirfsoc_local_timer_setup(struct clock_event_device *ce)
 
 	action->dev_id = ce;
 	BUG_ON(setup_irq(ce->irq, action));
-	irq_set_affinity(action->irq, cpumask_of(cpu));
+	irq_force_affinity(action->irq, cpumask_of(cpu));
 
 	clockevents_register_device(ce);
 	return 0;
-- 
1.7.9.5

