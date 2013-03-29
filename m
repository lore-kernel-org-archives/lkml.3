Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3C2NHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:07:49 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:65036 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3C2NHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:07:46 -0400
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Romain Naour <romain.naour@openwide.fr>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/3] gpio: remove GENERIC_GPIO completely
Date: Fri, 29 Mar 2013 06:11:15 -0700
Message-Id: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I have received no death threat from architecture maintainers I'd like to 
proceed with the remainder of this work so that it doesn't go half-baked into 
3.10. These three patches finish the removal of the GENERIC_GPIO config option 
which has been made equivalent to GPIOLIB in the previous series. It does so by 
first changing all references to GENERIC_GPIO into GPIOLIB in driver code and
configuration files, and then removing the unused option from the Kconfig files
where it is declared.

The last patch in the series confirms gpiolib in its new role as GPIO framework 
by renaming CONFIG_GPIOLIB into CONFIG_GPIO, following the model used by other 
frameworks. This name changing might rise concern but it seems more logical to 
me and the historical gpiolib name is still mentioned in the documentation to 
relieve the confusion.

If I can get a few acks on these (or at least the first two ones) I'd like to 
include them into my next branch as soon as possible so points of breakage can 
be fixed. There are indeed a few new users of GENERIC_GPIO (CC Romain, I sent a 
warning but saw no action so far) in the next tree and compilation will break 
for them.

Another issue, I could not update the Chinese documentation in a satisfying
manner due to my absence of Chinese skills. Hope that will be forgiven.

Alexandre Courbot (3):
  Convert selectors of GENERIC_GPIO to GPIOLIB
  Remove GENERIC_GPIO config option
  Rename CONFIG_GPIOLIB to CONFIG_GPIO

 Documentation/gpio.txt                            | 51 ++++++++---------
 Documentation/zh_CN/gpio.txt                      |  6 +-
 arch/alpha/Kconfig                                |  5 +-
 arch/arm/Kconfig                                  | 67 +++++++++++------------
 arch/arm/configs/kzm9d_defconfig                  |  2 +-
 arch/arm/configs/mvebu_defconfig                  |  2 +-
 arch/arm/configs/realview-smp_defconfig           |  2 +-
 arch/arm/configs/realview_defconfig               |  2 +-
 arch/arm/mach-bcm/Kconfig                         |  2 +-
 arch/arm/mach-highbank/Kconfig                    |  2 +-
 arch/arm/mach-imx/Kconfig                         |  2 +-
 arch/arm/mach-omap2/Kconfig                       |  2 +-
 arch/arm/mach-picoxcell/Kconfig                   |  2 +-
 arch/arm/mach-s3c24xx/Kconfig                     |  2 +-
 arch/arm/mach-shmobile/Kconfig                    | 26 ++++-----
 arch/arm/mach-socfpga/Kconfig                     |  4 +-
 arch/arm/mach-vexpress/Kconfig                    |  2 +-
 arch/arm/mach-virt/Kconfig                        |  2 +-
 arch/arm/mach-vt8500/Kconfig                      |  2 +-
 arch/arm/plat-orion/Makefile                      |  2 +-
 arch/arm/plat-orion/gpio.c                        |  2 +-
 arch/arm/plat-samsung/Kconfig                     |  2 +-
 arch/arm64/Kconfig                                |  5 +-
 arch/avr32/Kconfig                                |  5 +-
 arch/blackfin/Kconfig                             |  5 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |  2 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |  2 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |  2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |  2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF527-TLL6527M_defconfig    |  2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |  2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |  2 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig     |  2 +-
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   |  2 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF609-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/CM-BF527_defconfig          |  2 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |  2 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |  2 +-
 arch/blackfin/configs/CM-BF561_defconfig          |  2 +-
 arch/blackfin/configs/DNP5370_defconfig           |  2 +-
 arch/blackfin/configs/TCM-BF518_defconfig         |  2 +-
 arch/blackfin/include/asm/gpio.h                  |  6 +-
 arch/blackfin/kernel/bfin_gpio.c                  |  2 +-
 arch/blackfin/mach-bf538/Makefile                 |  2 +-
 arch/blackfin/mach-bf538/include/mach/gpio.h      |  2 +-
 arch/hexagon/Kconfig                              |  7 +--
 arch/ia64/Kconfig                                 |  5 +-
 arch/m68k/Kconfig                                 |  3 -
 arch/m68k/Kconfig.cpu                             |  2 +-
 arch/m68k/include/asm/mcfgpio.h                   |  4 +-
 arch/m68k/platform/coldfire/gpio.c                |  2 +-
 arch/metag/Kconfig                                |  3 -
 arch/microblaze/Kconfig                           |  5 +-
 arch/microblaze/configs/mmu_defconfig             |  2 +-
 arch/microblaze/configs/nommu_defconfig           |  2 +-
 arch/microblaze/kernel/reset.c                    |  2 +-
 arch/mips/Kconfig                                 | 25 ++++-----
 arch/mips/alchemy/Kconfig                         |  2 +-
 arch/mips/alchemy/common/Makefile                 |  2 +-
 arch/mips/alchemy/common/gpiolib.c                |  2 +-
 arch/mips/bcm47xx/Kconfig                         |  4 +-
 arch/mips/configs/db1000_defconfig                |  2 +-
 arch/mips/configs/gpr_defconfig                   |  2 +-
 arch/mips/configs/mtx1_defconfig                  |  2 +-
 arch/mips/include/asm/mach-au1x00/gpio-au1000.h   |  4 +-
 arch/mips/include/asm/mach-au1x00/gpio-au1300.h   |  2 +-
 arch/mips/include/asm/mach-au1x00/gpio.h          |  8 +--
 arch/mips/include/asm/mach-generic/gpio.h         |  2 +-
 arch/mips/loongson/common/Makefile                |  2 +-
 arch/mips/txx9/generic/setup.c                    |  2 +-
 arch/openrisc/Kconfig                             |  5 +-
 arch/powerpc/Kconfig                              |  7 +--
 arch/powerpc/configs/40x/virtex_defconfig         |  2 +-
 arch/powerpc/configs/44x/virtex5_defconfig        |  2 +-
 arch/powerpc/configs/mpc512x_defconfig            |  2 +-
 arch/powerpc/configs/wii_defconfig                |  2 +-
 arch/powerpc/platforms/40x/Kconfig                |  2 +-
 arch/powerpc/platforms/44x/Kconfig                |  2 +-
 arch/powerpc/platforms/512x/Kconfig               |  2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c         |  8 +--
 arch/powerpc/platforms/83xx/Kconfig               |  6 +-
 arch/powerpc/platforms/85xx/Kconfig               | 14 ++---
 arch/powerpc/platforms/86xx/Kconfig               |  8 +--
 arch/powerpc/platforms/8xx/Kconfig                |  2 +-
 arch/powerpc/platforms/Kconfig                    |  8 +--
 arch/sh/Kconfig                                   | 23 ++++----
 arch/sh/boards/Kconfig                            | 18 +++---
 arch/sh/boards/mach-highlander/Kconfig            |  2 +-
 arch/sh/boards/mach-rsk/Kconfig                   |  6 +-
 arch/sh/boards/mach-sdk7786/Makefile              |  2 +-
 arch/sh/boards/mach-x3proto/Makefile              |  2 +-
 arch/sh/include/asm/gpio.h                        |  4 +-
 arch/sh/kernel/cpu/sh2a/Makefile                  |  2 +-
 arch/sh/kernel/cpu/sh3/Makefile                   |  2 +-
 arch/sh/kernel/cpu/sh4a/Makefile                  |  2 +-
 arch/sparc/Kconfig                                |  7 +--
 arch/unicore32/Kconfig                            |  7 +--
 arch/x86/Kconfig                                  | 15 ++---
 arch/xtensa/Kconfig                               |  7 +--
 arch/xtensa/configs/s6105_defconfig               |  4 +-
 drivers/bcma/Kconfig                              |  2 +-
 drivers/block/Kconfig                             |  2 +-
 drivers/char/tpm/Kconfig                          |  2 +-
 drivers/extcon/Kconfig                            |  2 +-
 drivers/gpio/Kconfig                              | 19 +++----
 drivers/gpio/Makefile                             |  2 +-
 drivers/gpio/gpio-lpc32xx.c                       |  2 +-
 drivers/hwmon/Kconfig                             |  4 +-
 drivers/i2c/busses/Kconfig                        |  4 +-
 drivers/i2c/muxes/Kconfig                         |  2 +-
 drivers/input/keyboard/Kconfig                    |  6 +-
 drivers/input/keyboard/adp5588-keys.c             |  4 +-
 drivers/input/keyboard/adp5589-keys.c             |  4 +-
 drivers/input/misc/Kconfig                        |  8 +--
 drivers/input/mouse/Kconfig                       |  2 +-
 drivers/input/touchscreen/Kconfig                 |  4 +-
 drivers/input/touchscreen/ad7879.c                |  4 +-
 drivers/leds/Kconfig                              | 10 ++--
 drivers/leds/leds-tca6507.c                       |  8 +--
 drivers/media/dvb-frontends/cxd2820r_core.c       |  6 +-
 drivers/media/dvb-frontends/cxd2820r_priv.h       |  2 +-
 drivers/media/radio/wl128x/Kconfig                |  2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c             |  4 +-
 drivers/mfd/Kconfig                               | 26 ++++-----
 drivers/misc/ti-st/Kconfig                        |  2 +-
 drivers/mtd/maps/Kconfig                          |  2 +-
 drivers/mtd/nand/Kconfig                          |  2 +-
 drivers/net/phy/Kconfig                           |  2 +-
 drivers/pinctrl/Kconfig                           |  4 +-
 drivers/pinctrl/sh-pfc/Kconfig                    | 30 +++++-----
 drivers/pinctrl/spear/Kconfig                     |  2 +-
 drivers/platform/x86/Kconfig                      |  2 +-
 drivers/power/Kconfig                             |  2 +-
 drivers/regulator/Kconfig                         |  2 +-
 drivers/spi/Kconfig                               |  8 +--
 drivers/ssb/Kconfig                               |  2 +-
 drivers/staging/android/Kconfig                   |  2 +-
 drivers/staging/cptm1217/Kconfig                  |  2 +-
 drivers/staging/iio/accel/Kconfig                 |  2 +-
 drivers/staging/iio/adc/Kconfig                   |  6 +-
 drivers/staging/iio/addac/Kconfig                 |  2 +-
 drivers/staging/iio/magnetometer/Kconfig          |  2 +-
 drivers/staging/iio/resolver/Kconfig              |  4 +-
 drivers/staging/iio/trigger/Kconfig               |  2 +-
 drivers/staging/nvec/Kconfig                      |  2 +-
 drivers/staging/vme/devices/Kconfig               |  2 +-
 drivers/tty/serial/Kconfig                        |  2 +-
 drivers/tty/serial/max310x.c                      |  8 +--
 drivers/usb/otg/Kconfig                           |  2 +-
 drivers/video/Kconfig                             |  4 +-
 drivers/video/backlight/Kconfig                   |  4 +-
 drivers/w1/masters/Kconfig                        |  2 +-
 include/asm-generic/gpio.h                        |  6 +-
 include/linux/gpio.h                              |  6 +-
 include/linux/leds-tca6507.h                      |  2 +-
 include/linux/spi/ad7879.h                        |  2 +-
 include/sound/soc.h                               |  6 +-
 net/rfkill/Kconfig                                |  2 +-
 sound/soc/codecs/wm5100.c                         |  4 +-
 sound/soc/codecs/wm8903.c                         |  4 +-
 sound/soc/codecs/wm8962.c                         |  4 +-
 sound/soc/codecs/wm8996.c                         |  4 +-
 sound/soc/soc-jack.c                              |  4 +-
 168 files changed, 375 insertions(+), 441 deletions(-)

-- 
1.8.2

