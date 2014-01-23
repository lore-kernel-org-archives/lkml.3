Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaAWSr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:47:57 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47860 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaAWSrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:25 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 6/6] ARM: driver updates for 3.14
Date: Thu, 23 Jan 2014 10:36:28 -0800
Message-Id: <1390502188-16896-7-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1390502188-16896-1-git-send-email-olof@lixom.net>
References: <1390502188-16896-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates of SoC-near drivers and other driver updates that makes more sense to
take through our tree.

The largest part of this is a conversion of device registration for some
renesas shmobile/sh devices over to use resources. This has required
coordination with the corresponding arch/sh changes, and we've agreed
to merge the arch/sh changes through our tree.

Added in this branch is support for Trusted Foundations secure firmware,
which is what is used on many of the commercial Nvidia Tegra products
that are in the market, including the Nvidia Shield. The code is local
to arch/arm at this time since it's uncertain whether it will be shared
with arm64 longer-term, if needed we will refactor later.

A couple of new RTC drivers used on ARM boards, merged through our tree
on request by the RTC maintainer.

... plus a bunch of smaller updates across the board, gpio conversions

----------------------------------------------------------------

The following changes since commit 3ec910bd3c138f8c3a454bc1ee5ff2d4f85ce307:

  Merge branch 'next/boards' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-linus

for you to fetch changes up to cd2f43a1f7400a74a084094502f70df2e169c6e8:

  Merge tag 'davinci-for-v3.14/watchdog' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci into next/drivers

----------------------------------------------------------------

Alexandre Courbot (7):
      ARM: add basic support for Trusted Foundations
      of: add vendor prefix for Trusted Logic Mobility
      of: add Trusted Foundations bindings documentation
      ARM: tegra: add support for Trusted Foundations
      ARM: tegra: split setting of CPU reset handler
      ARM: tegra: set CPU reset handler using firmware
      ARM: tegra: support Trusted Foundations by default

Arnaud Ebalard (1):
      rtc: Add support for Intersil ISL12057 I2C RTC chip

Bastian Hecht (1):
      serial: sh-sci: Add OF support

Carlo Caione (2):
      ARM: sun4i/sun7i: DT documentation for RTC driver
      ARM: sun4i/sun7i: RTC driver

Chander Kashyap (1):
      irqchip: exynos-combiner: remove hard-coded irq_base value

Dan Carpenter (1):
      bus: mvebu-mbus: potential forever loop in mvebu_mbus_init()

Ezequiel Garcia (1):
      bus: mvebu-mbus: Remove deprecated comment

Grygorii Strashko (4):
      gpio: davinci: get rid of DAVINCI_N_GPIO
      gpio: introduce GPIO_DAVINCI kconfig option
      gpio: davinci: use chained_irq_enter/chained_irq_exit API
      gpio: davinci: don't create irq_domain in case of unbanked irqs

Ivan Khoronzhuk (1):
      watchdog: davinci: rename platform driver to davinci-wdt

Ivan T. Ivanov (1):
      usb: phy: msm: Move mach dependent code to platform data

KV Sujith (1):
      gpio: davinci: add OF support

Kevin Hilman (2):
      Merge tag 'renesas-usb-r8a66597-hcd-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'davinci-for-v3.14/watchdog' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers

Lad, Prabhakar (3):
      gpio: davinci: use {readl|writel}_relaxed() instead of __raw_*
      gpio: davinci: convert to use irqdomain support.
      gpio: davinci: remove unused variable intc_irq_num

Laurent Pinchart (7):
      usb: r8a66597-hcd: Convert to clk_prepare/unprepare
      sh: Declare SCIF register base and IRQ as resources
      sh: sh772[34]: Set serial port sampling rate to 8 for SCIFA ports
      sh: Don't set plat_sci_port scbrr_algo_id field
      serial: sh-sci: Remove platform data scbrr_algo_id field
      serial: sh-sci: Remove platform data mapbase and irqs fields
      serial: sh-sci: Add device tree bindings documentation

Linus Walleij (4):
      irqchip: versatile FPGA: support cascaded interrupts from DT
      ARM: integrator: pass parent IRQ to the SIC
      clk: versatile: pass a name to ICST clock provider
      clk: versatile: fixup IM-PD1 clock implementation

Magnus Damm (2):
      irqchip: renesas-irqc: Use lazy disable
      irqchip: renesas-irqc: Enable mask on suspend

Nicolas Ferre (4):
      crypto: atmel-aes - add support for Device Tree
      crypto: atmel-tdes - add support for Device Tree
      crypto: atmel-sha - add support for Device Tree
      crypto: atmel-sha - add sha information to the log

Olof Johansson (16):
      Merge tag 'mvebu-drivers-3.14' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 's3c64xx-dmaengine' of git://git.kernel.org/.../broonie/misc into next/drivers
      Merge branch 'at91/dt' into next/drivers
      Merge tag 'at91-drivers' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge tag 'samsung-irq' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'tegra-for-3.14-trusted-foundations' of git://git.kernel.org/.../tegra/linux into next/drivers
      Merge tag 'sunxi-drivers-for-3.14' of https://github.com/mripard/linux into next/drivers
      Merge tag 'renesas-irqc-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge branch 'renesas/drivers-sci2' into next/drivers
      Merge tag 'renesas-sh-soc-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'renesas-sh-sci3-for-v3.14' of git://git.kernel.org/.../horms/renesas into next/drivers
      Merge tag 'mvebu-drivers-3.14-2' of git://git.infradead.org/linux-mvebu into next/drivers
      Merge tag 'davinci-for-v3.14/gpio' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers
      Merge tag 'sunxi-core-for-3.14' of https://github.com/mripard/linux into next/drivers
      Merge tag 'integrator-for-v3.14' of git://git.kernel.org/.../linusw/linux-integrator into next/drivers
      Merge branch 'qcom/drivers' into next/drivers

Sergei Shtylyov (1):
      irq-renesas-irqc: simplify irq_set_type() method

Simon Horman (1):
      Merge branch 'sh-soc' into sh-sci2-base

Stephen Boyd (2):
      mmc: msm_sdcc: Limit driver to platforms that use it
      tty: serial: Limit msm_serial_hs driver to platforms that use it

panchaxari (1):
      ARM: integrator: Default enable ARM_PATCH_PHYS_VIRT, AUTO_ZRELADDR


 .../arm/firmware/tlm,trusted-foundations.txt    |  20 +
 Documentation/devicetree/bindings/arm/tegra.txt |   5 +
 .../bindings/arm/versatile-fpga-irq.txt         |   5 +
 .../devicetree/bindings/crypto/atmel-crypto.txt |  68 +++
 .../devicetree/bindings/gpio/gpio-davinci.txt   |  41 ++
 .../devicetree/bindings/i2c/trivial-devices.txt |   1 +
 .../devicetree/bindings/rtc/sunxi-rtc.txt       |  17 +
 .../bindings/serial/renesas,sci-serial.txt      |  46 ++
 .../devicetree/bindings/vendor-prefixes.txt     |   2 +
 arch/arm/Kconfig                                |   4 +
 arch/arm/Makefile                               |   1 +
 arch/arm/boot/dts/integratorcp.dts              |   3 +
 arch/arm/configs/tegra_defconfig                |   1 +
 arch/arm/firmware/Kconfig                       |  28 +
 arch/arm/firmware/Makefile                      |   1 +
 arch/arm/firmware/trusted_foundations.c         |  81 +++
 arch/arm/include/asm/trusted_foundations.h      |  67 +++
 arch/arm/mach-davinci/da830.c                   |   3 +-
 arch/arm/mach-davinci/da850.c                   |   3 +-
 arch/arm/mach-davinci/da8xx-dt.c                |   2 +-
 arch/arm/mach-davinci/devices-da8xx.c           |   4 +-
 arch/arm/mach-davinci/devices.c                 |   2 +-
 arch/arm/mach-davinci/dm355.c                   |   3 +-
 arch/arm/mach-davinci/dm365.c                   |   3 +-
 arch/arm/mach-davinci/dm644x.c                  |   3 +-
 arch/arm/mach-davinci/dm646x.c                  |   3 +-
 arch/arm/mach-msm/board-msm7x30.c               |  35 ++
 arch/arm/mach-msm/board-qsd8x50.c               |  35 ++
 arch/arm/mach-tegra/Kconfig                     |   1 +
 arch/arm/mach-tegra/reset.c                     |  40 +-
 arch/arm/mach-tegra/tegra.c                     |   2 +
 arch/sh/kernel/cpu/sh2/setup-sh7619.c           |  30 +-
 arch/sh/kernel/cpu/sh2a/setup-mxg.c             |  10 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c          |  80 ++-
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c          |  40 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c          |  40 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7264.c          | 104 +++-
 arch/sh/kernel/cpu/sh2a/setup-sh7269.c          | 104 +++-
 arch/sh/kernel/cpu/sh3/setup-sh7705.c           |  20 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c           |  30 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c           |  20 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c           |  20 +-
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c          |  16 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c           |  20 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c           |  62 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c          |  40 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c          |  10 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c          |  30 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c          |  63 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c          |  63 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7734.c          |  72 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c          |  30 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c          |  30 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c          | 100 ++--
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c          |  22 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c          |  60 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c          |  88 +++-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c            |  48 +-
 arch/sh/kernel/cpu/sh5/setup-sh5.c              |  12 +-
 drivers/bus/mvebu-mbus.c                        |  10 +-
 drivers/clk/versatile/clk-icst.c                |   3 +-
 drivers/clk/versatile/clk-icst.h                |   1 +
 drivers/clk/versatile/clk-impd1.c               |  88 +++-
 drivers/clk/versatile/clk-integrator.c          |   2 +-
 drivers/clk/versatile/clk-realview.c            |   6 +-
 drivers/crypto/atmel-aes.c                      | 143 +++--
 drivers/crypto/atmel-sha.c                      | 103 +++-
 drivers/crypto/atmel-tdes.c                     | 143 +++--
 drivers/gpio/Kconfig                            |   7 +
 drivers/gpio/Makefile                           |   2 +-
 drivers/gpio/gpio-davinci.c                     | 185 +++++--
 drivers/irqchip/exynos-combiner.c               |  15 +-
 drivers/irqchip/irq-renesas-irqc.c              |  21 +-
 drivers/irqchip/irq-versatile-fpga.c            |  15 +-
 drivers/mmc/host/Kconfig                        |   2 +-
 drivers/rtc/Kconfig                             |  18 +
 drivers/rtc/Makefile                            |   2 +
 drivers/rtc/rtc-isl12057.c                      | 310 +++++++++++
 drivers/rtc/rtc-sunxi.c                         | 523 +++++++++++++++++++
 drivers/tty/serial/Kconfig                      |   2 +-
 drivers/tty/serial/sh-sci.c                     | 187 +++++--
 drivers/usb/host/r8a66597-hcd.c                 |   4 +-
 drivers/usb/phy/phy-msm-usb.c                   |  35 +-
 drivers/watchdog/davinci_wdt.c                  |   4 +-
 include/linux/platform_data/gpio-davinci.h      |   3 +-
 include/linux/serial_sci.h                      |  36 --
 include/linux/usb/msm_hsusb.h                   |   3 +
 87 files changed, 2914 insertions(+), 753 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tlm,trusted-foundations.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/atmel-crypto.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/sunxi-rtc.txt
 create mode 100644 Documentation/devicetree/bindings/serial/renesas,sci-serial.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h
 create mode 100644 drivers/rtc/rtc-isl12057.c
 create mode 100644 drivers/rtc/rtc-sunxi.c
