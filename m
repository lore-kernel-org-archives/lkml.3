Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3EBKUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:20:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1911 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3EBKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:20:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 02 May 2013 03:17:25 -0700
Message-ID: <51823DDA.7010103@nvidia.com>
Date: Thu, 2 May 2013 19:20:10 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130403 Thunderbird/17.0.5
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: [GIT PULL] Removal of GENERIC_GPIO
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Here is the pull request for the GENERIC_GPIO removal. It is almost 
certain that a few fixups will be necessary - while I don't have precise 
patches, the following steps should ensure the state of the code is clean:

* "git grep CONFIG_GENERIC_GPIO" should return 0 hits. Matches should be 
replaced with CONFIG_GPIOLIB
* "git grep '\bGENERIC_GPIO\b'" should return 1 hit in the Chinese 
documentation. Selectors of GENERIC_GPIO should be turned into selectors 
of GPIOLIB, while definitions of the option in architecture code should 
be deleted.

Please let me know if there is something more I can do to ease your task.

Thanks,
Alex.

The following changes since commit 10b38669d64c757cfd927e3820292c580ed70aae:

   Merge tag 'for-linus-v3.9-rc4' of git://oss.sgi.com/xfs/xfs 
(2013-03-19 15:17:40 -0700)

are available in the git repository at:

   git://github.com/Gnurou/linux.git for_grant

for you to fetch changes up to f4c54050640e7afa4749875cf9b900d42db361c0:

   gpio: update gpio Chinese documentation (2013-04-16 18:47:22 +0900)

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
