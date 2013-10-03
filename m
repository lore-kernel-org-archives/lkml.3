Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3JCEQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:16:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63419 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3JCEQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:16:10 -0400
Date: Wed, 2 Oct 2013 21:15:41 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.12-rc
Message-ID: <20131003041541.GA2754@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 660e1c2f47f51f5b03ea7f63fa11f000e0240bda:

  Merge tag 'omap-for-v3.12/fixes-dt-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2013-09-18 14:01:39 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 6a98b2ffc7cf8a84a18d8666185c29b7e0e631e9:

  Merge tag 'fixes-3.12-2' of git://git.infradead.org/linux-mvebu into fixes (2013-10-02 20:55:05 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.12-rc

We have a fairly large batch of fixes this time around, mostly just due to
various platforms all having a fix or two more than usual.

Worth pointing out are:

- A fix for EDMA on Davinci/OMAP where channel allocation broke with
  the DT conversion. Due to some miscommunication we didn't
  understand the impact of the breakage, so we were pushing back on it
  for 3.12, but it sounds like it's actually breaking quite a few people
  out there.

- A bunch of fixes for Marvell platforms, some straggling fixes for
  merge window fallout and some fixes for a couple of the platforms
  (Netgear RN102 in particular).

- A fix for a race between multi-cluster power management and cpu hotplug
  on Versatile Express.

And a bunch of other smaller fixes that all add up.

We'll be switching over into stricter regressions-only mode from here
on out.

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: Kirkwood: Add missing DT reg property to cpu@0

Arnaud Ebalard (3):
      ARM: mvebu: fix ReadyNAS 102 Power button GPIO to make it active high
      ARM: mvebu: Add DT entry for ReadyNAS 102 to use gpio-poweroff driver
      ARM: mvebu: add missing DT Mbus ranges and relocate PCIe DT nodes for RN102

Barry Song (4):
      ARM: dts: makefile: build atlas6-evb.dtb for ARCH_ATLAS6
      ARM: dts: sirf: fix the ranges of peri-iobrg of prima2
      MAINTAINERS: ARM: SIRF: add missed drivers into maintain list
      MAINTAINERS: ARM: SIRF: use kernel.org mail box

Brian Norris (1):
      ARM: davinci: dm365 evm: fix unused variable warning

Ezequiel Garcia (2):
      ARM: mvebu: Add the reference 25 MHz fixed-clock to Armada XP
      ARM: mvebu: Add clock properties to Armada XP timer node

Guennadi Liakhovetski (1):
      ARM: shmobile: update SDHI DT compatibility string to the <unit>-<soc> format

Jason Gunthorpe (1):
      bus: mvebu-mbus: Fix optional pcie-mem/io-aperture properties

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: sam9g45: shutdown ddr1 too when rebooting

Jiri Prchal (1):
      ARM: at91: serial: fix wrong pinctrl_usart2_rts

Jisheng Zhang (2):
      ARM: mvebu: add missing of_node_put() to fix reference leak
      bus: mvebu: add missing of_node_put() to fix reference leak

Joel Fernandes (1):
      ARM: edma: Fix clearing of unused list for DT DMA resources

Joerg Roedel (1):
      ARM: mach-integrator: Add stub for pci_v3_early_init() for !CONFIG_PCI

Kuninori Morimoto (1):
      ARM: shmobile: armadillo: fixup ether pinctrl naming

Laurent Pinchart (2):
      gpio: rcar: Remove #gpio-range-cells DT property usage
      ARM: shmobile: Remove #gpio-ranges-cells DT property

Lorenzo Pieralisi (1):
      ARM: vexpress: tc2: fix hotplug/idle/kexec race on cluster power down

Michael Opdenacker (1):
      ARM: at91: remove IRQF_DISABLED

Nicolas Ferre (1):
      ARM: at91: at91sam9x5: set default mmc[01] pinctrl-names

Olof Johansson (6):
      Merge tag 'fixes-3.12' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'davinci-fixes-for-v3.12-rc2-v2' of git://git.kernel.org/.../nsekhar/linux-davinci into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'renesas-fixes4-for-v3.12' of git://git.kernel.org/.../horms/renesas into fixes
      ARM: multi_v7_defconfig: add SDHCI for i.MX
      Merge tag 'fixes-3.12-2' of git://git.infradead.org/linux-mvebu into fixes

Qipan Li (1):
      ARM: dts: sirf: fix fifosize, clks, dma channels for UART

Quentin Armitage (1):
      ARM: kirkwood: Fix address of second XOR engine

Renwei Wu (1):
      ARM: dts: sirf: fix interrupt and dma prop of VIP for prima2 and atlas6

Sekhar Nori (1):
      ARM: davinci: fix build breakage with DEBUG_LL

Sergei Shtylyov (1):
      ARM: shmobile: Lager: add Micrel KSZ8041 PHY fixup

 Documentation/devicetree/bindings/mmc/tmio_mmc.txt | 17 ++++----
 MAINTAINERS                                        |  8 +++-
 arch/arm/boot/dts/Makefile                         |  2 +
 arch/arm/boot/dts/armada-370-netgear-rn102.dts     | 49 ++++++++++++++--------
 arch/arm/boot/dts/armada-xp.dtsi                   | 11 +++++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  6 ++-
 arch/arm/boot/dts/atlas6.dtsi                      | 12 ++++++
 arch/arm/boot/dts/kirkwood.dtsi                    |  3 +-
 arch/arm/boot/dts/prima2.dtsi                      | 27 ++++++++++--
 arch/arm/boot/dts/r8a73a4.dtsi                     |  6 +--
 arch/arm/boot/dts/r8a7778.dtsi                     |  1 -
 arch/arm/boot/dts/r8a7779.dtsi                     |  1 -
 arch/arm/boot/dts/r8a7790.dtsi                     |  9 ++--
 arch/arm/boot/dts/sh73a0.dtsi                      |  6 +--
 arch/arm/common/edma.c                             | 38 +++++++++++++----
 arch/arm/configs/multi_v7_defconfig                |  1 +
 arch/arm/mach-at91/at91rm9200_time.c               |  2 +-
 arch/arm/mach-at91/at91sam926x_time.c              |  2 +-
 arch/arm/mach-at91/at91sam9g45_reset.S             |  8 ++++
 arch/arm/mach-at91/at91x40_time.c                  |  2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |  2 +-
 arch/arm/mach-davinci/include/mach/serial.h        |  4 +-
 arch/arm/mach-integrator/pci_v3.h                  |  7 ++++
 arch/arm/mach-mvebu/coherency.c                    |  8 +++-
 arch/arm/mach-mvebu/pmsu.c                         |  1 +
 arch/arm/mach-mvebu/system-controller.c            |  1 +
 arch/arm/mach-shmobile/board-armadillo800eva.c     |  4 +-
 arch/arm/mach-shmobile/board-lager.c               | 27 +++++++++++-
 arch/arm/mach-vexpress/tc2_pm.c                    | 11 ++++-
 drivers/bus/mvebu-mbus.c                           | 12 ++++--
 drivers/gpio/gpio-rcar.c                           |  7 ++--
 drivers/mmc/host/sh_mobile_sdhi.c                  | 16 +++----
 32 files changed, 233 insertions(+), 78 deletions(-)
