Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757Ab3JLEEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:04:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53981 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750701Ab3JLEEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:04:07 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: egtvedt@samfundet.no
Cc: tglx@linutronix.de, juhosg@openwrt.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] avr32: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:04:01 +0200
Message-Id: <1381550641-5894-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/avr32/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 12f828a..d0f771b 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
 	/* Oprofile uses the same irq as the timer, so allow it to be shared */
-	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
+	.flags		= IRQF_TIMER | IRQF_SHARED,
 	.name		= "avr32_comparator",
 };
 
-- 
1.8.1.2

