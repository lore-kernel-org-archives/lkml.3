Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3I2ULu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:11:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54945 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342Ab3I2ULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:11:48 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: linus.walleij@linaro.org
Cc: broonie@kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] gpio: arizona: Use the of_node from the Arizona device
Date: Sun, 29 Sep 2013 21:00:37 +0100
Message-Id: <1380484837-27668-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use the of_node from the main Arizona device as that
holds our configuration.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-arizona.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-arizona.c b/drivers/gpio/gpio-arizona.c
index a2bec3c..dceb5dc 100644
--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -109,6 +109,9 @@ static int arizona_gpio_probe(struct platform_device *pdev)
 	arizona_gpio->arizona = arizona;
 	arizona_gpio->gpio_chip = template_chip;
 	arizona_gpio->gpio_chip.dev = &pdev->dev;
+#ifdef CONFIG_OF_GPIO
+	arizona_gpio->gpio_chip.of_node = arizona->dev->of_node;
+#endif
 
 	switch (arizona->type) {
 	case WM5102:
-- 
1.7.2.5

