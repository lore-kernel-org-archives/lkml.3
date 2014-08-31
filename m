Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaHaQjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 12:39:37 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:59307 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbaHaQjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 12:39:35 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: John Crispin <blogic@openwrt.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: lantiq: Release gpiochip resources in fail case
Date: Sun, 31 Aug 2014 22:09:15 +0530
Message-Id: <1409503155-23648-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch releases gpiochip resources with of_gpiochip_remove
gpiochip_remove in failure cases.

CC: John Crispin <blogic@openwrt.org>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-xway.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index e66f4ca..d234dc2 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -802,6 +802,7 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 	ret = gpiochip_add(&xway_chip);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register gpio chip\n");
+		of_gpiochip_remove(&xway_chip);
 		return ret;
 	}
 
@@ -823,6 +824,8 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 	ret = ltq_pinctrl_register(pdev, &xway_info);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register pinctrl driver\n");
+		gpiochip_remove(&xway_chip);
+		of_gpiochip_remove(&xway_chip);
 		return ret;
 	}
 
-- 
1.7.0.4

