Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3BPLvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 06:51:12 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60723 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3BPLvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 06:51:10 -0500
Message-ID: <1361015443.11226.1.camel@phoenix>
Subject: [PATCH] regulator: tps6586x: Having slew rate settings for other
 than SM0/1 is not fatal
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2013 19:50:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore the setting and show "Only SM0/SM1 can set slew rate" warning is enough,
then we can return 0 instead of -EINVAL in tps6586x_regulator_set_slew_rate().

Otherwise, probe() fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6586x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e68382d..51da3f9 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -246,7 +246,7 @@ static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev,
 		break;
 	default:
 		dev_warn(&pdev->dev, "Only SM0/SM1 can set slew rate\n");
-		return -EINVAL;
+		return 0;
 	}
 
 	return tps6586x_write(parent, reg,
-- 
1.7.9.5



