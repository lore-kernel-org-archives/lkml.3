Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaBZTGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:06:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53869 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaBZTGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:05 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 5/9] Input: pm8xxx-vibrator - Add DT match table
Date: Wed, 26 Feb 2014 11:05:58 -0800
Message-Id: <1393441562-685-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is only supported on DT enabled platforms. Convert the
driver to DT so that it can probe properly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/misc/pm8xxx-vibrator.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index b88b7cbf93e2..5079bc54c3aa 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -141,6 +141,13 @@ static int pm8xxx_vib_play_effect(struct input_dev *dev, void *data,
 	return 0;
 }
 
+static const struct of_device_id pm8xxx_vib_id_table[] = {
+	{ .compatible = "qcom,pm8058-vib" },
+	{ .compatible = "qcom,pm8921-vib" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pm8xxx_vib_id_table);
+
 static int pm8xxx_vib_probe(struct platform_device *pdev)
 
 {
@@ -220,6 +227,7 @@ static struct platform_driver pm8xxx_vib_driver = {
 		.name	= "pm8xxx-vib",
 		.owner	= THIS_MODULE,
 		.pm	= &pm8xxx_vib_pm_ops,
+		.of_match_table = pm8xxx_vib_id_table,
 	},
 };
 module_platform_driver(pm8xxx_vib_driver);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

