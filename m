Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3L3QMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:12:51 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:57040 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3L3QJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:45 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/17] ARM: footbridge: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:21 +0100
Message-Id: <1388419771-30075-7-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-footbridge/dc21285-timer.c |    2 +-
 arch/arm/mach-footbridge/dc21285.c       |   10 +++++-----
 arch/arm/mach-footbridge/isa-timer.c     |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-footbridge/dc21285-timer.c b/arch/arm/mach-footbridge/dc21285-timer.c
index 9ee78f7..892d550 100644
--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -86,7 +86,7 @@ static irqreturn_t timer1_interrupt(int irq, void *dev_id)
 static struct irqaction footbridge_timer_irq = {
 	.name		= "dc21285_timer1",
 	.handler	= timer1_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.dev_id		= &ckevt_dc21285,
 };
 
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 7c2fdae..96a3d73 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -334,15 +334,15 @@ void __init dc21285_preinit(void)
 	/*
 	 * We don't care if these fail.
 	 */
-	dc21285_request_irq(IRQ_PCI_SERR, dc21285_serr_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_SERR, dc21285_serr_irq, 0,
 			    "PCI system error", &serr_timer);
-	dc21285_request_irq(IRQ_PCI_PERR, dc21285_parity_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_PERR, dc21285_parity_irq, 0,
 			    "PCI parity error", &perr_timer);
-	dc21285_request_irq(IRQ_PCI_ABORT, dc21285_abort_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_ABORT, dc21285_abort_irq, 0,
 			    "PCI abort", NULL);
-	dc21285_request_irq(IRQ_DISCARD_TIMER, dc21285_discard_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_DISCARD_TIMER, dc21285_discard_irq, 0,
 			    "Discard timer", NULL);
-	dc21285_request_irq(IRQ_PCI_DPERR, dc21285_dparity_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_DPERR, dc21285_dparity_irq, 0,
 			    "PCI data parity", NULL);
 
 	if (cfn_mode) {
diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index d9301dd..b73f52e 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
@@ -27,7 +27,7 @@ static irqreturn_t pit_timer_interrupt(int irq, void *dev_id)
 static struct irqaction pit_timer_irq = {
 	.name		= "pit",
 	.handler	= pit_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.dev_id		= &i8253_clockevent,
 };
 
-- 
1.7.9.5

