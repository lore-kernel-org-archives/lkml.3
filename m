Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3FRE3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:29:55 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62853 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3FRE3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:29:54 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, sachin.kamat@linaro.org, patches@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH V2 11/15] regulator: ti-abb: Convert to use devm_ioremap_resource
Date: Tue, 18 Jun 2013 09:45:07 +0530
Message-Id: <1371528907-14425-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

While at it, remove the error message as devm_ioremap_resource prints a similar
error message.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>
---
Changes for V2:
* Removed error messages from devm_ioremap_resource exit path

 drivers/regulator/ti-abb-regulator.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 870d209..3753ed0 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -722,10 +722,9 @@ static int ti_abb_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto err;
 	}
-	abb->base = devm_request_and_ioremap(dev, res);
-	if (!abb->base) {
-		dev_err(dev, "Unable to map '%s'\n", pname);
-		ret = -ENOMEM;
+	abb->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(abb->base)) {
+		ret = PTR_ERR(abb->base);
 		goto err;
 	}
 
@@ -776,10 +775,9 @@ static int ti_abb_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto skip_opt;
 	}
-	abb->ldo_base = devm_request_and_ioremap(dev, res);
-	if (!abb->ldo_base) {
-		dev_err(dev, "Unable to map '%s'\n", pname);
-		ret = -ENOMEM;
+	abb->ldo_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(abb->ldo_base)) {
+		ret = PTR_ERR(abb->ldo_base);
 		goto err;
 	}
 
-- 
1.7.9.5

