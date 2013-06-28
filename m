Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3F1NeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:34:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34114 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3F1NeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:34:20 -0400
Message-ID: <1372426454.28529.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: 88pm800: Remove NULL test for
 regulator_unregister()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 28 Jun 2013 21:34:14 +0800
In-Reply-To: <1372426354.28529.1.camel@phoenix>
References: <1372426354.28529.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's safe to call regulator_unregister with NULL.
In additional, having NULL check in the for loop is wrong because
the for loop exits if pm800_data->regulators[i] is NULL.
So we have have some regulators remains registered.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/88pm800.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index afa3762..1fc1899 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -405,7 +405,7 @@ static int pm800_regulator_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "Failed to register %s\n",
 				info->desc.name);
 
-			while (--i >= 0 && pm800_data->regulators[i])
+			while (--i >= 0)
 				regulator_unregister(pm800_data->regulators[i]);
 
 			return ret;
@@ -420,7 +420,7 @@ static int pm800_regulator_remove(struct platform_device *pdev)
 	struct pm800_regulators *pm800_data = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; pm800_data->regulators[i] && i < PM800_ID_RG_MAX; i++)
+	for (i = 0; i < PM800_ID_RG_MAX; i++)
 		regulator_unregister(pm800_data->regulators[i]);
 
 	return 0;
-- 
1.8.1.2



