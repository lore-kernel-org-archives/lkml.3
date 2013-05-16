Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3EPOV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:21:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11898 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3EPOVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:21:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 16 May 2013 07:18:08 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v4 0/8] Tegra USB PHY driver series
Date: Thu, 16 May 2013 19:42:54 +0530
Message-ID: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delta from v3:
This patch series is prepared as follow up of TEGRA USB PHY driver patch series
discussed at: https://lkml.org/lkml/2013/5/10/241

Venu Byravarasu (8):
  ARM: tegra: finalize USB EHCI and PHY bindings
  arm: dt: Tegra20: Modify ULPI reset GPIO properties
  ARM: tegra: update device trees for USB binding rework
  usb: phy: tegra: Return correct error value provided by clk_get_sys
  usb: phy: tegra: Get PHY mode using DT
  usb: phy: tegra: get ULPI reset GPIO info using DT.
  usb: phy: tegra: Add error handling & clean up.
  usb: phy: registering Tegra USB PHY as platform driver

 .../bindings/usb/nvidia,tegra20-ehci.txt           |   27 +--
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   41 +++-
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |    6 +-
 arch/arm/boot/dts/tegra20-harmony.dts              |   15 +-
 arch/arm/boot/dts/tegra20-iris-512.dts             |    9 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |   15 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |   26 ++-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |    4 +
 arch/arm/boot/dts/tegra20-trimslice.dts            |   25 ++-
 arch/arm/boot/dts/tegra20-ventana.dts              |   15 +-
 arch/arm/boot/dts/tegra20-whistler.dts             |   28 ++
 arch/arm/boot/dts/tegra20.dtsi                     |   49 +++-
 drivers/usb/host/ehci-tegra.c                      |  105 +++----
 drivers/usb/phy/phy-tegra-usb.c                    |  318 ++++++++++++--------
 include/linux/usb/tegra_usb_phy.h                  |   13 +-
 15 files changed, 451 insertions(+), 245 deletions(-)

