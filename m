Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3EVKAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:00:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:9880 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab3EVKAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:00:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="341297932"
Date: Wed, 22 May 2013 12:00:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [GIT] [3.10] MFD fixes
Message-ID: <20130522100001.GC20474@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first batch of MFD fixes for 3.10.

It's bigger than I would like, most of it is due to the big ab/db8500 merge
that went through during the 3.10 merge window.

So we have:

- Some build fixes for the tps65912 and ab8500 drivers.
- A couple of build fixes for the the si476x driver with pre 4.3 gcc
  compilers.
- A few runtime breakage fixes (probe failures or oopses) for the ab8500
  and db8500 drivers.
- Some sparse or regular gcc warning fixes for the si476x, ab8500 and
  cros_ec drivers.

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git tags/mfd-fixes-3.10-1

for you to fetch changes up to 5649d8f9e335f2b093751fcc2bdd5953f79f66ef:

  mfd: ab8500-sysctrl: Let sysctrl driver work without pdata (2013-05-21 23:23:21 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      mfd: ab8500: Debugfs code depends on gpadc

David Rientjes (1):
      mfd: tps65912: Select MFD_CORE

Fabio Baltieri (5):
      mfd: abx500-core: Fix sparse warning
      mfd: ab8500-sysctrl: Fix sparse warning
      mfd: ab8500-sysctrl: Set sysctrl_dev during probe
      mfd: ab8500-sysctrl: Always enable pm_power_off handler
      mfd: ab8500-sysctrl: Let sysctrl driver work without pdata

Geert Uytterhoeven (3):
      mfd: si476x: Do not use binary constants
      mfd: cros_ec_spi: Use %z to format pointer differences
      mfd: si476x: Use get_unaligned_be16() for unaligned be16 loads

Lee Jones (4):
      mfd: ab8500-gpadc: Suppress 'ignoring regulator_enable() return value' warning
      mfd: ab8500-core: Use the correct driver name when enabling gpio/pinctrl
      mfd: db8500-prcmu: Supply the pdata_size attribute for db8500-thermal
      mfd: ab8500-core: Pass GPADC compatible string to MFD core

Linus Walleij (1):
      mfd: ab8500: Pass AB8500 IRQ to debugfs code by resource

Ulf Hansson (1):
      mfd: db8500-prcmu: Update stored DSI PLL divider value

 drivers/mfd/Kconfig               |    3 +-
 drivers/mfd/ab8500-core.c         |   24 +++++-
 drivers/mfd/ab8500-debugfs.c      |   16 +++-
 drivers/mfd/ab8500-gpadc.c        |    7 +-
 drivers/mfd/ab8500-sysctrl.c      |   15 ++--
 drivers/mfd/abx500-core.c         |    2 +-
 drivers/mfd/cros_ec_spi.c         |    6 +-
 drivers/mfd/db8500-prcmu.c        |    3 +
 drivers/mfd/si476x-cmd.c          |  152 +++++++++++++++++++------------------
 include/linux/mfd/abx500/ab8500.h |    2 -
 10 files changed, 134 insertions(+), 96 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
