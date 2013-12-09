Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3LIE4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:56:30 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60966 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755693Ab3LIE43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:56:29 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: stigge@antcom.de, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: LPC32xx: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 05:55:56 +0100
Message-Id: <1386564956-19152-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381548100-5035-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381548100-5035-1-git-send-email-michael.opdenacker@free-electrons.com>
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
index 20eab63d10ba..4e5837299c04 100644
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
1.8.3.2

