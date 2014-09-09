Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaIIH7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:59:16 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:47873 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826AbaIIH7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:59:13 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: John Crispin <blogic@openwrt.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v1] pinctrl: lantiq: Release gpiochip resources in fail case
Date: Tue,  9 Sep 2014 13:32:47 +0530
Message-Id: <1410249767-12415-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch releases gpiochip resources with of_gpiochip_remove
and gpiochip_remove in failure cases.

CC: John Crispin <blogic@openwrt.org>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---

Changes since v1:
 Dropped call to of_gpiochip_remove() when ltq_pinctrl_register fails as
 gpiochip_remove() calls of_gpiochip_remove()

 drivers/pinctrl/pinctrl-xway.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index e66f4ca..37040ab 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -801,6 +801,7 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 	of_gpiochip_add(&xway_chip);
 	ret = gpiochip_add(&xway_chip);
 	if (ret) {
+		of_gpiochip_remove(&xway_chip);
 		dev_err(&pdev->dev, "Failed to register gpio chip\n");
 		return ret;
 	}
@@ -822,6 +823,7 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 	/* register with the generic lantiq layer */
 	ret = ltq_pinctrl_register(pdev, &xway_info);
 	if (ret) {
+		gpiochip_remove(&xway_chip);
 		dev_err(&pdev->dev, "Failed to register pinctrl driver\n");
 		return ret;
 	}
-- 
1.7.9.5

