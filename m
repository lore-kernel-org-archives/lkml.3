Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbbARLkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:40:05 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:34073 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbARLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:39:56 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, John Crispin <blogic@openwrt.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 4/8] gpio-mm-lantiq: Use of_propery_read_u16
Date: Sun, 18 Jan 2015 12:39:29 +0100
Message-Id: <1421581173-28416-5-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of parsing manually the shadow content, use the much simpler
helper of_property_read_u16.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: John Crispin <blogic@openwrt.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-mm-lantiq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mm-lantiq.c b/drivers/gpio/gpio-mm-lantiq.c
index 7d55161..b511a6b 100644
--- a/drivers/gpio/gpio-mm-lantiq.c
+++ b/drivers/gpio/gpio-mm-lantiq.c
@@ -105,7 +105,6 @@ static void ltq_mm_save_regs(struct of_mm_gpio_chip *mm_gc)
 static int ltq_mm_probe(struct platform_device *pdev)
 {
 	struct ltq_mm *chip;
-	const __be32 *shadow;
 
 	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -117,9 +116,8 @@ static int ltq_mm_probe(struct platform_device *pdev)
 	chip->mmchip.save_regs = ltq_mm_save_regs;
 
 	/* store the shadow value if one was passed by the devicetree */
-	shadow = of_get_property(pdev->dev.of_node, "lantiq,shadow", NULL);
-	if (shadow)
-		chip->shadow = be32_to_cpu(*shadow);
+	of_property_read_u16(pdev->dev.of_node, "lantiq,shadow",
+			     &chip->shadow);
 
 	return of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
 }
-- 
2.1.4

