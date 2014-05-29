Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbaE2GdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:33:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41586 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbaE2GdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:33:14 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kishon@ti.com, sachin.kamat@linaro.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] phy: exynos-mipi-video: Use PTR_ERR_OR_ZERO
Date: Thu, 29 May 2014 12:00:48 +0530
Message-Id: <1401345049-14779-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
References: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTR_ERR_OR_ZERO simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/phy/phy-exynos-mipi-video.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index ff026689358c..6d6bcf52a10e 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -149,10 +150,8 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
 
 	phy_provider = devm_of_phy_provider_register(dev,
 					exynos_mipi_video_phy_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(phy_provider);
 }
 
 static const struct of_device_id exynos_mipi_video_phy_of_match[] = {
-- 
1.7.9.5

