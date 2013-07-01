Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3GAT4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:56:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41227 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3GAT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:56:51 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Mon,  1 Jul 2013 20:56:18 +0100
Message-Id: <1372708578-9377-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm8994: Remove duplicate check for active JACKDET
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Probably the result of a mismerge or rebase failing to notice that the
hunk had already been applied.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/wm8994-core.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index ccdddf9..781115e 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -259,20 +259,6 @@ static int wm8994_suspend(struct device *dev)
 		break;
 	}
 
-	switch (wm8994->type) {
-	case WM1811:
-		ret = wm8994_reg_read(wm8994, WM8994_ANTIPOP_2);
-		if (ret < 0) {
-			dev_err(dev, "Failed to read jackdet: %d\n", ret);
-		} else if (ret & WM1811_JACKDET_MODE_MASK) {
-			dev_dbg(dev, "CODEC still active, ignoring suspend\n");
-			return 0;
-		}
-		break;
-	default:
-		break;
-	}
-
 	/* Disable LDO pulldowns while the device is suspended if we
 	 * don't know that something will be driving them. */
 	if (!wm8994->ldo_ena_always_driven)
-- 
1.8.3.1

