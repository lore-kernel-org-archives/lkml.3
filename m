Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab3IGHaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 03:30:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49788 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974Ab3IGHaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 03:30:13 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] mn10300: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 09:29:58 +0200
Message-Id: <1378538998-7467-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from mn10300 architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/mn10300/kernel/cevt-mn10300.c   | 2 +-
 arch/mn10300/kernel/mn10300-serial.c | 6 +++---
 arch/mn10300/kernel/smp.c            | 2 +-
 arch/mn10300/unit-asb2364/irq-fpga.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/kernel/cevt-mn10300.c b/arch/mn10300/kernel/cevt-mn10300.c
index ccce35e..60f64ca 100644
--- a/arch/mn10300/kernel/cevt-mn10300.c
+++ b/arch/mn10300/kernel/cevt-mn10300.c
@@ -113,7 +113,7 @@ int __init init_clockevents(void)
 	cd->set_next_event	= next_event;
 
 	iact = &per_cpu(timer_irq, cpu);
-	iact->flags = IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER;
+	iact->flags = IRQF_SHARED | IRQF_TIMER;
 	iact->handler = timer_interrupt;
 
 	clockevents_register_device(cd);
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index bf6e949..7ecf698 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -985,17 +985,17 @@ static int mn10300_serial_startup(struct uart_port *_port)
 	irq_set_chip(port->tm_irq, &mn10300_serial_pic);
 
 	if (request_irq(port->rx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_NOBALANCING,
 			port->rx_name, port) < 0)
 		goto error;
 
 	if (request_irq(port->tx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_NOBALANCING,
 			port->tx_name, port) < 0)
 		goto error2;
 
 	if (request_irq(port->tm_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_NOBALANCING,
 			port->tm_name, port) < 0)
 		goto error3;
 	mn10300_serial_mask_ack(port->tm_irq);
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index a17f9c9..f984193 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -143,7 +143,7 @@ static struct irqaction call_function_ipi = {
 static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id);
 static struct irqaction local_timer_ipi = {
 	.handler	= smp_ipi_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags		= IRQF_NOBALANCING,
 	.name		= "smp local timer IPI"
 };
 #endif
diff --git a/arch/mn10300/unit-asb2364/irq-fpga.c b/arch/mn10300/unit-asb2364/irq-fpga.c
index e16c216..073e2cc 100644
--- a/arch/mn10300/unit-asb2364/irq-fpga.c
+++ b/arch/mn10300/unit-asb2364/irq-fpga.c
@@ -76,7 +76,7 @@ static irqreturn_t fpga_interrupt(int irq, void *_mask)
 static struct irqaction fpga_irq[]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga",
 	},
 };
-- 
1.8.1.2

