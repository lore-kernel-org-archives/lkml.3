Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaGVK5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46569 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbaGVK5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:15 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/28] phy: exynos-mipi-video: Use PTR_ERR_OR_ZERO
Date: Tue, 22 Jul 2014 16:26:26 +0530
Message-ID: <1406026611-30493-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@linaro.org>

PTR_ERR_OR_ZERO simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-exynos-mipi-video.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index ff02668..6d6bcf5 100644
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

