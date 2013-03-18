Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3CRMfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:35:38 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19832 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3CRMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:33:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Mar 2013 05:26:01 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as platform driver
Date: Mon, 18 Mar 2013 17:59:34 +0530
Message-ID: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of this series, apart from patch containing changes to register TEGRA
USB PHY driver as platform driver, prepared below patches:
1. Re-arranging & adding new DT properties.
2. Getting various params from DT properties added.
3. code clean up.

Venu Byravarasu (7):
  ARM: tegra: finalize USB EHCI and PHY bindings
  ARM: tegra: update device trees for USB binding rework
  usb: phy: tegra: Get PHY mode using DT
  usb: phy: tegra: Return correct error value provided by clk_get_sys
  usb: phy: tegra: get ULPI reset GPIO info using DT.
  usb: phy: tegra: Add error handling & clean up.
  usb: phy: registering tegra USB PHY as platform driver

 .../bindings/usb/nvidia,tegra20-ehci.txt           |   27 +--
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   27 ++-
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |    4 +
 arch/arm/boot/dts/tegra20-harmony.dts              |    8 +-
 arch/arm/boot/dts/tegra20-iris-512.dts             |    4 +
 arch/arm/boot/dts/tegra20-paz00.dts                |    8 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |   13 +-
 arch/arm/boot/dts/tegra20-trimslice.dts            |   12 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |    7 +-
 arch/arm/boot/dts/tegra20.dtsi                     |   32 ++-
 drivers/usb/host/ehci-tegra.c                      |  100 +++----
 drivers/usb/phy/tegra_usb_phy.c                    |  301 ++++++++++++--------
 include/linux/usb/tegra_usb_phy.h                  |    5 +-
 13 files changed, 322 insertions(+), 226 deletions(-)

