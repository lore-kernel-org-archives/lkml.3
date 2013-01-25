Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3AYN3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:29:55 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50185 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3AYN3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:29:52 -0500
Message-ID: <1359120581.12504.2.camel@phoenix>
Subject: [PATCH] regulator: tps80031: Use IS_ERR to check return value of
 regulator_register()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 21:29:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_register() does not return NULL, it returns ERR_PTR on error.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps80031-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index b15d711..9019d0e 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -728,7 +728,7 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 			}
 		}
 		rdev = regulator_register(&ri->rinfo->desc, &config);
-		if (IS_ERR_OR_NULL(rdev)) {
+		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
 				"register regulator failed %s\n",
 					ri->rinfo->desc.name);
-- 
1.7.9.5



