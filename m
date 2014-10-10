Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaJJJkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:40:55 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:55065 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbaJJJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:40:52 -0400
Date: Fri, 10 Oct 2014 10:40:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD for v3.18
Message-ID: <20141010094046.GH26795@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.18

for you to fetch changes up to d86c21fd31114e3ef9fae64be335c76aa22859dc:

  mfd: cros_ec: wait for completion of commands that return IN_PROGRESS (2014-10-06 21:30:16 +0100)

----------------------------------------------------------------
Changes to existing drivers:
  - DT clean-ups in da9055-core, max14577, rn5t618, arizona, hi6421, stmpe, twl4030
  - Export symbols for use in modules in max14577
  - Plenty of static code analysis/Coccinelle fixes throughout the SS
  - Regmap clean-ups in arizona, wm5102, wm5110, da9052, tps65217, rk808
  - Remove unused/duplicate code in da9052, 88pm860x, ti_ssp, lpc_sch, arizona
  - Bug fixes in ti_am335x_tscadc, da9052, ti_am335x_tscadc, rtsx_pcr
  - IRQ fixups in arizona, stmpe, max14577
  - Regulator related changes in axp20x
  - Pass DMA coherency information from parent => child in MFD core
  - Rename DT document files for consistency
  - Add ACPI support to the MFD core
  - Add Andreas Werner to MAINTAINERS for MEN F21BMC

New drivers/supported devices:
  - New driver for MEN 14F021P00 Board Management Controller
  - New driver for Ricoh RN5T618 PMIC
  - New driver for Rockchip RK808
  - New driver for HiSilicon Hi6421 PMIC
  - New driver for Qualcomm SPMI PMICs
  - Add support for Intel Braswell in lpc_ich
  - Add support for Intel 9 Series PCH in lpc_ich
  - Add support for Intel Quark ILB in lpc_sch

----------------------------------------------------------------
Alan Cox (1):
      mfd: lpc_ich: Add PCI ID for Intel Braswell

Andreas Werner (5):
      mfd: menf21bmc: Introduce MEN 14F021P00 BMC MFD Core driver
      watchdog: menf21bmc_wdt: Introduce MEN 14F021P00 BMC Watchdog driver
      leds: leds-menf21bmc: Introduce MEN 14F021P00 BMC LED driver
      hwmon: (menf21bmc) Introduce MEN14F021P00 BMC HWMON driver
      MAINTAINERS: Adds Andreas Werner to maintainers list for MEN F21BMC

Andrew Bresticker (3):
      mfd: cros_ec: stop calling ->cmd_xfer() directly
      mfd: cros_ec: move locking into cros_ec_cmd_xfer
      mfd: cros_ec: wait for completion of commands that return IN_PROGRESS

Andy Shevchenko (4):
      mfd: lpc_sch: Reduce duplicate code and improve manageability
      mfd: lpc_sch: Add support for Intel Quark X1000
      mfd: lpc_sch: Remove FSF address
      mfd: pcf50633: Use sprintf directly

Arnout Vandecappelle (Essensium/Mind) (1):
      mfd: tps65910: Work around silicon erratum SWCZ010

Axel Lin (2):
      mfd: da9052-i2c: Remove duplicate test for I2C_FUNC_SMBUS_BYTE_DATA functionality
      mfd: da9052: Avoid setting read_flag_mask for da9052-i2c driver

Beniamino Galvani (2):
      mfd: rn5t618: Document device tree bindings
      mfd: Add Ricoh RN5T618 PMIC core driver

Boris BREZILLON (2):
      mfd: syscon: Add Atmel GPBR DT bindings documention
      mfd: Inherit coherent_dma_mask from parent device

Charles Keepax (7):
      mfd: arizona: Mark additional registers as volatile
      mfd: arizona: Avoid use of legacy IRQ mapping
      mfd: arizona: Add ASYNC_SAMPLE_RATE_2 registers
      mfd: arizona: Propagate irq_wake through to parent IRQ
      mfd: arizona: Use handle_simple_irq for IRQ dispatch chip
      Revert "mfd: wm5102: Manually apply register patch"
      mfd: arizona: Correct mask to allow setting micbias external cap

Chris Ball (1):
      mfd: rtsx_pcr: Fix MSI enable error handling

Chris Zhong (2):
      mfd: dt-bindings: Add RK808 device tree bindings document
      mfd: RK808: Add new mfd driver for RK808

Derek Basehore (1):
      i2c: i2c-cros-ec-tunnel: Set retries to 3

Doug Anderson (2):
      mfd: rk808: Add register caching
      mfd: cros_ec: Delay for 50ms when we see EC_CMD_REBOOT_EC

Guodong Xu (2):
      mfd: dt-bindings: Add Device Tree bindings for HI6421
      mfd: Add HI6421 PMIC Core driver

Hans Wennborg (1):
      mfd: rtsx_usb: Fix decimal printf format specifiers prefixed with 0x

Himangi Saraogi (1):
      mfd: menelaus: Remove null pointer dereference

Inha Song (2):
      mfd: arizona: Add support for INn_Mode register control
      mfd: arizona: Update DT binding to support INn_MODE init_data

Jacek Anaszewski (2):
      mfd: max77693: Fix register enum name
      mfd: max77693: Improve support for the flash cell

Jaewon Kim (1):
      mfd: intel_soc_pmic: Add CONFIG_PM_SLEEP check for suspend_fn/resume_fn

James Ralston (1):
      mfd: lpc_ich: Add Device IDs for Intel 9 Series PCH

Jeff Lance (1):
      mfd: ti_am335x_tscadc: Update logic in CTRL register for 5-wire TS

Josef Ahmad (1):
      pci_ids: Add support for Intel Quark ILB

Josh Cartwright (1):
      mfd: Add support for Qualcomm SPMI PMICs

Julia Lawall (2):
      mfd: twl6040: Fix error return code
      mfd: menelaus: Fix error return code

Krzysztof Kozlowski (9):
      mfd: max14577: Add defines for MAX77836 charger
      mfd: max14577: Map charger device to its own of_node
      charger: max14577: Add support for MAX77836 charger
      regulator/mfd: max14577: Export symbols for calculating charger current
      charger: max14577: Configure battery-dependent settings from DTS and sysfs
      power: max17040: Add ID for MAX77836 Fuel Gauge block
      devicetree: mfd: max14577: Add device tree bindings document
      Documentation: charger: max14577: Document exported sysfs entry
      mfd: max14577: Don't pass IRQ domain to mfd_add_devices

Lee Jones (19):
      Merge branches 'ib-mfd-arm-3.18', 'ib-mfd-hwmon-leds-watchdog-3.18' and 'ib-mfd-power-charger-regulator-3.18' into ibs-for-mfd-merged
      iio: sensors-core: st: Check st_sensors_set_drdy_int_pin()'s return value
      misc: st_core: Protect unsigned value against becoming negative
      misc: st_kim: Increase size of dev_name buffer to incorporate termination
      mfd: htc-i2cpld: container_of() cannot return NULL
      mfd: htc-i2cpld: Use '!variable' instead of 'variable == NULL'
      mfd: htc-i2cpld: Rectify pointer offset error
      mfd: wm5102: Insert missing break in case statement
      mfd: max77686: Remove check which is always true
      mfd: pcf50633: Check return value of platform_device_add()
      mfd: twl4030-irq: Check return value from twl_i2c_write() - warn() on failure
      mfd: sm501: Avoid implicit sign extension
      mfd: wm8994: Export symbols ready for built-in => modular build
      mfd: 88pm860x-i2c: Purge unused functions
      mfd: 88pm860x-i2c: Fix variable length array Sparse warning
      mfd: max8925-i2c: Fix variable length array Sparse warning
      mfd: stmpe: Rid variable length array Sparse warnings
      mfd: dt-bindings: qcom-pm8xxx: Rename doc file to conform to naming convention
      mfd: dt-bindings: atmel-gpbr: Rename doc file to conform to naming convention

Mark Brown (3):
      mfd: wm8994: Allow modular build
      mfd: wm5102: Mark register write sequencer control 3 readable
      mfd: tps65217: Tell regmap what registers are valid

Markus Pargmann (1):
      mfd: mc13xxx: Configure WDI reset

Maxime Ripard (1):
      mfd: axp209x: Drop the parent supplies field

Mika Westerberg (1):
      mfd: Add ACPI support

Nishanth Menon (2):
      mfd: dt-bindings: twl4030-power: Use the standard property to mark power control
      mfd: twl4030-power: Use 'ti,system-power-controller' as alternative way to support system power off

Rasmus Villemoes (2):
      mfd: ti_ssp: Remove unused header
      mfd: davinci_voicecodec: Fix 'if defined' guard type in header

Sean Cross (2):
      mfd: stmpe: Support gpio over irq under device tree
      mfd: stmpe: Document DT binding for irq_over_gpio

Sebastian Andrzej Siewior (1):
      mfd: ti_am335x_tscadc: Fix TSC resume

Stanimir Varbanov (2):
      mfd: dt-bindings: pm8xxx: Add new compatible string
      mfd: Document DT bindings for Qualcomm SPMI PMICs

Steve Twiss (1):
      devicetree: Dialog Semiconductor consolidate existing vendor prefixes to standardise on 'dlg'

Vignesh R (1):
      mfd: ti_am335x_tscadc: Fix TSC operation after ADC continouous mode

 Documentation/ABI/testing/sysfs-class-power        |  14 +
 Documentation/acpi/enumeration.txt                 |  27 ++
 .../devicetree/bindings/i2c/trivial-devices.txt    |   2 +-
 Documentation/devicetree/bindings/mfd/arizona.txt  |   7 +
 .../devicetree/bindings/mfd/atmel-gpbr.txt         |  15 +
 Documentation/devicetree/bindings/mfd/hi6421.txt   |  38 +++
 Documentation/devicetree/bindings/mfd/max14577.txt | 146 ++++++++
 .../devicetree/bindings/mfd/qcom,spmi-pmic.txt     |  64 ++++
 .../mfd/{qcom,pm8xxx.txt => qcom-pm8xxx.txt}       |   1 +
 Documentation/devicetree/bindings/mfd/rk808.txt    | 177 ++++++++++
 Documentation/devicetree/bindings/mfd/rn5t618.txt  |  36 ++
 Documentation/devicetree/bindings/mfd/stmpe.txt    |   1 +
 .../devicetree/bindings/mfd/twl4030-power.txt      |   9 +-
 .../devicetree/bindings/regulator/da9210.txt       |   4 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 Documentation/hwmon/menf21bmc                      |  50 +++
 MAINTAINERS                                        |   9 +
 arch/arm/boot/dts/imx53-smd.dts                    |   2 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |   2 +-
 arch/arm/boot/dts/r8a7790-lager.dts                |   2 +-
 arch/arm/boot/dts/r8a7791-koelsch.dts              |   2 +-
 drivers/hwmon/Kconfig                              |  10 +
 drivers/hwmon/Makefile                             |   1 +
 drivers/hwmon/menf21bmc_hwmon.c                    | 230 +++++++++++++
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |   5 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |   5 +-
 drivers/input/keyboard/cros_ec_keyb.c              |   2 +-
 drivers/leds/Kconfig                               |   9 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-menf21bmc.c                      | 131 ++++++++
 drivers/mfd/88pm860x-i2c.c                         |  66 +---
 drivers/mfd/Kconfig                                |  71 +++-
 drivers/mfd/Makefile                               |   5 +
 drivers/mfd/arizona-core.c                         |  29 +-
 drivers/mfd/arizona-irq.c                          |  14 +-
 drivers/mfd/axp20x.c                               |  11 -
 drivers/mfd/cros_ec.c                              |  48 +++
 drivers/mfd/cros_ec_spi.c                          |  20 +-
 drivers/mfd/da9052-core.c                          |   2 +-
 drivers/mfd/da9052-i2c.c                           |   7 -
 drivers/mfd/da9052-spi.c                           |   7 +-
 drivers/mfd/da9055-core.c                          |  26 +-
 drivers/mfd/hi6421-pmic-core.c                     | 113 +++++++
 drivers/mfd/htc-i2cpld.c                           |  44 +--
 drivers/mfd/intel_soc_pmic_core.c                  |   2 +
 drivers/mfd/lpc_ich.c                              |  17 +
 drivers/mfd/lpc_sch.c                              | 211 +++++++-----
 drivers/mfd/max14577.c                             | 103 +++++-
 drivers/mfd/max77686.c                             |   2 +-
 drivers/mfd/max77693.c                             |   5 +-
 drivers/mfd/max8925-i2c.c                          |   2 +-
 drivers/mfd/mc13xxx-core.c                         |   8 +
 drivers/mfd/menelaus.c                             |  11 +-
 drivers/mfd/menf21bmc.c                            | 132 ++++++++
 drivers/mfd/mfd-core.c                             |  41 +++
 drivers/mfd/pcf50633-core.c                        |  35 +-
 drivers/mfd/qcom-spmi-pmic.c                       |  67 ++++
 drivers/mfd/rk808.c                                | 275 +++++++++++++++
 drivers/mfd/rn5t618.c                              | 134 ++++++++
 drivers/mfd/rtsx_pcr.c                             |   2 +-
 drivers/mfd/rtsx_usb.c                             |   2 +-
 drivers/mfd/sm501.c                                |   2 +-
 drivers/mfd/stmpe.c                                |  11 +-
 drivers/mfd/ti_am335x_tscadc.c                     |  35 +-
 drivers/mfd/tps65217.c                             |   2 +
 drivers/mfd/tps65910.c                             |   5 +
 drivers/mfd/twl4030-irq.c                          |   8 +-
 drivers/mfd/twl4030-power.c                        |   3 +
 drivers/mfd/twl6040.c                              |   1 +
 drivers/mfd/wm5102-tables.c                        |  16 +-
 drivers/mfd/wm5110-tables.c                        |  10 +-
 drivers/mfd/wm8994-irq.c                           |   2 +
 drivers/mfd/wm8994-regmap.c                        |   4 +
 drivers/misc/ti-st/st_core.c                       |  11 +-
 drivers/power/Kconfig                              |   5 +-
 drivers/power/max14577_charger.c                   | 370 +++++++++++++++++++--
 drivers/power/max17040_battery.c                   |   3 +-
 drivers/regulator/max14577.c                       |  80 +----
 drivers/watchdog/Kconfig                           |  10 +
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/menf21bmc_wdt.c                   | 203 +++++++++++
 include/dt-bindings/clock/rockchip,rk808.h         |  11 +
 include/linux/mfd/arizona/registers.h              |  29 +-
 include/linux/mfd/core.h                           |   3 +
 include/linux/mfd/cros_ec.h                        |  24 +-
 include/linux/mfd/da9052/da9052.h                  |   2 +-
 include/linux/mfd/davinci_voicecodec.h             |   2 +-
 include/linux/mfd/hi6421-pmic.h                    |  41 +++
 include/linux/mfd/max14577-private.h               |  95 ++++--
 include/linux/mfd/max14577.h                       |  30 ++
 include/linux/mfd/max77693-private.h               |  61 +++-
 include/linux/mfd/max77693.h                       |  40 +++
 include/linux/mfd/rk808.h                          | 196 +++++++++++
 include/linux/mfd/rn5t618.h                        | 228 +++++++++++++
 include/linux/mfd/ti_am335x_tscadc.h               |   1 +
 include/linux/mfd/ti_ssp.h                         |  93 ------
 include/linux/mfd/tps65217.h                       |   2 +
 include/linux/pci_ids.h                            |   1 +
 include/linux/ti_wilink_st.h                       |   2 +-
 sound/soc/codecs/arizona.c                         |   2 +-
 100 files changed, 3590 insertions(+), 570 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-gpbr.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/hi6421.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
 rename Documentation/devicetree/bindings/mfd/{qcom,pm8xxx.txt => qcom-pm8xxx.txt} (98%)
 create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/rn5t618.txt
 create mode 100644 Documentation/hwmon/menf21bmc
 create mode 100644 drivers/hwmon/menf21bmc_hwmon.c
 create mode 100644 drivers/leds/leds-menf21bmc.c
 create mode 100644 drivers/mfd/hi6421-pmic-core.c
 create mode 100644 drivers/mfd/menf21bmc.c
 create mode 100644 drivers/mfd/qcom-spmi-pmic.c
 create mode 100644 drivers/mfd/rk808.c
 create mode 100644 drivers/mfd/rn5t618.c
 create mode 100644 drivers/watchdog/menf21bmc_wdt.c
 create mode 100644 include/dt-bindings/clock/rockchip,rk808.h
 create mode 100644 include/linux/mfd/hi6421-pmic.h
 create mode 100644 include/linux/mfd/rk808.h
 create mode 100644 include/linux/mfd/rn5t618.h
 delete mode 100644 include/linux/mfd/ti_ssp.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
