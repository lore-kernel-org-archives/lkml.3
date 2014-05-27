Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaE0RHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:07:19 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45985 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaE0RHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:07:14 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Enable Zynq peripheral drivers
Date: Tue, 27 May 2014 10:04:28 -0700
Message-Id: <1401210268-20729-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.3.1.ga73a6ad
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few drivers for Zynq peripherals made it into mainline recently.
Enable them in the defconfig. The following devices are enabled:
 - Cadence Macb Ethernet controller
 - Cadence I2C controller
 - Arasan SDHCI

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
After quite a while I gave the defonfig a shot again. At first try it
directly booted my Zynq board to a usable login prompt, and with this
patch even some peripherals work out of the box.

	Thanks,
	Sören
---
 arch/arm/configs/multi_v7_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index d4e8a47a2f7c..763054810ccf 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -121,6 +121,7 @@ CONFIG_SATA_HIGHBANK=y
 CONFIG_SATA_MV=y
 CONFIG_NETDEVICES=y
 CONFIG_SUN4I_EMAC=y
+CONFIG_MACB=y
 CONFIG_NET_CALXEDA_XGMAC=y
 CONFIG_MV643XX_ETH=y
 CONFIG_MVNETA=y
@@ -175,6 +176,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MUX=y
 CONFIG_I2C_MUX_PCA954x=y
 CONFIG_I2C_MUX_PINCTRL=y
+CONFIG_I2C_CADENCE=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_I2C_MV64XXX=y
 CONFIG_I2C_SIRF=y
@@ -272,6 +274,7 @@ CONFIG_MMC=y
 CONFIG_MMC_BLOCK_MINORS=16
 CONFIG_MMC_ARMMMCI=y
 CONFIG_MMC_SDHCI=y
+CONFIG_MMC_SDHCI_OF_ARASAN=y
 CONFIG_MMC_SDHCI_ESDHC_IMX=y
 CONFIG_MMC_SDHCI_TEGRA=y
 CONFIG_MMC_SDHCI_DOVE=y
-- 
1.9.3.1.ga73a6ad

