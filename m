Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3LJXTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:19:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37091 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3LJXTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:19:06 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH 2/2] gpio: msm: Add module device table and mark table const
Date: Tue, 10 Dec 2013 15:19:04 -0800
Message-Id: <1386717544-478-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386717544-478-1-git-send-email-sboyd@codeaurora.org>
References: <1386717544-478-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the module to be loaded automatically.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/gpio/gpio-msm-v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index 00a0978..a4dcbe4 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -430,10 +430,11 @@ static int msm_gpio_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id msm_gpio_of_match[] = {
+static const struct of_device_id msm_gpio_of_match[] = {
 	{ .compatible = "qcom,msm-gpio", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, msm_gpio_of_match);
 
 static int msm_gpio_remove(struct platform_device *dev)
 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

