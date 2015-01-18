Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbbARLj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:39:59 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:41508 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbbARLjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:39:54 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 2/8] gpio/-mm-lantiq: Use devm_kzalloc
Date: Sun, 18 Jan 2015 12:39:27 +0100
Message-Id: <1421581173-28416-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kzalloc with the device managed devm_kzalloc

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-mm-lantiq.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-mm-lantiq.c b/drivers/gpio/gpio-mm-lantiq.c
index f228b1c..7890163 100644
--- a/drivers/gpio/gpio-mm-lantiq.c
+++ b/drivers/gpio/gpio-mm-lantiq.c
@@ -107,14 +107,13 @@ static int ltq_mm_probe(struct platform_device *pdev)
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct ltq_mm *chip;
 	const __be32 *shadow;
-	int ret = 0;
 
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
 		return -ENOENT;
 	}
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -129,10 +128,7 @@ static int ltq_mm_probe(struct platform_device *pdev)
 	if (shadow)
 		chip->shadow = be32_to_cpu(*shadow);
 
-	ret = of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
-	if (ret)
-		kfree(chip);
-	return ret;
+	return of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
 }
 
 static const struct of_device_id ltq_mm_match[] = {
-- 
2.1.4

