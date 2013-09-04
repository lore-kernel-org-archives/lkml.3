Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939Ab3IDEyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:54:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59788 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761839Ab3IDEyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:54:45 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: at91: remove IRQF_DISABLED
Date: Wed,  4 Sep 2013 06:54:39 +0200
Message-Id: <1378270479-24628-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP since 2.6.36 and can be removed.

This is an update for 3.11 of a patch already sent for 3.10

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

