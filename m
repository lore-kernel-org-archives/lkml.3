Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaIXJHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:07:20 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46463 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaIXJHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:17 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8O96Z4H021622, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Adrian Hunter <adrian.hunter@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>,
        Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 2/2] mmc: rtsx_pci: Set power related cap2 macros
Date: Wed, 24 Sep 2014 17:07:14 +0800
Message-ID: <1411549634-28683-3-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411549634-28683-1-git-send-email-rogerable@realtek.com>
References: <1411549634-28683-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [101.3.38.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set MMC_CAP2_NO_PRESCAN_POWERUP and MMC_CAP2_FULL_PWR_CYCLE for
rtsx_pci_sdmmc and rtsx_usb_sdmmc to reflect properties of Realtek
card reader hosts.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    1 +
 drivers/mmc/host/rtsx_usb_sdmmc.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index dfde4a210238..d49460b5ff07 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1292,6 +1292,7 @@ static void realtek_init_host(struct realtek_pci_sdmmc *host)
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED |
 		MMC_CAP_MMC_HIGHSPEED | MMC_CAP_BUS_WIDTH_TEST |
 		MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25;
+	mmc->caps2 = MMC_CAP2_NO_PRESCAN_POWERUP | MMC_CAP2_FULL_PWR_CYCLE;
 	mmc->max_current_330 = 400;
 	mmc->max_current_180 = 800;
 	mmc->ops = &realtek_pci_sdmmc_ops;
diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 5d3766e792f0..a884631d7eea 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1329,6 +1329,7 @@ static void rtsx_usb_init_host(struct rtsx_usb_sdmmc *host)
 		MMC_CAP_MMC_HIGHSPEED | MMC_CAP_BUS_WIDTH_TEST |
 		MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25 | MMC_CAP_UHS_SDR50 |
 		MMC_CAP_NEEDS_POLL;
+	mmc->caps2 = MMC_CAP2_NO_PRESCAN_POWERUP | MMC_CAP2_FULL_PWR_CYCLE;
 
 	mmc->max_current_330 = 400;
 	mmc->max_current_180 = 800;
-- 
1.7.10.4

