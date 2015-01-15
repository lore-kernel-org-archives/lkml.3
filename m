Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbbAOKJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:09:56 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57937 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbAOKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:09:54 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: sa1100: add platform functions to handle PWER settings
Date: Thu, 15 Jan 2015 13:09:30 +0300
Message-Id: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWER settings logically belongs neither to GPIO nor to system IRQ code.
Add special functions to handle PWER (for GPIO and for system IRQs)
from platform code.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 arch/arm/mach-sa1100/generic.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 40e0d86..022e451 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -416,3 +416,24 @@ void sa1110_mb_enable(void)
 	local_irq_restore(flags);
 }
 
+int sa11x0_gpio_set_wake(unsigned int gpio, unsigned int on)
+{
+	if (on)
+		PWER |= BIT(gpio);
+	else
+		PWER &= ~BIT(gpio);
+
+	return 0;
+}
+
+int sa11x0_sc_set_wake(unsigned int irq, unsigned int on)
+{
+	if (BIT(irq) != IC_RTCAlrm)
+		return -EINVAL;
+
+	if (on)
+		PWER |= PWER_RTC;
+	else
+		PWER &= ~PWER_RTC;
+	return 0;
+}
-- 
2.1.4

