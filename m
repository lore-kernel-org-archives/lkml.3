Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaHLLoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:44:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50437 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbaHLLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:44:32 -0400
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] gpiolib: wm8994: Fix irq offset for gpio_to_irq
Date: Tue, 12 Aug 2014 12:44:20 +0100
Message-Id: <1407843860-4957-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier code was using the gpio offset as is to get the irq.
For wm8994 driver the gpio related irq's starts from a fixed
offset as fixed by this patch.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-wm8994.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wm8994.c b/drivers/gpio/gpio-wm8994.c
index d93b6b5..dec47c2 100644
--- a/drivers/gpio/gpio-wm8994.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -113,7 +113,8 @@ static int wm8994_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
 	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
 
-	return regmap_irq_get_virq(wm8994->irq_data, offset);
+	return regmap_irq_get_virq(wm8994->irq_data,
+			WM8994_IRQ_GPIO(offset + 1));
 }
 
 
-- 
1.7.9.5

