Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaGVLL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:11:58 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:54588 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaGVLL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/19] mfd: lp8788-irq: Fix 'missing blank line after declarations' warning
Date: Tue, 22 Jul 2014 12:11:16 +0100
Message-Id: <1406027485-15657-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: Missing a blank line after declarations
+       struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+       irqd->enabled[data->hwirq] = 1;

WARNING: Missing a blank line after declarations
+       struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+       irqd->enabled[data->hwirq] = 0;

total: 0 errors, 2 warnings, 198 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/lp8788-irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/lp8788-irq.c b/drivers/mfd/lp8788-irq.c
index c84ded5..23982db 100644
--- a/drivers/mfd/lp8788-irq.c
+++ b/drivers/mfd/lp8788-irq.c
@@ -66,12 +66,14 @@ static inline u8 _irq_to_val(enum lp8788_int_id id, int enable)
 static void lp8788_irq_enable(struct irq_data *data)
 {
 	struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+
 	irqd->enabled[data->hwirq] = 1;
 }
 
 static void lp8788_irq_disable(struct irq_data *data)
 {
 	struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+
 	irqd->enabled[data->hwirq] = 0;
 }
 
-- 
1.8.3.2

