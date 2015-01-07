Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbbAGClz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:41:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbbAGCQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.17 10/73] mmc: omap_hsmmc: Fix UHS card with DDR50 support
Date: Tue,  6 Jan 2015 18:15:31 -0800
Message-Id: <20150107021557.840737192@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 903101a83949d6fc77c092cef07e9c1e10c07e46 upstream.

The commit, mmc: omap: clarify DDR timing mode between SD-UHS and eMMC,
switched omap_hsmmc to support MMC DDR mode instead of UHS DDR50 mode.

Add UHS DDR50 mode again and this time let's also keep the MMC DDR mode.

Fixes: 5438ad95a57c (mmc: omap: clarify DDR timing mode between SD-UHS and eMMC)
Reported-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/omap_hsmmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -609,6 +609,7 @@ static void omap_hsmmc_set_clock(struct
 	 */
 	if ((mmc_slot(host).features & HSMMC_HAS_HSPE_SUPPORT) &&
 	    (ios->timing != MMC_TIMING_MMC_DDR52) &&
+	    (ios->timing != MMC_TIMING_UHS_DDR50) &&
 	    ((OMAP_HSMMC_READ(host->base, CAPA) & HSS) == HSS)) {
 		regval = OMAP_HSMMC_READ(host->base, HCTL);
 		if (clkdiv && (clk_get_rate(host->fclk)/clkdiv) > 25000000)
@@ -628,7 +629,8 @@ static void omap_hsmmc_set_bus_width(str
 	u32 con;
 
 	con = OMAP_HSMMC_READ(host->base, CON);
-	if (ios->timing == MMC_TIMING_MMC_DDR52)
+	if (ios->timing == MMC_TIMING_MMC_DDR52 ||
+	    ios->timing == MMC_TIMING_UHS_DDR50)
 		con |= DDR;	/* configure in DDR mode */
 	else
 		con &= ~DDR;


