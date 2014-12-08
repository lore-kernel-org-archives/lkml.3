Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaLHMBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:01:07 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:39909 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaLHMBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:01:05 -0500
Date: Mon, 8 Dec 2014 12:00:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD for v3.19
Message-ID: <20141208120058.GI3951@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

 The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.19

for you to fetch changes up to a3b63979f8a32af9e975a793fd0f612d42072740:

  mfd: rtsx: Add func to split u32 into register (2014-12-08 10:05:39 +0000)

----------------------------------------------------------------
Changes to the core:
 - Honour PLATFORM_DEVID_NONE and PLATFORM_DEVID_AUTO dev IDs

Changes to existing drivers:
 - IRQ additions/fixes; axp20x, da9063-core
 - Code simplification; i2c-dln2
 - Regmap additions/fixes; max77693
 - Error checking/handling improvements; dln2, db8500-prcmu
 - Bug fixes; dln2, wm8350-core
 - DT support/documentation; max77693, max77686, tps65217, twl4030-power,
                             gpio-tc3589x
 - Decouple syscon interface from platform devices
 - Use MFD hotplug registration; rtsx_usb, viperboard, hid-sensor-hub
 - Regulator fixups; sec-core
 - Power Management additions/fixes; rts5227, tc6393xb
 - Remove relic/redundant code; ab8500-sysctrl, lpc_sch, max77693-private
 - Clean-up/coding style changes; tps65090
 - Clk additions/fixes; tc6393xb, tc6387xb, t7l66xb
 - Add USB-SPI support; dln2
 - Trivial changes; max14577, arizona-spi, lpc_sch, wm8997-tables, wm5102-tables
                    wm5110-tables, axp20x, atmel-hlcdc, rtsx_pci

New drivers/supported devices:
 - axp288 PMIC support added to axp20x
 - s2mps13 support added to sec-core
 - New support for Diolan DLN-2
 - New support for atmel-hlcdc

----------------------------------------------------------------
Aaron Lu (1):
      iio: adc: Add module device table for autoloading

Andy Shevchenko (1):
      mfd: lpc_sch: Don't call mfd_remove_devices()

Boris Brezillon (3):
      mfd: Add atmel-hlcdc driver
      mfd: Add documentation for atmel-hlcdc DT bindings
      mfd: atmel-hlcdc: Add Kconfig option description and name

Chanwoo Choi (4):
      mfd: sec-core: Add support for S2MPS13 device
      regulator: s2mps11: Add support S2MPS13 regulator device
      clk: s2mps11: Add the support for S2MPS13 PMIC clock
      mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC

Charles Keepax (3):
      mfd: wm8997: Mark INTERRUPT_STATUS_2_MASK as readable
      mfd: arizona: Document HP_CTRL_1L and HP_CTRL_1R registers
      mfd: wm5110: Add missing registers for AIF2 channels 3-6

Dan Carpenter (1):
      mfd: dln2: A couple endian fixes

Daniel Baluta (1):
      gpio: add support for the Diolan DLN-2 USB GPIO driver

Dmitry Eremin-Solenikov (4):
      mfd: tc6393xb: Fail ohci suspend if full state restore is required
      mfd: tc6393xb: Prepare/unprepare clocks
      mfd: tc6387xb: prepare/unprepare clocks
      mfd: t7l66xb: prepare/unprepare clocks

Dmitry Lavnikevich (1):
      mfd: da9063: Get irq base dynamically before registering device

Guenter Roeck (1):
      mfd: ab8500-sysctrl: Drop ab8500_restart

Jacob Pan (4):
      mfd: axp20x: Extend axp20x to support axp288 pmic
      iio: adc: Add support for axp288 adc
      mfd/axp20x: avoid irq numbering collision
      iio/axp288_adc: remove THIS_MODULE owner

Jaewon Kim (3):
      mfd: max77693: Initialize haptic register map
      mfd: max77693: Add haptic of_compatible in mfd_cell
      mfd: max77693: Update DT binding to support haptic

Javier Martinez Canillas (1):
      Revert "mfd: sec-core: Prepare regulators for suspend state to reduce power-consumption"

Joe Perches (1):
      mfd: wm8350-core: Fix probable mask then right shift defect

Johan Hovold (4):
      mfd: core: Add helper function to register hotplug devices
      mfd: Use mfd_add_hotplug_devices() helper
      HID: hid-sensor-hub: Use mfd_add_hotplug_devices() helper
      mfd: core: Fix platform-device id generation

Johannes Pointner (1):
      mfd: tps65217: Add compatible string for subdevices

Krzysztof Kozlowski (4):
      mfd: max77693: Remove unused define
      mfd: max77693: Map charger device to its own of_node
      mfd/regulator: dt-bindings: max77686: Document regulators off in suspend
      mfd: max14577: Fix obvious typo in company name in copyright

Laurentiu Palcu (2):
      i2c: add support for Diolan DLN-2 USB-I2C adapter
      mfd: dln2: add support for USB-SPI module

Lee Jones (4):
      Merge branches 'ib-mfd-gpio-i2c-3.19', 'ib-mfd-iio-3.19' and 'ib-mfd-regulator-v3.19', tag 'ib-mfd-regulator-clk-v3.19' into ibs-for-mfd-merged
      mfd: db8500-prcmu: Provide sane error path values
      mfd: tps65090: Fix bonkers indenting strategy
      mfd: axp20x: Constify axp20x_acpi_match and rid unused warning

Linus Walleij (1):
      mfd: tc3589x: get rid of static base

Micky Ching (2):
      mfd: rtsx: Fix PM suspend for 5227 & 5249
      mfd: rtsx: Add func to split u32 into register

Octavian Purdila (4):
      mfd: Add support for Diolan DLN-2 devices
      mfd: dln2: Fix _dln2_transfer return code
      i2c: dln2: Simplify return flow for dln2_i2c_enable
      mfd: dln2: Add a limit check for invalid echo

Pankaj Dubey (1):
      mfd: syscon: Decouple syscon interface from platform devices

Pramod Gurav (1):
      mfd: db8500-prcmu: Check return of devm_ioremap for error

Romain Perier (1):
      of: Add standard property for poweroff capability

Tony Lindgren (1):
      mfd: twl4030-power: Fix regression with missing compatible flag

Will Sheppard (1):
      mfd: arizona-spi: Add lines after declarations - checkpatch catch

 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt |  51 +++++++++
 Documentation/devicetree/bindings/mfd/max77686.txt    |   6 +
 Documentation/devicetree/bindings/mfd/max77693.txt    |  21 ++++
 Documentation/devicetree/bindings/mfd/s2mps11.txt     |  22 ++--
 drivers/clk/clk-s2mps11.c                             |  24 ++++
 drivers/gpio/Kconfig                                  |  12 ++
 drivers/gpio/Makefile                                 |   1 +
 drivers/gpio/gpio-dln2.c                              | 553 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-tc3589x.c                           |   2 +-
 drivers/hid/hid-sensor-hub.c                          |   8 +-
 drivers/i2c/busses/Kconfig                            |  10 ++
 drivers/i2c/busses/Makefile                           |   1 +
 drivers/i2c/busses/i2c-dln2.c                         | 262 +++++++++++++++++++++++++++++++++++++++++++
 drivers/iio/adc/Kconfig                               |   8 ++
 drivers/iio/adc/Makefile                              |   1 +
 drivers/iio/adc/axp288_adc.c                          | 261 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                                   |  25 ++++-
 drivers/mfd/Makefile                                  |   4 +-
 drivers/mfd/ab8500-sysctrl.c                          |  57 ----------
 drivers/mfd/arizona-spi.c                             |   2 +
 drivers/mfd/atmel-hlcdc.c                             | 122 ++++++++++++++++++++
 drivers/mfd/axp20x.c                                  | 361 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/mfd/da9063-core.c                             |   4 +-
 drivers/mfd/db8500-prcmu.c                            |  22 ++--
 drivers/mfd/dln2.c                                    | 781 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/lpc_sch.c                                 |   6 +-
 drivers/mfd/max14577.c                                |   2 +-
 drivers/mfd/max77693.c                                |  31 +++++-
 drivers/mfd/mfd-core.c                                |   8 +-
 drivers/mfd/rts5227.c                                 |   6 +
 drivers/mfd/rts5249.c                                 |   4 +
 drivers/mfd/rtsx_gops.c                               |  37 +++++++
 drivers/mfd/rtsx_pcr.h                                |   3 +
 drivers/mfd/rtsx_usb.c                                |   4 +-
 drivers/mfd/sec-core.c                                |  39 +++++--
 drivers/mfd/sec-irq.c                                 |  23 +++-
 drivers/mfd/syscon.c                                  |  96 ++++++++++++----
 drivers/mfd/t7l66xb.c                                 |  14 +--
 drivers/mfd/tc3589x.c                                 |   9 +-
 drivers/mfd/tc6387xb.c                                |  10 +-
 drivers/mfd/tc6393xb.c                                |  23 +++-
 drivers/mfd/tps65090.c                                |  62 +++++------
 drivers/mfd/tps65217.c                                |   2 +
 drivers/mfd/twl4030-power.c                           |   3 +
 drivers/mfd/viperboard.c                              |   4 +-
 drivers/mfd/wm5102-tables.c                           |   6 +-
 drivers/mfd/wm5110-tables.c                           |  20 ++++
 drivers/mfd/wm8350-core.c                             |   2 +-
 drivers/mfd/wm8997-tables.c                           |   6 +
 drivers/regulator/Kconfig                             |  10 +-
 drivers/regulator/s2mps11.c                           | 102 ++++++++++++++++-
 include/linux/mfd/abx500/ab8500-sysctrl.h             |   1 -
 include/linux/mfd/arizona/registers.h                 |  50 +++++++++
 include/linux/mfd/atmel-hlcdc.h                       |  85 ++++++++++++++
 include/linux/mfd/axp20x.h                            |  59 ++++++++++
 include/linux/mfd/core.h                              |   7 ++
 include/linux/mfd/dln2.h                              | 103 +++++++++++++++++
 include/linux/mfd/max77693-private.h                  |   1 -
 include/linux/mfd/rtsx_pci.h                          |  37 +++++++
 include/linux/mfd/samsung/core.h                      |   2 +
 include/linux/mfd/samsung/s2mps13.h                   | 186 +++++++++++++++++++++++++++++++
 include/linux/mfd/tc3589x.h                           |   8 --
 include/linux/of.h                                    |  11 ++
 63 files changed, 3431 insertions(+), 272 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/iio/adc/axp288_adc.c
 create mode 100644 drivers/mfd/atmel-hlcdc.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 drivers/mfd/rtsx_gops.c
 create mode 100644 include/linux/mfd/atmel-hlcdc.h
 create mode 100644 include/linux/mfd/dln2.h
 create mode 100644 include/linux/mfd/samsung/s2mps13.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
