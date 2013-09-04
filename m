Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406Ab3IDE7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:59:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59805 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758246Ab3IDE7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:59:06 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: footbridge: remove obsolete IRQF_DISABLED
Date: Wed,  4 Sep 2013 06:59:01 +0200
Message-Id: <1378270741-24785-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from footbridge
code. It's a NOOP since 2.6.35.

This is an update for 3.11 of a patch already sent for 3.10

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-footbridge/dc21285-timer.c |  2 +-
 arch/arm/mach-footbridge/dc21285.c       | 10 +++++-----
 arch/arm/mach-footbridge/isa-timer.c     |  2 +-
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
index 3490a24..cc52e6c 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -336,15 +336,15 @@ void __init dc21285_preinit(void)
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
1.8.1.2

