Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3FJLuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:08 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39077 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3FJLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:04 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 04/15] gpio_msm: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:02 +0530
Message-Id: <1370864113-17895-5-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: linux-gpio@vger.kernel.org
CC: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>
---
 drivers/gpio/gpio-msm-v1.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
index c798585a..c0ead43 100644
--- a/drivers/gpio/gpio-msm-v1.c
+++ b/drivers/gpio/gpio-msm-v1.c
@@ -652,14 +652,14 @@ static int __devinit gpio_msm_v1_probe(struct platform_device *pdev)
 		return irq2;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base1 = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base1)
-		return -EADDRNOTAVAIL;
+	base1 = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base1))
+		return PTR_ERR(base1);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	base2 = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base2)
-		return -EADDRNOTAVAIL;
+	base2 = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base2))
+		return PTR_ERR(base2);
 
 	for (i = FIRST_GPIO_IRQ; i < FIRST_GPIO_IRQ + NR_GPIO_IRQS; i++) {
 		if (i - FIRST_GPIO_IRQ >=
-- 
1.7.9.5

