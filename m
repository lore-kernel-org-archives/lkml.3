Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaACAkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:40:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47312 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaACAhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:37:46 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH v2 06/10] Input: pm8xxx-vibrator - Add DT match table
Date: Thu,  2 Jan 2014 16:37:36 -0800
Message-Id: <1388709460-19222-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388709460-19222-1-git-send-email-sboyd@codeaurora.org>
References: <1388709460-19222-1-git-send-email-sboyd@codeaurora.org>
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
index 28251560249d..458d51b88be5 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -142,6 +142,13 @@ static int pm8xxx_vib_play_effect(struct input_dev *dev, void *data,
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
@@ -221,6 +228,7 @@ static struct platform_driver pm8xxx_vib_driver = {
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

