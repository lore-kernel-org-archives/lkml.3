Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab3HIDRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:17:39 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59141 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967411Ab3HIDRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:17:38 -0400
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
To: hskinnemoen@gmail.com, egtvedt@samfundet.no, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Kumar Gaurav <kumargauravgupta3@gmail.com>
Subject: [PATCH]arch:avr32:kernel:time.c: Removed IRQF_DISABLED
Date: Fri,  9 Aug 2013 08:47:23 +0530
Message-Id: <1376018243-8565-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed IRQF_DISABLED as it's no-op and should be removed

Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
---
 arch/avr32/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 869a1c6..0566c81 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
 	/* Oprofile uses the same irq as the timer, so allow it to be shared */
-	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
+	.flags		= IRQF_TIMER | IRQF_TRIGGER_NONE | IRQF_SHARED,
 	.name		= "avr32_comparator",
 };
 
-- 
1.7.9.5

