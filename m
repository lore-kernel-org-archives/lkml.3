Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3IEVwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:52:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:48928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab3IEVwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:52:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,849,1371106800"; 
   d="scan'208";a="291372046"
Date: Thu, 5 Sep 2013 23:51:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [GIT] [3.12] MFD pull request
Message-ID: <20130905215142.GA12248@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 3.12 merge window.

This time we have one new driver for the DA9063 PMIC from Dialog Semiconductor.

Besides that driver we also have:

- Device tree support for the s2mps11 driver
- More devm_* conversion for the pm8921, max89xx, menelaus, tps65010,
  wl1273 and pcf50633-adc drivers.
- A conversion to threaded IRQ and IRQ domain for the twl6030 driver.
- A fairly big update for the rtsx driver: Better power saving support,
  better vendor settings handling, and a few fixes.
- Support for a couple more boards (COMe-bHL6 and COMe-cTH6) for the
  Kontron driver.
- A conversion to the dev_get_platdata() API for all MFD drivers.
- A removal of non-DT (legacy) support for the twl6040 driver.
- A few fixes and additions (Mic detect level) to the wm5110 register
  tables.
- Regmap support for the davinci_voicecodec driver.
- The usual bunch of minor cleanups and janitorial fixes.

Thanks in advance for pulling this.

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git tags/mfd-3.12-1

for you to fetch changes up to 9c31e8840836de447e1e508a6d756af419790ed6:

  Merge tag 'mfd-lee-3.12-2' of git://git.linaro.org/people/ljones/mfd (2013-09-02 11:46:00 +0200)

----------------------------------------------------------------
Alexander Shiyan (1):
      mfd: syscon: Remove "base" field from private driver data

Andrea Adami (2):
      mfd: mcp: Add missing linux/device.h header
      mfd: ucb1x00: Explicitely include linux/device.h

Ankur Raina (2):
      mfd: Fix for DA9055 driver initialization
      mfd: Update DA9055 i2c device id name

Benedikt Spranger (1):
      mfd: core: Copy DMA mask and params from parent

Bill Huang (1):
      mfd: palmas: Add power off control

Chao Xie (2):
      mfd: 88pm800: Fix potential NULL pdata dereference
      mfd: 88pm805: Fix potential NULL pdata dereference

Charles Keepax (5):
      mfd: arizona: Move regulator disable to after marking cache only
      mfd: wm5110: Mark register containing FLL gains as readable
      mfd: wm5110: Add mic detect level registers
      mfd: wm5110: Add missing Mic Detect 3 register into defaults
      mfd: wm5110: Set FX_CTRL2 to volatile

Grygorii Strashko (3):
      mfd: twl6030-irq: Add error check when IRQs are masked initially
      mfd: twl6030-irq: Convert to use linear irq_domain
      mfd: twl6030-irq: Create struct twl6030_irq

J Keerthy (1):
      mfd: Add TPS659038 documentation under Palmas

Jingoo Han (17):
      mfd: Use dev_get_platdata()
      mfd: max8997: Cast void pointer to data of max8997_pmic_dt_match
      mfd: lpc_ich: Staticize struct 'lpc_chipset_info'
      mfd: twl4030-power: Staticize local functions
      mfd: menelaus: Use NULL instead of 0
      MFD: ucb1x00-core: Add CONFIG_PM_SLEEP to suspend/resume
      mfd: ab8500-gpadc: Add CONFIG_PM_RUNTIME to runtime_suspend/runtime_resume
      mfd: ab8500-gpadc: Add CONFIG_PM_SLEEP to suspend/resume
      mfd: pm8921: Include missing linux/module.h
      mfd: pm8921: Remove unnecessary platform_set_drvdata()
      mfd: pm8921: Use devm_*() functions
      mfd: max8997: Use devm_*() functions
      mfd: max8998: Use devm_*() functions
      mfd: menelaus: Use devm_*() functions
      mfd: tps65010: Use devm_*() functions
      mfd: wl1273: Use devm_*() functions
      mfd: pcf50633-adc: Use devm_*() functions

Krystian Garbaciak (3):
      mfd: da9063: Add register definitions for DA9063 driver
      mfd: da9063: Add Dialog DA9063 core driver
      mfd: da9063: Add IRQ support

Laxman Dewangan (1):
      mfd: palmas: Add support for external control configuration

Lee Jones (3):
      mfd: ab8500-debugfs: Apply a check for -ENOMEM after allocating memory for sysfs
      mfd: ab8500-debugfs: Apply a check for -ENOMEM after allocating memory for event name
      mfd: ucb1x00-core: Rewrite ucb1x00_add_dev()

Mark Brown (10):
      mfd: sec: Add register cache for interrupt mask registers
      mfd: wm8997: Make Kconfig prompt for WM8997 more consistent
      mfd: wm8994: Remove unneeded check for JACKDET
      mfd: wm8994: Remove check for active audio in runtime suspend
      mfd: wm831x: Remove erronious bits per word set
      mfd: stmpe: Staticise stmpe_of_probe()
      mfd: tps65010: Use power efficient workqueue for power polling
      mfd: davinci_voicecodec: Remove unused read and write functions
      mfd: davinci_voicecodec: Provide a regmap for register I/O
      mfd: twl6040: Use regmap for register cache

Michael Brunner (1):
      mfd: Add support for COMe-bHL6 and COMe-cTH6 to Kontron PLD driver

Naga Venkata Srikanth V (1):
      mfd: twl6030-irq: Migrate to IRQ threaded handler

Oleksandr Dmytryshyn (1):
      mfd: twl6030-irq: Add interrupt mapping table for the twl6032

Patil, Rachna (2):
      MFD: ti_tscadc: ADC Clock check not required
      MFD: ti_tscadc: Disable TSC config registers in adc mode

Peter Ujfalusi (3):
      mfd: twl6040: Remove support for legacy (pdata) mode
      mfd: twl6040: Cosmetic, parameter alignment change
      mfd: twl6040: Cleanup in early error handling in probe function

Philipp Zabel (3):
      regmap: irq: Allow to acknowledge masked interrupts during initialization
      regmap: irq: make flags bool and put them in a bitfield
      regmap: irq: document mask/wake_invert flags

Sachin Kamat (7):
      mfd: omap-usb-host: Staticize usbhs_driver_name
      mfd: db8500-prcmu: Use ANSI function declaration
      mfd: db8500-prcmu: Staticize clk_mgt
      mfd: ab8500-debugfs: Staticize local variables
      mfd: timberdale: Staticize local variables
      mfd: timberdale: Remove redundant break
      mfd: timberdale: Use module_pci_driver

Samuel Ortiz (4):
      Merge tag 'regmap-irq-ack-mask' of git://git.kernel.org/.../broonie/regmap
      Merge tag 'mfd-lee-3.12-1' of git://git.linaro.org/people/ljones/mfd
      Merge branch 'topic/for-asoc'
      Merge tag 'mfd-lee-3.12-2' of git://git.linaro.org/people/ljones/mfd

Wei WANG (9):
      mfd: rtsx: Read vendor setting from config space
      mfd: rtsx: Add shutdown callback in rtsx_pci_driver
      mfd: rtsx: Move some actions from rtsx_pci_init_hw to individual extra_init_hw
      mfd: rtsx: Clear hardware PFM mode in rtl8411b
      mfd: rtsx: Configure to enter a deeper power-saving mode in S3
      mfd: rtsx: Copyright modifications
      mfd: mmc: rtsx: Change default tx phase
      mmc: rtsx: Clear SD_CLK toggle enable bit if switching voltage fail
      mmc: memstick: rtsx: Modify copyright comments

Yadwinder Singh Brar (3):
      mfd: s2mps11: Add device tree support
      mfd: s2mps11: Remove clocks from regulators list
      mfd: sec: Add clock cell for s2mps11

Zubair Lutfullah (2):
      mfd: ti_am335x_tscadc: Fix spin lock and reg_cache
      mfd: ti_am335x_tscadc: Update reg_cache variable in clr function

 Documentation/devicetree/bindings/mfd/palmas.txt   |    2 +
 Documentation/devicetree/bindings/mfd/s2mps11.txt  |  109 +++
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +
 drivers/base/regmap/regmap-irq.c                   |   25 +
 drivers/memstick/host/rtsx_pci_ms.c                |    3 +-
 drivers/mfd/88pm800.c                              |   12 +-
 drivers/mfd/88pm805.c                              |    4 +-
 drivers/mfd/88pm860x-core.c                        |    2 +-
 drivers/mfd/Kconfig                                |   14 +-
 drivers/mfd/Makefile                               |    3 +
 drivers/mfd/aat2870-core.c                         |    2 +-
 drivers/mfd/ab3100-core.c                          |    2 +-
 drivers/mfd/ab8500-debugfs.c                       |   14 +-
 drivers/mfd/ab8500-gpadc.c                         |    4 +
 drivers/mfd/adp5520.c                              |    2 +-
 drivers/mfd/arizona-core.c                         |    2 +-
 drivers/mfd/as3711.c                               |    2 +-
 drivers/mfd/asic3.c                                |    2 +-
 drivers/mfd/da903x.c                               |    2 +-
 drivers/mfd/da9052-core.c                          |    2 +-
 drivers/mfd/da9055-core.c                          |    7 +-
 drivers/mfd/da9055-i2c.c                           |    2 +-
 drivers/mfd/da9063-core.c                          |  185 ++++
 drivers/mfd/da9063-i2c.c                           |  182 ++++
 drivers/mfd/da9063-irq.c                           |  193 ++++
 drivers/mfd/davinci_voicecodec.c                   |   23 +-
 drivers/mfd/db8500-prcmu.c                         |    4 +-
 drivers/mfd/dm355evm_msp.c                         |    4 +-
 drivers/mfd/ezx-pcap.c                             |    6 +-
 drivers/mfd/htc-egpio.c                            |    2 +-
 drivers/mfd/htc-i2cpld.c                           |   10 +-
 drivers/mfd/htc-pasic3.c                           |    2 +-
 drivers/mfd/intel_msic.c                           |    4 +-
 drivers/mfd/kempld-core.c                          |   30 +-
 drivers/mfd/lm3533-core.c                          |    8 +-
 drivers/mfd/lp8788.c                               |    2 +-
 drivers/mfd/lpc_ich.c                              |    2 +-
 drivers/mfd/max77686.c                             |    2 +-
 drivers/mfd/max77693.c                             |    2 +-
 drivers/mfd/max8925-i2c.c                          |    2 +-
 drivers/mfd/max8997.c                              |   18 +-
 drivers/mfd/max8998.c                              |    7 +-
 drivers/mfd/mcp-sa11x0.c                           |    2 +-
 drivers/mfd/menelaus.c                             |   22 +-
 drivers/mfd/mfd-core.c                             |    2 +
 drivers/mfd/omap-usb-host.c                        |    6 +-
 drivers/mfd/palmas.c                               |  130 ++-
 drivers/mfd/pcf50633-adc.c                         |    3 +-
 drivers/mfd/pcf50633-core.c                        |    2 +-
 drivers/mfd/pm8921-core.c                          |   14 +-
 drivers/mfd/rc5t583.c                              |    2 +-
 drivers/mfd/rtl8411.c                              |   94 +-
 drivers/mfd/rts5209.c                              |   63 +-
 drivers/mfd/rts5227.c                              |  115 ++-
 drivers/mfd/rts5229.c                              |   53 +-
 drivers/mfd/rts5249.c                              |  110 ++-
 drivers/mfd/rtsx_pcr.c                             |   76 +-
 drivers/mfd/rtsx_pcr.h                             |   32 +-
 drivers/mfd/sec-core.c                             |   40 +-
 drivers/mfd/si476x-i2c.c                           |    2 +-
 drivers/mfd/sm501.c                                |    6 +-
 drivers/mfd/sta2x11-mfd.c                          |    4 +-
 drivers/mfd/stmpe.c                                |    3 +-
 drivers/mfd/syscon.c                               |    8 +-
 drivers/mfd/t7l66xb.c                              |    8 +-
 drivers/mfd/tc3589x.c                              |    2 +-
 drivers/mfd/tc6387xb.c                             |    6 +-
 drivers/mfd/tc6393xb.c                             |    8 +-
 drivers/mfd/ti-ssp.c                               |    2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |   32 +-
 drivers/mfd/timberdale.c                           |   34 +-
 drivers/mfd/tps6105x.c                             |    2 +-
 drivers/mfd/tps65010.c                             |   24 +-
 drivers/mfd/tps65090.c                             |    2 +-
 drivers/mfd/tps6586x.c                             |    2 +-
 drivers/mfd/tps65912-core.c                        |    2 +-
 drivers/mfd/tps80031.c                             |    2 +-
 drivers/mfd/twl-core.c                             |    2 +-
 drivers/mfd/twl4030-audio.c                        |    2 +-
 drivers/mfd/twl4030-madc.c                         |    2 +-
 drivers/mfd/twl4030-power.c                        |    8 +-
 drivers/mfd/twl6030-irq.c                          |  377 +++----
 drivers/mfd/twl6040.c                              |  133 ++-
 drivers/mfd/ucb1400_core.c                         |    2 +-
 drivers/mfd/ucb1x00-core.c                         |   34 +-
 drivers/mfd/wl1273-core.c                          |    8 +-
 drivers/mfd/wm5110-tables.c                        |   18 +
 drivers/mfd/wm831x-core.c                          |    2 +-
 drivers/mfd/wm831x-irq.c                           |    2 +-
 drivers/mfd/wm831x-spi.c                           |    1 -
 drivers/mfd/wm8350-i2c.c                           |    3 +-
 drivers/mfd/wm8400-core.c                          |    2 +-
 drivers/mfd/wm8994-core.c                          |   44 +-
 drivers/mfd/wm8994-irq.c                           |    2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   70 +-
 include/linux/mfd/da9063/core.h                    |   93 ++
 include/linux/mfd/da9063/pdata.h                   |  111 +++
 include/linux/mfd/da9063/registers.h               | 1028 ++++++++++++++++++++
 include/linux/mfd/davinci_voicecodec.h             |    3 +
 include/linux/mfd/mcp.h                            |    2 +
 include/linux/mfd/palmas.h                         |   50 +
 include/linux/mfd/rtsx_common.h                    |    3 +-
 include/linux/mfd/rtsx_pci.h                       |   66 +-
 include/linux/mfd/samsung/s2mps11.h                |    6 +-
 include/linux/mfd/ti_am335x_tscadc.h               |    1 -
 include/linux/mfd/twl6040.h                        |    2 +-
 include/linux/mfd/ucb1x00.h                        |    1 +
 include/linux/regmap.h                             |   10 +-
 108 files changed, 3254 insertions(+), 659 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt
 create mode 100644 drivers/mfd/da9063-core.c
 create mode 100644 drivers/mfd/da9063-i2c.c
 create mode 100644 drivers/mfd/da9063-irq.c
 create mode 100644 include/linux/mfd/da9063/core.h
 create mode 100644 include/linux/mfd/da9063/pdata.h
 create mode 100644 include/linux/mfd/da9063/registers.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
