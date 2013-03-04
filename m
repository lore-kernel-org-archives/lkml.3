Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3CDJUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:20:08 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:46980 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3CDJUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:20:07 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux@prisktech.co.nz, grant.likely@secretlab.ca, linus.walleij@linaro.org,
        sachin.kamat@linaro.org, thierry.reding@avionic-design.de
Subject: [PATCH 1/1] gpio/vt8500: Convert to devm_ioremap_resource()
Date: Mon,  4 Mar 2013 14:39:39 +0530
Message-Id: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages; so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/gpio/gpio-vt8500.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-vt8500.c b/drivers/gpio/gpio-vt8500.c
index 81683ca..b2d8d6f 100644
--- a/drivers/gpio/gpio-vt8500.c
+++ b/drivers/gpio/gpio-vt8500.c
@@ -309,11 +309,9 @@ static int vt8500_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	gpio_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!gpio_base) {
-		dev_err(&pdev->dev, "Unable to map GPIO registers\n");
-		return -ENOMEM;
-	}
+	gpio_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(gpio_base))
+		return PTR_ERR(gpio_base);
 
 	ret = vt8500_add_chips(pdev, gpio_base, of_id->data);
 
-- 
1.7.4.1

