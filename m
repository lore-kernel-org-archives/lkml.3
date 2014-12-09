Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaLIIaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:30:18 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64978 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaLIIaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:30:16 -0500
MIME-Version: 1.0
Date: Tue, 9 Dec 2014 09:30:14 +0100
Message-ID: <CACRpkdaWXC=eb+DMShaF+CCfLtmpiuf_ZHhr0H4ZwR=sRZCSFQ@mail.gmail.com>
Subject: [GIT PULL] pin control bulk changes for v3.19
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a stash of pin control changes I have collected for the
v3.19 series. Mainly new hardware support, with Intels new
embedded SoC as the especially interesting thing standing out,
fully using the subsystem.

The details are in the signed tag as usual.

There is some minor conflict in a device tree from ARM SoC,
that will appear with this or their pull request.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.19-1

for you to fetch changes up to 853b6bf044dcced57c523dbddabf8942e907be6e:

  pinctrl: at91: enhance (debugfs) at91_gpio_dbg_show (2014-12-03
12:23:10 +0100)

----------------------------------------------------------------
Pin control changes for the v3.19 series:

- Force conversion of the ux500 pin control device trees
  and parsers to use the generic pin control bindings.
- New driver and device tree bindings for the Qualcomm
  PMIC MPP pin controller and GPIO.
- Some ACPI infrastructure for pin controllers.
- New driver for the Intel CherryView/Braswell pin controller,
  the first Intel pin controller to fully take advantage of
  the pin control subsystem.
- Support the Freescale i.MX VF610 variant.
- Support the sunxi A80 variant.
- Support the Samsung Exynos 4415 and Exynos 7 variants.
- Split out Intel pin controllers to their own subdirectory.
- A large slew of rockchip pin control updates, including
  suspend/resume support.
- A large slew of Samsung Exynos pin controller updates.
- Various minor updates and fixes.

----------------------------------------------------------------
Abhilash Kesavan (3):
      pinctrl: exynos: Generalize the eint16_31 demux code
      pinctrl: exynos: Consolidate irq domain callbacks
      pinctrl: exynos: Add irq_chip instance for Exynos7 wakeup interrupts

Alexandre Belloni (1):
      pinctrl: at91: use own header

Beniamino Galvani (1):
      pinctrl: meson: add device tree bindings documentation

Bjorn Andersson (1):
      pinctrl: Device tree bindings for Qualcomm PMIC GPIO block

Chris Zhong (2):
      pinctrl: rockchip: add suspend/resume functions
      pinctrl: rockchip: save and restore gpio6_c6 pinmux in suspend/resume

Dmitry Torokhov (1):
      gpio: tz1090: Fix error handling of irq_of_parse_and_map

Doug Anderson (4):
      pinctrl: rockchip: Set wake_enabled
      pinctrl: rockchip: Don't call pinctrl_gpio_direction_output() in
pin_config_set()
      pinctrl: rockchip: Parse pin groups before calling pinctrl_register()
      pinctrl: rockchip: Protect read-modify-write with the spinlock

Felipe Balbi (1):
      pinctrl: baytrail: add missing module removal support

Ivan T. Ivanov (3):
      pinctrl: Device tree bindings for Qualcomm PMIC MPP block
      pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver
      pinctrl: Qualcomm SPMI PMIC MPP pin controller driver

James Hogan (1):
      pinctrl: tz1090-pinctrl.txt: Fix typo in binding

Linus Walleij (10):
      pinctrl: nomadik: force-convert to generic mux bindings
      pinctrl: abx500: force-convert to generic mux bindings
      pinctrl: nomadik: force-convert to generic config bindings
      pinctrl: abx500: force-convert to generic config bindings
      pinctrl: abx500: retire phandle config mechanism
      pinctrl: abx500: update device tree bindings
      pinctrl: abx500: mark pin config as generic
      pinctrl: nomadik: amend MMC/SD pins
      Merge tag 'v3.19-rockchip-pinctrl1' of
git://git.kernel.org/.../mmind/linux-rockchip into devel
      Merge tag 'for_3.19/samsung-pinctrl' of
git://git.kernel.org/.../tfiga/samsung-pinctrl into devel

Matthieu Crapet (1):
      pinctrl: at91: enhance (debugfs) at91_gpio_dbg_show

Maxime Ripard (2):
      pinctrl: sunxi: Add PN bank base pin
      pinctrl: sunxi: Add A80 pinctrl muxing options

Mika Westerberg (4):
      pinctrl: Move Intel Baytrail pinctrl driver under intel directory
      MAINTAINERS: Add entry for Intel pin controller drivers
      gpio / ACPI: Add knowledge about pin controllers to acpi_get_gpiod()
      pinctrl: Add Intel Cherryview/Braswell pin controller support

Naveen Krishna Ch (1):
      pinctrl: exynos: Add initial driver data for Exynos7

Pramod Gurav (1):
      pinctrl: st: Fix Sparse error

Soren Brinkmann (2):
      pinctrl: pinconf-generic: Add flag to print arguments
      pinctrl: pinconf-generic: Declare dt_params/conf_items const

Stefan Agner (1):
      pinctrl: imx: add gpio pinmux support for vf610

Thierry Reding (1):
      pinctrl: tegra-xusb: Don't leak configurations

Tomasz Figa (6):
      pinctrl: samsung: Make samsung_pinctrl_get_soc_data use ERR_PTR()
      pinctrl: samsung: Drop unused label field in samsung_pin_ctrl struct
      pinctrl: samsung: Constify samsung_pin_bank_type struct
      pinctrl: samsung: Constify samsung_pin_ctrl struct
      pinctrl: samsung: Separate per-bank init and runtime data
      pinctrl: exynos: Add support for Exynos4415

Uwe Kleine-König (1):
      pinctrl: mxs: warn if functions are not grouped by name

Varka Bhadram (2):
      pinctrl-tb10x: remove duplicate check on resource
      pinctrl-bcm281xx: remove duplicate check on resource

Yingjoe Chen (1):
      pinctrl: Fix path error in documentation

 .../bindings/pinctrl/img,tz1090-pinctrl.txt        |    2 +-
 .../devicetree/bindings/pinctrl/meson,pinctrl.txt  |   96 ++
 .../bindings/pinctrl/pinctrl-bindings.txt          |    2 +-
 .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt |  215 +++
 .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  |  162 +++
 .../bindings/pinctrl/samsung-pinctrl.txt           |    3 +
 .../devicetree/bindings/pinctrl/ste,abx500.txt     |  184 +--
 MAINTAINERS                                        |    8 +-
 arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi         |   64 +-
 arch/arm/boot/dts/ste-href-ab8500.dtsi             |  162 +--
 arch/arm/boot/dts/ste-href-ab8505.dtsi             |   90 +-
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi     |  230 +--
 arch/arm/boot/dts/ste-href-stuib.dtsi              |    4 +-
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi         |   12 +-
 arch/arm/boot/dts/ste-hrefprev60.dtsi              |   20 +-
 arch/arm/boot/dts/ste-hrefv60plus.dtsi             |   42 +-
 arch/arm/boot/dts/ste-nomadik-s8815.dts            |    8 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         |   32 +-
 arch/arm/boot/dts/ste-snowball.dts                 |   36 +-
 drivers/gpio/gpio-tz1090.c                         |    2 +-
 drivers/gpio/gpiolib-acpi.c                        |   62 +-
 drivers/pinctrl/Kconfig                            |   13 +-
 drivers/pinctrl/Makefile                           |    2 +-
 drivers/pinctrl/freescale/pinctrl-imx.c            |   72 +
 drivers/pinctrl/freescale/pinctrl-mxs.c            |   25 +
 drivers/pinctrl/intel/Kconfig                      |   27 +
 drivers/pinctrl/intel/Makefile                     |    4 +
 drivers/pinctrl/{ => intel}/pinctrl-baytrail.c     |    7 +-
 drivers/pinctrl/intel/pinctrl-cherryview.c         | 1519 ++++++++++++++++++++
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |   33 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c  |    4 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   18 +-
 drivers/pinctrl/pinconf-generic.c                  |   71 +-
 drivers/pinctrl/pinctrl-at91.c                     |   17 +-
 drivers/pinctrl/pinctrl-at91.h                     |   72 +
 drivers/pinctrl/pinctrl-bcm281xx.c                 |    5 -
 drivers/pinctrl/pinctrl-rockchip.c                 |  116 +-
 drivers/pinctrl/pinctrl-st.c                       |    2 +-
 drivers/pinctrl/pinctrl-tb10x.c                    |    8 +-
 drivers/pinctrl/pinctrl-tegra-xusb.c               |   19 +-
 drivers/pinctrl/qcom/Kconfig                       |   13 +
 drivers/pinctrl/qcom/Makefile                      |    2 +
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  933 ++++++++++++
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c            |  949 ++++++++++++
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  376 +++--
 drivers/pinctrl/samsung/pinctrl-exynos.h           |    3 +
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c          |   30 +-
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c          |   31 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |  131 +-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   82 +-
 drivers/pinctrl/sunxi/Kconfig                      |    4 +
 drivers/pinctrl/sunxi/Makefile                     |    1 +
 drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c          |  749 ++++++++++
 drivers/pinctrl/sunxi/pinctrl-sunxi.h              |    1 +
 include/dt-bindings/pinctrl/qcom,pmic-gpio.h       |  142 ++
 include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |   44 +
 56 files changed, 6151 insertions(+), 810 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
 create mode 100644 drivers/pinctrl/intel/Kconfig
 create mode 100644 drivers/pinctrl/intel/Makefile
 rename drivers/pinctrl/{ => intel}/pinctrl-baytrail.c (99%)
 create mode 100644 drivers/pinctrl/intel/pinctrl-cherryview.c
 create mode 100644 drivers/pinctrl/pinctrl-at91.h
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-gpio.h
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h
