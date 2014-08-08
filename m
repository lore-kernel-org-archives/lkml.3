Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbaHHQr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:47:57 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43994 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbaHHQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:49 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/7] .17 ARM: SoC driver changes for 3.17
Date: Fri,  8 Aug 2014 09:47:57 -0700
Message-Id: <1407516479-1251-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
In-Reply-To: <1407516479-1251-1-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A handful of driver-related changes. We've had a bunch of them going in through
other branches as well, so it's only a part of what we really have this release.

Larger pieces are:

* Removal of a now unused PWM driver for atmel
  - This includes AVR32 changes that have been appropriately acked.
* Performance counter support for the arm CCN interconnect
* OMAP mailbox driver cleanups and consolidation
* PCI and SATA PHY drivers for SPEAr 13xx platforms
* Redefinition (with backwards compatibility!) of PCI DT bindings for
  Tegra to better model regulators/power.

Conflicts:

arch/arm/mach-spear/spear1340.c:
        Change/remove: (A fix staticized some of the removed 
        functions). Remove the conflicting chunk, leaving just the
        dt_init, compat table and machine descriptor.

drivers/phy/Kconfig:
        Add/add. Keep both sides, sort (ST -> QCOM -> XGENE)

drivers/phy/Makefile:
        Add/add. Keep both sides, sort.

----------------------------------------------------------------

The following changes since commit 02eb2d4ca08934f1fd4a2ebe9fbe5d6f2bc7e438:

  Merge branch 'next/dt' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-3.17

for you to fetch changes up to 3e528cb7bae00ba0d73def6645d0f2fa906ee3e8:

  bus: arm-ccn: Fix error handling at event allocation

----------------------------------------------------------------

Alexandre Belloni (15):
      ARM: at91: at91sam9g45: switch to generic PWM framework
      ARM: at91: sam9m10g45ek: use generic leds_pwm driver
      ARM: at91: at91sam9263: switch to generic PWM framework
      ARM: at91: sam9263ek: use generic leds_pwm driver
      ARM: at91: at91sam9rl: switch to generic PWM framework
      ARM: at91: remove useless at91_pwm_leds()
      PWM: atmel: allow building for AVR32
      avr32/at32ap: switch to the generic PWM framework
      avr32: MRMT: use generic leds_pwm driver
      avr32: merisc: use generic leds_pwm driver
      avr32: favr-32: use generic pwm_bl driver
      avr32: update defconfig to use the generic PWM framework
      backlight: atmel-pwm-bl: remove obsolete driver
      leds: atmel-pwm: remove obsolete driver
      misc: atmel_pwm: remove obsolete driver

Arnd Bergmann (3):
      bus: ARM CCN: add PERF_EVENTS dependency
      Merge branch 'omap-for-v3.17/mailbox' into next/drivers
      Merge tag 'omap-for-v3.17/mailbox-cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers

Mohit Kumar (1):
      ARM: SPEAr13xx: Update defconfigs

Olof Johansson (3):
      Merge tag 'at91-drivers' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge branch 'spear/pcie-support-v10' of git://git.kernel.org/.../vireshk/linux into next/drivers
      Merge tag 'tegra-for-3.17-pcie-regulators' of git://git.kernel.org/.../tegra/linux into next/drivers

Pawel Moll (2):
      bus: ARM CCN PMU driver
      bus: arm-ccn: Fix error handling at event allocation

Pratyush Anand (5):
      PCI: spear: Add PCIe driver for ST Microelectronics SPEAr13xx
      phy: Add drivers for PCIe and SATA phy on SPEAr13xx
      ARM: SPEAr13xx: Fix static mapping table
      ARM: SPEAr13xx: Add bindings and dt node for misc block
      ARM: SPEAr13xx: Add pcie and miphy DT nodes

Suman Anna (7):
      mailbox/omap: use devm_* interfaces
      mailbox/omap: remove OMAP1 mailbox driver
      mailbox/omap: remove omap_mbox_type_t from mailbox ops
      mailbox/omap: simplify the fifo assignment by using macros
      mailbox/omap: consolidate OMAP mailbox driver
      mailbox/omap: remove the private mailbox structure
      mailbox/omap: add a parent structure for every IP instance

Thierry Reding (5):
      PCI: tegra: Overhaul regulator usage
      ARM: tegra: Add new PCIe regulator properties
      PCI: tegra: Implement accurate power supply scheme
      PCI: tegra: Remove deprecated power supply properties
      ARM: tegra: Remove legacy PCIe power supply properties

Viresh Kumar (2):
      PCI: spear: Fix Section mismatch compilation warning for probe()
      PCI: spear: Remove spear13xx_pcie_remove()


 Documentation/arm/CCN.txt                       |   52 +
 Documentation/devicetree/bindings/arm/ccn.txt   |   21 +
 .../devicetree/bindings/arm/spear-misc.txt      |    9 +
 .../bindings/pci/nvidia,tegra20-pcie.txt        |   30 +-
 .../devicetree/bindings/pci/spear13xx-pcie.txt  |   14 +
 .../devicetree/bindings/phy/st-spear-miphy.txt  |   15 +
 MAINTAINERS                                     |    6 +
 arch/arm/boot/dts/spear1310-evb.dts             |    4 +
 arch/arm/boot/dts/spear1310.dtsi                |   93 +-
 arch/arm/boot/dts/spear1340-evb.dts             |    4 +
 arch/arm/boot/dts/spear1340.dtsi                |   30 +-
 arch/arm/boot/dts/spear13xx.dtsi                |    9 +-
 arch/arm/boot/dts/tegra20-harmony.dts           |    8 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |    7 +-
 arch/arm/boot/dts/tegra20-trimslice.dts         |    8 +-
 arch/arm/boot/dts/tegra30-beaver.dts            |   12 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |   11 +-
 arch/arm/configs/omap1_defconfig                |    2 -
 arch/arm/configs/spear13xx_defconfig            |   16 +
 arch/arm/mach-at91/at91sam9263.c                |    1 +
 arch/arm/mach-at91/at91sam9263_devices.c        |   11 +-
 arch/arm/mach-at91/at91sam9g45.c                |    1 +
 arch/arm/mach-at91/at91sam9g45_devices.c        |   11 +-
 arch/arm/mach-at91/at91sam9rl.c                 |    1 +
 arch/arm/mach-at91/at91sam9rl_devices.c         |   11 +-
 arch/arm/mach-at91/board-sam9263ek.c            |   55 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c         |   42 +-
 arch/arm/mach-at91/board.h                      |    1 -
 arch/arm/mach-at91/leds.c                       |   37 -
 arch/arm/mach-spear/Kconfig                     |    4 +
 arch/arm/mach-spear/include/mach/spear.h        |    4 +-
 arch/arm/mach-spear/spear1340.c                 |  125 +-
 arch/arm/mach-spear/spear13xx.c                 |    2 +-
 arch/avr32/boards/atngw100/mrmt.c               |   34 +-
 arch/avr32/boards/favr-32/setup.c               |   48 +-
 arch/avr32/boards/merisc/setup.c                |   34 +-
 arch/avr32/configs/atngw100_mrmt_defconfig      |    5 +-
 arch/avr32/configs/atstk1002_defconfig          |    5 +-
 arch/avr32/configs/atstk1003_defconfig          |    5 +-
 arch/avr32/configs/atstk1004_defconfig          |    5 +-
 arch/avr32/configs/atstk1006_defconfig          |    5 +-
 arch/avr32/configs/favr-32_defconfig            |    6 +-
 arch/avr32/configs/merisc_defconfig             |    5 +-
 arch/avr32/mach-at32ap/at32ap700x.c             |    7 +-
 drivers/bus/Kconfig                             |    8 +
 drivers/bus/Makefile                            |    4 +-
 drivers/bus/arm-ccn.c                           | 1391 ++++++++++++++++++
 drivers/leds/Kconfig                            |    8 -
 drivers/leds/Makefile                           |    1 -
 drivers/leds/leds-atmel-pwm.c                   |  149 --
 drivers/mailbox/Kconfig                         |   19 +-
 drivers/mailbox/Makefile                        |    6 +-
 drivers/mailbox/mailbox-omap1.c                 |  203 ---
 drivers/mailbox/mailbox-omap2.c                 |  357 -----
 drivers/mailbox/omap-mailbox.c                  |  444 ++++--
 drivers/mailbox/omap-mbox.h                     |   67 -
 drivers/misc/Kconfig                            |   10 -
 drivers/misc/Makefile                           |    1 -
 drivers/misc/atmel_pwm.c                        |  402 -----
 drivers/pci/host/Kconfig                        |    8 +
 drivers/pci/host/Makefile                       |    1 +
 drivers/pci/host/pci-tegra.c                    |  222 ++-
 drivers/pci/host/pcie-spear13xx.c               |  393 +++++
 drivers/phy/Kconfig                             |   20 +-
 drivers/phy/Makefile                            |    4 +-
 drivers/phy/phy-spear1310-miphy.c               |  274 ++++
 drivers/phy/phy-spear1340-miphy.c               |  307 ++++
 drivers/pwm/Kconfig                             |    2 +-
 drivers/video/backlight/Kconfig                 |   11 -
 drivers/video/backlight/Makefile                |    1 -
 drivers/video/backlight/atmel-pwm-bl.c          |  223 ---
 include/linux/atmel-pwm-bl.h                    |   43 -
 include/linux/atmel_pwm.h                       |   70 -
 73 files changed, 3447 insertions(+), 2018 deletions(-)
 create mode 100644 Documentation/arm/CCN.txt
 create mode 100644 Documentation/devicetree/bindings/arm/ccn.txt
 create mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt
 create mode 100644 Documentation/devicetree/bindings/pci/spear13xx-pcie.txt
 create mode 100644 Documentation/devicetree/bindings/phy/st-spear-miphy.txt
 create mode 100644 drivers/bus/arm-ccn.c
 delete mode 100644 drivers/leds/leds-atmel-pwm.c
 delete mode 100644 drivers/mailbox/mailbox-omap1.c
 delete mode 100644 drivers/mailbox/mailbox-omap2.c
 delete mode 100644 drivers/mailbox/omap-mbox.h
 delete mode 100644 drivers/misc/atmel_pwm.c
 create mode 100644 drivers/pci/host/pcie-spear13xx.c
 create mode 100644 drivers/phy/phy-spear1310-miphy.c
 create mode 100644 drivers/phy/phy-spear1340-miphy.c
 delete mode 100644 drivers/video/backlight/atmel-pwm-bl.c
 delete mode 100644 include/linux/atmel-pwm-bl.h
 delete mode 100644 include/linux/atmel_pwm.h
