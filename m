Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaCDStM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:49:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56822 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaCDSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:48:55 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH 2/2] mfd: pm8921: Use IRQCHIP_SKIP_SET_WAKE
Date: Tue,  4 Mar 2014 10:48:52 -0800
Message-Id: <1393958932-3585-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393958932-3585-1-git-send-email-sboyd@codeaurora.org>
References: <1393958932-3585-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to implement a dummy irq_set_wake op if we just set
IRQCHIP_SKIP_SET_WAKE.

Suggested-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/pm8921-core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 3ebbdf6c61db..3493cd6e973b 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -240,18 +240,12 @@ static int pm8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
 	return pm8xxx_config_irq(chip, block, config);
 }
 
-static int pm8xxx_irq_set_wake(struct irq_data *d, unsigned int on)
-{
-	return 0;
-}
-
 static struct irq_chip pm8xxx_irq_chip = {
 	.name		= "pm8xxx",
 	.irq_mask_ack	= pm8xxx_irq_mask_ack,
 	.irq_unmask	= pm8xxx_irq_unmask,
 	.irq_set_type	= pm8xxx_irq_set_type,
-	.irq_set_wake	= pm8xxx_irq_set_wake,
-	.flags		= IRQCHIP_MASK_ON_SUSPEND,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_SKIP_SET_WAKE,
 };
 
 static int pm8xxx_irq_domain_map(struct irq_domain *d, unsigned int irq,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

