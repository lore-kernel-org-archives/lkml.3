Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3LIFRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:17:01 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32838 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860Ab3LIFRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:17:00 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: hskinnemoen@gmail.com, egtvedt@samfundet.no
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] avr32: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 06:16:51 +0100
Message-Id: <1386566211-19536-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20131013072003.GA11195@samfundet.no>
References: <20131013072003.GA11195@samfundet.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 12f828ad5058..d0f771be9e96 100644
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
1.8.3.2

