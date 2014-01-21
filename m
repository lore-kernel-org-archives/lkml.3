Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaAURYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:24:15 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34829 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaAURYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:24:12 -0500
Date: Tue, 21 Jan 2014 17:24:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD pull-request for v3.14
Message-ID: <20140121172405.GF27111@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please find the following v3.14 pull-request for the MFD Subsystem.

Kind regards,
Lee

The following changes since commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc:

  Linux 3.13-rc7 (2014-01-04 15:12:14 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/mfd.git tags/mfd-3.14-1

for you to fetch changes up to 02915661dbb91b25b621ab3f387ab55311bded7f:

  mfd: wm5110: Add register patch for rev D chip (2014-01-21 08:29:02 +0000)

----------------------------------------------------------------
MFD changes due for the v3.14 merge window

New drivers
 - Samsung Maxim 14577; Micro USB, Regulator, IRQ Controller and Battery Charger
 - TI/National Semiconductor LP3943 I2C GPIO Expander and PWM Generator

Existing driver adaptions
 - Expansion of Wolfson Arizona DSP and High-Pass filter controls
 - TI TWL6040 default Regmap support and Regcache addition/bypass
 - Some nice Smatch catch fixes
 - Conversion of TI OMAP-USB and TI TWL6030 to endian neutralness
 - ChromeOS EC timing (delay) adaptions and added dependency on OF
 - Many constifications of 'struct {mfd_cell,regmap_irq,et. al}'
 - Watchdog support added for NVIDIA AS3722
 - Convert functions to static in TI AM335x
 - Realigned previously defeated functionality in TI AM335x
 - IIO ADC-TSC concurrency dead-lock/timeout resolution
 - Addition of Power Management and Clock support for Samsung core
 - DEFINE_PCI_DEVICE_TABLE macro removal from MFD Subsystem
 - Greater use of irqdomain functionality in ST-E AB8500
 - Removal of 'include/linux/mfd/abx500/ab8500-gpio.h'
 - Wolfson WM831x PMIC Power Management changes s/poweroff/shutdown/
 - Device Tree documentation added for TI/Nat Semi LP3943
 - Version detection and voltage tables for TI TPS6586x PMIC devices
 - Simplification of Freescale MC13XXX (de-)initialisation routines
 - Clean-up and simplification of the Realtek parent driver
 - Added support for RTL8402 Realtek PCI-Express card reader
 - Resource leak fix for Maxim 77686
 - Possible suspend BUG() fix in OMAP USB TLL
 - Support for new Wolfson WM5110 Revision (D)
 - Testing of automatic assignment of of_node in mfd_add_device()
   - Reversion of the above when it started to cause issues
 - Remove legacy Platform Data from;
              TI TWL Core, Qualcomm SSBI and ST-E ABx500 Pinctrl
 - Clean-ups; tabbing issues, function name changes, 'drvdata = NULL' removal,
              unused uninitialised warning mitigation, error message clarity,
              removal of redundant/duplicate checks, licensing (GPL -> GPL2),
              coding consistency, duplicate function declaration, ret checks,
              commit corrections, redundant of_match_ptr() helper removal,
              spelling, #if-deffery removal and header guards name changes

----------------------------------------------------------------
Alexander Shiyan (4):
      mfd: mc13xxx: Remove redundant checks
      mfd: mc13xxx: Remove duplicate mc13xxx_get_flags() declaration
      mfd: mc13xxx: Remove useless symbol MFD_MC13783
      mfd: mc13xxx: Simplify probe() & remove()

Bibek Basu (1):
      mfd: as3722: Add watchdog support

Chanwoo Choi (1):
      mfd: max14577: Add max14577 MFD driver core

Charles Keepax (4):
      mfd: wm5110: Make DSP memories readable
      ASoC: wm5110: Expose input high pass filter controls
      mfd: wm5110: Correct default for register LDO2 Control 1
      mfd: wm5110: Add register patch for rev D chip

Dan Carpenter (2):
      mfd: ab8500-debugfs: Move dereference after check for NULL
      mfd: max14577: Cleanup an error message

Danke Xie (1):
      mfd: twl6030: Fix endianness problem in IRQ handler

Derek Basehore (1):
      mfd: cros ec: spi: Increase EC transaction delay

Geert Uytterhoeven (10):
      mfd: stmicro: Constify struct mfd_cell where possible
      mfd: dialog: Constify struct mfd_cell where possible
      mfd: wolfson: Constify struct mfd_cell where possible
      mfd: toshiba: Constify struct mfd_cell where possible
      mfd: marvell: Constify struct mfd_cell where possible
      mfd: maxim: Constify struct mfd_cell where possible
      mfd: intel: Constify struct mfd_cell where possible
      mfd: staging: Constify struct mfd_cell where possible
      mfd: Constify struct mfd_cell where possible
      mfd: ti: Constify struct mfd_cell where possible

Jingoo Han (2):
      mfd: mc13xxx: Remove unnecessary spi_set_drvdata()
      mfd: Remove DEFINE_PCI_DEVICE_TABLE macro

Julia Lawall (1):
      mfd: sta2x11-mfd: Use named constants for pci_power_t values

Krzysztof Kozlowski (5):
      mfd: sec: Add PM ops and make it a wake up source
      mfd: max14577: Match regulator by of_compatible string
      mfd: sec: Constify regmap configs and regmap irqs
      mfd: max77686: Fix regmap resource leak on driver remove
      mfd: max77693: Set proper maximum register for MUIC regmap

Laszlo Papp (2):
      mfd: max8997: Enforce mfd_add_devices() return value check
      mfd: Represent correct filenames in file headers

Lee Jones (5):
      Merge tag 'tags/ib-asoc-1' into for-mfd-next
      Merge tag 'ib-asoc-3.14.2' into for-mfd-next
      Merge tag 'ib-iio-input-3.13-1' into for-mfd-next
      mfd: rtsx: Prevent 'used uninitialised' warnings
      mfd: Revert "mfd: Always assign of_node in mfd_add_device()"

Linus Walleij (4):
      pinctrl: abx500: Delete non-devicetree probe path
      mfd: ab8500: Delete all GPIO platform data instances
      mfd/pinctrl: Delete platform data header
      mfd: ab8500: Use irqdomain to map interrupts

Manish Badarkhe (1):
      mfd: max8997: Use "IS_ENABLED(CONFIG_OF)" for DT code.

Mark Brown (1):
      mfd: wm831x: Use PM ops for shutdown

Micky Ching (2):
      mfd: rtsx: Add set pull control macro and simplify rtl8411
      mfd: rtsx: Add support for card reader rtl8402

Milo Kim (4):
      Documentation: Add LP3943 DT bindings and document
      gpio: add LP3943 I2C GPIO expander driver
      mfd: Add LP3943 MFD driver
      pwm: Add LP3943 PWM driver

Peter Ujfalusi (4):
      mfd: twl6040: reg_defaults support for regmap
      mfd: twl-core: Simplify IO wrapper functions by moving common code out
      mfd: twl-core: API to set the regcache bypass for a given regmap in twl
      mfd: twl-core: Enable regcache for audio registers

Rhyland Klein (1):
      mfd: cros ec: spi: Add delay for raising CS

Roger Quadros (1):
      mfd: omap-usb-tll: Don't hold lock during pm_runtime_get/put_sync()

Ruslan Ruslichenko (1):
      mfd: twl-core: Clean up module by removing twl603x pdata handling

Sachin Kamat (4):
      mfd: max14577: Remove redundant of_match_ptr helper
      mfd: Cleanup mfd-mcp-sa11x0.h header
      Documentation: mfd: Fix LDO index in s2mps11.txt
      gpio: lp3943: Remove redundant of_match_ptr helper

Sebastian Andrzej Siewior (5):
      iio: ti_am335x_adc: Adjust the closing bracket in tiadc_read_raw()
      mfd: ti_am335x_tscadc: Make am335x_tsc_se_update() local
      mfd: ti_am335x_tscadc: Don't read back REG_SE
      mfd: ti_am335x: Drop am335x_tsc_se_update() from resume path
      mfd: input: iio: ti_amm335x: Rework TSC/ADC synchronization

Stefan Agner (2):
      mfd: tps6586x: Add version detection
      regulator: tps6586x: Add and use correct voltage table

Stephen Boyd (3):
      mfd: ssbi: Remove platform data structs and hide ssbi type enum
      mfd: ssbi: Constify buffer in ssbi_write
      mfd: ssbi: Mark match table const

Stephen Warren (1):
      mfd: Always assign of_node in mfd_add_device()

Thierry Reding (6):
      mfd: cros ec: spi: Fix debug output
      mfd: cros ec: spi: Use consistent function names
      mfd: cros ec: i2c: Use consistent function names
      mfd: cros ec: spi: Use correct module license
      mfd: cros ec: spi: Depend on OF
      mfd: cros ec: spi: Use 0 instead of '\0' consistently

Tony Lindgren (1):
      mfd: twl-core: Fix passing of platform data in the device tree case

Tushar Behera (1):
      mfd: sec-core: Add cells for S5M8767-clocks

Victor Kamensky (2):
      mfd: omap-usb-tll: Raw read and write endian fix
      mfd: omap-usb-host: Raw read and write endian fix

Wei Yongjun (4):
      mfd: sta2x11-mfd: Fix return value check in sta2x11_mfd_platform_probe()
      mfd: sec-core: Fix sparse NULL pointer warning
      mfd: rtsx: Fix sparse non static symbol warning
      mfd: twl6040: Fix sparse non static symbol warning

 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt |  37 +++++++++
 Documentation/devicetree/bindings/mfd/cros-ec.txt      |   9 +++
 Documentation/devicetree/bindings/mfd/lp3943.txt       |  33 +++++++++
 Documentation/devicetree/bindings/mfd/s2mps11.txt      |   2 +-
 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt   |  58 +++++++++++++++
 arch/arm/boot/dts/tegra20-colibri-512.dtsi             |   4 +-
 drivers/gpio/Kconfig                                   |   8 ++
 drivers/gpio/Makefile                                  |   1 +
 drivers/gpio/gpio-lp3943.c                             | 242 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/iio/adc/ti_am335x_adc.c                        |  68 ++++++++++++-----
 drivers/input/misc/Kconfig                             |   2 +-
 drivers/input/touchscreen/Kconfig                      |   2 +-
 drivers/input/touchscreen/ti_am335x_tsc.c              |   4 +-
 drivers/mfd/88pm800.c                                  |   4 +-
 drivers/mfd/88pm805.c                                  |   2 +-
 drivers/mfd/Kconfig                                    |  30 ++++++--
 drivers/mfd/Makefile                                   |   2 +
 drivers/mfd/ab8500-core.c                              |  16 ++--
 drivers/mfd/ab8500-debugfs.c                           |   5 +-
 drivers/mfd/arizona-core.c                             |   8 +-
 drivers/mfd/as3722.c                                   |   5 +-
 drivers/mfd/asic3.c                                    |   4 +-
 drivers/mfd/cros_ec.c                                  |   2 +-
 drivers/mfd/cros_ec_i2c.c                              |   8 +-
 drivers/mfd/cros_ec_spi.c                              |  56 +++++++++++---
 drivers/mfd/cs5535-mfd.c                               |   2 +-
 drivers/mfd/da9052-core.c                              |   2 +-
 drivers/mfd/da9055-core.c                              |   2 +-
 drivers/mfd/da9063-core.c                              |   2 +-
 drivers/mfd/db8500-prcmu.c                             |   4 +-
 drivers/mfd/htc-pasic3.c                               |   2 +-
 drivers/mfd/intel_msic.c                               |   2 +-
 drivers/mfd/janz-cmodio.c                              |   2 +-
 drivers/mfd/jz4740-adc.c                               |   2 +-
 drivers/mfd/lp3943.c                                   | 167 +++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/lp8788.c                                   |   2 +-
 drivers/mfd/lpc_ich.c                                  |   2 +-
 drivers/mfd/lpc_sch.c                                  |   2 +-
 drivers/mfd/max14577.c                                 | 245 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/max77686.c                                 |   4 +-
 drivers/mfd/max77693.c                                 |  10 ++-
 drivers/mfd/max8907.c                                  |   2 +-
 drivers/mfd/max8925-core.c                             |   8 +-
 drivers/mfd/max8997.c                                  |  25 ++-----
 drivers/mfd/max8998.c                                  |   4 +-
 drivers/mfd/mc13xxx-core.c                             |  41 +++++-----
 drivers/mfd/mc13xxx-i2c.c                              |  18 +----
 drivers/mfd/mc13xxx-spi.c                              |  20 ++---
 drivers/mfd/mc13xxx.h                                  |   6 +-
 drivers/mfd/omap-usb-host.c                            |   8 +-
 drivers/mfd/omap-usb-tll.c                             |  44 ++++-------
 drivers/mfd/rc5t583.c                                  |   2 +-
 drivers/mfd/rdc321x-southbridge.c                      |   4 +-
 drivers/mfd/retu-mfd.c                                 |   6 +-
 drivers/mfd/rtl8411.c                                  | 101 +++++++++++++------------
 drivers/mfd/rtsx_pcr.c                                 |   7 +-
 drivers/mfd/rtsx_pcr.h                                 |   9 +++
 drivers/mfd/sec-core.c                                 |  62 +++++++++++++---
 drivers/mfd/sec-irq.c                                  |  12 +--
 drivers/mfd/sm501.c                                    |   2 +-
 drivers/mfd/ssbi.c                                     |  16 ++--
 drivers/mfd/sta2x11-mfd.c                              |   6 +-
 drivers/mfd/stmpe.c                                    |  10 +--
 drivers/mfd/stmpe.h                                    |   2 +-
 drivers/mfd/tc3589x.c                                  |   4 +-
 drivers/mfd/tc6387xb.c                                 |   2 +-
 drivers/mfd/ti_am335x_tscadc.c                         |  71 +++++++++++++++---
 drivers/mfd/timberdale.c                               |  14 ++--
 drivers/mfd/tps6507x.c                                 |   2 +-
 drivers/mfd/tps65090.c                                 |   2 +-
 drivers/mfd/tps65217.c                                 |   2 +-
 drivers/mfd/tps6586x.c                                 |  52 ++++++++++---
 drivers/mfd/tps65910.c                                 |   2 +-
 drivers/mfd/tps65912-core.c                            |   2 +-
 drivers/mfd/tps80031.c                                 |   2 +-
 drivers/mfd/twl-core.c                                 | 403 +++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
 drivers/mfd/twl6030-irq.c                              |   8 +-
 drivers/mfd/twl6040.c                                  |  92 ++++++++++++++++++++++-
 drivers/mfd/viperboard.c                               |   2 +-
 drivers/mfd/vx855.c                                    |   4 +-
 drivers/mfd/wm5110-tables.c                            | 105 ++++++++++++++++++++++++--
 drivers/mfd/wm831x-core.c                              |  14 ++--
 drivers/mfd/wm831x-i2c.c                               |   8 +-
 drivers/mfd/wm831x-spi.c                               |   8 +-
 drivers/mfd/wm8994-core.c                              |   4 +-
 drivers/pinctrl/pinctrl-abx500.c                       |  37 +++------
 drivers/pinctrl/pinctrl-abx500.h                       |  12 +++
 drivers/pwm/Kconfig                                    |  10 +++
 drivers/pwm/Makefile                                   |   1 +
 drivers/pwm/pwm-lp3943.c                               | 314 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig                              |   2 +-
 drivers/regulator/tps6586x-regulator.c                 |  93 ++++++++++++++++++-----
 drivers/staging/nvec/nvec.c                            |   2 +-
 include/linux/i2c/twl.h                                |   3 +
 include/linux/mfd/abx500/ab8500-gpio.h                 |  33 ---------
 include/linux/mfd/abx500/ab8500.h                      |   2 -
 include/linux/mfd/arizona/registers.h                  |  37 +++++++++
 include/linux/mfd/lp3943.h                             | 114 ++++++++++++++++++++++++++++
 include/linux/mfd/max14577-private.h                   | 330 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max14577.h                           |  69 +++++++++++++++++
 include/linux/mfd/max77686-private.h                   |   2 +-
 include/linux/mfd/max8997-private.h                    |   2 +-
 include/linux/mfd/max8998-private.h                    |   2 +-
 include/linux/mfd/mc13xxx.h                            |   2 -
 include/linux/mfd/ti_am335x_tscadc.h                   |   8 +-
 include/linux/mfd/tps6586x.h                           |   7 ++
 include/linux/platform_data/mfd-mcp-sa11x0.h           |   6 +-
 include/linux/ssbi.h                                   |  19 +----
 sound/soc/codecs/arizona.c                             |  10 +++
 sound/soc/codecs/arizona.h                             |   1 +
 sound/soc/codecs/wm5110.c                              |  19 +++++
 sound/soc/fsl/Kconfig                                  |   2 +-
 112 files changed, 2734 insertions(+), 687 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
 create mode 100644 drivers/gpio/gpio-lp3943.c
 create mode 100644 drivers/mfd/lp3943.c
 create mode 100644 drivers/mfd/max14577.c
 create mode 100644 drivers/pwm/pwm-lp3943.c
 delete mode 100644 include/linux/mfd/abx500/ab8500-gpio.h
 create mode 100644 include/linux/mfd/lp3943.h
 create mode 100644 include/linux/mfd/max14577-private.h
 create mode 100644 include/linux/mfd/max14577.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
