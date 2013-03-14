Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3CNJ2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:28:12 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47842 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3CNJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:28:10 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: gpio: Use devm_ioremap_resource function
Date: Thu, 14 Mar 2013 11:27:29 +0200
Message-Id: <1363253249-3128-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error
handling.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/gpio/gpio-vt8500.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-vt8500.c b/drivers/gpio/gpio-vt8500.c
index 81683ca..eaed4ac 100644
--- a/drivers/gpio/gpio-vt8500.c
+++ b/drivers/gpio/gpio-vt8500.c
@@ -309,10 +309,10 @@ static int vt8500_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	gpio_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!gpio_base) {
+	gpio_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(gpio_base)) {
 		dev_err(&pdev->dev, "Unable to map GPIO registers\n");
-		return -ENOMEM;
+		return PTR_ERR(gpio_base);
 	}
 
 	ret = vt8500_add_chips(pdev, gpio_base, of_id->data);
-- 
1.7.9.5

