Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaEAS5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:57:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54374 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaEAS5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:57:12 -0400
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Thu,  1 May 2014 11:56:47 -0700
Message-Id: <1398970607-25623-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.9.2
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: tps65090: Check for pdata before dereferencing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The per-regulator pdata is optional so we need to check that it's there
before dereferencing it. This wasn't done in "regulator: tps65090: Allow
setting the overcurrent wait time", fix that.

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/tps65090-regulator.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index ca04e9f..fbe0bf5 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -306,8 +306,11 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 		ri = &pmic[num];
 		ri->dev = &pdev->dev;
 		ri->desc = &tps65090_regulator_desc[num];
-		ri->overcurrent_wait_valid = tps_pdata->overcurrent_wait_valid;
-		ri->overcurrent_wait = tps_pdata->overcurrent_wait;
+		if (tps_pdata) {
+			ri->overcurrent_wait_valid =
+				tps_pdata->overcurrent_wait_valid;
+			ri->overcurrent_wait = tps_pdata->overcurrent_wait;
+		}
 
 		/*
 		 * TPS5090 DCDC support the control from external digital input.
-- 
1.9.2

