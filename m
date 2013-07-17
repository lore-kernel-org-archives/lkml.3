Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3GQLVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:21:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50422 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3GQLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:21:05 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Wed, 17 Jul 2013 12:20:36 +0100
Message-Id: <1374060037-18527-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] mfd: wm8994: Remove duplicate check for active JACKDET
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
index 781115e..e8ecb8e 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -245,20 +245,6 @@ static int wm8994_suspend(struct device *dev)
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
1.8.3.2

