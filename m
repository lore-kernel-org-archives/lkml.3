Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3JLDVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:21:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53853 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137Ab3JLDVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:21:48 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: stigge@antcom.de, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: LPC32xx: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 05:21:40 +0200
Message-Id: <1381548100-5035-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-lpc32xx/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-lpc32xx/timer.c b/arch/arm/mach-lpc32xx/timer.c
index 20eab63..4e58372 100644
--- a/arch/arm/mach-lpc32xx/timer.c
+++ b/arch/arm/mach-lpc32xx/timer.c
@@ -90,7 +90,7 @@ static irqreturn_t lpc32xx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction lpc32xx_timer_irq = {
 	.name		= "LPC32XX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= lpc32xx_timer_interrupt,
 };
 
-- 
1.8.1.2

