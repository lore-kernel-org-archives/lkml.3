Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaHaLXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:23:18 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:38075 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbaHaLXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:23:14 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] pinctrl: at91: Add remove function in platform_driver at91_gpio_driver
Date: Sun, 31 Aug 2014 16:51:55 +0530
Message-Id: <1409484115-1974-5-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds remove function in at91_gpio_driver platform_driver so that
driver can be unloaded cleanly.

CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-at91.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 8b8772c..92641b6 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1646,6 +1646,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	if (ret)
 		goto irq_setup_err;
 
+	platform_set_drvdata(pdev, at91_chip);
 	dev_info(&pdev->dev, "at address %p\n", at91_chip->regbase);
 
 	return 0;
@@ -1663,6 +1664,17 @@ err:
 	return ret;
 }
 
+static int at91_gpio_remove(struct platform_device *pdev)
+{
+	struct at91_gpio_chip *at91_chip = platform_get_drvdata(pdev);
+
+	gpiochip_remove(&at91_chip->chip);
+	clk_disable(at91_chip->clock);
+	clk_unprepare(at91_chip->clock);
+
+	return 0;
+}
+
 static struct platform_driver at91_gpio_driver = {
 	.driver = {
 		.name = "gpio-at91",
@@ -1670,6 +1682,7 @@ static struct platform_driver at91_gpio_driver = {
 		.of_match_table = at91_gpio_of_match,
 	},
 	.probe = at91_gpio_probe,
+	.remove = at91_gpio_remove,
 };
 
 static struct platform_driver at91_pinctrl_driver = {
-- 
1.7.0.4

