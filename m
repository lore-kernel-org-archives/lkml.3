Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab3DGPPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:15:31 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:60805 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832Ab3DGPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:15:30 -0400
Message-ID: <1365347724.9931.5.camel@phoenix>
Subject: [PATCH 3/4] regulator: ab8500-ext: Remove unnecessary checking for
 ab9540 and ab8540
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 07 Apr 2013 23:15:24 +0800
In-Reply-To: <1365347548.9931.1.camel@phoenix>
References: <1365347548.9931.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was added by commit 0fe17e20a6
"regulator: ab8500-ext: Add support for AB9540 regulators"
and commit bd44e2cb "regulator: ab8500: Also check for AB8505 based platforms"

The original patch[1] is to set info->desc.ops = &ab9540_ext_regulator_ops.

However, ab9540_ext_regulator_ops is identical to ab8500_ext_regulator_ops[2].
Thus we can complete remove the unnecessary checking for ab9540 and ab8540.

[1] https://lkml.org/lkml/2013/3/28/333
[2] https://lkml.org/lkml/2013/4/1/178

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500-ext.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 5e604a2..c7896af 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -389,15 +389,8 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		config.init_data = &pdata->ext_regulator[i];
 		config.driver_data = info;
 
-		if ((is_ab9540(ab8500) || is_ab8540(ab8500)) &&
-		    ((info->desc.id == AB8500_EXT_SUPPLY1) ||
-		     (info->desc.id == AB8500_EXT_SUPPLY2) ||
-		     (info->desc.id == AB8500_EXT_SUPPLY3)))
-			info->desc.ops = &ab8500_ext_regulator_ops;
-
 		/* register regulator with framework */
 		info->rdev = regulator_register(&info->desc, &config);
-
 		if (IS_ERR(info->rdev)) {
 			err = PTR_ERR(info->rdev);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
-- 
1.7.10.4



