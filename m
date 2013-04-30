Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3D3FSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:18:11 -0400
Received: from mail-gg0-f181.google.com ([209.85.161.181]:52405 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3D3FSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:18:08 -0400
Date: Mon, 29 Apr 2013 22:14:02 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20130430051402.GA22056@lizard.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6 git tree to receive changes queued for v3.10. Here
are some highlights for this merge cycle:

- OpenFirmware/DeviceTree support for the Power Supply core: the core now
  automatically populates supplied_from hierarchy from the device tree.
  With these patches chargers and batteries can now lookup each other
  without the board files support shim. Rhyland Klein at NVIDIA did the
  work;

- New ST-Ericsson ABX500 hwmon driver. The driver is heavily using the
  AB85xx core and depends on some recent changes to it, so that is why the
  driver comes through the battery tree. It has an appropriate ack from
  the hwmon maintainer (i.e. Guenter Roeck). Martin Persson at ST-Ericsson
  and Hongbo Zhang at Linaro authored the driver;

- Final bits to sync AB85xx ST-Ericsson changes into mainline. The changes
  touch mfd parts, but these were acked by the appropriate MFD maintainer
  (i.e. Samuel Ortiz). Lee Jones at Linaro did most of the work and lead
  the submission process.

Minor changes, but still worth mentioning:

- Battery temperature reporting fix for Nokia N900 phones;
- Versatile Express poweroff driver moved into drivers/power/reset/.
- Tree-wise: use devm_kzalloc() where appropriate;
- Tree-wise: dev_pm_ops cleanups/fixes.

Thanks!

Anton


The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.10

for you to fetch changes up to 6b170807cd5cac8dc6353f47a88ccb14bbf76c4f:

  pm2301-charger: Fix suspend/resume (2013-04-16 19:00:01 -0700)

----------------------------------------------------------------
Andrei Epure (1):
      charger-manager: Use kmemdup instead of kzalloc + memcpy

Andrey Gelman (1):
      test_power: Fix a bug in setting module parameter values

Anton Vorontsov (3):
      Merge branch 'for-mfd-and-power' of git://git.linaro.org/people/ljones/linux-3.0-ux500
      Merge branch 'urgent'
      Merge branch 'vexpress' of git://git.kernel.org/.../cmarinas/linux-aarch64

Catalin Marinas (2):
      arm: vexpress: Move the poweroff/restart code to drivers/power/reset
      arm: vexpress: Decouple vexpress-poweroff implementation from machine_desc

Daniel WILLERUD (1):
      mfd: ab8500-gpadc: Implemented suspend/resume

Dariusz Szymczak (1):
      mfd: ab8500-core: Hierarchical interrupt registers

Hakan Berg (3):
      ab8500-btemp: Filter btemp readings
      ab8500-fg: Allow capacity to raise from 1% when charging
      ab8500-charger: Add AB8505_USB_LINK_STATUS

Hongbo Zhang (5):
      ab8500_btemp: Make ab8500_btemp_get* interfaces public
      ab8500_bmdata: Eliminate CamelCase warning of some variables
      ab8500_{bmdata,fg}: Add const attributes to some data arrays
      ab8500_bmdata: Export abx500_res_to_temp tables for hwmon
      hwmon: Add ST-Ericsson ABX500 hwmon driver

Jingoo Han (15):
      twl4030_charger: Use module_platform_driver_probe()
      wm831x_backup: Use devm_kzalloc()
      88pm860x_charger: Drop kfree of devm_kzalloc'd data
      rx51_battery: Use devm_kzalloc()
      pcf50633-charger: Use devm_kzalloc()
      max8998_charger: Use devm_kzalloc()
      max8997_charger: Use devm_kzalloc()
      max8903_charger: Use devm_kzalloc()
      isp1704_charger: Use devm_kzalloc()
      gpio-charger: Use devm_kzalloc()
      ds2780_battery: Use devm_kzalloc()
      ds2760_battery: Use devm_kzalloc()
      da9052-battery: Use devm_kzalloc()
      da9030_battery: Use devm_kzalloc()
      max8925_power: Use devm_kzalloc()

Jonas Aaberg (3):
      mfd: ab8500-gpadc: Reread on failure
      mfd: ab8500-debug: Better error handling on crash
      mfd: ab8500-debug: Add wake-up info

Kim, Milo (1):
      lp8788-charger: Use PAGE_SIZE for the sysfs read operation

Lars-Peter Clausen (5):
      pm2301_charger: Remove __dev* annotations
      ds2782_battery: Use dev_pm_ops
      max17040_battery: Use dev_pm_ops
      sbs-battery: Use dev_pm_ops
      pm2301-charger: Fix suspend/resume

Lee Jones (33):
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

Linus Walleij (1):
      mfd: ab8500-debug: Add explicit dependencies

M BenZoubeir (1):
      pm2301-charger: Adjust interrupt handler behavior

Marcus Cooper (4):
      pm2301-charger: Always compile the PM2301 Charger driver with AB8500 Battery Mgnt
      ab8500-charger: Use USBLink1Status Register
      ab8500-charger: Add UsbLineCtrl2 reference
      ab8500-bm: Trivially fix up some incorrect and out-of-date comments

Marcus Danielsson (1):
      mfd: ab8500-sysctrl: Error check clean up

Martin Bergstrom (1):
      ab8500-fg: Report unscaled capacity

Mattias Wallin (2):
      mfd: ab8500-debug: Print banks in hex
      mfd: ab8500-core: Show turn on status at boot

Mustapha Ben Zoubeir (1):
      pm2301-charger: Resolve I2C detection problem on ab9540

Pali Rohár (1):
      rx51_battery: Fix reporting temperature

Per Forlin (1):
      pm2301-charger: Force main charger detect

Rabin Vincent (2):
      mfd: ab8500-sysctrl: AB8505 doesn't have SYSCLKREQ5..8
      ab8500-charger: Run detect workaround only on AB8500

Rajkumar Kasirajan (2):
      mfd: ab8500-sysctrl: Update correct turn on status
      pm2301-charger: Enable SW EOC control on the ab9540

Rhyland Klein (7):
      power_supply: Add OF bindings documentation for tps65090-charger
      power_supply: Add support for tps65090-charger
      tps65090: Update bindings for subnode
      tps65090: Setup compatible property for dt
      power_supply: Define Binding for power-supplies
      power_supply: Add core support for supplied_from
      power_supply: Populate supplied_from hierarchy from the device tree

Rupesh Kumar (8):
      pm2301-charger: Support for over voltage protection on the ab9540
      pm2301-charger: Die temp thermal protection
      pm2301-charger: Wake system when ext charger is plugged-in
      ab8500-btemp: Defer btemp filtering while initialising
      pm2301-charger: Removed unused code from PM2301 driver
      pm2301-charger: Charging LED control for pm2301
      pm2301-charger: Wake device on register access
      pm2301-charger: Reference put missing after access

Sachin Kamat (1):
      sbs-battery: Use of_match_ptr() macro

Silviu-Mihai Popescu (1):
      goldfish_battery: Use resource_size()

Syam Sidhardhan (1):
      s3c-adc-battery: Fix possible NULL pointer dereference

Ulf Hansson (1):
      mfd: ab8500-core: Add abx500-clk as an mfd child device

Yang QU (1):
      ab8500-charger: Add backup battery charge voltages on the ab8540

lme00437 (2):
      pm2301-charger: lpn pin used only in C2C boards
      ab8500-fg: Change current calculation

srinidhi kasagar (2):
      mfd: ab8500-debug: Convert to kstrtoul_from_user
      abx500-chargalg: Use module_platform_driver() rather

 .../bindings/power_supply/power_supply.txt         |   23 +
 .../devicetree/bindings/power_supply/tps65090.txt  |   17 +
 Documentation/hwmon/ab8500                         |   22 +
 Documentation/hwmon/abx500                         |   28 +
 arch/arm/mach-vexpress/Kconfig                     |    3 +
 arch/arm/mach-vexpress/Makefile                    |    2 +-
 arch/arm/mach-vexpress/v2m.c                       |    5 -
 drivers/hwmon/Kconfig                              |   13 +
 drivers/hwmon/Makefile                             |    1 +
 drivers/hwmon/ab8500.c                             |  206 ++
 drivers/hwmon/abx500.c                             |  491 ++++
 drivers/hwmon/abx500.h                             |   69 +
 drivers/mfd/ab8500-core.c                          |  544 +++--
 drivers/mfd/ab8500-debugfs.c                       | 2559 +++++++++++++++-----
 drivers/mfd/ab8500-gpadc.c                         |  559 ++++-
 drivers/mfd/ab8500-sysctrl.c                       |   98 +-
 drivers/power/88pm860x_charger.c                   |    2 -
 drivers/power/Kconfig                              |   14 +-
 drivers/power/Makefile                             |    4 +-
 drivers/power/ab8500_bmdata.c                      |  140 +-
 drivers/power/ab8500_btemp.c                       |   80 +-
 drivers/power/ab8500_charger.c                     |  699 ++++--
 drivers/power/ab8500_fg.c                          |  501 +++-
 drivers/power/abx500_chargalg.c                    |  455 +++-
 drivers/power/charger-manager.c                    |    3 +-
 drivers/power/da9030_battery.c                     |    6 +-
 drivers/power/da9052-battery.c                     |    5 +-
 drivers/power/ds2760_battery.c                     |    4 +-
 drivers/power/ds2780_battery.c                     |    7 +-
 drivers/power/ds2782_battery.c                     |   23 +-
 drivers/power/goldfish_battery.c                   |    2 +-
 drivers/power/gpio-charger.c                       |    5 +-
 drivers/power/isp1704_charger.c                    |    5 +-
 drivers/power/lp8788-charger.c                     |    8 +-
 drivers/power/max17040_battery.c                   |   20 +-
 drivers/power/max8903_charger.c                    |    4 +-
 drivers/power/max8925_power.c                      |    5 +-
 drivers/power/max8997_charger.c                    |    9 +-
 drivers/power/max8998_charger.c                    |    5 +-
 drivers/power/pcf50633-charger.c                   |    7 +-
 drivers/power/pm2301_charger.c                     |  391 ++-
 drivers/power/pm2301_charger.h                     |   23 +-
 drivers/power/power_supply_core.c                  |  187 +-
 drivers/power/reset/Kconfig                        |    7 +
 drivers/power/reset/Makefile                       |    3 +-
 .../power/reset/vexpress-poweroff.c                |    9 +-
 drivers/power/rx51_battery.c                       |    8 +-
 drivers/power/s3c_adc_battery.c                    |    7 +-
 drivers/power/sbs-battery.c                        |   22 +-
 drivers/power/test_power.c                         |   31 +-
 drivers/power/tps65090-charger.c                   |  320 +++
 drivers/power/twl4030_charger.c                    |   12 +-
 drivers/power/wm831x_backup.c                      |   10 +-
 include/linux/mfd/abx500.h                         |   27 +-
 include/linux/mfd/abx500/ab8500-bm.h               |   61 +-
 include/linux/mfd/abx500/ab8500-gpadc.h            |   74 +-
 include/linux/mfd/abx500/ab8500-sysctrl.h          |    6 +
 include/linux/mfd/abx500/ab8500.h                  |    3 +
 include/linux/mfd/abx500/ux500_chargalg.h          |    7 +
 include/linux/mfd/tps65090.h                       |    5 +
 include/linux/pm2301_charger.h                     |    2 +-
 include/linux/power/ab8500.h                       |   16 +
 include/linux/power_supply.h                       |    6 +
 include/linux/vexpress.h                           |    3 -
 64 files changed, 6393 insertions(+), 1500 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/power_supply.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/tps65090.txt
 create mode 100644 Documentation/hwmon/ab8500
 create mode 100644 Documentation/hwmon/abx500
 create mode 100644 drivers/hwmon/ab8500.c
 create mode 100644 drivers/hwmon/abx500.c
 create mode 100644 drivers/hwmon/abx500.h
 rename arch/arm/mach-vexpress/reset.c => drivers/power/reset/vexpress-poweroff.c (93%)
 create mode 100644 drivers/power/tps65090-charger.c
 create mode 100644 include/linux/power/ab8500.h
