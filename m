Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314Ab3GRUHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:07:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49715 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102Ab3GRUHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:07:40 -0400
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, "Bird, Tim" <Tim.Bird@sonymobile.com>,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 2/3] drivers: gpio: msm: Fix the error condition for reading ngpio
Date: Thu, 18 Jul 2013 13:07:14 -0700
Message-Id: <1374178035-19943-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
References: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

of_property_read_u32 return 0 on success. The check was using a ! to
return error. Fix the if condition.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Pankaj Jangra  <jangra.pankaj9@gmail.com>
Cc: "Bird, Tim" <Tim.Bird@sonymobile.com>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/gpio/gpio-msm-v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index f4491a4..c2fa770 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -378,7 +378,7 @@ static int msm_gpio_probe(struct platform_device *pdev)
 	int ret, ngpio;
 	struct resource *res;
 
-	if (!of_property_read_u32(pdev->dev.of_node, "ngpio", &ngpio)) {
+	if (of_property_read_u32(pdev->dev.of_node, "ngpio", &ngpio)) {
 		dev_err(&pdev->dev, "%s: ngpio property missing\n", __func__);
 		return -EINVAL;
 	}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

