Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaHGJxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:53:39 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57442 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaHGJxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:53:36 -0400
Date: Thu, 7 Aug 2014 10:53:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD for v3.17 merge-window
Message-ID: <20140807095330.GD10136@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.17

for you to fetch changes up to 7caa79917ad4c1f91366b11f18e48623554aaa52:

  MAINTAINERS: Update MFD repo location (2014-07-29 16:09:18 +0100)

----------------------------------------------------------------
 == Changes to existing drivers ==
  - Checkpatch fixes throughout the subsystem
  - Use Regmap to handle IRQs in max77686, extcon-max77693 and mc13xxx-core
  - Use DMA in rtsx_pcr
  - Restrict building on unsupported architectures on timberdale, cs5535
  - SPI hardening in cros_ec_spi
  - More robust error handing in asic3, cros_ec, ab8500-debugfs,
        max77686 and pcf50633-core
  - Reorder PM runtime and regulator handing during shutdown in arizona
  - Enable wakeup in cros_ec_spi
  - Unused variable/code clean-up in pm8921-core, cros_ec, htc-i2cpld,
        tps65912-spi, wm5110-tables and ab8500-debugfs
  - Add regulator handing into suspend() in sec-core
  - Remove pointless wrapper functions in extcon-max77693 and i2c-cros-ec-tunnel
  - Use cross-architecture friendly data sizes in stmpe-i2c, arizona,
        max77686 and tps65910
  - Device Tree documentation updates throughout
  - Provide power management support in max77686
  - Few OF clean-ups in max77686
  - Use manged resources in tps6105x

 == New drivers/supported devices ==
  - Add support for s2mpu02 to sec-core
  - Add support for Allwinner A32 to sun6i-prcm
  - Add support for Maxim 77802 in max77686
  - Add support for DA9063 AD in da9063
  - Add new driver for Intel PMICs (generic) and specifically Crystal Cove

 == (Re-)moved drivers ==
  - Move out keyboard functionality cros_ec ==> input/keyboard/cros_ec_keyb

----------------------------------------------------------------
Alexander Shiyan (1):
      mfd: mc13xxx: Use regmap irq framework for interrupts

Andreas Färber (2):
      Documentation: devicetree: Fix s2mps11 example syntax
      Documentation: devicetree: Fix s2mps11 and s5m8767 typos

Andrew Bresticker (1):
      mfd: cros_ec: Move EC interrupt to cros_ec_keyb

Bill Richardson (8):
      mfd: cros_ec: Fix the comment on cros_ec_remove()
      mfd: cros_ec: Allow static din/dout buffers with cros_ec_register()
      mfd: cros_ec: Tweak struct cros_ec_device for clarity
      mfd: cros_ec: Use struct cros_ec_command to communicate with the EC
      mfd: cros_ec: cleanup: remove unused fields from struct cros_ec_device
      mfd: cros_ec: cleanup: Remove EC wrapper functions
      mfd: cros_ec: Check result code from EC messages
      mfd: cros_ec: ec_dev->cmd_xfer() returns number of bytes received from EC

Chanwoo Choi (4):
      mfd: sec-core: Add support for S2MPU02 device
      regulator: s2mps11: Add support S2MPU02 regulator device
      dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
      mfd: sec-core: Prepare regulators for suspend state to reduce power-consumption

Charles Keepax (17):
      mfd: arizona: Disable PM runtime at start of driver removal
      mfd: arizona: Disable DCVDD before we destroy the MFD
      mfd: arizona: Don't use devres for DCVDD
      mfd: arizona: Use num_core_supplies in arizona_dev_exit
      mfd: arizona: Lower ARIZONA_MAX_CORE_SUPPLIES to 2
      mfd: wm8994: Add a bunch of missing defaults/readables
      mfd: arizona: Add comment to explain non-devm regulator_get
      mfd: arizona: Update DT binding to support LDO1 init_data
      mfd: arizona: Update DT binding to support MICVDD init_data
      mfd: arizona: Add MICVDD to mapped regulators for wm8997
      mfd: arizona: Map MICVDD from extcon device to the Arizona core
      mfd: wm5110: Remove non-existant interrupts
      mfd: wm5110: Add in the output done interrupts
      mfd: arizona: Rename thermal shutdown interrupt
      mfd: wm5110: Add new interrupt register definitions
      mfd: arizona: Add missing handling for ISRC3 under/overclocked
      mfd: arizona: Only free the CTRLIF_ERR IRQ if we requested it

Chen-Yu Tsai (1):
      mfd: sun6i-prcm: Add support for Allwinner A23 PRCM

Doug Anderson (2):
      mfd: cros_ec: spi: Fix end of transfer on devices with no spi-msg-delay
      mfd: cros_ec: Use the proper size when looking at the cros_ec_i2c result

Fabian Frederick (1):
      mfd: ab8500-debugfs: Remove unnecessary null test before debugfs_remove_recursive

Himangi Saraogi (1):
      mfd: tps6105x: Use managed resources when allocating memory

Javier Martinez Canillas (8):
      mfd: max77686: Convert to use regmap_irq
      mfd: max77686: Add power management support
      mfd: max77686: Don't define dummy function if OF isn't enabled
      mfd: max77686: Make platform data over-rule DT
      mfd: max77686: Return correct error when pdata isn't found
      mfd: max77686: Make error checking consistent
      mfd: max77686: Remove unneeded OOM error message
      mfd: max77686: Add Maxim 77802 PMIC support

Jean Delvare (2):
      mfd: timberdale: Depend on X86_32
      mfd: Fix cs5535 dependencies

Laxman Dewangan (2):
      dt-binding: mfd: as3722: Correct macro name
      Doc: mfd: as3722: Add details of optional missing property

Lee Jones (36):
      gpio: crystalcove: Fix implicit declaration of function 'seq_printf' error
      Merge branches 'ib-mfd-extcon-regulator-3.17', 'ib-mfd-gpio-3.17' and 'ib-mfd-mmc-3.17' into ibs-for-mfd-merged
      mfd: pcf50633: Reconnect -ENOMEM error path
      mfd: ab8500-core: Remove pointless else in if statement
      mfd: ab8500-debugfs: Simplify invalid debugfs data checking
      mfd: intel_soc_pmic: Rid compiler working for unused ACPI match table
      mfd: stmpe: Rid data size incompatibility warn when building for 64bit
      mfd: arizona: Rid data size incompatibility warn when building for 64bit
      mfd: tps65910: Rid data size incompatibility warn when building for 64bit
      mfd: 88pm805: msleep(1ms ~ 20ms) may not do what the caller intends
      mfd: 88pm860x-core: Repair formatting issues
      mfd: 88pm860x-i2c: Repair 'space before tab' warning
      mfd: aat2870-core: Stop using obsolte simple_strtoul()
      mfd: ab3100-core: Correct code sytle problems
      mfd: ab8500-core: Resolve code style issues
      mfd: ab8500-debugfs: BIG clean-up
      mfd: max77686: Fix 'line over 80 chars' warning
      mfd: max8925-i2c: Fix 'blank line after declarations' warning
      mfd: mcp-core: Fix 'blank line after declarations' warning
      mfd: wm8350-irq: Fix 'line over 80 chars' warning
      mfd: dm355evm_msp: Fix checkpatch error: insert space after ','
      mfd: sec-core: Fix 'missing blank line after declarations' warning
      mfd: twl6040: Fix 'insert space after ','', error
      mfd: ezx-pcap: Repair coding style errors picked up with checkpatch
      mfd: lp8788-irq: Fix 'missing blank line after declarations' warning
      mfd: twl4030-irq: Fix style warnings relating to pr_warn() and sizeof()
      mfd: max8925-core: Fix 'missing blank line after declarations' warning
      mfd: wm8350-i2c: Replace spaces with tabs
      mfd: twl6030-irq: Extinguish coding style warnings
      mfd: tc6387xb: Remove unnecessary braces and correct style warnings
      mfd: si476x-cmd: Remedy checkpatch style complains
      mfd: ipaq-micro: Fix coding style errors/warnings reported by checkpatch
      mfd: kempld-core: Correct a variety of checkpatch warnings
      mfd: wm8997-tables: Suppress 'line over 80 chars' warnings
      mfd: max77686: Ensure device type IDs are architecture agnostic
      MAINTAINERS: Update MFD repo location

Linus Walleij (1):
      mfd: tc3589x: Translate onecell, not twocell

Michael Welling (1):
      mfd: omap-usb-host: Fix improper mask use.

Micky Ching (2):
      mfd: rtsx: Add dma transfer function
      mmc: rtsx: add support for async request

Opensource [Steve Twiss] (1):
      mfd: da9063: Add support for AD silicon variant

Prathyush K (1):
      mfd: cros_ec_spi: Set wakeup capability

Rickard Strandqvist (2):
      mfd: ab8500-debugfs.c: Cleaning up values that are never used
      mfd: ab8500-debugfs: Cleaning up unnecessary to test, unsigned can't be negative.

Robert Baldyga (2):
      mfd: max77693: Remove unnecessary wrapper functions
      mfd: max77693: Handle IRQs using regmap

Sachin Kamat (4):
      mfd: asic3: Fix potential null pointer dereference
      mfd: pm8921-core: Remove unused variable
      mfd: htc-i2cpld: Remove unused code
      mfd: tps65912-spi: Remove unused variable

Simon Glass (1):
      mfd: cros_ec: Detect in-progress commands

Zhu, Lejun (3):
      mfd: intel_soc_pmic: Core driver
      mfd: intel_soc_pmic: Crystal Cove support
      gpio: Add support for Intel Crystal Cove PMIC

 Documentation/devicetree/bindings/mfd/arizona.txt  |  10 +
 Documentation/devicetree/bindings/mfd/as3722.txt   |   8 +
 Documentation/devicetree/bindings/mfd/s2mps11.txt  |  11 +-
 .../devicetree/bindings/mfd/sun6i-prcm.txt         |   2 +-
 .../bindings/regulator/s5m8767-regulator.txt       |   2 +-
 MAINTAINERS                                        |   3 +-
 drivers/extcon/extcon-max77693.c                   |  35 +-
 drivers/gpio/Kconfig                               |  13 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-crystalcove.c                    | 380 ++++++++++
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |  17 +-
 drivers/input/keyboard/cros_ec_keyb.c              |  70 +-
 drivers/mfd/88pm805.c                              |   2 +-
 drivers/mfd/88pm860x-core.c                        |  37 +-
 drivers/mfd/88pm860x-i2c.c                         |   3 +-
 drivers/mfd/Kconfig                                |  26 +-
 drivers/mfd/Makefile                               |   7 +-
 drivers/mfd/aat2870-core.c                         |   5 +-
 drivers/mfd/ab3100-core.c                          |  54 +-
 drivers/mfd/ab8500-core.c                          |  49 +-
 drivers/mfd/ab8500-debugfs.c                       | 308 ++++----
 drivers/mfd/arizona-core.c                         |  53 +-
 drivers/mfd/arizona-i2c.c                          |   5 +-
 drivers/mfd/arizona-irq.c                          |  29 +-
 drivers/mfd/arizona-spi.c                          |   3 +-
 drivers/mfd/arizona.h                              |   5 +-
 drivers/mfd/asic3.c                                |  12 +-
 drivers/mfd/cros_ec.c                              |  97 +--
 drivers/mfd/cros_ec_i2c.c                          |  44 +-
 drivers/mfd/cros_ec_spi.c                          |  56 +-
 drivers/mfd/da9063-core.c                          |   6 +-
 drivers/mfd/da9063-i2c.c                           | 134 +++-
 drivers/mfd/dm355evm_msp.c                         |   2 +-
 drivers/mfd/ezx-pcap.c                             |   3 +-
 drivers/mfd/htc-i2cpld.c                           |   5 -
 drivers/mfd/intel_soc_pmic_core.c                  | 170 +++++
 drivers/mfd/intel_soc_pmic_core.h                  |  32 +
 drivers/mfd/intel_soc_pmic_crc.c                   | 158 +++++
 drivers/mfd/ipaq-micro.c                           |   8 +-
 drivers/mfd/kempld-core.c                          |  10 +-
 drivers/mfd/lp8788-irq.c                           |   2 +
 drivers/mfd/max77686-irq.c                         | 319 ---------
 drivers/mfd/max77686.c                             | 329 ++++++++-
 drivers/mfd/max77693-irq.c                         | 336 ---------
 drivers/mfd/max77693.c                             | 210 ++++--
 drivers/mfd/max8925-core.c                         |   2 +
 drivers/mfd/max8925-i2c.c                          |   2 +
 drivers/mfd/mc13xxx-core.c                         | 310 ++------
 drivers/mfd/mc13xxx.h                              |  11 +-
 drivers/mfd/mcp-core.c                             |   1 +
 drivers/mfd/omap-usb-host.c                        |   2 +-
 drivers/mfd/pcf50633-core.c                        |  18 +-
 drivers/mfd/pm8921-core.c                          |   4 -
 drivers/mfd/rtsx_pcr.c                             |  76 +-
 drivers/mfd/sec-core.c                             |  82 ++-
 drivers/mfd/sec-irq.c                              | 110 ++-
 drivers/mfd/si476x-cmd.c                           |  12 +-
 drivers/mfd/stmpe-i2c.c                            |   4 +-
 drivers/mfd/stmpe.c                                |   2 +-
 drivers/mfd/stmpe.h                                |   2 +-
 drivers/mfd/sun6i-prcm.c                           |  30 +
 drivers/mfd/tc3589x.c                              |   2 +-
 drivers/mfd/tc6387xb.c                             |   7 +-
 drivers/mfd/tps6105x.c                             |  17 +-
 drivers/mfd/tps65910.c                             |  10 +-
 drivers/mfd/tps65912-spi.c                         |   3 +-
 drivers/mfd/twl4030-irq.c                          |   6 +-
 drivers/mfd/twl6030-irq.c                          |   4 +-
 drivers/mfd/twl6040.c                              |   2 +-
 drivers/mfd/wm5102-tables.c                        |   8 +-
 drivers/mfd/wm5110-tables.c                        | 245 ++++++-
 drivers/mfd/wm8350-i2c.c                           |   8 +-
 drivers/mfd/wm8350-irq.c                           |   3 +-
 drivers/mfd/wm8994-regmap.c                        |  64 ++
 drivers/mfd/wm8997-tables.c                        |  16 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  | 133 +++-
 drivers/regulator/max77693.c                       |  12 +-
 drivers/regulator/s2mps11.c                        | 321 ++++++++-
 drivers/rtc/rtc-da9063.c                           |  54 +-
 drivers/rtc/rtc-max77686.c                         |  27 +-
 include/dt-bindings/mfd/as3722.h                   |   2 +-
 include/linux/mfd/abx500/ab8500.h                  |   1 +
 include/linux/mfd/arizona/core.h                   |  35 +-
 include/linux/mfd/arizona/registers.h              | 785 +++++++++++++++++++--
 include/linux/mfd/cros_ec.h                        | 110 +--
 include/linux/mfd/da9063/core.h                    |   3 +-
 include/linux/mfd/da9063/registers.h               | 129 ++--
 include/linux/mfd/intel_soc_pmic.h                 |  30 +
 include/linux/mfd/max77686-private.h               | 239 ++++++-
 include/linux/mfd/max77686.h                       |  59 +-
 include/linux/mfd/max77693-private.h               |  54 +-
 include/linux/mfd/mc13783.h                        |   1 -
 include/linux/mfd/mc13xxx.h                        |  23 +-
 include/linux/mfd/rtsx_pci.h                       |   6 +
 include/linux/mfd/samsung/core.h                   |   1 +
 include/linux/mfd/samsung/irq.h                    |  24 +
 include/linux/mfd/samsung/s2mpu02.h                | 201 ++++++
 include/linux/mfd/tps65910.h                       |   2 +-
 sound/soc/codecs/arizona.c                         |  10 +-
 99 files changed, 4526 insertions(+), 1870 deletions(-)
 create mode 100644 drivers/gpio/gpio-crystalcove.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.h
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
 delete mode 100644 drivers/mfd/max77686-irq.c
 delete mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 include/linux/mfd/intel_soc_pmic.h
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
