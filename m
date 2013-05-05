Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3EEXPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 19:15:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:15088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab3EEXO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 19:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,617,1363158000"; 
   d="scan'208";a="332897749"
Date: Mon, 6 May 2013 01:14:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [GIT] [3.10] MFD pull request
Message-ID: <20130505231451.GO4563@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 3.10 merge window. There is one merge
conflict with your tree, and I fixed it for reference in my mfd-3.10-merge
branch.

For 3.10 we have a few new MFD drivers for:

- The ChromeOS embedded controller which provides keyboard, battery and power
  management services. This controller is accessible through i2c or SPI.

- Silicon Laboratories 476x controller, providing access to their FM chipset
  and their audio codec.

- Realtek's RTS5249, a memory stick, MMC and SD/SDIO PCI based reader.

- Nokia's Tahvo power button and watchdog device. This device is very similar
  to Retu and is thus supported by the same code base.

- STMicroelectronics STMPE1801, a keyboard and GPIO controller supported by
  the stmpe driver.

- ST-Ericsson AB8540 and AB8505 power management and voltage converter
  controllers through the existing ab8500 code.

Some other drivers got cleaned up or improved. In particular:

- The Linaro/STE guys got the ab8500 driver in sync with their internal code
  through a series of optimizations, fixes and improvements.

- The AS3711 and OMAP USB drivers now have DT support.

- The arizona clock and interrupt handling code got improved.

- The wm5102 register patch and boot mechanism also got improved.

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git tags/mfd-3.10-1

for you to fetch changes up to 99f4c6b66a9ae362d21e6df95d04bc74e04d285e:

  mfd: si476x: Don't use 0bNNN (2013-04-26 17:23:30 +0200)

----------------------------------------------------------------
Aaro Koskinen (1):
      mfd: retu: Add Tahvo support

Alessandro Rubini (1):
      mfd: sta2x11: Build warning fix

Alexander Shiyan (4):
      mfd: syscon: Removed unneeded field "dev" from private driver structure
      mfd: syscon: Add non-DT support
      of: Add stub of_get_parent for non-OF builds
      mfd: syscon: Fix warnings when printing resource_size_t

Andrew Morton (1):
      mfd: si476x: Don't use 0bNNN

Andrey Smirnov (4):
      mfd: si476x: Add commands abstraction layer
      mfd: si476x: Add the bulk of the core driver
      mfd: si476x: Add chip properties handling code
      mfd: si476x: Add header files and Kbuild plumbing

Arnd Bergmann (2):
      ARM: ux500: split out prcmu initialization
      mfd: ab8500: Export ab8500_gpadc_sw_hw_convert properly

Ashish Jangam (1):
      mfd: da9055: Change irq state to default

Charles Keepax (7):
      mfd: wm5102: Manually apply register patch
      mfd: arizona: Factor out register polling
      mfd: arizona: Add a hardware patch mechanism
      mfd: wm5102: Deactivate standard boot sequence
      mfd: wm5102: Update defaults to match patch
      mfd: arizona: Wait for internal clocks to startup after reset
      mfd: wm5102: Don't wait for boot when boot sequencer is disabled

Daniel WILLERUD (1):
      mfd: ab8500-gpadc: Implemented suspend/resume

Dariusz Szymczak (1):
      mfd: ab8500-core: Hierarchical interrupt registers

David Rientjes (1):
      mfd: cros_ec: Add MFD_CORE dependency

Fabio Baltieri (2):
      mfd: ab8500-core: Ignore masked out interrupts
      mfd: ab8500-core: Add of_compatilbe property for ab8500-usb

Gabriel Fernandez (2):
      mfd: stmpe: DT: Enable no-irq mode configuration
      mfd: stmpe: DT: Add stmpe-i2c dt alias to get id device

Guennadi Liakhovetski (1):
      mfd: as3711: Add OF support

Hakan Berg (3):
      ab8500-btemp: Filter btemp readings
      ab8500-fg: Allow capacity to raise from 1% when charging
      ab8500-charger: Add AB8505_USB_LINK_STATUS

Hans Verkuil (1):
      mfd: si476x: Fix i2c warning

Ian Lartey (1):
      mfd: palmas: is_palmas_charger needed by multiple drivers

J Keerthy (1):
      mfd: palmas: Change the DT node property names to follow the convention

Jean-Nicolas Graux (1):
      mfd: support stmpe1801 18 bits enhanced port expander

Jingoo Han (19):
      mfd: ab3100-otp: use module_platform_driver_probe()
      mfd: htc-pasic3: use module_platform_driver_probe()
      mfd: davinci_voicecodec: use module_platform_driver_probe()
      mfd: wm8994: Silence bogus warning in wm8994_device_init()
      mfd: 88pm860x: Drop devm_kfree of devm_kzalloc'd data
      mfd: lm3533: Use devm_gpio_request_one()
      mfd: intel_msic: Use devm_gpio_request_one()
      mfd: omap-usb-host: Use devm_gpio_request_one()
      mfd: aat2870: Use use devm_*() functions
      mfd: twl6040: Use devm_*() functions
      mfd: ezx-pcap: Use devm_*() functions
      mfd: da903x: Use devm_*() functions
      mfd: tc3589x: Use devm_*() functions
      mfd: wm831x: Use spi_get_drvdata() and spi_set_drvdata()
      mfd: da9052: Use spi_get_drvdata() and spi_set_drvdata()
      mfd: ezx-pcap: Use spi_get_drvdata() and spi_set_drvdata()
      mfd: mc13xxx: Use spi_get_drvdata() and spi_set_drvdata()
      mfd: arizona: Use spi_get_drvdata()
      mfd: stmpe: Use spi_get_drvdata()

Jiri Slaby (1):
      MFD: rtsx_pcr: Fix probe fail path

Jonas Aaberg (3):
      mfd: ab8500-gpadc: Reread on failure
      mfd: ab8500-debug: Better error handling on crash
      mfd: ab8500-debug: Add wake-up info

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume

Laxman Dewangan (1):
      mfd: palmas: Initialise client->of_node for dummy created client

Lee Jones (35):
      mfd: ab8500-gpadc: Add gpadc hw conversion
      mfd: ab8500-core: APE Interrupts are not cleared
      mfd: ab8500-debug: Function to save all ABB registers to mem
      mfd: ab8500-core: Add ADC support for ab8540
      mfd: ab8500-core: Rework MFD sub-device initialisation structures
      mfd: ab8500-core: Add Interrupt support for ab8540
      mfd: ab8500-debugfs: Add tests for ab8540 based platform initialisations
      mfd: ab8500-debug: Add support for ab8505 and ab9540
      mfd: ab8500-sysctrl: Add new reset function
      mfd: ab8500-gpadc: Add support for the AB8540
      mfd: ab8500-debug: Add support for the AB8540
      mfd: ab8500-gpadc: Optimise GPADC driver
      mfd: ab8500-core: Add additional resources to ab8505_iddet_resources
      mfd: ab8500-debugfs: Dump sim registers
      mfd: ab8500-debug: Add ADC input channel usb_id in debugfs
      mfd: ab8500-debugfs: Change AB8500 debug permissions
      mfd: ab8500-debug: Add register map for ab8540.
      mfd: ab8500-debugfs: Trivially beautify the debugfs driver
      pm2301_charger: Remove __exit, __init and __devexit_p()
      abx500-chargalg: Store the AB8500 MFD parent device for platform differentiation
      ab8500-fg: Add power cut feature for ab8505 and ab8540
      ab8500-charger: Trivial coding style changes
      ab8500-bm: Quick re-attach charging behaviour
      ab8500-bm: Charge only mode fixes for the ab9540
      ab8500_charger: Prevent auto drop of VBUS
      ab8500-bm: Add usb power path support
      ab8500-bm: Add support for the new ab8540 platform
      abx500-chargalg: Prevent the watchdog from being kicked twice
      ab8500-chargalg: Use hrtimer
      pm2301-charger: Add pm_runtime_resume & pm_runtime_suspend
      ab8500-charger: Remove duplicate code
      abx500-chargalg: Add charging current step interface
      ab8500-charger: Do not use [delayed_]work_pending()
      mfd: db8500-prcmu: Return early if the TCPM cannot be located
      mfd: db8500-prcmu: Support platform dependant device selection

Linus Walleij (6):
      mfd: ab8500-debug: Add explicit dependencies
      mfd: abx500: Move the AB8500 Kconfig fragment
      mfd: prcmu: pass a base and size with the early initcall
      mfd: db8500-prcmu: get base address from resource
      ARM: ux500: move PM-related PRCMU functions to machine
      mfd: db8500-prcmu: drop unused includes

M BenZoubeir (1):
      pm2301-charger: Adjust interrupt handler behavior

Marcus Cooper (4):
      pm2301-charger: Always compile the PM2301 Charger driver with AB8500 Battery Mgnt
      ab8500-charger: Use USBLink1Status Register
      ab8500-charger: Add UsbLineCtrl2 reference
      ab8500-bm: Trivially fix up some incorrect and out-of-date comments

Marcus Danielsson (1):
      mfd: ab8500-sysctrl: Error check clean up

Marek Vasut (1):
      mfd: ucb1400: Pass ucb1400-gpio data through ac97 bus

Mark Brown (17):
      mfd: arizona: Disable all wake sources by default
      mfd: arizona: Clean up on failed runtime resume
      mfd: arizona: Clarify error message for failed primary IRQ request
      mfd: arizona: Basic support for edge triggered IRQs
      mfd: arizona: Allow GPIO to be specified for IRQ line
      mfd: arizona: Try to use interrupt flags from interrupt controller
      mfd: arizona: Support configuring MICBIASes into bypass mode
      mfd: wm5102: Update patch for latest evaluation
      mfd: arizona: Fully support the use of MCLK1 as the 32kHz clock source
      mfd: arizona: Unconditionally enable 32kHz clock
      mfd: wm5102: Only use the lowest three bits of device revision
      mfd: arizona: Hold device in reset while ramping supplies
      mfd: arizona: Define additional FLL control registers
      mfd: wm5102: Map in additional FLL control registers
      mfd: wm8994: Don't use system PM operations
      mfd: wm8994: Add device ID data to WM8994 OF device IDs
      mfd: wm8994: Add some OF properties

Martin Bergstrom (1):
      ab8500-fg: Report unscaled capacity

Mattias Wallin (2):
      mfd: ab8500-debug: Print banks in hex
      mfd: ab8500-core: Show turn on status at boot

Michal Marek (1):
      input: Export matrix_keypad_parse_of_params()

Mustapha Ben Zoubeir (1):
      pm2301-charger: Resolve I2C detection problem on ab9540

Pali Rohár (2):
      mfd: twl4030-madc: Add support for raw value in twl4030_madc_conversion
      power: rx51_battery: Fix reporting correct values

Paul Bolle (2):
      mfd: da9055: Drop "select PMIC_DA9055"
      mfd: Remove twelve unused Kconfig symbols

Pawel Moll (2):
      mfd: vexpress: Give the "leds-gpio" device a real parent
      mfd: vexpress: Handle pending config transactions

Per Forlin (1):
      pm2301-charger: Force main charger detect

Rabin Vincent (2):
      mfd: ab8500-sysctrl: AB8505 doesn't have SYSCLKREQ5..8
      ab8500-charger: Run detect workaround only on AB8500

Rajkumar Kasirajan (2):
      mfd: ab8500-sysctrl: Update correct turn on status
      pm2301-charger: Enable SW EOC control on the ab9540

Rhyland Klein (3):
      mfd: tps65090: Fix enum in header file
      mfd: tps65090: Add resources for charger
      mfd: tps65090: Add compatible string for charger subnode

Roger Quadros (5):
      mfd: omap-usb-host: Update nports in platform_data
      mfd: omap-usb-tll: Move configuration code to omap_tll_init()
      mfd: omap-usb-tll: Add device tree support and binding information
      mfd: omap-usb-host: Remove PHY reset handling code
      mfd: omap-usb-host: Add device tree support and binding information

Rupesh Kumar (8):
      pm2301-charger: Support for over voltage protection on the ab9540
      pm2301-charger: Die temp thermal protection
      pm2301-charger: Wake system when ext charger is plugged-in
      ab8500-btemp: Defer btemp filtering while initialising
      pm2301-charger: Removed unused code from PM2301 driver
      pm2301-charger: Charging LED control for pm2301
      pm2301-charger: Wake device on register access
      pm2301-charger: Reference put missing after access

Sachin Kamat (4):
      mfd: adp5520: Use module_i2c_driver()
      mfd: max77686: Use NULL instead of 0
      mfd: omap-usb-host: Convert to devm_ioremap_resource()
      mfd: omap-usb-tll: Convert to devm_ioremap_resource()

Samuel Ortiz (5):
      mfd: cros_ec: Export needed symbols for the i2c and spi modules
      mfd: cros_ec_spi: Warnings fix
      Merge branch 'for-mfd-and-power' of git://git.linaro.org/people/ljones/linux-3.0-ux500
      Merge tag 'ux500-multiplatform-mfd' of git://git.kernel.org/.../linusw/linux-stericsson
      mfd: Kconfig alphabetical re-ordering

Simon Glass (6):
      mfd: Add ChromeOS EC messages header
      mfd: Add ChromeOS EC implementation
      mfd: Add ChromeOS EC I2C driver
      mfd: Add ChromeOS EC SPI driver
      input: matrix-keymap: Add function to read the new DT binding
      input: Add ChromeOS EC keyboard driver

Sylwester Nawrocki (1):
      mfd: syscon: Add missing struct device_node declaration

Ulf Hansson (2):
      mfd: ab8500-core: Add abx500-clk as an mfd child device
      mfd: ab8500: sysctrl: Initialize driver at arch_initcall

Wei WANG (1):
      mfd: rtsx: Support RTS5249

Yang QU (1):
      ab8500-charger: Add backup battery charge voltages on the ab8540

lme00437 (2):
      pm2301-charger: lpn pin used only in C2C boards
      ab8500-fg: Change current calculation

srinidhi kasagar (2):
      mfd: ab8500-debug: Convert to kstrtoul_from_user
      abx500-chargalg: Use module_platform_driver() rather

 .../devicetree/bindings/input/cros-ec-keyb.txt     |   72 +
 Documentation/devicetree/bindings/mfd/as3711.txt   |   73 +
 Documentation/devicetree/bindings/mfd/cros-ec.txt  |   56 +
 .../devicetree/bindings/mfd/omap-usb-host.txt      |   80 +
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |   17 +
 Documentation/devicetree/bindings/sound/wm8994.txt |   58 +-
 arch/arm/mach-imx/Kconfig                          |    2 -
 arch/arm/mach-s3c64xx/Kconfig                      |    3 -
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    4 +-
 arch/arm/mach-ux500/Makefile                       |    2 +-
 arch/arm/mach-ux500/board-mop500.c                 |   58 -
 arch/arm/mach-ux500/cpu-db8500.c                   |    2 -
 arch/arm/mach-ux500/cpu.c                          |   21 +-
 arch/arm/mach-ux500/cpuidle.c                      |    3 +-
 arch/arm/mach-ux500/devices-db8500.c               |    2 +
 arch/arm/mach-ux500/include/mach/hardware.h        |    2 -
 arch/arm/mach-ux500/include/mach/irqs-db8500.h     |   25 -
 arch/arm/mach-ux500/pm.c                           |  167 ++
 drivers/gpio/gpio-ucb1400.c                        |   19 +-
 drivers/input/keyboard/Kconfig                     |   12 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/cros_ec_keyb.c              |  334 +++
 drivers/input/keyboard/lpc32xx-keys.c              |   11 +-
 drivers/input/keyboard/omap4-keypad.c              |   16 +-
 drivers/input/keyboard/tca8418_keypad.c            |    7 +-
 drivers/input/matrix-keymap.c                      |   20 +
 drivers/mfd/88pm860x-core.c                        |   12 +-
 drivers/mfd/Kconfig                                | 1620 ++++++-------
 drivers/mfd/Makefile                               |    9 +-
 drivers/mfd/aat2870-core.c                         |   20 +-
 drivers/mfd/ab3100-otp.c                           |   14 +-
 drivers/mfd/ab8500-core.c                          |  572 +++--
 drivers/mfd/ab8500-debugfs.c                       | 2559 +++++++++++++++-----
 drivers/mfd/ab8500-gpadc.c                         |  561 ++++-
 drivers/mfd/ab8500-sysctrl.c                       |  100 +-
 drivers/mfd/adp5520.c                              |   20 +-
 drivers/mfd/arizona-core.c                         |  267 +-
 drivers/mfd/arizona-irq.c                          |  106 +-
 drivers/mfd/arizona-spi.c                          |    2 +-
 drivers/mfd/as3711.c                               |   27 +-
 drivers/mfd/cros_ec.c                              |  196 ++
 drivers/mfd/cros_ec_i2c.c                          |  201 ++
 drivers/mfd/cros_ec_spi.c                          |  375 +++
 drivers/mfd/da903x.c                               |   19 +-
 drivers/mfd/da9052-spi.c                           |    4 +-
 drivers/mfd/da9055-core.c                          |    2 +-
 drivers/mfd/davinci_voicecodec.c                   |   12 +-
 drivers/mfd/db8500-prcmu.c                         |  388 +--
 drivers/mfd/dbx500-prcmu-regs.h                    |  204 +-
 drivers/mfd/ezx-pcap.c                             |   21 +-
 drivers/mfd/htc-pasic3.c                           |   13 +-
 drivers/mfd/intel_msic.c                           |   10 +-
 drivers/mfd/lm3533-core.c                          |    8 +-
 drivers/mfd/max77686.c                             |    2 +-
 drivers/mfd/mc13xxx-spi.c                          |    6 +-
 drivers/mfd/omap-usb-host.c                        |  209 +-
 drivers/mfd/omap-usb-tll.c                         |  219 +-
 drivers/mfd/omap-usb.h                             |    5 +-
 drivers/mfd/palmas.c                               |    7 +-
 drivers/mfd/retu-mfd.c                             |   85 +-
 drivers/mfd/rts5249.c                              |  241 ++
 drivers/mfd/rtsx_pcr.c                             |   11 +-
 drivers/mfd/rtsx_pcr.h                             |    1 +
 drivers/mfd/si476x-cmd.c                           | 1553 ++++++++++++
 drivers/mfd/si476x-i2c.c                           |  886 +++++++
 drivers/mfd/si476x-prop.c                          |  241 ++
 drivers/mfd/sta2x11-mfd.c                          |   11 -
 drivers/mfd/stmpe-i2c.c                            |    1 +
 drivers/mfd/stmpe-spi.c                            |    2 +-
 drivers/mfd/stmpe.c                                |  105 +-
 drivers/mfd/stmpe.h                                |   49 +
 drivers/mfd/syscon.c                               |   80 +-
 drivers/mfd/tc3589x.c                              |   21 +-
 drivers/mfd/tps65090.c                             |   11 +
 drivers/mfd/twl4030-madc.c                         |   14 +-
 drivers/mfd/twl6040.c                              |   31 +-
 drivers/mfd/ucb1400_core.c                         |    5 +
 drivers/mfd/vexpress-config.c                      |   35 +-
 drivers/mfd/vexpress-sysreg.c                      |    4 +-
 drivers/mfd/wm5102-tables.c                        |   64 +-
 drivers/mfd/wm831x-spi.c                           |    6 +-
 drivers/mfd/wm8994-core.c                          |   88 +-
 drivers/power/Kconfig                              |    7 -
 drivers/power/Makefile                             |    3 +-
 drivers/power/ab8500_bmdata.c                      |   96 +-
 drivers/power/ab8500_btemp.c                       |   75 +-
 drivers/power/ab8500_charger.c                     |  699 ++++--
 drivers/power/ab8500_fg.c                          |  497 +++-
 drivers/power/abx500_chargalg.c                    |  455 +++-
 drivers/power/pm2301_charger.c                     |  371 ++-
 drivers/power/pm2301_charger.h                     |   23 +-
 drivers/power/rx51_battery.c                       |    1 +
 include/linux/i2c/twl4030-madc.h                   |    2 +
 include/linux/input/matrix_keypad.h                |   19 +
 include/linux/mfd/abx500.h                         |   21 +-
 include/linux/mfd/abx500/ab8500-bm.h               |   60 +-
 include/linux/mfd/abx500/ab8500-gpadc.h            |   74 +-
 include/linux/mfd/abx500/ab8500-sysctrl.h          |    6 +
 include/linux/mfd/abx500/ab8500.h                  |    3 +
 include/linux/mfd/abx500/ux500_chargalg.h          |    7 +
 include/linux/mfd/arizona/pdata.h                  |    7 +-
 include/linux/mfd/arizona/registers.h              |   40 +
 include/linux/mfd/cros_ec.h                        |  170 ++
 include/linux/mfd/cros_ec_commands.h               | 1369 +++++++++++
 include/linux/mfd/db8500-prcmu.h                   |   10 +-
 include/linux/mfd/dbx500-prcmu.h                   |   38 +-
 include/linux/mfd/palmas.h                         |   12 +-
 include/linux/mfd/retu.h                           |    8 +-
 include/linux/mfd/rtsx_pci.h                       |   36 +
 include/linux/mfd/si476x-core.h                    |  533 ++++
 include/linux/mfd/si476x-platform.h                |  267 ++
 include/linux/mfd/si476x-reports.h                 |  163 ++
 include/linux/mfd/stmpe.h                          |    3 +
 include/linux/mfd/syscon.h                         |    3 +
 include/linux/mfd/tps65090.h                       |    1 +
 include/linux/of.h                                 |    5 +
 include/linux/platform_data/arm-ux500-pm.h         |   21 +
 include/linux/pm2301_charger.h                     |    2 +-
 include/linux/ucb1400.h                            |   18 +-
 119 files changed, 14380 insertions(+), 3147 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/cros-ec-keyb.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/as3711.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/cros-ec.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-host.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
 create mode 100644 arch/arm/mach-ux500/pm.c
 create mode 100644 drivers/input/keyboard/cros_ec_keyb.c
 create mode 100644 drivers/mfd/cros_ec.c
 create mode 100644 drivers/mfd/cros_ec_i2c.c
 create mode 100644 drivers/mfd/cros_ec_spi.c
 create mode 100644 drivers/mfd/rts5249.c
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/cros_ec.h
 create mode 100644 include/linux/mfd/cros_ec_commands.h
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/linux/mfd/si476x-platform.h
 create mode 100644 include/linux/mfd/si476x-reports.h
 create mode 100644 include/linux/platform_data/arm-ux500-pm.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
