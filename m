Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3EJOCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:02:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7052 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3EJOCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:02:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 May 2013 07:02:41 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 00/10] Tegra USB PHY driver series
Date: Fri, 10 May 2013 19:24:01 +0530
Message-ID: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delta from v2:
This patch is prepared as follow up patch of TEGRA USB PHY driver
patch series discussed at:
http://marc.info/?l=linux-tegra&m=136497946026787&w=2

Venu Byravarasu (10):
  ARM: tegra: finalize USB EHCI and PHY bindings
  arm: dt: Tegra20: Modify ULPI reset GPIO properties
  ARM: tegra: update device trees for USB binding rework
  Revert "usb: phy: tegra: don't call into tegra-ehci directly"
  usb: phy: tegra: Get PHY mode using DT
  usb: phy: tegra: Return correct error value provided by clk_get_sys
  usb: phy: tegra: get ULPI reset GPIO info using DT.
  usb: phy: tegra: Add error handling & clean up.
  usb: phy: registering Tegra USB PHY as platform driver
  Usb: Move PORTSC access to PHY

 .../bindings/usb/nvidia,tegra20-ehci.txt           |   27 +--
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   40 ++-
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |    6 +-
 arch/arm/boot/dts/tegra20-harmony.dts              |   10 +-
 arch/arm/boot/dts/tegra20-iris-512.dts             |    1 -
 arch/arm/boot/dts/tegra20-paz00.dts                |   10 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |   24 +-
 arch/arm/boot/dts/tegra20-trimslice.dts            |   23 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |   10 +-
 arch/arm/boot/dts/tegra20-whistler.dts             |   26 ++
 arch/arm/boot/dts/tegra20.dtsi                     |   46 ++-
 drivers/usb/host/ehci-tegra.c                      |  143 +++------
 drivers/usb/phy/phy-tegra-usb.c                    |  349 +++++++++++++-------
 include/linux/usb/tegra_usb_phy.h                  |    9 +-
 14 files changed, 424 insertions(+), 300 deletions(-)

