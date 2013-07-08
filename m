Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3GHWxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 18:53:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:25358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab3GHWxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 18:53:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1023,1363158000"; 
   d="scan'208";a="265630265"
Date: Tue, 9 Jul 2013 00:51:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [GIT] [3.11] MFD pull request
Message-ID: <20130708225157.GA31856@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 3.11 merge window.

For the 3.11 merge we only have one new MFD driver for the Kontron PLD.

But we also have:

- Support for the TPS659038 PMIC from the palmas driver.
- Intel's Coleto Creek and Avoton SoCs support from the lpc_ich driver.
- RTL8411B support from the rtsx driver.
- More DT support for the Arizona, max8998, twl4030-power and the
  ti_am335x_tsadc drivers.
- The SSBI driver move under MFD.
- A conversion to the devm_* API for most of the MFD drivers.
- The twl4030-power got split from twl-core into its own module.
- A major ti_am335x_adc cleanup, leading to a proper DT support.
- Our regular arizona and wm* updates and cleanups from the Wolfson
  folks.
- A better error handling and initialization, and a regulator subdevice
  addition for the 88pm80x driver.
- A bulk platform_set_drvdata() call removal that's no longer need since
  commit 0998d063.

Thanks in advance for pulling this.

There are 3 fairly trivial merge conflicts with your tree and I fixed them
for reference in my mfd-3.11-merge branch.

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git tags/mfd-3.11-1

for you to fetch changes up to 25f311fa58c18c19ae1348336265ccb8368638f0:

  mfd: sec: Provide max_register to regmap (2013-07-02 00:54:39 +0200)

----------------------------------------------------------------
Alexandre Torgue (1):
      mfd: ab8500-core: Add device for new RTC version for AB8540 cut2

Arnd Bergmann (1):`
      mfd: Move ssbi driver into drivers/mfd

Chao Xie (7):
      mfd: 88pm80x: Fix driver name for 88pm800 and 88pm805
      mfd: 88pm800: Initialize mask_invert
      mfd: 88pm800: Remove the power and gpadc page addr from platform data
      mfd: 88pm800: Enhance error handling for sub pages probe/remove
      mfd: 88pm80x: Change chip id definition and detection
      mfd: 88pm800: Enhance sub devices initialization
      mfd: 88pm800: Add regulator sub device

Charles Keepax (3):
      mfd: wm5102: Manually apply register patch
      mfd: arizona: Change fast_start pdata name to better reflect functionality
      mfd: arizona: Integrate wm8997 into Arizona mfd

Fabio Baltieri (1):
      mfd: ab8500-core: Add of_compatible property for ab8500-codec

Florian Vaussard (5):
      mfd: twl4030-power: Split from twl-core into a dedicated module
      mfd: twl4030-power: Simplify probing of power scripts and resources
      mfd: twl4030-power: Start transition to DT
      mfd: twl4030-power: Simplify error path
      mfd: twl4030-power: Fix relocking on error

Geert Uytterhoeven (1):
      mfd: cros_ec: Fix Kconfig typo - s/ned/need/

Graeme Gregory (1):
      mfd: twl-core: Change TWL6025 references to TWL6032

Grygorii Strashko (1):
      mfd: twl-core: Convert to module_i2c_driver()

J Keerthy (5):
      mfd: palmas: Remove code which is not necessary for a device tree boot
      mfd: palmas: Check if irq is valid
      mfd: palmas: Add SMPS10_BOOST feature
      mfd: palmas: Add TPS659038 PMIC support
      regulator: palmas: Add TPS659038 support

James Ralston (1):
      mfd: lpc_ich: Add support for Intel Avoton SoC

Jingoo Han (9):
      mfd: intel_msic: Remove unnecessary platform_set_drvdata()
      mfd: jz4740-adc: Remove unnecessary platform_set_drvdata()
      mfd: twl4030-audio: Remove unnecessary platform_set_drvdata()
      mfd: twl4030-madc: Remove unnecessary platform_set_drvdata()
      mfd: mcp-sa11x0: Remove unnecessary platform_set_drvdata()
      mfd: t7l66xb: Remove unnecessary platform_set_drvdata()
      mfd: tc6387xb: Remove unnecessary platform_set_drvdata()
      mfd: tc6393xb: Remove unnecessary platform_set_drvdata()
      mfd: Replace strict_strtoul() with kstrtoul() in ab* and att*

Kevin Hilman (1):
      mfd: twl4030: Allow IRQ wake enable to succeed on subchip IRQs

Kevin Strasser (2):
      mfd: Kontron PLD mfd driver
      watchdog: Kontron PLD watchdog timer driver

Lars-Peter Clausen (1):
      mfd: jz4740-adc: Use clk_prepare_enable/clk_disable_unprepare

Lee Jones (19):
      mfd: ab8500-core: Drop references to ab8500-leds
      mfd: dbx500-prcmu: Use correct names for clock management registers
      mfd: ab8500-core: Add AB8500 external regulators as MFD devices
      mfd: tps65912: Convert to managed resources for allocating memory
      mfd: ab3100-otp: Convert to managed resources for allocating memory
      mfd: ab8500-debug: Convert to managed resources for allocating memory
      mfd: ab8500-gpadc: Convert to managed resources for allocating memory
      mfd: abx500-core: Convert to managed resources for allocating memory
      mfd: adp5520: Convert to managed resources for allocating memory
      mfd: asic3: Convert to managed resources for allocating memory
      mfd: cros_ec: Convert to managed resources for allocating memory
      mfd: davinci_voicecodec: Convert to managed resources for allocating memory
      mfd: htc-egpio: Convert to managed resources for allocating memory
      mfd: htc-i2cpld: Convert to managed resources for allocating memory
      mfd: htc-pasic3: Convert to managed resources for allocating memory
      mfd: janz-cmodio: Convert to managed resources for allocating memory
      mfd: max77686: Convert to managed resources for allocating memory
      mfd: max8925: Convert to managed resources for allocating memory
      mfd: 88pm860x: Convert to managed resources for allocating memory

Leon Romanovsky (1):
      mfd: sec-core: Remove explicit call to mfd_remove_devices

Libo Chen (1):
      mfd: lpc_ich: Convert to module_pci_driver

Mark Brown (12):
      mfd: arizona: Read the device identification information after boot
      mfd: arizona: Add missing cleanup on remove
      mfd: arizona: Disable interrupts during suspend
      mfd: Add device tree bindings for Arizona class devices
      mfd: arizona: Support use of external DCVDD
      mfd: wm5110: Make DSPn_STATUS_3 readable
      mfd: wm8994: Emulate level triggered interrupts if required
      mfd: wm8994: Reset device during probe
      mfd: sec: Remove fields not used since regmap conversion
      MAINTAINERS: Add include directory to MFD file patterns
      mfd: wm8994: Remove duplicate check for active JACKDET
      mfd: sec: Provide max_register to regmap

Olof Johansson (1):
      mfd: max77687: Add registration of max77686-clk

Pantelis Antoniou (2):
      iio: ti_tscadc: provide datasheet_name and scan_type
      mfd: ti_tscadc: deal with partial activation

Patil, Rachna (7):
      input: ti_am33x_tsc: Step enable bits made configurable
      input: ti_am33x_tsc: Order of TSC wires, made configurable
      input: ti_am33x_tsc: remove unwanted fifo flush
      input: ti_am33x_tsc: Add DT support
      iio: ti_am335x_adc: Add DT support
      mfd: ti_am335x_tscadc: Add DT support
      arm: am33xx: add TSC/ADC mfd device support

Pawel Moll (1):
      mfd: vexpress: Make the driver optional for arm and arm64

Roger Tseng (1):
      mfd: rtsx: Add support for RTL8411B

Sachin Kamat (3):
      mfd: 88pm860x: Use devm_regmap_init_i2c()
      mfd: davinci_voicecodec: Convert to use devm_* APIs
      mfd: davinci_voicecodec: Fix build breakage

Samuel Ortiz (5):
      MAINTAINERS: Add Lee Jones as the MFD co-maintainer
      Merge tag 'mfd-arizona-v3.10-rc2' of git://git.kernel.org/.../broonie/misc
      Merge branch 'for-mfd-next' of git://git.linaro.org/people/ljones/linux-3.0-ux500
      Merge tag 'am335x_tsc-adc' of git://breakpoint.cc/bigeasy/linux
      Merge branch 'for-mfd-next' of git://git.linaro.org/people/ljones/linux-3.0-ux500

Sebastian Andrzej Siewior (12):
      mfd: input: iio: ti_am335x_adc: use one structure for ti_tscadc_dev
      input: ti_am33x_tsc: remove platform_data support
      iio: ti_am335x_adc: remove platform_data support
      mfd: ti_am335x_tscadc: remove platform_data support
      input: mfd: ti_am335x_tsc remove remaining platform data pieces
      mfd: input: ti_am335x_tsc: rename device from tsc to TI-am335x-tsc
      mfd: iio: ti_am335x_adc: rename device from tiadc to TI-am335x-adc
      input: ti_am335x_adc: use only FIFO0 and clean up a little
      input: ti_am335x_tsc: ACK the HW_PEN irq in ISR
      input: ti_am335x_tsc: return IRQ_NONE if there was no IRQ for us
      iio: ti_am335x_adc: Allow to specify input line
      iio: ti_am335x_adc: check if we found the value

Seth Heasley (1):
      mfd: lpc_ich: iTCO_wdt patch for Intel Coleto Creek DeviceIDs

Stephen Boyd (2):
      mfd: ssbi: Add MODULE_DEVICE_TABLE
      mfd: ssbi: Use devm_* and simplify code

Tomasz Figa (3):
      mfd: max8998: Add irq domain support
      regulator: max8998: Use arrays for specifying voltages in platform data
      mfd: max8998: Add support for Device Tree

Wei Yongjun (1):
      mfd: htc-egpio: Use devm_ioremap_nocache() instead of ioremap_nocache()

Yi Zhang (2):
      mfd: 88pm800: Fix NULL pointer dereference
      mfd: 88pm800: 88pm805: Remove "IRQF_TRIGGER_FALLING" flag

 .../bindings/input/touchscreen/ti-tsc-adc.txt      |   44 +
 Documentation/devicetree/bindings/mfd/arizona.txt  |   62 +
 Documentation/devicetree/bindings/mfd/max8998.txt  |  119 ++
 .../devicetree/bindings/mfd/twl4030-power.txt      |   28 +
 .../bindings/regulator/twl-regulator.txt           |   26 +-
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |    2 +-
 MAINTAINERS                                        |    5 +-
 arch/arm/boot/dts/am335x-evm.dts                   |   14 +
 arch/arm/boot/dts/am33xx.dtsi                      |   18 +
 arch/arm/mach-exynos/mach-universal_c210.c         |    8 +-
 arch/arm/mach-s5pv210/mach-aquila.c                |    8 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    8 +-
 drivers/Kconfig                                    |    2 -
 drivers/Makefile                                   |    1 -
 drivers/iio/adc/ti_am335x_adc.c                    |  132 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |  288 ++--
 drivers/mfd/88pm800.c                              |  238 +--
 drivers/mfd/88pm805.c                              |   20 +-
 drivers/mfd/88pm80x.c                              |   47 +-
 drivers/mfd/88pm860x-core.c                        |    8 +-
 drivers/mfd/Kconfig                                |   36 +-
 drivers/mfd/Makefile                               |    6 +-
 drivers/mfd/aat2870-core.c                         |    5 +-
 drivers/mfd/ab3100-core.c                          |   28 +-
 drivers/mfd/ab3100-otp.c                           |   14 +-
 drivers/mfd/ab8500-core.c                          |   79 +-
 drivers/mfd/ab8500-debugfs.c                       |   36 +-
 drivers/mfd/ab8500-gpadc.c                         |    6 +-
 drivers/mfd/abx500-core.c                          |   10 +-
 drivers/mfd/adp5520.c                              |    8 +-
 drivers/mfd/arizona-core.c                         |  261 +++-
 drivers/mfd/arizona-i2c.c                          |   16 +-
 drivers/mfd/arizona-irq.c                          |    8 +
 drivers/mfd/arizona-spi.c                          |   10 +-
 drivers/mfd/arizona.h                              |   17 +
 drivers/mfd/asic3.c                                |   14 +-
 drivers/mfd/cros_ec.c                              |   28 +-
 drivers/mfd/davinci_voicecodec.c                   |   58 +-
 drivers/mfd/dbx500-prcmu-regs.h                    |    4 +-
 drivers/mfd/htc-egpio.c                            |   13 +-
 drivers/mfd/htc-i2cpld.c                           |   15 +-
 drivers/mfd/htc-pasic3.c                           |    4 +-
 drivers/mfd/intel_msic.c                           |    1 -
 drivers/mfd/janz-cmodio.c                          |   12 +-
 drivers/mfd/jz4740-adc.c                           |    7 +-
 drivers/mfd/kempld-core.c                          |  641 ++++++++
 drivers/mfd/lpc_ich.c                              |   30 +-
 drivers/mfd/max77686.c                             |   26 +-
 drivers/mfd/max8925-i2c.c                          |    4 +-
 drivers/mfd/max8998-irq.c                          |   65 +-
 drivers/mfd/max8998.c                              |   67 +-
 drivers/mfd/mcp-sa11x0.c                           |    3 -
 drivers/mfd/palmas.c                               |  146 +-
 drivers/mfd/rtl8411.c                              |  132 ++
 drivers/mfd/rtsx_pcr.c                             |    5 +
 drivers/mfd/rtsx_pcr.h                             |    1 +
 drivers/mfd/sec-core.c                             |   44 +-
 drivers/{ssbi => mfd}/ssbi.c                       |   70 +-
 drivers/mfd/t7l66xb.c                              |    1 -
 drivers/mfd/tc6387xb.c                             |    1 -
 drivers/mfd/tc6393xb.c                             |    1 -
 drivers/mfd/ti_am335x_tscadc.c                     |  112 +-
 drivers/mfd/tps65912-core.c                        |    2 -
 drivers/mfd/tps65912-i2c.c                         |    3 +-
 drivers/mfd/tps65912-spi.c                         |    3 +-
 drivers/mfd/twl-core.c                             |   70 +-
 drivers/mfd/twl4030-audio.c                        |    5 +-
 drivers/mfd/twl4030-irq.c                          |    1 +
 drivers/mfd/twl4030-madc.c                         |    5 +-
 drivers/mfd/twl4030-power.c                        |  148 +-
 drivers/mfd/vexpress-sysreg.c                      |   10 +-
 drivers/mfd/wm5110-tables.c                        |    8 +
 drivers/mfd/wm8994-core.c                          |   25 +-
 drivers/mfd/wm8994-irq.c                           |  100 +-
 drivers/mfd/wm8997-tables.c                        | 1525 ++++++++++++++++++++
 drivers/regulator/max8998.c                        |  227 ++-
 drivers/regulator/palmas-regulator.c               |    4 +
 drivers/regulator/twl-regulator.c                  |   76 +-
 drivers/rtc/rtc-max8998.c                          |   14 +-
 drivers/ssbi/Kconfig                               |   16 -
 drivers/ssbi/Makefile                              |    1 -
 drivers/usb/phy/phy-twl6030-usb.c                  |    2 +-
 drivers/watchdog/Kconfig                           |   11 +
 drivers/watchdog/Makefile                          |    1 +
 drivers/watchdog/kempld_wdt.c                      |  581 ++++++++
 include/linux/i2c/twl.h                            |   31 +-
 include/linux/input/ti_am335x_tsc.h                |   23 -
 include/linux/mfd/88pm80x.h                        |   17 +-
 include/linux/mfd/abx500/ab8500.h                  |    2 +
 include/linux/mfd/arizona/core.h                   |    4 +
 include/linux/mfd/arizona/pdata.h                  |    2 +-
 include/linux/mfd/arizona/registers.h              |    3 +
 include/linux/mfd/davinci_voicecodec.h             |    3 +-
 include/linux/mfd/kempld.h                         |  125 ++
 include/linux/mfd/max8998-private.h                |    7 +-
 include/linux/mfd/max8998.h                        |   20 +-
 include/linux/mfd/palmas.h                         |   14 +
 include/linux/mfd/rtsx_pci.h                       |    1 +
 include/linux/mfd/samsung/core.h                   |    6 -
 include/linux/mfd/ti_am335x_tscadc.h               |   35 +-
 include/linux/mfd/wm8994/core.h                    |    2 +
 include/linux/mfd/wm8994/pdata.h                   |    5 +
 include/linux/platform_data/ti_am335x_adc.h        |   14 -
 103 files changed, 5155 insertions(+), 1120 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/arizona.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/twl4030-power.txt
 create mode 100644 drivers/mfd/kempld-core.c
 rename drivers/{ssbi => mfd}/ssbi.c (85%)
 create mode 100644 drivers/mfd/wm8997-tables.c
 delete mode 100644 drivers/ssbi/Kconfig
 delete mode 100644 drivers/ssbi/Makefile
 create mode 100644 drivers/watchdog/kempld_wdt.c
 delete mode 100644 include/linux/input/ti_am335x_tsc.h
 create mode 100644 include/linux/mfd/kempld.h
 delete mode 100644 include/linux/platform_data/ti_am335x_adc.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
