Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab3FSB6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:58:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40000 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055Ab3FSBxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:41 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers: gpio: msm: Fix the error condition for reading ngpio
Date: Tue, 18 Jun 2013 18:53:32 -0700
Message-Id: <1371606813-5575-3-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1371606813-5575-1-git-send-email-rvaswani@codeaurora.org>
References: <1371606813-5575-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_property_read_u32 return 0 on success. The check was using a ! to
return error. Fix the if condition.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 drivers/gpio/gpio-msm-v2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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

