Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaLUVPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:15:44 -0500
Received: from sauhun.de ([89.238.76.85]:52879 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbaLUVP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:26 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Subject: [PATCH 07/28] gpio: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:28 +0100
Message-Id: <1419196495-9626-8-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/gpio/gpio-vf610.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 4ee4cee832ec..971c73964ef1 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -278,7 +278,6 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 static struct platform_driver vf610_gpio_driver = {
 	.driver		= {
 		.name	= "gpio-vf610",
-		.owner	= THIS_MODULE,
 		.of_match_table = vf610_gpio_dt_ids,
 	},
 	.probe		= vf610_gpio_probe,
-- 
2.1.3

