Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaFEKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:09:27 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36050 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFEKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:09:12 -0400
Date: Thu, 5 Jun 2014 11:09:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD changes due for v3.16
Message-ID: <20140605100906.GD19550@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.16

for you to fetch changes up to 89abd4df28c6f85645e32f37ffab6426f800e4a1:

  mfd: wm5102: Correct default for LDO Control 2 register (2014-06-03 08:12:55 +0100)

----------------------------------------------------------------
Changes to existing drivers:
 - Increase DT coverage - arizona, mc13xxx, stmpe-i2c, syscon, sun6i-prcm
 - Regmap use of and/or clean-up - tps65090, twl6040
 - Basic renaming - max14577
 - Use new cpufreq helpers -  db8500-prcmu
 - Increase regulator support - stmpe, arizona, wm5102
 - Reduce legacy GPIO overhead - stmpe
 - Provide necessary remove path - bcm590xx
 - Expand sysfs presence - kempld
 - Move driver specific code out to drivers - rtc-s5m, arizona
 - Clk handling - twl6040
 - Use managed (devm_*) resources - ipaq-micro
 - Clean-up/remove unused/duplicated code - tps65218, sec, pm8921, abx500-core
   		   		     	    db8500-prcmu, menelaus
 - Build/boot/sematic bug fixes - rtsx_usb, stmpe, bcm590xx, abx500, mc13xxx
                                  rdc321x-southbridge, mfd-core, sec, max14577
				  syscon, cros_ec_spi
 - Constify stuff 		- sm501, tps65910, tps6507x, tps6586x, max77686,
   	    	  		  max8997, kempld, max77693, max8907, rtsx_usb
				  db8500-prcmu, max8998, wm8400, sec, lp3943,
				  max14577, as3711, omap-usb-host, ipaq-micro
Support for new devices:
 - Add support for max77836 into max14577
 - Add support for tps658640 into tps6586x
 - Add support for cros-ec-i2c-tunnel into cros_ec
 - Add new driver for rtsx_usb_sdmmc and rtsx_usb_ms
 - Add new driver for axp20x
 - Add new driver for sun6i-prcm
 - Add new driver for ipaq-micro

----------------------------------------------------------------
Alban Bedel (2):
      regulator: tps6586x: Prepare supporting fixed regulators
      regulator: tps6586x: Add support for the TPS658640

Alexander Shiyan (3):
      ASoC: mc13783: Add devicetree support
      mfd: mc13xxx: Move definitions out of structures
      mfd: mc13xxx: Do not use platform data with devicetree

Axel Lin (4):
      mfd: bcm590xx: Add missing remove function
      mfd: bcm590xx: Fix modalias prefix
      mfd: tps65218: Remove unused *rdev[] from struct tps65218
      mfd: rdc321x: Fix off-by-one for ngpio setting

Bill Richardson (2):
      mfd: cros_ec: cleanup: cros_ec.c is GPL licensed, like all the others.
      mfd: cros_ec: Sync to the latest cros_ec_commands.h from EC sources

Boris BREZILLON (2):
      mfd: sun6i-prcm: Document DT bindings
      mfd: Add support for sun6i PRCM (Power/Reset/Clock Management) unit

Carlo Caione (1):
      mfd: AXP20x: Add mfd driver for AXP20x PMIC

Chanwoo Choi (1):
      extcon: max14577: Change extcon name instead of static name according to device type

Charles Keepax (9):
      mfd: arizona: Factor out read of device tree GPIOs
      regulator: arizona-micsupp: Add processing of init_data from device tree
      regulator: arizona-ldo1: Move setup processing from arizona-core
      regulator: arizona-ldo1: Add processing of init_data from device tree
      mfd: wm5110: Add missing isolation control register
      mfd: core: Don't use devres functions before device is added
      mfd: arizona: Add MICVDD to mapped regulators
      mfd: wm8997: Add registers for high power mode
      mfd: arizona: Correct error message for addition of main IRQ chip

David Hendricks (1):
      mfd: cros_ec: spi: Calculate delay between transfers correctly

Doug Anderson (6):
      mfd: tps65090: Don't tell child devices we have an IRQ if we don't
      mfd: tps65090: Stop caching most registers
      mfd: cros_ec: spi: Add mutex to cros_ec_spi
      mfd: cros_ec: spi: Make the cros_ec_spi timeout more reliable
      mfd: cros_ec: spi: Increase cros_ec_spi deadline from 5ms to 100ms
      i2c: ChromeOS EC tunnel driver

Fabio Estevam (1):
      mfd: mc13xxx-core: Initialize the lock prior to using it

Guenter Roeck (1):
      mfd: lpc_ich: Enable GPIO for Panther Point

Ivan Khoronzhuk (1):
      mfd: ti-keystone-devctrl: Add bindings for device state control

Jay Aurabind (1):
      mfd: abx500-core: Fix compiler warning larger stack frame

Jingoo Han (5):
      mfd: sm501: Make of_device_id array const
      mfd: tps65910: Make of_device_id array const
      mfd: tps6507x: Make of_device_id array const
      mfd: tps6586x: Make of_device_id array const
      mfd: ipaq-micro: Use devm_ioremap_resource()

Keerthy (1):
      mfd: palmas: Format the header file

Krzysztof Kozlowski (29):
      mfd: max14577: Add muic prefix to regmap config
      mfd: max14577: Add detection of device type
      extcon: max14577: Add max14577 prefix to muic_irqs
      extcon: max14577: Choose muic_irqs according to device type
      mfd: max14577: Add MAX14577 prefix to IRQ defines
      mfd: max77836: Add MAX77836 support to max14577 driver
      extcon: max14577: Add support for MAX77836
      regulator: max14577: Add support for MAX77836 regulators
      mfd/rtc: s5m: Do not allocate RTC I2C dummy and regmap for unsupported chipsets
      mfd: sec-core: Update sec_pmic documentation
      mfd: sec-core: Remove duplicated device type from sec_pmic_dev
      mfd: sec-core: Fix IRQ handling after resume if this is not a wakeup source
      mfd: max14577: Fix IRQ handling after resume if this is not a wakeup source
      mfd: max77686: Make of_device_id array const
      mfd: max8997: Make of_device_id array const
      mfd: kempld-core: Make mfd_cell array const
      mfd: max77693: Make of_device_id array const
      mfd: max8907: Make of_device_id array const
      mfd: db8500-prcmu: Make mfd_cell array const
      mfd: max8998: Make of_device_id array const
      mfd: wm8400-core: Make mfd_cell array const
      mfd: sec-core: Make of_device_id array const
      mfd: max14577: Make of_device_id array const
      mfd: lp3943: Make mfd_cell array const
      mfd: max14577: Make mfd_cell array const
      mfd: as3711: Make of_device_id array const
      mfd: omap-usb-host: Make of_device_id array const
      mfd: rtsx_usb: Make mfd_cell array const
      mfd: ipaq-micro: Make mfd_cell array const

Lee Jones (4):
      Merge tag 'regulator-tps658640' into ib-from-regulator-3.16
      Merge branches 'ib-from-asoc-3.16', 'ib-from-pm-3.16', 'ib-from-regulator-3.16', 'ib-mfd-gpio-3.16' and 'ib-mfd-mmc-memstick-3.16', tags 'ib-mfd-extcon-3.16', 'ib-mfd-omap-3.16' and 'ib-mfd-regulator-3.16' into ibs-for-mfd-merged
      mfd: max14577: Cast to architecture agnostic data type
      mfd: abx500-core: Remove unused function abx500_dump_all_banks()

Linus Walleij (5):
      mfd: stmpe: mask off unused blocks properly
      mfd: stmpe: Probe properly from the Device Tree
      mfd: stmpe: add optional regulators
      mfd: stmpe: root out static GPIO and IRQ assignments
      mfd: Add driver for Atmel Microcontroller on iPaq h3xxx

Michael Brunner (1):
      mfd: Add sysfs attributes for Kontron PLD firmware revision

Pankaj Dubey (1):
      mfd: syscon: Allow property as NULL in syscon_regmap_lookup_by_phandle

Paul Bolle (1):
      mfd: db8500-prcmu: Remove check for CONFIG_DBX500_PRCMU_DEBUG

Peter Ujfalusi (5):
      mfd: twl6040: Clear the interrupt ID register before requesting IRQ
      mfd: twl6040: Select i2c fast mode as default with regmap patch
      mfd: twl6040: Optional clk32k clock handling
      mfd: twl6040: Move register patching earlier in probe
      mfd: twl6040: Correct HPPLL configuration for 19.2 and 38.4 MHz mclk

Richard Fitzgerald (2):
      mfd: arizona: Correct addresses of always-on trigger registers
      mfd: wm5102: Correct default for LDO Control 2 register

Roger Tseng (4):
      mfd: rtsx_usb: Fix possible race condition
      mfd: rtsx_usb: Add comment in rtsx_usb_suspend
      mmc: Add realtek USB sdmmc host driver
      memstick: Add realtek USB memstick host driver

Sachin Kamat (1):
      mfd: menelaus: Use module_i2c_driver

Stephen Boyd (2):
      mfd: pm8921: Remove pm8xxx API now that sub-devices use regmap
      mfd: tps65218: Terminate of match table

Stratos Karafotis (4):
      cpufreq: Introduce macros for cpufreq_frequency_table iteration
      cpufreq: Use cpufreq_for_each_* macros for frequency table iteration
      ARM: davinci: da850: Use cpufreq_for_each_entry macro for iteration
      mfd: db8500-prcmu: Use cpufreq_for_each_entry macro for iteration

Tony Lindgren (1):
      mfd: twl-core: Fix idle mode signaling for omaps when booted with device tree

Tushar Behera (1):
      mfd: syscon: Include linux/err.h to fix build error

 Documentation/cpu-freq/cpu-drivers.txt                        |   19 +
 Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt  |   39 ++
 Documentation/devicetree/bindings/mfd/mc13xxx.txt             |    3 +
 Documentation/devicetree/bindings/mfd/sun6i-prcm.txt          |   59 +++
 Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt |   19 +
 Documentation/devicetree/bindings/mfd/twl6040.txt             |    2 +
 arch/arm/mach-davinci/da850.c                                 |    9 +-
 arch/arm/mach-omap2/omap_twl.c                                |   60 ----
 drivers/cpufreq/acpi-cpufreq.c                                |    9 +-
 drivers/cpufreq/arm_big_little.c                              |   16 +-
 drivers/cpufreq/cpufreq.c                                     |   11 +
 drivers/cpufreq/cpufreq_stats.c                               |   24 +-
 drivers/cpufreq/dbx500-cpufreq.c                              |    8 +-
 drivers/cpufreq/elanfreq.c                                    |    9 +-
 drivers/cpufreq/exynos-cpufreq.c                              |   11 +-
 drivers/cpufreq/exynos5440-cpufreq.c                          |   30 +-
 drivers/cpufreq/freq_table.c                                  |   56 ++-
 drivers/cpufreq/longhaul.c                                    |   11 +-
 drivers/cpufreq/pasemi-cpufreq.c                              |   10 +-
 drivers/cpufreq/powernow-k6.c                                 |   14 +-
 drivers/cpufreq/ppc_cbe_cpufreq.c                             |    9 +-
 drivers/cpufreq/s3c2416-cpufreq.c                             |   40 +--
 drivers/cpufreq/s3c64xx-cpufreq.c                             |   15 +-
 drivers/extcon/Kconfig                                        |    4 +-
 drivers/extcon/extcon-max14577.c                              |  174 ++++++---
 drivers/gpio/gpio-stmpe.c                                     |   18 +-
 drivers/i2c/busses/Kconfig                                    |    9 +
 drivers/i2c/busses/Makefile                                   |    1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c                       |  318 +++++++++++++++++
 drivers/memstick/host/Kconfig                                 |   10 +
 drivers/memstick/host/Makefile                                |    1 +
 drivers/memstick/host/rtsx_usb_ms.c                           |  839 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                                           |   37 +-
 drivers/mfd/Makefile                                          |    3 +
 drivers/mfd/abx500-core.c                                     |   16 -
 drivers/mfd/arizona-core.c                                    |   42 ++-
 drivers/mfd/arizona-irq.c                                     |    2 +-
 drivers/mfd/as3711.c                                          |    2 +-
 drivers/mfd/axp20x.c                                          |  258 +++++++++++++
 drivers/mfd/bcm590xx.c                                        |    9 +-
 drivers/mfd/cros_ec.c                                         |   10 +-
 drivers/mfd/cros_ec_spi.c                                     |   67 +++-
 drivers/mfd/db8500-prcmu.c                                    |   24 +-
 drivers/mfd/ipaq-micro.c                                      |  482 +++++++++++++++++++++++++
 drivers/mfd/kempld-core.c                                     |  129 +++++--
 drivers/mfd/lp3943.c                                          |    2 +-
 drivers/mfd/lpc_ich.c                                         |    1 +
 drivers/mfd/max14577.c                                        |  347 ++++++++++++++----
 drivers/mfd/max77686.c                                        |    2 +-
 drivers/mfd/max77693.c                                        |    2 +-
 drivers/mfd/max8907.c                                         |    2 +-
 drivers/mfd/max8997.c                                         |    2 +-
 drivers/mfd/max8998.c                                         |    2 +-
 drivers/mfd/mc13xxx-core.c                                    |   22 +-
 drivers/mfd/menelaus.c                                        |   23 +-
 drivers/mfd/mfd-core.c                                        |   11 +-
 drivers/mfd/omap-usb-host.c                                   |    2 +-
 drivers/mfd/pm8921-core.c                                     |  123 +------
 drivers/mfd/rdc321x-southbridge.c                             |    2 +-
 drivers/mfd/rtsx_usb.c                                        |   16 +-
 drivers/mfd/sec-core.c                                        |   88 +----
 drivers/mfd/sec-irq.c                                         |    2 +-
 drivers/mfd/sm501.c                                           |    2 +-
 drivers/mfd/stmpe-i2c.c                                       |   30 +-
 drivers/mfd/stmpe.c                                           |   33 +-
 drivers/mfd/stmpe.h                                           |    2 +-
 drivers/mfd/sun6i-prcm.c                                      |  134 +++++++
 drivers/mfd/syscon.c                                          |    6 +-
 drivers/mfd/tps6507x.c                                        |    2 +-
 drivers/mfd/tps65090.c                                        |   41 ++-
 drivers/mfd/tps65218.c                                        |    1 +
 drivers/mfd/tps6586x.c                                        |    6 +-
 drivers/mfd/tps65910.c                                        |    2 +-
 drivers/mfd/twl-core.c                                        |   15 +
 drivers/mfd/twl6040.c                                         |   42 ++-
 drivers/mfd/wm5102-tables.c                                   |    4 +-
 drivers/mfd/wm5110-tables.c                                   |   14 +-
 drivers/mfd/wm8400-core.c                                     |    2 +-
 drivers/mfd/wm8997-tables.c                                   |   14 +-
 drivers/mmc/host/Kconfig                                      |    7 +
 drivers/mmc/host/Makefile                                     |    1 +
 drivers/mmc/host/rtsx_usb_sdmmc.c                             | 1455 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/power/tps65090-charger.c                              |   11 -
 drivers/regulator/Kconfig                                     |    7 +-
 drivers/regulator/arizona-ldo1.c                              |   57 +++
 drivers/regulator/arizona-micsupp.c                           |   37 ++
 drivers/regulator/max14577.c                                  |  277 ++++++++++++--
 drivers/regulator/tps6586x-regulator.c                        |   63 +++-
 drivers/rtc/rtc-s5m.c                                         |   75 +++-
 include/linux/cpufreq.h                                       |   21 ++
 include/linux/mfd/abx500.h                                    |    1 -
 include/linux/mfd/arizona/core.h                              |    3 +
 include/linux/mfd/arizona/registers.h                         |   14 +-
 include/linux/mfd/axp20x.h                                    |  180 ++++++++++
 include/linux/mfd/cros_ec.h                                   |    4 +-
 include/linux/mfd/cros_ec_commands.h                          | 1128 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/mfd/ipaq-micro.h                                |  148 ++++++++
 include/linux/mfd/kempld.h                                    |    4 +
 include/linux/mfd/max14577-private.h                          |  222 +++++++++---
 include/linux/mfd/max14577.h                                  |   19 +-
 include/linux/mfd/mc13xxx.h                                   |   22 +-
 include/linux/mfd/palmas.h                                    | 2166 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
 include/linux/mfd/pm8xxx/core.h                               |   81 -----
 include/linux/mfd/rdc321x.h                                   |    2 +-
 include/linux/mfd/samsung/core.h                              |   35 +-
 include/linux/mfd/stmpe.h                                     |   19 +-
 include/linux/mfd/syscon.h                                    |    2 +
 include/linux/mfd/tps65090.h                                  |   14 +
 include/linux/mfd/tps65218.h                                  |    1 -
 include/linux/mfd/tps6586x.h                                  |    2 +
 include/linux/mfd/twl6040.h                                   |    3 +
 sound/soc/codecs/mc13783.c                                    |   14 +-
 112 files changed, 7908 insertions(+), 2124 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
 create mode 100644 drivers/i2c/busses/i2c-cros-ec-tunnel.c
 create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
 create mode 100644 drivers/mfd/axp20x.c
 create mode 100644 drivers/mfd/ipaq-micro.c
 create mode 100644 drivers/mfd/sun6i-prcm.c
 create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c
 create mode 100644 include/linux/mfd/axp20x.h
 create mode 100644 include/linux/mfd/ipaq-micro.h
 delete mode 100644 include/linux/mfd/pm8xxx/core.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
