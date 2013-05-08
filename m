Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3EHNsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:48:46 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39993 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3EHNsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:48:43 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 8 May 2013 14:48:22 +0100
X-Google-Sender-Auth: 5-Od-adqOQtyIrkrdiUiFE7NX80
Message-ID: <CACxGe6uCJde0vw=zcqJOxdiwOJO8bRe00yzs6UDzup5z-jTRbw@mail.gmail.com>
Subject: [git pull] GENERIC_GPIO removal
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the other GPIO branch I have for this cycle. Alexandre has
done all of the legwork on this branch including getting it into
linux-next early and following up on the conflicts. You can read the
full description below. I've gone through and made sure the branch is
correct. It is based on a random commit from your tree, but by the
time I noticed that the merge window was getting really close and it
would have required a rebase to change. So I asked Alexandre to leave
it as-is because this is the branch that has spent a lot of quality
time in linux-next.

There are merge conflicts you need to be aware of. The full
description and instructions are below in the tag message.

The following changes since commit 10b38669d64c757cfd927e3820292c580ed70aae:

  Merge tag 'for-linus-v3.9-rc4' of git://oss.sgi.com/xfs/xfs
(2013-03-19 15:17:40 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/gpio-for-linus

for you to fetch changes up to f4c54050640e7afa4749875cf9b900d42db361c0:

  gpio: update gpio Chinese documentation (2013-04-16 18:47:22 +0900)

----------------------------------------------------------------
Removal of GENERIC_GPIO for v3.10

GENERIC_GPIO now synonymous with GPIOLIB. There are no longer any valid
cases for enableing GENERIC_GPIO without GPIOLIB, even though it is
possible to do so which has been causing confusion and breakage. This
branch does the work to completely eliminate GENERIC_GPIO.

However, it is not trivial to just create a branch to remove it. Over
the course of the v3.9 cycle more code referencing GENERIC_GPIO has been
added to linux-next that conflicts with this branch. The following must
be done to resolve the conflicts when merging this branch into mainline:

* "git grep CONFIG_GENERIC_GPIO" should return 0 hits. Matches should be
  replaced with CONFIG_GPIOLIB
* "git grep '\bGENERIC_GPIO\b'" should return 1 hit in the Chinese
  documentation.
* Selectors of GENERIC_GPIO should be turned into selectors of GPIOLIB
* definitions of the option in architecture Kconfig code should be deleted.

Stephen has 3 merge fixup patches[1] that do the above. They are currently
applicable on mainline as of May 2nd.

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg428056.html

----------------------------------------------------------------
Alexandre Courbot (18):
      mips: remove redundant GENERIC_GPIO select
      mips: loongson: use GPIO driver on CONFIG_GPIOLIB
      mips: txx9: change GENERIC_GPIO to GPIOLIB
      mips: alchemy: require gpiolib
      arm: remove redundant GENERIC_GPIO selection
      arm: plat-orion: use GPIO driver on CONFIG_GPIOLIB
      unicore32: remove unneeded select GENERIC_GPIO
      unicore32: default GENERIC_GPIO to false
      powerpc: remove redundant GENERIC_GPIO selection
      sh: replace CONFIG_GENERIC_GPIO by CONFIG_GPIOLIB
      xtensa: remove explicit selection of GENERIC_GPIO
      avr32: default GENERIC_GPIO to false
      openrisc: default GENERIC_GPIO to false
      mips: pnx833x: remove requirement for GENERIC_GPIO
      m68k: coldfire: use gpiolib
      blackfin: force use of gpiolib
      Convert selectors of GENERIC_GPIO to GPIOLIB
      Remove GENERIC_GPIO config option

Chen Baozi (1):
      gpio: update gpio Chinese documentation

 Documentation/gpio.txt               | 10 +++++-----
 Documentation/zh_CN/gpio.txt         |  8 ++++----
 arch/alpha/Kconfig                   |  3 ---
 arch/arm/Kconfig                     |  3 ---
 arch/arm/plat-orion/Makefile         |  2 +-
 arch/arm/plat-orion/gpio.c           |  2 +-
 arch/arm64/Kconfig                   |  3 ---
 arch/avr32/Kconfig                   |  3 ---
 arch/blackfin/Kconfig                |  5 +----
 arch/hexagon/Kconfig                 |  3 ---
 arch/ia64/Kconfig                    |  3 ---
 arch/m68k/Kconfig                    |  3 ---
 arch/m68k/Kconfig.cpu                |  3 +--
 arch/metag/Kconfig                   |  3 ---
 arch/microblaze/Kconfig              |  3 ---
 arch/mips/Kconfig                    | 10 +---------
 arch/mips/loongson/common/Makefile   |  2 +-
 arch/mips/txx9/generic/setup.c       |  2 +-
 arch/openrisc/Kconfig                |  3 ---
 arch/powerpc/Kconfig                 |  5 -----
 arch/powerpc/platforms/40x/Kconfig   |  1 -
 arch/powerpc/platforms/44x/Kconfig   |  1 -
 arch/powerpc/platforms/85xx/Kconfig  |  1 -
 arch/powerpc/platforms/86xx/Kconfig  |  3 ---
 arch/powerpc/platforms/8xx/Kconfig   |  1 -
 arch/powerpc/platforms/Kconfig       |  4 ----
 arch/sh/Kconfig                      |  3 ---
 arch/sh/boards/mach-sdk7786/Makefile |  2 +-
 arch/sh/boards/mach-x3proto/Makefile |  2 +-
 arch/sh/kernel/cpu/sh2a/Makefile     |  2 +-
 arch/sh/kernel/cpu/sh3/Makefile      |  2 +-
 arch/sh/kernel/cpu/sh4a/Makefile     |  2 +-
 arch/sparc/Kconfig                   |  5 -----
 arch/unicore32/Kconfig               |  6 +-----
 arch/x86/Kconfig                     |  3 ---
 arch/xtensa/Kconfig                  |  3 ---
 arch/xtensa/configs/iss_defconfig    |  1 -
 arch/xtensa/configs/s6105_defconfig  |  1 -
 drivers/extcon/Kconfig               |  2 +-
 drivers/gpio/Kconfig                 |  1 -
 drivers/gpio/gpio-lpc32xx.c          |  2 +-
 drivers/i2c/busses/Kconfig           |  4 ++--
 drivers/i2c/muxes/Kconfig            |  2 +-
 drivers/input/keyboard/Kconfig       |  6 +++---
 drivers/input/misc/Kconfig           |  8 ++++----
 drivers/input/mouse/Kconfig          |  2 +-
 drivers/leds/Kconfig                 |  6 +++---
 drivers/mtd/maps/Kconfig             |  2 +-
 drivers/mtd/nand/Kconfig             |  2 +-
 drivers/net/phy/Kconfig              |  2 +-
 drivers/pinctrl/sh-pfc/Kconfig       | 26 +++++++++++++-------------
 drivers/regulator/Kconfig            |  2 +-
 drivers/spi/Kconfig                  |  8 ++++----
 drivers/staging/android/Kconfig      |  2 +-
 drivers/staging/iio/accel/Kconfig    |  2 +-
 drivers/staging/iio/adc/Kconfig      |  2 +-
 drivers/staging/iio/addac/Kconfig    |  2 +-
 drivers/staging/iio/resolver/Kconfig |  4 ++--
 drivers/staging/iio/trigger/Kconfig  |  2 +-
 drivers/usb/otg/Kconfig              |  2 +-
 drivers/video/Kconfig                |  2 +-
 drivers/video/backlight/Kconfig      |  4 ++--
 drivers/w1/masters/Kconfig           |  2 +-
 include/linux/gpio.h                 |  6 +++---
 64 files changed, 74 insertions(+), 153 deletions(-)
