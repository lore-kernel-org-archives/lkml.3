Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab3LIJMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:12:31 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33954 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932104Ab3LIJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:12:27 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] clocksource: misc drivers: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:12:10 +0100
Message-Id: <1386580330-4187-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381639028-6791-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381639028-6791-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/clocksource/cadence_ttc_timer.c | 3 +--
 drivers/clocksource/cs5535-clockevt.c   | 2 +-
 drivers/clocksource/dw_apb_timer.c      | 3 +--
 drivers/clocksource/nomadik-mtu.c       | 2 +-
 drivers/clocksource/samsung_pwm_timer.c | 2 +-
 drivers/clocksource/sh_cmt.c            | 3 +--
 drivers/clocksource/sh_mtu2.c           | 3 +--
 drivers/clocksource/sh_tmu.c            | 3 +--
 8 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4bc205..dc35962ab59c 100644
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
index ea210482dd20..db2105290898 100644
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
index e54ca1062d8e..f3656a6b0382 100644
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
index ed7b73b508e0..152a3f3875ee 100644
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
index 85082e8d3052..5645cfc90c41 100644
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
index 0965e9848b3d..c6186339dd52 100644
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
index 3cf12834681e..ec871bb1c146 100644
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
index 63557cda0a7d..75b935d53924 100644
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
1.8.3.2

