Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbbAOKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:09:59 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:50244 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbAOKJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:09:57 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: sa1100: use sa11x0_sc_set_wake() in irq driver
Date: Thu, 15 Jan 2015 13:09:31 +0300
Message-Id: <1421316574-10022-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new function controlling PWER register in IRQ driver.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 arch/arm/mach-sa1100/irq.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/arm/mach-sa1100/irq.c b/arch/arm/mach-sa1100/irq.c
index 65aebfa..7a5aa56 100644
--- a/arch/arm/mach-sa1100/irq.c
+++ b/arch/arm/mach-sa1100/irq.c
@@ -40,19 +40,9 @@ static void sa1100_unmask_irq(struct irq_data *d)
 	ICMR |= BIT(d->hwirq);
 }
 
-/*
- * Apart form GPIOs, only the RTC alarm can be a wakeup event.
- */
 static int sa1100_set_wake(struct irq_data *d, unsigned int on)
 {
-	if (BIT(d->hwirq) == IC_RTCAlrm) {
-		if (on)
-			PWER |= PWER_RTC;
-		else
-			PWER &= ~PWER_RTC;
-		return 0;
-	}
-	return -EINVAL;
+	return sa11x0_sc_set_wake(d->hwirq, on);
 }
 
 static struct irq_chip sa1100_normal_chip = {
-- 
2.1.4

