Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCFRSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:18:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaCFRSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:18:41 -0500
From: Paolo Pisati <paolo.pisati@canonical.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] leds-gpio: of: introduce MODULE_DEVICE_TABLE for module autoloading
Date: Thu,  6 Mar 2014 18:18:37 +0100
Message-Id: <1394126318-19806-1-git-send-email-paolo.pisati@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable autoloading of leds-gpio module when a corresponing DT entry is present.

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 drivers/leds/leds-gpio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 78b0e27..653d501 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -224,6 +224,8 @@ static const struct of_device_id of_gpio_leds_match[] = {
 	{ .compatible = "gpio-leds", },
 	{},
 };
+
+MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
 #else /* CONFIG_OF_GPIO */
 static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 {
-- 
1.9.0

