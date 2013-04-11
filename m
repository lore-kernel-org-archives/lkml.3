Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab3DKQjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:39:24 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:61339 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3DKQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:39:22 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: exynos: Turn SDIO interrupts on
Date: Thu, 11 Apr 2013 09:38:58 -0700
Message-Id: <1365698338-27503-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmc part in exynos supports SDIO interrupts and they work fine, so
turn the capability on.  With this I see download speeds increase
about 10x.  This is a port of a change present in the Chrome OS tree
that can be found at <https://gerrit.chromium.org/gerrit/#/c/26729/>.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc-exynos.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index c7f0976..3a227be 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -192,10 +192,10 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
 /* Common capabilities of Exynos4/Exynos5 SoC */
 static unsigned long exynos_dwmmc_caps[4] = {
 	MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
-		MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
-	MMC_CAP_CMD23,
-	MMC_CAP_CMD23,
-	MMC_CAP_CMD23,
+		MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
+	MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
+	MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
+	MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
 };
 
 static const struct dw_mci_drv_data exynos_drv_data = {
-- 
1.8.1.3

