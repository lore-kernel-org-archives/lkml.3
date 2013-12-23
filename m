Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3LWUqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:46:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab3LWUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:46:11 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 6/7] mfd: pm8921: Add DT match table
Date: Mon, 23 Dec 2013 12:46:02 -0800
Message-Id: <1387831563-13535-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow this driver to probe based on devicetree.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/pm8921-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index d13cb6e..290f0da 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -420,6 +420,13 @@ static const struct regmap_config ssbi_regmap_config = {
 	.reg_write = ssbi_reg_write
 };
 
+static const struct of_device_id pm8921_id_table[] = {
+	{ .compatible = "qcom,pm8058", },
+	{ .compatible = "qcom,pm8921", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pm8921_id_table);
+
 static int pm8921_probe(struct platform_device *pdev)
 {
 	struct pm8921 *pmic;
@@ -429,7 +436,6 @@ static int pm8921_probe(struct platform_device *pdev)
 	unsigned int irq;
 	u32 rev;
 
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
@@ -494,6 +500,7 @@ static struct platform_driver pm8921_driver = {
 	.driver		= {
 		.name	= "pm8921-core",
 		.owner	= THIS_MODULE,
+		.of_match_table = pm8921_id_table,
 	},
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

