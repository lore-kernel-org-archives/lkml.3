Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaGVLMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:12:03 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:63622 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaGVLL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/19] mfd: max8925-core: Fix 'missing blank line after declarations' warning
Date: Tue, 22 Jul 2014 12:11:18 +0100
Message-Id: <1406027485-15657-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: Missing a blank line after declarations
+       struct max8925_chip *chip = irq_data_get_irq_chip_data(data);
+       max8925_irqs[data->irq - chip->irq_base].enable

WARNING: Missing a blank line after declarations
+       struct max8925_chip *chip = irq_data_get_irq_chip_data(data);
+       max8925_irqs[data->irq - chip->irq_base].enable = 0;

total: 0 errors, 2 warnings, 927 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max8925-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index f3faf0c..97a787a 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -624,6 +624,7 @@ static void max8925_irq_sync_unlock(struct irq_data *data)
 static void max8925_irq_enable(struct irq_data *data)
 {
 	struct max8925_chip *chip = irq_data_get_irq_chip_data(data);
+
 	max8925_irqs[data->irq - chip->irq_base].enable
 		= max8925_irqs[data->irq - chip->irq_base].offs;
 }
@@ -631,6 +632,7 @@ static void max8925_irq_enable(struct irq_data *data)
 static void max8925_irq_disable(struct irq_data *data)
 {
 	struct max8925_chip *chip = irq_data_get_irq_chip_data(data);
+
 	max8925_irqs[data->irq - chip->irq_base].enable = 0;
 }
 
-- 
1.8.3.2

