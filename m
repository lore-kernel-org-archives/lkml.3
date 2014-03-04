Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbaCDUwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:52:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274AbaCDUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:51:57 -0500
Date: Tue, 4 Mar 2014 12:51:44 -0800
From: tip-bot for Michael Opdenacker <tipbot@zytor.com>
Message-ID: <tip-322a126a8fa8af80d9dc06e7168db11d1aabdba7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        michael.opdenacker@free-electrons.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        michael.opdenacker@free-electrons.com, tglx@linutronix.de
In-Reply-To: <1393965111-17092-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1393965111-17092-1-git-send-email-michael.opdenacker@free-electrons.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] mn10300: Remove deprecated IRQF_DISABLED
Git-Commit-ID: 322a126a8fa8af80d9dc06e7168db11d1aabdba7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  322a126a8fa8af80d9dc06e7168db11d1aabdba7
Gitweb:     http://git.kernel.org/tip/322a126a8fa8af80d9dc06e7168db11d1aabdba7
Author:     Michael Opdenacker <michael.opdenacker@free-electrons.com>
AuthorDate: Tue, 4 Mar 2014 21:31:51 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 21:47:51 +0100

mn10300: Remove deprecated IRQF_DISABLED

This patch removes the IRQF_DISABLED flag from mn10300 architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-am33-list@redhat.com
Cc: dhowells@redhat.com
Cc: yasutake.koichi@jp.panasonic.com
Link: http://lkml.kernel.org/r/1393965111-17092-1-git-send-email-michael.opdenacker@free-electrons.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
