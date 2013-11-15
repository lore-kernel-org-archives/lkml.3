Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3KOPtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:49:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:53220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3KOPtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:49:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435882192"
Date: Fri, 15 Nov 2013 16:49:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [GIT] [3.13] MFD pull request
Message-ID: <20131115154939.GV24952@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 3.13 merge window.

We have a couple of new drivers for the AMS AS3722 PMIC and for
STMicroelectronics STw481x PMIC.

Although this is a smaller update than usual, we also have:

- Device tree support for the max77693 driver.
- linux/of.h inclusion for all DT compatible MFD drivers, to avoid build
  breakage in the future.
- Support for Intel Wildcat Point-LP PCH through the lpc_ich driver.
- A small arizona update for new wm5110 DSP registers and a few fixes.
- A small palmas update as well, including an of_device table addition
  and a few minor fixes.
- Two small mfd-core changes, one including a memory leak fix for when
  mfd_add_device() fails.
- Our usual round of minor cleanups and janitorial fixes.

Thanks in advance for pulling this.

(There is one obvious merge conflict against sound/soc/codecs/mc13783.c,
that I fixed in my mfd-3.13-merge branch).

The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git tags/mfd-3.13-1

for you to fetch changes up to 90b128ed1557c2f523995a379a53e5105891ecf8:

  Merge tag 'mfd-lee-3.13-3' of git://git.linaro.org/people/ljones/mfd (2013-11-11 23:44:31 +0100)

----------------------------------------------------------------
Andrzej Hajda (2):
      mfd: max77693: Remove device wakeup from driver
      mfd: max77693: Added device tree support

Chanwoo Choi (1):
      mfd: max77693: Fix up bug of wrong interrupt number

Charles Keepax (6):
      mfd: arizona: Update registers for WM5110 DSP
      mfd: wm5110: Update noise gate default to match the patch file
      mfd: arizona: Correct register definition for FLL2_SYNC_BW
      mfd: arizona: Correct handling of device tree gpio defaults
      mfd: arizona: Mark missing AOD registers as volatile
      mfd: wm5110: Enable micd clamp functionality

Dan Carpenter (1):
      mfd: pm8921: Potential NULL dereference in pm8921_remove()

David Jander (1):
      mfd: da9052: Avoid multiwrite mode due to silicon errata

Geert Uytterhoeven (2):
      mfd: Stop setting refcounting pointers in original mfd_cell arrays
      mfd: Fix memory leak in mfd_add_devices()

Guenter Roeck (1):
      mfd: sm501: dbg_regs attribute must be read-only

James Ralston (1):
      mfd: lpc_ich: Add Device IDs for Intel Wildcat Point-LP PCH

Jingoo Han (3):
      mfd: lpc_ich: Remove unnecessary pci_set_drvdata()
      mfd: sm501: Remove unnecessary pci_set_drvdata()
      mfd: timberdale: Remove unnecessary pci_set_drvdata()

Johannes Thumshirn (1):
      mfd: lpc_sch: Ignore resource conflicts when adding mfd cells

Laxman Dewangan (7):
      regmap: add helper macro to set min/max range of register
      mfd: palmas: Remove call of mfd_remove_devices
      mfd: palmas: Add MODULE_DEVICE_TABLE for of_device table
      mfd: palmas: Reset pm_power_off if it is set for the device
      mfd: palmas: Fix resource leak of i2c_dummy devices
      mfd: Add support for ams AS3722 PMIC
      mfd: tps65910: Remove warning during dt node parsing

Lee Jones (1):
      mfd: arizona: Only attempt to parse DT if platform data was not passed

Linus Walleij (2):
      mfd: Add STw481x driver
      mfd: tc3589x: Detect the precise version

Mark Brown (5):
      mfd: wm8994: Inline register I/O functions
      mfd: wm8994: Remove unused irq_lock
      mfd: mc13xxx: Don't require lock for simple register I/O
      mfd: mc13xxx: Move SPI erratum workaround into SPI I/O function
      mfd: as3722: Don't export the regmap config

Matthias Kaehlcke (2):
      mfd: ti_am335x_tscadc: Fix idle timeout value
      mfd: ti_am335x_tscadc: Restore clock divider on resume

Peter Chen (1):
      mfd: syscon: Return -ENOSYS if CONFIG_MFD_SYSCON is not enabled

Roger Quadros (1):
      mfd: omap-usb: prepare/unprepare clock while enable/disable

Sachin Kamat (19):
      mfd: aat2870: Fix sparse error
      mfd: mc12xx-i2c: rtsx_pcr: ti-ssp: Remove redundant dev_set_drvdata
      mfd: max8925: Remove redundant of_match_ptr
      mfd: tps65217: Remove redundant of_match_ptr
      mfd: 88pm860x: Remove redundant of_match_ptr
      mfd: ti_am335x_tscadc: Remove redundant of_match_ptr
      mfd: omap-usb: Remove redundant of_match_ptr
      mfd: palmas: Remove redundant of_match_ptr
      mfd: as3711: Include linux/of.h header
      mfd: arizona: Include linux/of.h header
      mfd: tps65910: Include linux/of.h header
      mfd: tps6586x: Include linux/of.h header
      mfd: tps6507x: Include linux/of.h header
      mfd: sec-core: Include linux/of.h header
      mfd: max8997: Include linux/of.h header
      mfd: max8907: Include linux/of.h header
      mfd: max77686: Include linux/of.h header
      mfd: max77693: Include linux/of.h header
      Documentation: mfd: Update s2mps11.txt

Samuel Ortiz (3):
      Merge tag 'range-macro' of git://git.kernel.org/.../broonie/regmap
      Merge tag 'mfd-lee-3.13-1' of git://git.linaro.org/people/ljones/mfd
      Merge tag 'mfd-lee-3.13-3' of git://git.linaro.org/people/ljones/mfd

Sebastian Andrzej Siewior (1):
      mfd: ti_am335x_tscadc: Avoid possible deadlock of reg_lock

Stephen Warren (1):
      mfd: tps6586x: Implement irq_set_wake

Wei WANG (1):
      mfd: rtsx: Modify rts5249_optimize_phy

Wei Yongjun (3):
      mfd: ucb1x00-core: Fix error return code in ucb1x00_probe()
      mfd: ezx-pcap: Drop devm_free_irq of devm_ allocated irq
      mfd: twl6040: Drop devm_free_irq of devm_ allocated irq

Wolfram Sang (1):
      mfd: twl6040: Remove obsolete cleanup for i2c clientdata

 Documentation/devicetree/bindings/mfd/as3722.txt  | 194 ++++++++++
 Documentation/devicetree/bindings/mfd/s2mps11.txt |  13 +-
 drivers/mfd/88pm860x-core.c                       |   2 +-
 drivers/mfd/Kconfig                               |  22 ++
 drivers/mfd/Makefile                              |   2 +
 drivers/mfd/aat2870-core.c                        |   2 +-
 drivers/mfd/arizona-core.c                        |   6 +-
 drivers/mfd/arizona-i2c.c                         |   1 +
 drivers/mfd/arizona-spi.c                         |   1 +
 drivers/mfd/as3711.c                              |   1 +
 drivers/mfd/as3722.c                              | 449 ++++++++++++++++++++++
 drivers/mfd/da9052-i2c.c                          |  12 +-
 drivers/mfd/ezx-pcap.c                            |   8 +-
 drivers/mfd/lpc_ich.c                             |  15 +-
 drivers/mfd/lpc_sch.c                             |   3 +
 drivers/mfd/max77686.c                            |   1 +
 drivers/mfd/max77693-irq.c                        |   3 +-
 drivers/mfd/max77693.c                            |  19 +-
 drivers/mfd/max8907.c                             |   1 +
 drivers/mfd/max8925-i2c.c                         |   2 +-
 drivers/mfd/max8997.c                             |   1 +
 drivers/mfd/mc13xxx-core.c                        |   5 -
 drivers/mfd/mc13xxx-i2c.c                         |   1 -
 drivers/mfd/mc13xxx-spi.c                         |   5 +
 drivers/mfd/mfd-core.c                            |  29 +-
 drivers/mfd/omap-usb-host.c                       |  18 +-
 drivers/mfd/omap-usb-tll.c                        |   6 +-
 drivers/mfd/palmas.c                              |  30 +-
 drivers/mfd/pm8921-core.c                         |   9 +-
 drivers/mfd/rts5249.c                             |  48 ++-
 drivers/mfd/rtsx_pcr.c                            |   5 +-
 drivers/mfd/sec-core.c                            |   1 +
 drivers/mfd/sm501.c                               |   4 +-
 drivers/mfd/stw481x.c                             | 250 ++++++++++++
 drivers/mfd/tc3589x.c                             |  37 +-
 drivers/mfd/ti-ssp.c                              |   1 -
 drivers/mfd/ti_am335x_tscadc.c                    |  24 +-
 drivers/mfd/timberdale.c                          |   6 +-
 drivers/mfd/tps6507x.c                            |   1 +
 drivers/mfd/tps65217.c                            |   2 +-
 drivers/mfd/tps6586x.c                            |  19 +-
 drivers/mfd/tps65910.c                            |   5 +-
 drivers/mfd/twl6040.c                             |  18 +-
 drivers/mfd/ucb1x00-core.c                        |   1 +
 drivers/mfd/wm5102-tables.c                       |   1 -
 drivers/mfd/wm5110-tables.c                       |  47 ++-
 drivers/mfd/wm8994-core.c                         |  78 ----
 include/dt-bindings/mfd/as3722.h                  |  52 +++
 include/linux/mfd/arizona/registers.h             |   2 +-
 include/linux/mfd/as3722.h                        | 423 ++++++++++++++++++++
 include/linux/mfd/core.h                          |   2 +-
 include/linux/mfd/da9052/da9052.h                 |  20 +-
 include/linux/mfd/max77693-private.h              |   1 -
 include/linux/mfd/max77693.h                      |   2 -
 include/linux/mfd/mc13xxx.h                       |   7 +
 include/linux/mfd/rtsx_pci.h                      |  53 +++
 include/linux/mfd/stw481x.h                       |  56 +++
 include/linux/mfd/syscon.h                        |  25 ++
 include/linux/mfd/ti_am335x_tscadc.h              |  20 +-
 include/linux/mfd/wm8994/core.h                   |  47 ++-
 include/linux/regmap.h                            |   2 +
 sound/soc/codecs/mc13783.c                        |   4 -
 62 files changed, 1883 insertions(+), 242 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
 create mode 100644 drivers/mfd/as3722.c
 create mode 100644 drivers/mfd/stw481x.c
 create mode 100644 include/dt-bindings/mfd/as3722.h
 create mode 100644 include/linux/mfd/as3722.h
 create mode 100644 include/linux/mfd/stw481x.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
