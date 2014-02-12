Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaBLIYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:24:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50237 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbaBLIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:05 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Linus Walleij" <linus.walleij@linaro.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.262371634@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 41/79] gpio: msm: Fix irq mask/unmask by writing bits
 instead of numbers
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 4cc629b7a20945ce35628179180329b6bc9e552b upstream.

We should be writing bits here but instead we're writing the
numbers that correspond to the bits we want to write. Fix it by
wrapping the numbers in the BIT() macro. This fixes gpios acting
as interrupts.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-msm-v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -249,7 +249,7 @@ static void msm_gpio_irq_mask(struct irq
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(gpio));
-	clear_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	clear_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	__clear_bit(gpio, msm_gpio.enabled_irqs);
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
@@ -261,7 +261,7 @@ static void msm_gpio_irq_unmask(struct i
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	__set_bit(gpio, msm_gpio.enabled_irqs);
-	set_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	set_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(gpio));
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }

