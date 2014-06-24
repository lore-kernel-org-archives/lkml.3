Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaFXJMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:12:25 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48024 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaFXJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:12:23 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davidb@codeaurora.org, lee.jones@linaro.org, spk.linux@gmail.com
Subject: [PATCH 1/1] mfd: pm8921-core: Remove unused variable
Date: Tue, 24 Jun 2014 14:39:07 +0530
Message-Id: <1403600947-17790-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

‘irq_bit’ is unused in the function. Remove it.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
Compile tested.
---
 drivers/mfd/pm8921-core.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 959513803542..39904f77c049 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -186,11 +186,9 @@ static void pm8xxx_irq_mask_ack(struct irq_data *d)
 {
 	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
 	unsigned int pmirq = irqd_to_hwirq(d);
-	int	irq_bit;
 	u8	block, config;
 
 	block = pmirq / 8;
-	irq_bit = pmirq % 8;
 
 	config = chip->config[pmirq] | PM_IRQF_MASK_ALL | PM_IRQF_CLR;
 	pm8xxx_config_irq(chip, block, config);
@@ -200,11 +198,9 @@ static void pm8xxx_irq_unmask(struct irq_data *d)
 {
 	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
 	unsigned int pmirq = irqd_to_hwirq(d);
-	int	irq_bit;
 	u8	block, config;
 
 	block = pmirq / 8;
-	irq_bit = pmirq % 8;
 
 	config = chip->config[pmirq];
 	pm8xxx_config_irq(chip, block, config);
-- 
1.7.9.5

