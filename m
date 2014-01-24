Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaAXR4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:56:25 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:56934 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAXR4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:56:24 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 12:56:24 EST
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: gpio-regulator: Remove unneeded OOM error message
Date: Fri, 24 Jan 2014 15:48:18 -0200
Message-Id: <1390585698-31661-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to print an OOM message after devm_kzalloc, since there is
a generic OOM message in place.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/gpio-regulator.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index c0a1d00..bad44f3 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -239,10 +239,8 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct gpio_regulator_data),
 			       GFP_KERNEL);
-	if (drvdata == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate device data\n");
+	if (drvdata == NULL)
 		return -ENOMEM;
-	}
 
 	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
 	if (drvdata->desc.name == NULL) {
-- 
1.8.1.2

