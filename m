Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbbALS4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:56:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbbALSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 149/216] mmc: omap_hsmmc: Fix UHS card with DDR50 support
Date: Mon, 12 Jan 2015 18:28:47 +0000
Message-Id: <1421087394-2712-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 903101a83949d6fc77c092cef07e9c1e10c07e46 upstream.

The commit, mmc: omap: clarify DDR timing mode between SD-UHS and eMMC,
switched omap_hsmmc to support MMC DDR mode instead of UHS DDR50 mode.

Add UHS DDR50 mode again and this time let's also keep the MMC DDR mode.

Fixes: 5438ad95a57c (mmc: omap: clarify DDR timing mode between SD-UHS and eMMC)
Reported-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/omap_hsmmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 6b7b75585926..6c70a01b5c15 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -583,6 +583,7 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
 	 */
 	if ((mmc_slot(host).features & HSMMC_HAS_HSPE_SUPPORT) &&
 	    (ios->timing != MMC_TIMING_MMC_DDR52) &&
+	    (ios->timing != MMC_TIMING_UHS_DDR50) &&
 	    ((OMAP_HSMMC_READ(host->base, CAPA) & HSS) == HSS)) {
 		regval = OMAP_HSMMC_READ(host->base, HCTL);
 		if (clkdiv && (clk_get_rate(host->fclk)/clkdiv) > 25000000)
@@ -602,7 +603,8 @@ static void omap_hsmmc_set_bus_width(struct omap_hsmmc_host *host)
 	u32 con;
 
 	con = OMAP_HSMMC_READ(host->base, CON);
-	if (ios->timing == MMC_TIMING_MMC_DDR52)
+	if (ios->timing == MMC_TIMING_MMC_DDR52 ||
+	    ios->timing == MMC_TIMING_UHS_DDR50)
 		con |= DDR;	/* configure in DDR mode */
 	else
 		con &= ~DDR;
-- 
2.1.4

