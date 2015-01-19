Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbbASL2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:28:49 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:45484 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbASL1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:27:48 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, John Crispin <blogic@openwrt.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 4/8] gpio-mm-lantiq: Use of_property_read_u32
Date: Mon, 19 Jan 2015 12:27:24 +0100
Message-Id: <1421666844-14599-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <20150119105753.GC21553@leverpostej>
References: <20150119105753.GC21553@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of parsing manually the shadow content, use the much simpler
helper of_property_read_u32.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: John Crispin <blogic@openwrt.org>
Cc: devicetree@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v2: Reported by Mark Rutland <mark.rutland@arm.com>
 -use of_property_read_u32 instead of u16

 drivers/gpio/gpio-mm-lantiq.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mm-lantiq.c b/drivers/gpio/gpio-mm-lantiq.c
index 7d55161..95ff180 100644
--- a/drivers/gpio/gpio-mm-lantiq.c
+++ b/drivers/gpio/gpio-mm-lantiq.c
@@ -105,7 +105,7 @@ static void ltq_mm_save_regs(struct of_mm_gpio_chip *mm_gc)
 static int ltq_mm_probe(struct platform_device *pdev)
 {
 	struct ltq_mm *chip;
-	const __be32 *shadow;
+	u32 shadow;
 
 	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -117,9 +117,8 @@ static int ltq_mm_probe(struct platform_device *pdev)
 	chip->mmchip.save_regs = ltq_mm_save_regs;
 
 	/* store the shadow value if one was passed by the devicetree */
-	shadow = of_get_property(pdev->dev.of_node, "lantiq,shadow", NULL);
-	if (shadow)
-		chip->shadow = be32_to_cpu(*shadow);
+	if (!of_property_read_u32(pdev->dev.of_node, "lantiq,shadow", &shadow))
+		chip->shadow = shadow;
 
 	return of_mm_gpiochip_add(pdev->dev.of_node, &chip->mmchip);
 }
-- 
2.1.4

