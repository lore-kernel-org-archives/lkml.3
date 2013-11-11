Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3KKFeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:34:14 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56051 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3KKFdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:33:03 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/6] ARM: driver updates for 3.13
Date: Sun, 10 Nov 2013 21:29:34 -0800
Message-Id: <1384147776-18735-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1384147776-18735-1-git-send-email-olof@lixom.net>
References: <1384147776-18735-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates of SoC-near drivers and other driver updates that makes more sense to
take through our tree. In this case it's involved:

- Some Davinci driver updates that has required corresponding platform code
changes (gpio mostly)
- CCI bindings and a few driver updates
- Marvell mvebu patches for PCI MSI support (could have gone through the PCI
tree for this release, but they were acked by Bjorn for 3.12 so we kept them
through arm-soc).
- Marvell dove switch-over to DT-based PCIe configuration
- Misc updates for Samsung platform dmaengine drivers


Conflicts:
* arch/arm/mach-dove/board-dt.c:
  Remove/remove conflicts, remove all conflicting lines.
  This should have been resolved locally in our tree but we missed to base
  this branch off of the next/cleanup branch that did one side of the
  code removals.

----------------------------------------------------------------

The following changes since commit c8f3588db3d3cc41c88d846d5dbd45473a40ff56:

  Merge branch 'next/soc' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-linus

for you to fetch changes up to 3316dee245ef297155fa45b8d14263dfd6a9164b:

  Merge tag 's3c24xx-dma' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/drivers

----------------------------------------------------------------

Gregory CLEMENT (1):
      ARM: mvebu: fix gated clock documentation

Heiko Stuebner (7):
      ARM: S3C24XX: number the dma clocks
      dmaengine: add driver for Samsung s3c24xx SoCs
      ARM: S3C24XX: add platform-devices for new dma driver for s3c2412 and s3c2443
      ARM: SAMSUNG: set s3c24xx_dma_filter for s3c64xx-spi0 device
      ARM: S3C24XX: Fix possible dma selection warning
      dmaengine: s3c24xx-dma: add support for the s3c2410 type of controller
      ARM: S3C24XX: add dma pdata for s3c2410, s3c2440 and s3c2442

Jason Gunthorpe (1):
      PCI: mvebu: Dynamically detect if the PEX link is up to enable hot plug

Jingoo Han (1):
      PCI: mvebu: make local functions static

KV Sujith (2):
      gpio: davinci: move to platform device
      ARM: davinci: da8xx: support gpio platform device

Kevin Hilman (3):
      Merge tag 'drivers-3.13' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 'arm-perf-3.13' of git://git.kernel.org/.../will/linux into next/drivers
      Merge tag 'drivers-3.13-2' of git://git.infradead.org/linux-mvebu into next/drivers

Olof Johansson (2):
      Merge tag 'davinci-for-v3.13/gpio' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers
      Merge tag 's3c24xx-dma' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers

Philip Avinash (5):
      gpio: davinci: coding style correction
      ARM: davinci: support gpio platform device
      ARM: davinci: da8xx boards: gpio device creation
      ARM: davinci: board: gpio device creation
      ARM: davinci: gpio: use gpiolib API instead of inline functions

Punit Agrawal (3):
      ARM: dts: Improve CCI bindings documentation
      ARM: dts: Document the CCI PMU DT bindings
      drivers: CCI: add ARM CCI PMU support

Sebastian Hesselbarth (7):
      PCI: mvebu: move clock enable before register access
      PCI: mvebu: increment nports only for registered ports
      PCI: mvebu: remove subsys_initcall
      PCI: mvebu: add support for reset on GPIO
      PCI: mvebu: add support for Marvell Dove SoCs
      ARM: dove: switch to DT probed mbus address windows
      ARM: dove: remove legacy pcie and clock init

Seungwon Jeon (1):
      PCI: mvebu: add I/O access wrappers

Thomas Petazzoni (3):
      irqchip: armada-370-xp: properly request resources
      irqchip: armada-370-xp: implement MSI support
      PCI: mvebu: add support for MSI

Wei Yongjun (1):
      drivers: CCI: fix the error handle in cci_pmu_probe()


 .../bindings/arm/armada-370-xp-mpic.txt         |    3 +
 Documentation/devicetree/bindings/arm/cci.txt   |   60 +-
 .../bindings/clock/mvebu-gated-clock.txt        |   14 +-
 .../devicetree/bindings/pci/mvebu-pci.txt       |   10 +
 arch/arm/Kconfig                                |    1 -
 arch/arm/mach-davinci/board-da830-evm.c         |   14 +-
 arch/arm/mach-davinci/board-da850-evm.c         |    6 +
 arch/arm/mach-davinci/board-dm355-evm.c         |   15 +-
 arch/arm/mach-davinci/board-dm355-leopard.c     |   14 +-
 arch/arm/mach-davinci/board-dm365-evm.c         |    6 +
 arch/arm/mach-davinci/board-dm644x-evm.c        |    5 +
 arch/arm/mach-davinci/board-dm646x-evm.c        |   13 +-
 arch/arm/mach-davinci/board-neuros-osd2.c       |   14 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c     |    6 +
 arch/arm/mach-davinci/da830.c                   |   16 +-
 arch/arm/mach-davinci/da850.c                   |   16 +-
 arch/arm/mach-davinci/davinci.h                 |    7 +
 arch/arm/mach-davinci/devices-da8xx.c           |   26 +
 arch/arm/mach-davinci/devices.c                 |   13 +
 arch/arm/mach-davinci/dm355.c                   |   35 +-
 arch/arm/mach-davinci/dm365.c                   |   37 +-
 arch/arm/mach-davinci/dm644x.c                  |   30 +-
 arch/arm/mach-davinci/dm646x.c                  |   30 +-
 arch/arm/mach-davinci/include/mach/da8xx.h      |    3 +
 .../mach-davinci/include/mach/gpio-davinci.h    |   91 --
 arch/arm/mach-davinci/include/mach/gpio.h       |   88 --
 arch/arm/mach-dove/board-dt.c                   |   39 +-
 arch/arm/mach-s3c24xx/Kconfig                   |    3 +-
 arch/arm/mach-s3c24xx/clock-s3c2412.c           |    8 +-
 arch/arm/mach-s3c24xx/common-s3c2443.c          |   12 +-
 arch/arm/mach-s3c24xx/common.c                  |  206 +++
 arch/arm/mach-s3c24xx/common.h                  |    5 +
 arch/arm/mach-s3c24xx/mach-jive.c               |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2413.c           |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2416.c           |    1 +
 arch/arm/mach-s3c24xx/mach-smdk2443.c           |    1 +
 arch/arm/mach-s3c24xx/mach-vstms.c              |    1 +
 arch/arm/plat-samsung/devs.c                    |    5 +-
 drivers/bus/arm-cci.c                           |  617 +++++++-
 drivers/dma/Kconfig                             |   12 +
 drivers/dma/Makefile                            |    1 +
 drivers/dma/s3c24xx-dma.c                       | 1350 ++++++++++++++++++
 drivers/gpio/gpio-davinci.c                     |  132 +-
 drivers/gpio/gpio-tnetv107x.c                   |    1 +
 drivers/irqchip/irq-armada-370-xp.c             |  202 ++-
 drivers/pci/host/Kconfig                        |    2 +-
 drivers/pci/host/pci-mvebu.c                    |  235 +--
 include/linux/platform_data/dma-s3c24xx.h       |   46 +
 include/linux/platform_data/gpio-davinci.h      |   60 +
 sound/soc/samsung/Kconfig                       |    2 +-
 50 files changed, 3082 insertions(+), 434 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/include/mach/gpio-davinci.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/gpio.h
 create mode 100644 drivers/dma/s3c24xx-dma.c
 create mode 100644 include/linux/platform_data/dma-s3c24xx.h
 create mode 100644 include/linux/platform_data/gpio-davinci.h
