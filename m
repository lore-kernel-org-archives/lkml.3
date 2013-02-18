Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3BRSGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:06:51 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:35748 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab3BRSGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:06:49 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, Chris Ball <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] mmc: dw_mmc: Add MSHC compatible for Exynos4412
Date: Tue, 19 Feb 2013 03:06:14 +0900
Message-Id: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the compatible string for MSHC controller of Exynos4412, and
share the controller specific properties with Exynos5250 since they have same
features. Its driver data name is changed to exynos_drv_data instead SoC
specific name.

Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/mmc/host/dw_mmc-exynos.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 4d50da6..38cd03c 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -199,8 +199,8 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
 	return 0;
 }
 
-/* Exynos5250 controller specific capabilities */
-static unsigned long exynos5250_dwmmc_caps[4] = {
+/* Exynos4412/Exynos5250 controller specific capabilities */
+static unsigned long exynos_dwmmc_caps[4] = {
 	MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
 		MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
 	MMC_CAP_CMD23,
@@ -208,8 +208,8 @@ static unsigned long exynos5250_dwmmc_caps[4] = {
 	MMC_CAP_CMD23,
 };
 
-static const struct dw_mci_drv_data exynos5250_drv_data = {
-	.caps			= exynos5250_dwmmc_caps,
+static const struct dw_mci_drv_data exynos_drv_data = {
+	.caps			= exynos_dwmmc_caps,
 	.init			= dw_mci_exynos_priv_init,
 	.setup_clock		= dw_mci_exynos_setup_clock,
 	.prepare_command	= dw_mci_exynos_prepare_command,
@@ -219,8 +219,10 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
 };
 
 static const struct of_device_id dw_mci_exynos_match[] = {
+	{ .compatible = "samsung,exynos4412-dw-mshc",
+			.data = &exynos_drv_data, },
 	{ .compatible = "samsung,exynos5250-dw-mshc",
-			.data = &exynos5250_drv_data, },
+			.data = &exynos_drv_data, },
 	{},
 };
 MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
-- 
1.7.10.4

