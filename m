Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3FZBY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:24:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48264 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3FZBYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:24:24 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>, Balaji TK <balajitk@ti.com>,
        Chris Ball <cjb@laptop.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] AM33xx: MMC resources from DT without HWMOD data
Date: Tue, 25 Jun 2013 20:23:28 -0500
Message-ID: <1372209808-6532-1-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel A Fernandes <agnel.joel@gmail.com>

This series is fixes to get MMC working on AM33XX without HWMOD data.
On removal of HWMOD data, interrupt and register properties need to be provided
for the driver to function correctly.

Also instead of specifying offset in match->data, I've added bindings for the
same and specify it directly from DT as this is a hardware description.

Reposting Matt's remaining 2 patches on the bindings and dts.

Joel A Fernandes (3):
  MMC: omap_hsmmc: Add reg_offset to DT bindings
  ARM: dts: am33xx: Add interrupts and memory resources for MMC
  mmc: omap_hsmmc: Add reg-offset to bindings documentation

Matt Porter (2):
  ARM: dts: add AM33XX MMC support
  mmc: omap_hsmmc: add generic DMA request support to the DT binding

 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   29 +++++++++++++-
 arch/arm/boot/dts/am335x-bone.dts                  |    7 ++++
 arch/arm/boot/dts/am335x-evm.dts                   |    7 ++++
 arch/arm/boot/dts/am335x-evmsk.dts                 |    7 ++++
 arch/arm/boot/dts/am33xx.dtsi                      |   40 ++++++++++++++++++++
 drivers/mmc/host/omap_hsmmc.c                      |    7 +++-
 6 files changed, 95 insertions(+), 2 deletions(-)

-- 
1.7.9.5

