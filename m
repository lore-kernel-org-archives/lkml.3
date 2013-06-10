Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3FJLul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:41 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40446 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3FJLui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:38 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 11/15] regulator: ti-abb: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:09 +0530
Message-Id: <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>
---
 drivers/regulator/ti-abb-regulator.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 870d209..f494a11 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -722,10 +722,10 @@ static int ti_abb_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto err;
 	}
-	abb->base = devm_request_and_ioremap(dev, res);
-	if (!abb->base) {
+	abb->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(abb->base)) {
 		dev_err(dev, "Unable to map '%s'\n", pname);
-		ret = -ENOMEM;
+		ret = PTR_ERR(abb->base);
 		goto err;
 	}
 
@@ -776,10 +776,10 @@ static int ti_abb_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto skip_opt;
 	}
-	abb->ldo_base = devm_request_and_ioremap(dev, res);
-	if (!abb->ldo_base) {
+	abb->ldo_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(abb->ldo_base)) {
 		dev_err(dev, "Unable to map '%s'\n", pname);
-		ret = -ENOMEM;
+		ret = PTR_ERR(abb->ldo_base);
 		goto err;
 	}
 
-- 
1.7.9.5

