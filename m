Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaCGGqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:46:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37915 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaCGGow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:44:52 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH 6/7] pinctrl: msm: Remove impossible WARN_ON()s
Date: Thu,  6 Mar 2014 22:44:45 -0800
Message-Id: <1394174686-8358-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
References: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these functions are limited in what they can pass as the gpio
or irq number to whatever is setup during probe. Remove the
checks.

Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/pinctrl/pinctrl-msm.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 58c23f138d7a..bdfb697194f6 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -403,8 +403,6 @@ static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 	u32 val;
 
 	g = &pctrl->soc->groups[offset];
-	if (WARN_ON(g->io_reg < 0))
-		return -EINVAL;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -425,8 +423,6 @@ static int msm_gpio_direction_output(struct gpio_chip *chip, unsigned offset, in
 	u32 val;
 
 	g = &pctrl->soc->groups[offset];
-	if (WARN_ON(g->io_reg < 0))
-		return -EINVAL;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -453,8 +449,6 @@ static int msm_gpio_get(struct gpio_chip *chip, unsigned offset)
 	u32 val;
 
 	g = &pctrl->soc->groups[offset];
-	if (WARN_ON(g->io_reg < 0))
-		return -EINVAL;
 
 	val = readl(pctrl->regs + g->io_reg);
 	return !!(val & BIT(g->in_bit));
@@ -468,8 +462,6 @@ static void msm_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	u32 val;
 
 	g = &pctrl->soc->groups[offset];
-	if (WARN_ON(g->io_reg < 0))
-		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -618,8 +610,6 @@ static void msm_gpio_irq_mask(struct irq_data *d)
 
 	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
-	if (WARN_ON(g->intr_cfg_reg < 0))
-		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -641,8 +631,6 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 
 	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
-	if (WARN_ON(g->intr_status_reg < 0))
-		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -668,8 +656,6 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 
 	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
-	if (WARN_ON(g->intr_status_reg < 0))
-		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -694,8 +680,6 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 
 	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
-	if (WARN_ON(g->intr_cfg_reg < 0))
-		return -EINVAL;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

