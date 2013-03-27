Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3C0U2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:28:11 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:40826 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3C0U2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:28:10 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: inki.dae@samsung.com, dh09.lee@samsung.com, kyungmin.park@samsung.com,
        FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] video: exynos: Convert to devm_ioremap_resource()
Date: Wed, 27 Mar 2013 22:28:01 +0200
Message-Id: <1364416081-24113-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new devm_ioremap_resource() provides its own error messages.
Patch found using coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/video/exynos/exynos_mipi_dsi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index fac7df6..dd5e5e9 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -384,10 +384,9 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	dsim->reg_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!dsim->reg_base) {
-		dev_err(&pdev->dev, "failed to remap io region\n");
-		ret = -ENOMEM;
+	dsim->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dsim->reg_base)) {
+		ret = PTR_ERR(dsim->reg_base);
 		goto error;
 	}
 
-- 
1.7.9.5

