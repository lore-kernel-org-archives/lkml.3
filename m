Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3EBLhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:37:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39361 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3EBLhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:37:20 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: gregkh@linuxfoundation.org, grant.likely@linaro.org,
        rob.herring@calxeda.com
Cc: p.zabel@pengutronix.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] staging: imx-drm: use devm_ioremap_resource()
Date: Thu,  2 May 2013 13:41:41 +0200
Message-Id: <1367494901-2036-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/staging/imx-drm/imx-tve.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index ac16344..a6efa8f6 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -638,11 +638,9 @@ static int imx_tve_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base) {
-		dev_err(&pdev->dev, "failed to remap memory region\n");
-		return -ENOENT;
-	}
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	tve_regmap_config.lock_arg = tve;
 	tve->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "tve", base,
-- 
1.7.10.4

