Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaANL7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:59:32 -0500
Received: from sauhun.de ([89.238.76.85]:47850 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaANL7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:59:25 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Subject: [PATCH 7/7] drivers/gpio: don't check resource with devm_ioremap_resource
Date: Tue, 14 Jan 2014 12:58:58 +0100
Message-Id: <1389700739-3696-7-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

Should go via subsystem tree

 drivers/gpio/gpio-davinci.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 84be701..a5e1a56 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -172,11 +172,6 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "Invalid memory resource\n");
-		return -EBUSY;
-	}
-
 	gpio_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(gpio_base))
 		return PTR_ERR(gpio_base);
-- 
1.8.5.1

