Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaATOMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:12:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaATOMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:12:18 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <lee.jones@linaro.org>, <arnd@arndb.de>, <sre@debian.org>,
        <mark.rutland@arm.com>, <m.paolino@virtualopensystems.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v6 00/10] USB Host support for OMAP5 uEVM (for 3.14)
Date: Mon, 20 Jan 2014 16:11:21 +0200
Message-ID: <1390227091-4523-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit & Tony,

This patchset brings up USB Host ports and Ethernet port on
the OMAP5 uEVM board.

It depends on the TI Clock DT conversion patches [1] and is based
on 3.13

[1] - http://article.gmane.org/gmane.linux.ports.arm.kernel/293147

Tested on:
 - OMAP5 uEVM
 - Pandaboard ES Rev. B1
 - Beagleboard-XM Rev C2
 - Beagleboard Rev C4.

cheers,
-roger

Changelog:

v6:
- Initialized clocks to -ENODEV and split patch 3.

v5:
- Expose all clocks in the DT binding document for mfd:omap-usb-host
and mfd:omap-usb-tll

v4:
- Updated DT binding document for clock binding

v3:
- Rebased on top of 3.13-rc7

cheers,
-roger

Roger Quadros (10):
  mfd: omap-usb-host: Use resource managed clk_get()
  mfd: omap-usb-host: Get clocks based on hardware revision
  mfd: omap-usb-host: Use clock names as per function for reference
    clocks
  mfd: omap-usb-host: Update DT clock binding information
  mfd: omap-usb-tll: Update DT clock binding information
  ARM: dts: omap4: Update omap-usb-host node
  ARM: dts: omap5: Update omap-usb-host node
  ARM: dts: omap4-panda: Provide USB PHY clock
  ARM: dts: omap5-uevm: Provide USB PHY clock
  ARM: OMAP2+: Remove legacy_init_ehci_clk()

 .../devicetree/bindings/mfd/omap-usb-host.txt      |  23 +++
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |  10 ++
 arch/arm/boot/dts/omap4-panda-common.dtsi          |   8 +-
 arch/arm/boot/dts/omap4.dtsi                       |   6 +
 arch/arm/boot/dts/omap5-uevm.dts                   |   8 +-
 arch/arm/boot/dts/omap5.dtsi                       |   6 +
 arch/arm/mach-omap2/pdata-quirks.c                 |  16 --
 drivers/mfd/omap-usb-host.c                        | 171 ++++++++++-----------
 8 files changed, 128 insertions(+), 120 deletions(-)

-- 
1.8.3.2

