Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3BVPof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:44:35 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56454 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab3BVPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:44:34 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linus.walleij@stericsson.com
Subject: [PATCH] clocksource : nomadik-mtu : fix missing irq initialization
Date: Fri, 22 Feb 2013 16:44:30 +0100
Message-Id: <1361547870-32638-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the clock device irq field which is not initialized.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/nomadik-mtu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 8914c3c..7cbcaa0 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -226,5 +226,6 @@ void __init nmdk_timer_init(void __iomem *base, int irq)
 	/* Timer 1 is used for events, register irq and clockevents */
 	setup_irq(irq, &nmdk_timer_irq);
 	nmdk_clkevt.cpumask = cpumask_of(0);
+	nmdk_clkevt.irq = irq;
 	clockevents_config_and_register(&nmdk_clkevt, rate, 2, 0xffffffffU);
 }
-- 
1.7.9.5

