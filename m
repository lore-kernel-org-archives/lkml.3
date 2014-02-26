Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaBZTGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:06:10 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53844 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaBZTGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:04 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/9] Input: pmic8xxx-pwrkey - Migrate to regmap APIs
Date: Wed, 26 Feb 2014 11:05:54 -0800
Message-Id: <1393441562-685-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the regmap APIs for this driver instead of custom pm8xxx
APIs. This breaks this driver's dependency on the pm8xxx APIs and
allows us to easily port it to other bus protocols in the future.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/misc/pmic8xxx-pwrkey.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index 0e1a05f95858..cf6125dc3b51 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -120,6 +120,10 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!regmap)
+		return -ENODEV;
+
 	input_set_capability(pwr, EV_KEY, KEY_POWER);
 
 	pwr->name = "pmic8xxx_pwrkey";
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

