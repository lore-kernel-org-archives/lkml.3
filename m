Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaGBMEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:04:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35063 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaGBMEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:04:06 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/6] omap: phy: dra7-evm PHY fixes for 3.16
Date: Wed, 2 Jul 2014 15:03:52 +0300
Message-ID: <1404302638-3003-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On DRA7-evm, the VDDA_1V8_PHY supply must be always-on for proper functioning
of the PHYs on the SoC.

The 3.3V USB supply (ldousb_reg) can be turned OFF when the High Speed USB PHYs
are not in use. We add regulator support in the PHY framework core to manage
the PHY's regulator during PHY power on/off.

Finally we add the 3.3V regulator information to the USB2 PHYs.

This series should get the USB and SATA working again on 3.16 on DRA7-evm.

cheers,
-roger

---
Roger Quadros (6):
  ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always on
  phy: core: Fix error path in phy_create()
  phy: core: Support regulator supply for PHY power
  phy: core: Add phy-supply to DT binding documentation
  phy: omap-usb2: Balance pm_runtime_enable() on probe failure
  ARM: dts: dra7-evm: Add regulator information to USB2 PHYs

 .../devicetree/bindings/phy/phy-bindings.txt       |  4 +++
 arch/arm/boot/dts/dra7-evm.dts                     |  9 +++++
 drivers/phy/phy-core.c                             | 39 ++++++++++++++++++++--
 drivers/phy/phy-omap-usb2.c                        |  8 +++--
 include/linux/phy/phy.h                            |  2 ++
 5 files changed, 57 insertions(+), 5 deletions(-)

-- 
1.8.3.2

