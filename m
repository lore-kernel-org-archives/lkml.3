Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaEKOnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 10:43:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65310 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaEKOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 10:43:23 -0400
Date: Sun, 11 May 2014 07:43:30 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.15-rc
Message-ID: <20140511144330.GA31447@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I know you said you'd be offline this week, but I might as well post it
for when you return. :)


Thanks!

-Olof


The following changes since commit 76e7745e8e4330fdb30f049303d524261c0b7a2c:

  Merge tag 'zynq-dt-fixes-for-3.15' of git://git.xilinx.com/linux-xlnx into fixes (2014-04-25 11:22:20 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 3b27dcec920075b6f1f5f8014e32e764fcbb96f8:

  Merge tag 'davinci-fixes-for-v3.15-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci into fixes (2014-05-10 22:06:07 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.15-rc

Seems like we've had more fixes than usual this release cycle, but
there's nothing in particular that we're doing differently. Perhaps it's
just one of those cycles where more people are finding more regressions
(and/or that the latency of when people actually test what's been in
the tree for a while is catching up so that we get the bug reports now).

The bigger changes here are are for TI and Marvell platforms:
* Timing changes for GPMC (generic localbus) on OMAP causing some largeish
  DTS deltas.
* Fixes to window allocation on PCI for mvebu touching drivers/ stuff. Patches
  have acks from subsystem maintainers where needed.
* A fix from Thomas for a botched DT conversion in drivers/edma.

There's a handful of other fixes for the above platforms as well as sunxi,
at91, i.MX. I also included a MAINTAINER update for Broadcom, and a trivial
move of a binding doc.

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: Kirkwood: T5325: Fix double probe of Codec

Arnd Bergmann (1):
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Bo Shen (1):
      ARM: at91: fix spi cs on sama5d3 Xplained board

Dave Gerlach (1):
      ARM: dts: am437x-gp-evm: Do not reset gpio5

Emilio López (1):
      ARM: sun7i: fix PLL4 clock and add PLL8

Jason Gunthorpe (1):
      bus: mvebu-mbus: Avoid setting an undefined window size

Javier Martinez Canillas (1):
      ARM: dts: omap3-igep0020: use SMSC9221 timings

Joel Fernandes (1):
      ARM: OMAP5: Switch to THUMB mode if needed on secondary CPU

Matt Porter (1):
      MAINTAINERS: update Broadcom ARM tree location and add an SoC family

Maxime Ripard (2):
      ARM: sun7i: Fix i2c4 base address
      ARM: sunxi: Enable GMAC in sunxi_defconfig

Olof Johansson (7):
      Merge tag 'omap-for-v3.15/fixes-gpmc' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'mvebu-fixes-3.15' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'mvebu-dt-fixes-3.15' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'mvebu-mbus_pci-fixes-3.15' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'mvebu-dt-fixes-3.15-2' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'sunxi-fixes-for-3.15' of https://github.com/mripard/linux into fixes
      Merge tag 'davinci-fixes-for-v3.15-rc4' of git://git.kernel.org/.../nsekhar/linux-davinci into fixes

Sascha Hauer (1):
      ARM: dts: i.MX53: Fix ipu register space size

Sebastian Hesselbarth (1):
      ARM: dts: kirkwood: fix mislocated pcie-controller nodes

Suman Anna (3):
      ARM: dts: OMAP5: Add mailbox dt node to fix boot warning
      ARM: dts: OMAP2: Fix interrupts for OMAP2420 mailbox
      ARM: dts: AM3517: Disable absent IPs inherited from OMAP3

Thomas Gleixner (1):
      ARM: common: edma: Fix xbar mapping

Thomas Petazzoni (10):
      memory: mvebu-devbus: fix the conversion of the bus width
      ARM: orion5x: fix target ID for crypto SRAM window
      bus: mvebu-mbus: allow several windows with the same target/attribute
      PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree
      ARM: mvebu: use qsgmii phy-mode for Armada XP GP interfaces
      ARM: mvebu: specify I2C bus frequency on Armada 370 DB
      ARM: mvebu: enable the SATA interface on Armada 375 DB

Tony Lindgren (3):
      ARM: dts: Fix bad OTG muxing for cm-t boards
      ARM: dts: Fix GPMC Ethernet timings for omap cm-t sbc-t boards for device tree
      ARM: dts: Fix GPMC timings for LAN9220

Tushar Behera (1):
      dt-bindings: clock: Move at91.h to dt-bindigs/clock

Willy Tarreau (1):
      PCI: mvebu: fix off-by-one in the computed size of the mbus windows

 .../devicetree/bindings/clock/at91-clock.txt       |  2 +-
 Documentation/devicetree/bindings/dma/ti-edma.txt  |  4 +-
 MAINTAINERS                                        |  5 +-
 arch/arm/boot/dts/am33xx.dtsi                      |  2 +-
 arch/arm/boot/dts/am3517.dtsi                      | 16 ++++
 arch/arm/boot/dts/am437x-gp-evm.dts                |  5 ++
 arch/arm/boot/dts/armada-370-db.dts                |  1 +
 arch/arm/boot/dts/armada-375-db.dts                |  5 ++
 arch/arm/boot/dts/armada-xp-db.dts                 |  2 +-
 arch/arm/boot/dts/armada-xp-gp.dts                 | 10 +--
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |  2 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |  4 +-
 arch/arm/boot/dts/at91sam9261.dtsi                 |  2 +-
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  2 +-
 arch/arm/boot/dts/imx53.dtsi                       |  2 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts     | 18 +++--
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi      | 18 +++--
 arch/arm/boot/dts/kirkwood-t5325.dts               |  5 --
 arch/arm/boot/dts/omap-gpmc-smsc911x.dtsi          | 19 ++---
 arch/arm/boot/dts/omap2.dtsi                       |  7 --
 arch/arm/boot/dts/omap2420.dtsi                    |  8 ++
 arch/arm/boot/dts/omap2430.dtsi                    |  7 ++
 arch/arm/boot/dts/omap3-cm-t3x30.dtsi              | 66 ++++------------
 arch/arm/boot/dts/omap3-igep.dtsi                  |  2 +-
 arch/arm/boot/dts/omap3-igep0020.dts               |  4 +-
 arch/arm/boot/dts/omap3-sb-t35.dtsi                | 37 +++------
 arch/arm/boot/dts/omap3-sbc-t3517.dts              | 13 +++
 arch/arm/boot/dts/omap3.dtsi                       |  2 +-
 arch/arm/boot/dts/omap5.dtsi                       |  7 ++
 arch/arm/boot/dts/sama5d3.dtsi                     |  2 +-
 arch/arm/boot/dts/sama5d3_mci2.dtsi                |  2 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |  2 +-
 arch/arm/boot/dts/sama5d3_uart.dtsi                |  2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   | 14 +++-
 arch/arm/common/edma.c                             | 48 ++++-------
 arch/arm/configs/sunxi_defconfig                   |  2 +-
 arch/arm/mach-omap2/omap-headsmp.S                 |  8 +-
 arch/arm/mach-orion5x/common.h                     |  2 +-
 drivers/bus/mvebu-mbus.c                           | 22 ++++--
 drivers/memory/mvebu-devbus.c                      | 15 +++-
 drivers/pci/host/pci-mvebu.c                       | 92 ++++++++++++++++++----
 include/dt-bindings/{clk => clock}/at91.h          |  0
 42 files changed, 281 insertions(+), 207 deletions(-)
 rename include/dt-bindings/{clk => clock}/at91.h (100%)
