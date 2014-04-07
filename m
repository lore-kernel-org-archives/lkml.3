Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaDGIf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:35:27 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36962 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaDGIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:35:22 -0400
Date: Mon, 7 Apr 2014 09:35:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD pull-request for v3.15
Message-ID: <20140407083515.GA8888@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.15

for you to fetch changes up to 2d28ca731b9bb6262f7711241628c7844b0cf7dc:

  mfd: wm5110: Correct default for HEADPHONE_DETECT_1 (2014-03-31 13:33:04 +0100)

----------------------------------------------------------------
 == Changes to existing drivers ==
   - Use of managed resources - omap, twl4030, ti_am335x_tscadc
   - Advanced error handling - omap
   - Rework clk management - omap
   - Device Tree (re-)work - tc3589x, pm8921, da9055, sec
   - IRQ management overhaul and !BROKEN - pm8921
   - Convert to regmap - ssbi, pm8921
   - Use simple power-management ops - ucb1x00
   - Include file clean-up - adp5520, cs5535, janz, lpc_ich,
      - lpc_sch, max14577, mcp-sa11x0, pcf50633-adc, rc5t583,
      	rdc321x-southbridge, retu, smsc-ece1099, ti-ssp, ti_am335x_tscadc,
	tps65912, vexpress-config, wm8350, ywm8350
   - Various bug fixes across the subsystem
      - NULL/invalid pointer dereference prevention
      - Resource leak mitigation
      - Variable used initialised
      - Staticise various containers
      - Enforce return value checks

 == New drivers/supported devices ==
   - Add support for s2mps14 and s2mpa01 to sec
   - Add support for da9063 (v5) to da9063
   - Add support for atom-c2000 to gpio-ich
   - Add support for come-{mbt10,cbt6,chl6} to kempld
   - Add support for da9053 to da9052
   - Add support for itco-wdt (v3) and baytrail to lpc_ich
   - Add new drivers for tps65218, rtsx_usb, bcm590xx

 == (Re-)moved drivers ==
   - twl4030 ==> drivers/iio
   - ti-ssp  ==> /dev/null

----------------------------------------------------------------
Adam Thomson (2):
      mfd: da9055: Add DT support for PMIC
      mfd: da9055: Add DT binding documentation for PMIC

Alexander Gordeev (1):
      mfd: timberdale: Use pci_enable_msix_exact() instead of pci_enable_msix()

Alexander Shiyan (4):
      mfd: syscon: Move diagnostic messages to dev_dbg()
      mfd: mc13xxx: Limit maximum SPI speed
      mfd: mc13xxx: Add missing spi_setup()
      mfd: syscon: Simplify syscon_match_pdevname()

Arnd Bergmann (1):
      mfd: Remove obsolete ti-ssp driver

Axel Lin (1):
      mfd: bcm590xx: Fix type argument for module device table

Charles Keepax (6):
      mfd: wm5102: Update register patch
      mfd: wm5102: Make additional DSP registers available to the user
      mfd: wm5110: Make additional DSP registers available to the user
      mfd: arizona: Mark DSP clocking register as volatile
      mfd: arizona: Correct small errors in the DT binding documentation
      mfd: wm5110: Correct default for HEADPHONE_DETECT_1

Colin Ian King (1):
      mfd: omap-usb-tll: Fix cppcheck sizeof warning

Florian Vaussard (2):
      mfd: twl6040: Remove duplicate register write
      mfd: twl6040: Check for error when reading revision register

Guenter Roeck (1):
      mfd: kempld-core: Fix potential hang-up during boot

Jingoo Han (2):
      mfd: ti_am335x_tscadc: Use devm_ioremap_resource()
      mfd: ucb1x00-core: Use SIMPLE_DEV_PM_OPS macro

Josh Cartwright (2):
      mfd: pm8921: Fixup probe() error path when irq invalid
      mfd: devicetree: bindings: Add pm8xxx RTC description

Keerthy (1):
      mfd: tps65218: Add driver for the TPS65218 PMIC

Krzysztof Kozlowski (23):
      mfd: sec-core: Add maximum RTC register for regmap config
      mfd: sec-core: Select different RTC regmaps for devices
      mfd: sec-irq: Use consistent S2MPS11 RTC alarm interrupt indexes
      mfd: sec: Add support for S2MPS14
      mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
      mfd: max14577: Remove unused enum max14577_irq_source
      mfd: max14577: Remove not needed header inclusion
      mfd: max14577: Add of_compatible to extcon mfd_cell
      mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
      mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: 88pm800: Fix I2C device resource leak if probe fails
      mfd: max14577: Select REGMAP_IRQ
      Documentation: mfd: s2mps11: Describe S5M8767 and S2MPS14 clocks
      mfd: sec-core: Add of_compatible strings for clock MFD cells
      mfd: sec-core: Fix I2C dummy device resource leak on probe failure
      mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail
      mfd: tps65910: Fix regmap_irq_chip_data leak on mfd_add_devices fail
      mfd: sec-core: Fix uninitialized 'regmap_rtc' on S2MPA01

Laszlo Papp (1):
      mfd: Trivial: Fix a grammar issues in MFD Kconfig

Lee Jones (4):
      Merge branch 'ib-mfd-regulator-3.15' into HEAD
      Merge branch 'ib-mfd-omap' into HEAD
      Merge branch 'ib-mfd-io-3.15' into HEAD
      mfd: tps65218: Fix reported randconfig error

Linus Walleij (2):
      mfd: Include all drivers in subsystem menu
      mfd: tc3589x: Reform device tree probing

Matt Porter (2):
      mfd: Add bcm590xx pmu DT binding
      mfd: Add bcm590xx pmu driver

Michael Brunner (1):
      mfd: kempld: Add support for COMe-mBT10, COMe-cBT6 and COMe-cHL6 to Kontron PLD driver

Opensource [Anthony Olech] (2):
      mfd: da9052: Add new DA9053 BC chip variant
      mfd: da9052: Extend support to a new chip

Opensource [Steve Twiss] (2):
      mfd: da9063: Add support for production silicon variant code
      mfd: da9063: Upgrade of register definitions to support production silicon

Pankaj Dubey (1):
      mfd: sec-core: Silence compiler warning

Paul Gortmaker (1):
      mfd: Delete non-required instances of include <linux/init.h>

Peter Tyser (8):
      mfd: lpc_ich: Fix ACPI enable bitmask
      mfd: lpc_ich: Only configure watchdog or GPIO when present
      mfd: lpc_ich: Remove lpc_ich_cfg struct use
      mfd: lpc_ich: Add support for iTCO v3
      watchdog: iTCO_wdt: Add support for v3 silicon
      mfd: lpc_ich: Change Avoton to iTCO v3
      mfd: lpc_ich: Add support for NM10 GPIO
      mfd: lpc_ich: Add support for Intel Bay Trail SoC

Roger Quadros (7):
      mfd: omap-usb-host: Use resource managed clk_get()
      mfd: omap-usb-host: Get clocks based on hardware revision
      mfd: omap-usb-host: Always fail on clk_get() error
      mfd: omap-usb-host: Use proper clock name instead of alias
      mfd: omap-usb-host: Use clock names as per function for reference clocks
      mfd: omap-usb-host: Update DT clock binding information
      mfd: omap-usb-tll: Update DT clock binding information

Roger Tseng (1):
      mfd: Add realtek USB card reader driver

Sachin Kamat (9):
      mfd: Add support for S2MPA01 device
      regulator: Add support for S2MPA01 regulator
      Documentation: mfd: Add binding document for S2MPA01
      mfd: stmpe: Trivial: Remove unnecessary semicolon
      mfd: max14577: Include missing err.h
      mfd: stw481x: Staticize stw481x_regmap_config
      mfd: stw481x: Check the return value of devm_regmap_init_i2c
      mfd: wm8400-core: Remove unnecessary goto
      mfd: vexpress: Staticize vexpress_config_bridges

Sebastian Reichel (7):
      mfd: twl4030-madc: Use managed resources
      mfd: twl4030-madc: Add DT support and convert to IIO framework
      mfd: twl4030-madc: Cleanup driver
      mfd: twl-core: Add twl_i2c_read/write_u16
      mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
      Documentation: DT: Document twl4030-madc binding
      mfd: twl4030-madc: Move driver to drivers/iio/adc

Semen Protsenko (1):
      mfd: vexpress-sysreg: Initialize 'site' variable

Stephen Boyd (10):
      mfd: pm8xxx: Move pm8xxx-irq.c contents into only driver that uses it
      mfd: pm8921: Update for genirq changes
      mfd: pm8921: Migrate to irqdomains
      mfd: ssbi: Add regmap read/write helpers
      mfd: pm8921: Use ssbi regmap
      mfd: pm8921: Add DT match table
      mfd: pm8921: Loosen Kconfig dependency
      mfd: devicetree: bindings: Document PM8921/8058 PMICs
      mfd: pm8921: Drop irq_set_lockdep_class() code
      mfd: pm8921: Use IRQCHIP_SKIP_SET_WAKE

Stephen Warren (1):
      mfd: as3722: Make FUSE7_REG readable

Tomas Novotny (1):
      mfd: twl-core: Fix accessibility of some twl4030 audio registers

Vincent Donnefort (6):
      mfd: lpc_ich: Convert ICH GPIOs IDs to enum
      mfd: lpc_ich: Add support for Intel Avoton GPIOs
      gpio: ich: Add blink capability option
      gpio: ich: Add support for multiple register addresses
      gpio: ich: Add output levels cache support
      gpio: ich: Add support for Intel Avoton

anthony.olech.opensource@diasemi.com (1):
      mfd: da9052: Fix volatile register definition ommissions

 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt |  24 +++
 Documentation/devicetree/bindings/mfd/arizona.txt          |  23 +--
 Documentation/devicetree/bindings/mfd/bcm590xx.txt         |  37 +++++
 Documentation/devicetree/bindings/mfd/da9055.txt           |  72 ++++++++
 Documentation/devicetree/bindings/mfd/omap-usb-host.txt    |  23 +++
 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt     |  10 ++
 Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt      |  96 +++++++++++
 Documentation/devicetree/bindings/mfd/s2mpa01.txt          |  90 ++++++++++
 Documentation/devicetree/bindings/mfd/s2mps11.txt          |  24 ++-
 arch/arm/boot/dts/omap4.dtsi                               |   6 +
 arch/arm/boot/dts/omap5.dtsi                               |   6 +
 arch/arm/mach-omap2/cclock3xxx_data.c                      |   4 -
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c                 |   6 -
 drivers/clk/ti/clk-3xxx.c                                  |   4 -
 drivers/gpio/gpio-ich.c                                    |  96 +++++++++--
 drivers/iio/adc/Kconfig                                    |  10 ++
 drivers/iio/adc/Makefile                                   |   1 +
 drivers/{mfd => iio/adc}/twl4030-madc.c                    | 321 ++++++++++++++++++++++--------------
 drivers/mfd/88pm800.c                                      |   3 +-
 drivers/mfd/88pm860x-core.c                                |   6 +
 drivers/mfd/Kconfig                                        |  98 ++++++-----
 drivers/mfd/Makefile                                       |   6 +-
 drivers/mfd/adp5520.c                                      |   1 -
 drivers/mfd/as3722.c                                       |   1 +
 drivers/mfd/bcm590xx.c                                     |  93 +++++++++++
 drivers/mfd/cs5535-mfd.c                                   |   1 -
 drivers/mfd/da9052-core.c                                  |   3 +
 drivers/mfd/da9052-i2c.c                                   |   5 +-
 drivers/mfd/da9052-spi.c                                   |   1 +
 drivers/mfd/da9055-i2c.c                                   |   8 +
 drivers/mfd/da9063-core.c                                  |  25 +--
 drivers/mfd/janz-cmodio.c                                  |   1 -
 drivers/mfd/kempld-core.c                                  |  31 +++-
 drivers/mfd/lpc_ich.c                                      | 151 ++++++++++++-----
 drivers/mfd/lpc_sch.c                                      |   1 -
 drivers/mfd/max14577.c                                     |   6 +-
 drivers/mfd/max77686.c                                     |   4 +
 drivers/mfd/max77693.c                                     |  12 +-
 drivers/mfd/max8925-i2c.c                                  |   9 +
 drivers/mfd/max8997.c                                      |  18 ++
 drivers/mfd/max8998.c                                      |   4 +
 drivers/mfd/mc13xxx-spi.c                                  |   5 +
 drivers/mfd/mcp-sa11x0.c                                   |   1 -
 drivers/mfd/omap-usb-host.c                                | 189 ++++++++++-----------
 drivers/mfd/omap-usb-tll.c                                 |   2 +-
 drivers/mfd/pcf50633-adc.c                                 |   1 -
 drivers/mfd/pm8921-core.c                                  | 419 ++++++++++++++++++++++++++++++++++++++++------
 drivers/mfd/pm8xxx-irq.c                                   | 371 -----------------------------------------
 drivers/mfd/rc5t583-irq.c                                  |   1 -
 drivers/mfd/rdc321x-southbridge.c                          |   1 -
 drivers/mfd/retu-mfd.c                                     |   1 -
 drivers/mfd/rtsx_usb.c                                     | 760 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/sec-core.c                                     | 129 +++++++++++++--
 drivers/mfd/sec-irq.c                                      |  97 ++++++++++-
 drivers/mfd/smsc-ece1099.c                                 |   1 -
 drivers/mfd/stmpe.c                                        |   2 +-
 drivers/mfd/stw481x.c                                      |   8 +-
 drivers/mfd/syscon.c                                       |   9 +-
 drivers/mfd/tc3589x.c                                      |  84 +++++++---
 drivers/mfd/ti-ssp.c                                       | 465 ---------------------------------------------------
 drivers/mfd/ti_am335x_tscadc.c                             |  24 +--
 drivers/mfd/timberdale.c                                   |   2 +-
 drivers/mfd/tps65218.c                                     | 282 +++++++++++++++++++++++++++++++
 drivers/mfd/tps65910.c                                     |   5 +-
 drivers/mfd/tps65912-core.c                                |   1 -
 drivers/mfd/tps65912-irq.c                                 |   1 -
 drivers/mfd/twl-core.c                                     |  10 +-
 drivers/mfd/twl4030-irq.c                                  |   1 -
 drivers/mfd/twl6030-irq.c                                  |   1 -
 drivers/mfd/twl6040.c                                      |   6 +-
 drivers/mfd/ucb1x00-core.c                                 |   4 +-
 drivers/mfd/vexpress-config.c                              |   3 +-
 drivers/mfd/vexpress-sysreg.c                              |   2 +-
 drivers/mfd/wm5102-tables.c                                |  36 ++++
 drivers/mfd/wm5110-tables.c                                | 174 +++++++++++++++++++-
 drivers/mfd/wm8350-core.c                                  |   1 -
 drivers/mfd/wm8350-irq.c                                   |   1 -
 drivers/mfd/wm8400-core.c                                  |  22 +--
 drivers/regulator/Kconfig                                  |   7 +
 drivers/regulator/Makefile                                 |   1 +
 drivers/regulator/s2mpa01.c                                | 481 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/iTCO_wdt.c                                | 137 ++++++++-------
 include/linux/i2c/twl.h                                    |  12 ++
 include/linux/i2c/twl4030-madc.h                           |   2 +-
 include/linux/mfd/arizona/registers.h                      |  84 ++++++++++
 include/linux/mfd/bcm590xx.h                               |  31 ++++
 include/linux/mfd/da9052/da9052.h                          |   1 +
 include/linux/mfd/da9063/core.h                            |   6 +-
 include/linux/mfd/da9063/registers.h                       | 120 +++++++-------
 include/linux/mfd/lpc_ich.h                                |  25 +--
 include/linux/mfd/max14577-private.h                       |   8 -
 include/linux/mfd/max14577.h                               |   5 -
 include/linux/mfd/pm8xxx/irq.h                             |  59 -------
 include/linux/mfd/pm8xxx/pm8921.h                          |  30 ----
 include/linux/mfd/rtsx_usb.h                               | 628 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/samsung/core.h                           |  19 ++-
 include/linux/mfd/samsung/irq.h                            |  81 ++++++++-
 include/linux/mfd/samsung/rtc.h                            |  57 ++++++-
 include/linux/mfd/samsung/s2mpa01.h                        | 192 +++++++++++++++++++++
 include/linux/mfd/samsung/s2mps14.h                        | 152 +++++++++++++++++
 include/linux/mfd/tps65218.h                               | 284 ++++++++++++++++++++++++++++++++
 include/linux/ssbi.h                                       |  20 +++
 102 files changed, 5275 insertions(+), 1630 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/bcm590xx.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mpa01.txt
 rename drivers/{mfd => iio/adc}/twl4030-madc.c (74%)
 create mode 100644 drivers/mfd/bcm590xx.c
 delete mode 100644 drivers/mfd/pm8xxx-irq.c
 create mode 100644 drivers/mfd/rtsx_usb.c
 delete mode 100644 drivers/mfd/ti-ssp.c
 create mode 100644 drivers/mfd/tps65218.c
 create mode 100644 drivers/regulator/s2mpa01.c
 create mode 100644 include/linux/mfd/bcm590xx.h
 delete mode 100644 include/linux/mfd/pm8xxx/irq.h
 delete mode 100644 include/linux/mfd/pm8xxx/pm8921.h
 create mode 100644 include/linux/mfd/rtsx_usb.h
 create mode 100644 include/linux/mfd/samsung/s2mpa01.h
 create mode 100644 include/linux/mfd/samsung/s2mps14.h
 create mode 100644 include/linux/mfd/tps65218.h

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
