Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaCEThP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:37:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60341 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCEThN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:37:13 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: pm8921: fixup probe() error path when irq invalid
Date: Wed,  5 Mar 2014 13:34:25 -0600
Message-Id: <1394048065-14200-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_get_irq() returns a negative error code when an IRQ is invalid
or unspecified.  Make 'irq' signed to properly handle this.

Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/mfd/pm8921-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 3aab6ac..d48452d 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -403,9 +403,8 @@ static int pm8921_probe(struct platform_device *pdev)
 {
 	struct pm8921 *pmic;
 	struct regmap *regmap;
-	int rc;
+	int irq, rc;
 	unsigned int val;
-	unsigned int irq;
 	u32 rev;
 	struct pm_irq_chip *chip;
 	unsigned int nirqs = PM8921_NR_IRQS;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

