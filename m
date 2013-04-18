Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390Ab3DRK1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:27:39 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60114 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968124Ab3DRK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:27:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 4/9] crypto: ux500/cryp - Prepare clock before enabling it
Date: Thu, 18 Apr 2013 11:27:00 +0100
Message-Id: <1366280825-31136-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to prepare the ux500-cryp clock before enabling it the
platform will fail to boot. Here we insure this happens.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 8bc5fef..a56cbc4 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -670,7 +670,7 @@ static int cryp_disable_power(struct device *dev,
 	}
 	spin_unlock(&device_data->ctx_lock);
 
-	clk_disable(device_data->clk);
+	clk_disable_unprepare(device_data->clk);
 	ret = regulator_disable(device_data->pwr_regulator);
 	if (ret)
 		dev_err(dev, "[%s]: "
@@ -703,9 +703,9 @@ static int cryp_enable_power(
 			goto out;
 		}
 
-		ret = clk_enable(device_data->clk);
+		ret = clk_prepare_enable(device_data->clk);
 		if (ret) {
-			dev_err(dev, "[%s]: clk_enable() failed!",
+			dev_err(dev, "[%s]: clk_prepare_enable() failed!",
 					__func__);
 			regulator_disable(device_data->pwr_regulator);
 			goto out;
-- 
1.7.10.4

