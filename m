Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3L3QLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:11:06 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:33675 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3L3QJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:58 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/17] ARM: imx: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:29 +0100
Message-Id: <1388419771-30075-15-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-imx/mach-pca100.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index c5f9567..a3ab282 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -245,8 +245,7 @@ static int pca100_sdhc2_init(struct device *dev, irq_handler_t detect_irq,
 	int ret;
 
 	ret = request_irq(gpio_to_irq(IMX_GPIO_NR(3, 29)), detect_irq,
-			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
-			  "imx-mmc-detect", data);
+			  IRQF_TRIGGER_FALLING, "imx-mmc-detect", data);
 	if (ret)
 		printk(KERN_ERR
 			"pca100: Failed to reuest irq for sd/mmc detection\n");
-- 
1.7.9.5

