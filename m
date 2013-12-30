Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3L3KUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:20:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56094 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3L3KUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:20:10 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de
Cc: axel.lin@ingics.com, ezequiel.garcia@free-electrons.com,
        jg1.han@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        michael.opdenacker@free-electrons.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/20] clocksource: misc drivers: Remove deprecated IRQF_DISABLED
Date: Mon, 30 Dec 2013 11:19:35 +0100
Message-Id: <1388398779-11222-16-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
References: <52C1479E.80808@linaro.org>
 <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>

This patch removes the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

[dlezcano] : slightly changed the changelog

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/cadence_ttc_timer.c |    3 +--
 drivers/clocksource/cs5535-clockevt.c   |    2 +-
 drivers/clocksource/dw_apb_timer.c      |    3 +--
 drivers/clocksource/nomadik-mtu.c       |    2 +-
 drivers/clocksource/samsung_pwm_timer.c |    2 +-
 drivers/clocksource/sh_cmt.c            |    3 +--
 drivers/clocksource/sh_mtu2.c           |    3 +--
 drivers/clocksource/sh_tmu.c            |    3 +--
 8 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b865b4e..8c7382b 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -388,8 +388,7 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	__raw_writel(0x1,  ttcce->ttc.base_addr + TTC_IER_OFFSET);
 
 	err = request_irq(irq, ttc_clock_event_interrupt,
-			  IRQF_DISABLED | IRQF_TIMER,
-			  ttcce->ce.name, ttcce);
+			  IRQF_TIMER, ttcce->ce.name, ttcce);
 	if (WARN_ON(err)) {
 		kfree(ttcce);
 		return;
diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index ea21048..db21052 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -131,7 +131,7 @@ static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
+	.flags = IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
 	.name = DRV_NAME,
 };
 
diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index e54ca10..f3656a6 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -243,8 +243,7 @@ dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 	dw_ced->irqaction.dev_id	= &dw_ced->ced;
 	dw_ced->irqaction.irq		= irq;
 	dw_ced->irqaction.flags		= IRQF_TIMER | IRQF_IRQPOLL |
-					  IRQF_NOBALANCING |
-					  IRQF_DISABLED;
+					  IRQF_NOBALANCING;
 
 	dw_ced->eoi = apbt_eoi;
 	err = setup_irq(irq, &dw_ced->irqaction);
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index ed7b73b..152a3f3 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -187,7 +187,7 @@ static irqreturn_t nmdk_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction nmdk_timer_irq = {
 	.name		= "Nomadik Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= nmdk_timer_interrupt,
 	.dev_id		= &nmdk_clkevt,
 };
diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index 85082e8..5645cfc 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -264,7 +264,7 @@ static irqreturn_t samsung_clock_event_isr(int irq, void *dev_id)
 
 static struct irqaction samsung_clock_event_irq = {
 	.name		= "samsung_time_irq",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= samsung_clock_event_isr,
 	.dev_id		= &time_event_device,
 };
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 0965e98..c618633 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -726,8 +726,7 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 	p->irqaction.name = dev_name(&p->pdev->dev);
 	p->irqaction.handler = sh_cmt_interrupt;
 	p->irqaction.dev_id = p;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "cmt_fck");
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index f02648e..b6a56b1 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -302,8 +302,7 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_mtu2_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "mtu2_fck");
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 54ab475..fc752f7 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -462,8 +462,7 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 	p->irqaction.handler = sh_tmu_interrupt;
 	p->irqaction.dev_id = p;
 	p->irqaction.irq = irq;
-	p->irqaction.flags = IRQF_DISABLED | IRQF_TIMER | \
-			     IRQF_IRQPOLL  | IRQF_NOBALANCING;
+	p->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
 
 	/* get hold of clock */
 	p->clk = clk_get(&p->pdev->dev, "tmu_fck");
-- 
1.7.9.5

