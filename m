Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaEASvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:51:07 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:39533 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaEASvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:51:05 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, olof@lixom.net,
        Doug Anderson <dianders@chromium.org>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: tps65090: Fix tps65090 crash on Tegra Dalmore
Date: Thu,  1 May 2014 11:50:16 -0700
Message-Id: <1398970216-23519-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch (60e91b5 regulator: tps65090: Allow setting the overcurrent
wait time) introduced a crash on Tegra Dalmore.  On Dalmore the device
tree doesn't have an entry for all of the FETs so it leaves tps_pdata
NULL in some cases.  Add a check for NULL like the rest of the code
does.

Signed-off-by: Doug Anderson <dianders@chromium.org>
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
1.9.1.423.g4596e3a

