Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3GFFPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:15:42 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53680 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3GFFPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:15:41 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: at91: remove IRQF_DISABLED
Date: Sat,  6 Jul 2013 07:15:30 +0200
Message-Id: <1373087730-19917-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP since 2.6.36 and can be removed.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-at91/at91rm9200_time.c  | 2 +-
 arch/arm/mach-at91/at91sam926x_time.c | 2 +-
 arch/arm/mach-at91/at91x40_time.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index 180b302..f607deb 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -93,7 +93,7 @@ static irqreturn_t at91rm9200_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction at91rm9200_timer_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= at91rm9200_timer_interrupt,
 	.irq		= NR_IRQS_LEGACY + AT91_ID_SYS,
 };
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 3a4bc2e..bb39232 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -171,7 +171,7 @@ static irqreturn_t at91sam926x_pit_interrupt(int irq, void *dev_id)
 
 static struct irqaction at91sam926x_pit_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= at91sam926x_pit_interrupt,
 	.irq		= NR_IRQS_LEGACY + AT91_ID_SYS,
 };
diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
index 2919eba..c0e637a 100644
--- a/arch/arm/mach-at91/at91x40_time.c
+++ b/arch/arm/mach-at91/at91x40_time.c
@@ -57,7 +57,7 @@ static irqreturn_t at91x40_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction at91x40_timer_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= at91x40_timer_interrupt
 };
 
-- 
1.8.1.2

