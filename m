Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaG1Ldt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:33:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59186 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaG1Ldr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:33:47 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Mon, 28 Jul 2014 12:33:40 +0100
Message-Id: <1406547220-2750-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: lp872x: Don't set constraints within the regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Regulator drivers should not be specifying constraints since the valid
configurations depend on how the device is used in a given system, there
is no way to know if a configuration is safe for a given board.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/lp872x.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 2e022aabd951..954616f16c81 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -892,14 +892,6 @@ static struct lp872x_platform_data
 		pdata->regulator_data[i].id =
 				(enum lp872x_regulator_id)match[i].driver_data;
 		pdata->regulator_data[i].init_data = match[i].init_data;
-
-		/* Operation mode configuration for buck/buck1/buck2 */
-		if (strncmp(match[i].name, "buck", 4))
-			continue;
-
-		d = pdata->regulator_data[i].init_data;
-		d->constraints.valid_modes_mask |= LP872X_VALID_OPMODE;
-		d->constraints.valid_ops_mask |= REGULATOR_CHANGE_MODE;
 	}
 out:
 	return pdata;
-- 
2.0.1

