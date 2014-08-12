Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaHLQOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:14:37 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45853 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaHLQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:14:35 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tgih.jun@samsung.com, jh80.chung@samsung.com, chris@printf.net,
        ulf.hansson@linaro.org, jarkko.lavinen@nokia.com, balajitk@ti.com,
        baohua@kernel.org, viresh.linux@gmail.com, ian.molton@codethink.co.uk,
        maxime.ripard@free-electrons.com, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, spear-devel@list.st.com,
        linux-tegra@vger.kernel.org, michal.simek@xilinx.com,
        swarren@wwwdotorg.org
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH 0/5] MMC cleanup of dev_pm_ops and .owner
Date: Tue, 12 Aug 2014 17:14:24 +0100
Message-Id: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up a few platform drivers in how they are declaring there
dev_pm_ops structs, and gets rid of a few now redundant #else conditions.

Also it removes the .owner field of drivers which use module_platform_driver
api to register themselves, as this field gets overwritten.

Peter Griffin (5):
  mmc: remove .owner field for drivers using module_platform_driver
  mmc: dw_mmc-pci: Remove superflous #else condition on CONFIG_PM_SLEEP
  mmc: dw_mmc-pltfm: Remove superflous #else condition on
    CONFIG_PM_SLEEP
  mmc: sdhci-pci: Use SET_RUNTIME_PM_OPS macro to set runtime pm
    callbacks
  mmc: sdhci-acpi.c: Use SET_RUNTIME_PM_OPS macro to set runtime pm
    callbacks

 drivers/mmc/host/dw_mmc-pci.c      |  3 ---
 drivers/mmc/host/dw_mmc-pltfm.c    |  3 ---
 drivers/mmc/host/jz4740_mmc.c      |  1 -
 drivers/mmc/host/moxart-mmc.c      |  1 -
 drivers/mmc/host/mxcmmc.c          |  1 -
 drivers/mmc/host/mxs-mmc.c         |  1 -
 drivers/mmc/host/omap.c            |  1 -
 drivers/mmc/host/omap_hsmmc.c      |  1 -
 drivers/mmc/host/pxamci.c          |  1 -
 drivers/mmc/host/rtsx_pci_sdmmc.c  |  1 -
 drivers/mmc/host/rtsx_usb_sdmmc.c  |  1 -
 drivers/mmc/host/s3cmci.c          |  1 -
 drivers/mmc/host/sdhci-acpi.c      | 11 ++---------
 drivers/mmc/host/sdhci-bcm-kona.c  |  1 -
 drivers/mmc/host/sdhci-bcm2835.c   |  1 -
 drivers/mmc/host/sdhci-cns3xxx.c   |  1 -
 drivers/mmc/host/sdhci-dove.c      |  1 -
 drivers/mmc/host/sdhci-esdhc-imx.c |  1 -
 drivers/mmc/host/sdhci-msm.c       |  1 -
 drivers/mmc/host/sdhci-of-arasan.c |  1 -
 drivers/mmc/host/sdhci-of-esdhc.c  |  1 -
 drivers/mmc/host/sdhci-of-hlwd.c   |  1 -
 drivers/mmc/host/sdhci-pci.c       | 11 ++---------
 drivers/mmc/host/sdhci-pxav2.c     |  1 -
 drivers/mmc/host/sdhci-pxav3.c     |  1 -
 drivers/mmc/host/sdhci-s3c.c       |  1 -
 drivers/mmc/host/sdhci-sirf.c      |  1 -
 drivers/mmc/host/sdhci-spear.c     |  1 -
 drivers/mmc/host/sdhci-tegra.c     |  1 -
 drivers/mmc/host/sh_mmcif.c        |  1 -
 drivers/mmc/host/sh_mobile_sdhi.c  |  1 -
 drivers/mmc/host/sunxi-mmc.c       |  1 -
 32 files changed, 4 insertions(+), 52 deletions(-)

-- 
1.9.1

