Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaCDStN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:49:13 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56816 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaCDSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:48:55 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH 1/2] mfd: pm8921: Drop irq_set_lockdep_class() code
Date: Tue,  4 Mar 2014 10:48:51 -0800
Message-Id: <1393958932-3585-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393958932-3585-1-git-send-email-sboyd@codeaurora.org>
References: <1393958932-3585-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't necessary as we aren't setting the summary interrupt
to wake up the system in the irq_wake() callback.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/pm8921-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index f7341114f35f..3ebbdf6c61db 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -254,14 +254,11 @@ static struct irq_chip pm8xxx_irq_chip = {
 	.flags		= IRQCHIP_MASK_ON_SUSPEND,
 };
 
-static struct lock_class_key pm8xxx_irq_lock_class;
-
 static int pm8xxx_irq_domain_map(struct irq_domain *d, unsigned int irq,
 				   irq_hw_number_t hwirq)
 {
 	struct pm_irq_chip *chip = d->host_data;
 
-	irq_set_lockdep_class(irq, &pm8xxx_irq_lock_class);
 	irq_set_chip_and_handler(irq, &pm8xxx_irq_chip, handle_level_irq);
 	irq_set_chip_data(irq, chip);
 #ifdef CONFIG_ARM
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

