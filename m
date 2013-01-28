Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3A1AjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:39:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:51882 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab3A1AjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,548,1355126400"; 
   d="scan'208";a="277260458"
Date: Mon, 28 Jan 2013 01:39:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        AnilKumar Ch <anilkumar@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [GIT] [3.8] MFD fixes
Message-ID: <20130128003909.GX1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first pull request for MFD fixes for 3.8

We have some build failure fixes (twl4030, vexpress, abx500 and tps65910),
some actual runtime oops and lockup fixes (rtsx, da9052), and some more
hypothetical NULL pointers dereferences fixes for pcf50633 and max776xx.

Then we also have additional rtsx fixes for a correct switch output voltage
and clock divider correctness for rtl8411 (rtsx driver), and irqdomain fix for
db8550-prcmu, and some more cosmetic fixes for arizona and wm5102.

Thanks in advance for pulling them in.

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git tags/mfd-for-linus-3.8-1

for you to fetch changes up to 2d1484f5990c094e2c706672a8d286576dd096b4:

  mfd: rtsx: Fix oops when rtsx_pci_sdmmc is not probed (2013-01-27 02:18:07 +0100)

----------------------------------------------------------------
AnilKumar Ch (1):
      mfd: tps65910: Select REGMAP_IRQ in Kconfig to fix build error

Arnd Bergmann (1):
      mfd: twl4030: Don't warn about uninitialized return code

Ashish Jangam (1):
      mfd: da9052/53 lockup fix

Axel Lin (3):
      mfd: max77686: Init max77686->dev before using it
      mfd: max77693: Init max77693->dev before using it
      mfd: pcf50633: Init pcf->dev before using it

Guenter Roeck (1):
      mfd: vexpress: Export global functions to fix build error

Lee Jones (1):
      mfd: Fix compile errors and warnings when !CONFIG_AB8500_BM

Linus Walleij (2):
      mfd: db8500-prcmu: Fix irqdomain usage
      mfd: tc3589x: Use simple irqdomain

Mark Brown (3):
      mfd: arizona: Disable control interface reporting for WM5102 and WM5110
      mfd: arizona: Check errors from regcache_sync()
      mfd: wm5102: Fix definition of WM5102_MAX_REGISTER

Wei WANG (4):
      mfd: rtsx: Add output voltage switch hook
      mmc: rtsx: Call MFD hook to switch output voltage
      mfd: rtsx: Add clock divider hook
      mfd: rtsx: Fix oops when rtsx_pci_sdmmc is not probed

 drivers/mfd/Kconfig                  |    1 +
 drivers/mfd/ab8500-core.c            |    1 +
 drivers/mfd/arizona-core.c           |    7 +++-
 drivers/mfd/arizona-irq.c            |   18 ++--------
 drivers/mfd/da9052-i2c.c             |   61 +++++++++++++++++++++++++++++++
 drivers/mfd/db8500-prcmu.c           |   13 ++++---
 drivers/mfd/max77686.c               |   18 +++++-----
 drivers/mfd/max77693.c               |   34 +++++++++---------
 drivers/mfd/pcf50633-core.c          |    5 ++-
 drivers/mfd/rtl8411.c                |   29 +++++++++++++++
 drivers/mfd/rts5209.c                |   21 +++++++++++
 drivers/mfd/rts5229.c                |   21 +++++++++++
 drivers/mfd/rtsx_pcr.c               |   27 +++++++++++---
 drivers/mfd/tc3589x.c                |   17 +++------
 drivers/mfd/twl4030-power.c          |    2 +-
 drivers/mfd/vexpress-config.c        |    8 +++--
 drivers/mfd/wm5102-tables.c          |    2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c    |   30 +++-------------
 include/linux/mfd/abx500.h           |    2 --
 include/linux/mfd/abx500/ab8500-bm.h |   29 +++------------
 include/linux/mfd/da9052/da9052.h    |   66 +++++++++++++++++++++++++++++++---
 include/linux/mfd/da9052/reg.h       |    3 ++
 include/linux/mfd/rtsx_common.h      |    3 ++
 include/linux/mfd/rtsx_pci.h         |   25 ++++++++++---
 24 files changed, 314 insertions(+), 129 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
