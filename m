Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563Ab3BTCX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:23:57 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:65202 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab3BTCX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:23:56 -0500
Message-ID: <1361327026.9733.1.camel@phoenix>
Subject: [PATCH] regulator: tps6586x: Use dev_err rather than dev_warn for
 error message
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 20 Feb 2013 10:23:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tps6586x_regulator_set_slew_rate() returns -EINVAL when having slew rate
settings for other than SM0/1, thus use dev_err rather than dev_warn.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6586x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e68382d..94a681e 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -245,7 +245,7 @@ static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev,
 		reg = TPS6586X_SM1SL;
 		break;
 	default:
-		dev_warn(&pdev->dev, "Only SM0/SM1 can set slew rate\n");
+		dev_err(&pdev->dev, "Only SM0/SM1 can set slew rate\n");
 		return -EINVAL;
 	}
 
-- 
1.7.9.5



