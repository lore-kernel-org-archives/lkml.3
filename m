Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbaAHSiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:38:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60491 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbaAHSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:37:56 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 6/7] mfd: pm8921: Add DT match table
Date: Wed,  8 Jan 2014 10:37:49 -0800
Message-Id: <1389206270-3728-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow this driver to probe based on devicetree.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/pm8921-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index e9340bd6d1ab..3aab6ace5eb5 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -392,6 +392,13 @@ static const struct regmap_config ssbi_regmap_config = {
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
@@ -501,6 +508,7 @@ static struct platform_driver pm8921_driver = {
 	.driver		= {
 		.name	= "pm8921-core",
 		.owner	= THIS_MODULE,
+		.of_match_table = pm8921_id_table,
 	},
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

