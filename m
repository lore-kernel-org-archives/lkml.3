Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbaGDRs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:48:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25458 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaGDRs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:48:57 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-23-53b6e906b0bd
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 00/19] ARM: SAMSUNG: S5PV210 platform clean-up
Date: Fri, 04 Jul 2014 19:48:00 +0200
Message-id: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xy7psL7cFG9zawmnxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CV8WNvK3PB
	5ZKK/297mBoYb4V1MXJySAiYSNzsfssKYYtJXLi3nq2LkYtDSGApo8TPr2uYQRJCAn1MEn+X
	8YLYbAJqEp8bHrGB2CICqhKf2xawdzFycDAL3GaSaBUGMYUF7CSuTg8BqWABqni58RVYNa+A
	k0TrrbdsEKvkJHq3vWGewMi9gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIaH3Zwbj4
	mNUhRgEORiUe3sYVG4KFWBPLiitzDzFKcDArifD+WbUtWIg3JbGyKrUoP76oNCe1+BAjEwen
	VAOjZs4ms/+Zhy4FzPqYqv7M5UKi7aaWtX6VYdVpfBfPOVSsmxLz/cSq++fNS3YfVzHkOFky
	e/P0ZYmTlgk1dHJvVs5PUp7/5xG3r9HhxFTFr9yse1YsOngmh7dALHKCo6emLCf7+rT9CQxp
	urML4x5PuR4Wtu/fxdJp+c4hAY4prI/f7zv5mHWPEktxRqKhFnNRcSIAQKu4uwsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This huge series is a (hopefully final) attempt to convert Samsung S5PV210
into a DT-only and multiplatform-aware platform. It consists of several
steps to gradually replace legacy code with one meeting current standards
and then finally remove unused remnants.

Patches 1-6 migrate the platform to fully use the Common Clock Framework
and get rid of legacy private clock code, of which s5pv210 was the last
user. Then patch 7 adds generic PHY driver for USB PHY on S5PV210 to allow
USB to be supported when using DT. Further three patches (8-10) add DT
support for mach-s5pv210 and necessary DT sources for currently supported
boards. Patch 11 removes board files and code directly related to them,
effectively making s5pv210 a DT-only platform. In next step, patches 12-15
prepare remaining code for multiplatform enablement, which is finally done
in patch 16. Patches 17-19 are a final clean-up, which remove a lot of
unused code left after making the last S5P platform DT-only.

Build tested patch by patch on following configs:
 - s3c2410_defconfig (with DT support enabled),
 - s3c6400_defconfig (with DT support enabled),
 - s5pv210_defconfig (with DT support enabled after patches adding it),
 - exynos_defconfig,
 - exynos_defconfig with S5PV210 enabled in multiplatform configuration.

Boot tested on s5pv210-goni board.

Note that support for smdkc110, smdkv210 and torbreck boards is provided
by moving data from existing board files to new device tree sources. No
testing was performed due to mentioned board not being available anymore.
However I believe we agreed on this approach, because apparently there
are no active users of them. See the RFC from August 2013 asking for
removal of the whole platform [1].

[1] http://www.mail-archive.com/linux-samsung-soc%40vger.kernel.org/msg21882.html

Mateusz Krawczuk (6):
  clk: samsung: Add clock driver for S5PV210 and compatible SoCs
  ARM: s5pv210: Migrate clock handling to Common Clock Framework
  phy: Add support for S5PV210 to the Exynos USB 2.0 PHY driver
  ARM: s5pv210: Add board file for boot using Device Tree
  ARM: Samsung: DT: Add Device tree for s5pv210
  ARM: Samsung: DT: Add Device tree for S5PC110/S5PV210 Boards

Tomasz Figa (13):
  cpufreq: s3c24xx: Remove some dead code
  serial: samsung: Remove support for legacy clock code
  ARM: SAMSUNG: Remove legacy clock code
  clk: samsung: Add S5PV210 Audio Subsystem clock driver
  ARM: S5PV210: Remove support for board files
  ARM: S5PV210: Untie PM support from legacy code
  ARM: s5pv210: move debug-macro.S into the common space
  ARM: s5pv210: Register cpufreq platform device
  cpufreq: s5pv210: Make the driver multiplatform aware
  ARM: s5pv210: Enable multi-platform build support
  gpio: samsung: Remove legacy support of S5PV210
  ARM: SAMSUNG: Remove remaining legacy code
  clk: samsung: s5pv210: Remove legacy board support

 .../bindings/clock/clk-s5pv210-audss.txt           |   53 +
 .../bindings/clock/samsung,s5pv210-clock.txt       |   78 ++
 .../devicetree/bindings/phy/samsung-phy.txt        |    1 +
 arch/arm/Kconfig                                   |   22 +-
 arch/arm/Kconfig.debug                             |   12 +-
 arch/arm/Makefile                                  |    4 +-
 arch/arm/boot/dts/Makefile                         |    5 +
 arch/arm/boot/dts/s5pv210-aquila.dts               |  392 ++++++
 arch/arm/boot/dts/s5pv210-goni.dts                 |  449 +++++++
 arch/arm/boot/dts/s5pv210-pinctrl.dtsi             |  839 ++++++++++++
 arch/arm/boot/dts/s5pv210-smdkc110.dts             |   78 ++
 arch/arm/boot/dts/s5pv210-smdkv210.dts             |  238 ++++
 arch/arm/boot/dts/s5pv210-torbreck.dts             |   92 ++
 arch/arm/boot/dts/s5pv210.dtsi                     |  633 +++++++++
 arch/arm/include/debug/s5pv210.S                   |   34 +
 arch/arm/mach-exynos/pm.c                          |    1 -
 arch/arm/mach-s3c24xx/common.c                     |    2 -
 arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |    1 -
 arch/arm/mach-s3c24xx/mach-h1940.c                 |    5 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |    1 -
 arch/arm/mach-s3c24xx/mach-vstms.c                 |    1 -
 arch/arm/mach-s3c24xx/s3c2410.c                    |    6 -
 arch/arm/mach-s3c24xx/s3c2412.c                    |    6 -
 arch/arm/mach-s3c24xx/s3c2442.c                    |    1 -
 arch/arm/mach-s3c24xx/s3c244x.c                    |    6 -
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    1 -
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    1 -
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    1 -
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    1 -
 arch/arm/mach-s3c64xx/mach-smartq.c                |    1 -
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    1 -
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    1 -
 arch/arm/mach-s3c64xx/s3c6400.c                    |    1 -
 arch/arm/mach-s3c64xx/s3c6410.c                    |    1 -
 arch/arm/mach-s5pv210/Kconfig                      |  197 +--
 arch/arm/mach-s5pv210/Makefile                     |   29 +-
 arch/arm/mach-s5pv210/Makefile.boot                |    2 -
 arch/arm/mach-s5pv210/clock.c                      | 1365 --------------------
 arch/arm/mach-s5pv210/common.c                     |  279 ----
 arch/arm/mach-s5pv210/common.h                     |   21 +-
 arch/arm/mach-s5pv210/dev-audio.c                  |  246 ----
 arch/arm/mach-s5pv210/dma.c                        |  130 --
 arch/arm/mach-s5pv210/include/mach/debug-macro.S   |   41 -
 arch/arm/mach-s5pv210/include/mach/dma.h           |   26 -
 arch/arm/mach-s5pv210/include/mach/gpio.h          |  140 --
 arch/arm/mach-s5pv210/include/mach/hardware.h      |   18 -
 arch/arm/mach-s5pv210/include/mach/irqs.h          |  137 --
 arch/arm/mach-s5pv210/include/mach/map.h           |  158 ---
 arch/arm/mach-s5pv210/include/mach/memory.h        |   27 -
 arch/arm/mach-s5pv210/include/mach/pm-core.h       |   46 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    2 +-
 arch/arm/mach-s5pv210/include/mach/regs-gpio.h     |   41 -
 arch/arm/mach-s5pv210/include/mach/regs-irq.h      |   18 -
 arch/arm/mach-s5pv210/mach-aquila.c                |  687 ----------
 arch/arm/mach-s5pv210/mach-goni.c                  |  916 -------------
 arch/arm/mach-s5pv210/mach-smdkc110.c              |  159 ---
 arch/arm/mach-s5pv210/mach-smdkv210.c              |  337 -----
 arch/arm/mach-s5pv210/mach-torbreck.c              |  135 --
 arch/arm/mach-s5pv210/pm.c                         |  147 ++-
 arch/arm/mach-s5pv210/s5pv210.c                    |   77 ++
 arch/arm/mach-s5pv210/setup-fb-24bpp.c             |   49 -
 arch/arm/mach-s5pv210/setup-fimc.c                 |   43 -
 arch/arm/mach-s5pv210/setup-i2c0.c                 |   28 -
 arch/arm/mach-s5pv210/setup-i2c1.c                 |   28 -
 arch/arm/mach-s5pv210/setup-i2c2.c                 |   28 -
 arch/arm/mach-s5pv210/setup-ide.c                  |   39 -
 arch/arm/mach-s5pv210/setup-keypad.c               |   24 -
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c           |  103 --
 arch/arm/mach-s5pv210/setup-spi.c                  |   34 -
 arch/arm/mach-s5pv210/setup-usb-phy.c              |   95 --
 arch/arm/mach-s5pv210/sleep.S                      |   36 +
 arch/arm/plat-samsung/Kconfig                      |  143 +-
 arch/arm/plat-samsung/Makefile                     |   15 -
 arch/arm/plat-samsung/clock-clksrc.c               |  212 ---
 arch/arm/plat-samsung/clock.c                      |  539 --------
 arch/arm/plat-samsung/cpu.c                        |    3 +-
 arch/arm/plat-samsung/devs.c                       |  330 -----
 arch/arm/plat-samsung/include/plat/camport.h       |   28 -
 arch/arm/plat-samsung/include/plat/clock-clksrc.h  |   83 --
 arch/arm/plat-samsung/include/plat/clock.h         |  152 ---
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |    3 -
 arch/arm/plat-samsung/include/plat/cpu.h           |   13 -
 arch/arm/plat-samsung/include/plat/devs.h          |   42 -
 arch/arm/plat-samsung/include/plat/fb-core.h       |   15 -
 arch/arm/plat-samsung/include/plat/fb.h            |   22 -
 arch/arm/plat-samsung/include/plat/fimc-core.h     |   51 -
 arch/arm/plat-samsung/include/plat/gpio-cfg.h      |   64 -
 arch/arm/plat-samsung/include/plat/hdmi.h          |   16 -
 arch/arm/plat-samsung/include/plat/irqs.h          |   72 --
 arch/arm/plat-samsung/include/plat/mfc.h           |   35 -
 arch/arm/plat-samsung/include/plat/pll.h           |  323 -----
 arch/arm/plat-samsung/include/plat/s5p-clock.h     |   65 -
 arch/arm/plat-samsung/include/plat/sdhci.h         |   47 -
 arch/arm/plat-samsung/include/plat/tv-core.h       |   44 -
 arch/arm/plat-samsung/init.c                       |    1 -
 arch/arm/plat-samsung/pm-gpio.c                    |    4 +-
 arch/arm/plat-samsung/s5p-clock.c                  |  294 -----
 arch/arm/plat-samsung/s5p-dev-mfc.c                |   81 +-
 arch/arm/plat-samsung/s5p-dev-uart.c               |   88 --
 arch/arm/plat-samsung/s5p-irq-eint.c               |  221 ----
 arch/arm/plat-samsung/s5p-irq-gpioint.c            |  218 ----
 arch/arm/plat-samsung/s5p-irq-pm.c                 |   92 --
 arch/arm/plat-samsung/s5p-irq.c                    |   31 -
 arch/arm/plat-samsung/s5p-pm.c                     |   40 -
 arch/arm/plat-samsung/s5p-sleep.S                  |   45 -
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-s5pv210-audss.c            |  241 ++++
 drivers/clk/samsung/clk-s5pv210.c                  |  856 ++++++++++++
 drivers/cpufreq/s3c2410-cpufreq.c                  |    2 -
 drivers/cpufreq/s3c2412-cpufreq.c                  |    3 -
 drivers/cpufreq/s3c2440-cpufreq.c                  |    3 -
 drivers/cpufreq/s3c24xx-cpufreq.c                  |    1 -
 drivers/cpufreq/s5pv210-cpufreq.c                  |  131 +-
 drivers/gpio/gpio-samsung.c                        |  240 ----
 drivers/phy/Kconfig                                |   10 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-s5pv210-usb2.c                     |  187 +++
 drivers/phy/phy-samsung-usb2.c                     |    6 +
 drivers/phy/phy-samsung-usb2.h                     |    1 +
 drivers/tty/serial/samsung.c                       |    4 -
 include/dt-bindings/clock/s5pv210-audss.h          |   34 +
 include/dt-bindings/clock/s5pv210.h                |  239 ++++
 125 files changed, 4843 insertions(+), 9409 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-s5pv210-audss.txt
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
 create mode 100644 arch/arm/boot/dts/s5pv210-aquila.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-goni.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkc110.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkv210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-torbreck.dts
 create mode 100644 arch/arm/boot/dts/s5pv210.dtsi
 create mode 100644 arch/arm/include/debug/s5pv210.S
 delete mode 100644 arch/arm/mach-s5pv210/Makefile.boot
 delete mode 100644 arch/arm/mach-s5pv210/clock.c
 delete mode 100644 arch/arm/mach-s5pv210/common.c
 delete mode 100644 arch/arm/mach-s5pv210/dev-audio.c
 delete mode 100644 arch/arm/mach-s5pv210/dma.c
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/memory.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5pv210/mach-aquila.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-goni.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-smdkc110.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-smdkv210.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-torbreck.c
 create mode 100644 arch/arm/mach-s5pv210/s5pv210.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-fb-24bpp.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-fimc.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c0.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c1.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c2.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-ide.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-keypad.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-sdhci-gpio.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-spi.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-usb-phy.c
 create mode 100644 arch/arm/mach-s5pv210/sleep.S
 delete mode 100644 arch/arm/plat-samsung/clock-clksrc.c
 delete mode 100644 arch/arm/plat-samsung/clock.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/camport.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/clock-clksrc.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/clock.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/fimc-core.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/hdmi.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/irqs.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/mfc.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/pll.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5p-clock.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/tv-core.h
 delete mode 100644 arch/arm/plat-samsung/s5p-clock.c
 delete mode 100644 arch/arm/plat-samsung/s5p-dev-uart.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-eint.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-gpioint.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq-pm.c
 delete mode 100644 arch/arm/plat-samsung/s5p-irq.c
 delete mode 100644 arch/arm/plat-samsung/s5p-pm.c
 delete mode 100644 arch/arm/plat-samsung/s5p-sleep.S
 create mode 100644 drivers/clk/samsung/clk-s5pv210-audss.c
 create mode 100644 drivers/clk/samsung/clk-s5pv210.c
 create mode 100644 drivers/phy/phy-s5pv210-usb2.c
 create mode 100644 include/dt-bindings/clock/s5pv210-audss.h
 create mode 100644 include/dt-bindings/clock/s5pv210.h

-- 
1.9.3

