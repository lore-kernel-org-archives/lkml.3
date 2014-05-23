Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaEWKpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:45:23 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:33677 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaEWKcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:18 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 33/71] clocksource: sh_tmu: Rename clock to "fck" in the non-legacy case
Date: Fri, 23 May 2014 12:31:13 +0200
Message-Id: <1400841111-6683-33-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The sh_tmu driver gets the TMU functional clock using a connection ID of
"tmu_fck". While all SH SoCs create clock lookup entries with a NULL
device ID and a "tmu_fck" connection ID, the ARM SoCs use the device ID
only with a NULL connection ID. This works on legacy platforms but will
break on ARM with DT boot.

Fix the situation by using a connection ID of "fck" in the non-legacy
platform data case. Clock lookup entries will be renamed to use the
device ID as well as the connection ID as platforms get moved to new
platform data. The legacy code will eventually be dropped, leaving us
with device ID based clock lookup, compatible with DT boot.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_tmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 0306d31..cf07797 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -568,7 +568,8 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	tmu->model = id->driver_data;
 
 	/* Get hold of clock. */
-	tmu->clk = clk_get(&tmu->pdev->dev, "tmu_fck");
+	tmu->clk = clk_get(&tmu->pdev->dev,
+			   tmu->model == SH_TMU_LEGACY ? "tmu_fck" : "fck");
 	if (IS_ERR(tmu->clk)) {
 		dev_err(&tmu->pdev->dev, "cannot get clock\n");
 		return PTR_ERR(tmu->clk);
-- 
1.7.9.5

