Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaFDSfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:35:32 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:51569 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFDSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <1401906155-10543-1-git-send-email-berthe.ab@gmail.com>
References: <CAAVeFuLMLfa-1RhcdSrKDUz7=eLqZurBSFSsN7N0x-0S+_btJA@mail.gmail.com>
	<1401906155-10543-1-git-send-email-berthe.ab@gmail.com>
Date: Wed, 4 Jun 2014 20:35:30 +0200
Message-ID: <CABprByY+wAbUrwFtneuFH-20E6uzFu8g+ixjOfJPZzMBSqAp0Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] gpiochip remove
From: abdoulaye berthe <berthe.ab@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, m@bues.ch,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: abdoulaye berthe <berthe.ab@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't modify the panic in the second patch as the initial goal of
the patch was to avoid logging a message and continue as nothing
happens however that happens to be a bad idea compared to a new
proposal, I am ready to change it.

On Wed, Jun 4, 2014 at 8:22 PM, abdoulaye berthe <berthe.ab@gmail.com> wrote:
> The aim of this patch is to make gpiochip_remove() behavior consistent,
> especially when issuing a remove request while the chipio chip is still
> requested. It is the 1st patch in a serie af 2 patches The 1st patch
> updates users of the return value while the 2nd patch changes the return
> value of gpiochip_remove from int to void.
>
> abdoulaye berthe (2):
>   gpio: removes all usage of gpiochip_remove retval
>   gpio: gpiolib: set gpiochip_remove retval to void
>
>  arch/arm/common/scoop.c                        | 10 ++--------
>  arch/mips/txx9/generic/setup.c                 |  4 ++--
>  arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |  3 ++-
>  arch/sh/boards/mach-x3proto/gpio.c             |  6 ++----
>  drivers/bcma/driver_gpio.c                     |  3 ++-
>  drivers/gpio/gpio-74x164.c                     |  8 +++-----
>  drivers/gpio/gpio-adnp.c                       |  9 +--------
>  drivers/gpio/gpio-adp5520.c                    |  8 +-------
>  drivers/gpio/gpio-adp5588.c                    |  6 +-----
>  drivers/gpio/gpio-amd8111.c                    |  3 +--
>  drivers/gpio/gpio-arizona.c                    |  3 ++-
>  drivers/gpio/gpio-cs5535.c                     |  8 +-------
>  drivers/gpio/gpio-da9052.c                     |  3 ++-
>  drivers/gpio/gpio-da9055.c                     |  3 ++-
>  drivers/gpio/gpio-dwapb.c                      |  2 +-
>  drivers/gpio/gpio-em.c                         |  5 +----
>  drivers/gpio/gpio-f7188x.c                     | 18 ++----------------
>  drivers/gpio/gpio-generic.c                    |  3 ++-
>  drivers/gpio/gpio-grgpio.c                     |  4 +---
>  drivers/gpio/gpio-ich.c                        |  9 +--------
>  drivers/gpio/gpio-it8761e.c                    |  6 +-----
>  drivers/gpio/gpio-janz-ttl.c                   |  8 +-------
>  drivers/gpio/gpio-kempld.c                     |  3 ++-
>  drivers/gpio/gpio-lp3943.c                     |  3 ++-
>  drivers/gpio/gpio-lynxpoint.c                  |  5 +----
>  drivers/gpio/gpio-max730x.c                    | 12 ++++--------
>  drivers/gpio/gpio-max732x.c                    |  7 +------
>  drivers/gpio/gpio-mc33880.c                    | 11 +++--------
>  drivers/gpio/gpio-mc9s08dz60.c                 |  3 ++-
>  drivers/gpio/gpio-mcp23s08.c                   | 26 +++++++-------------------
>  drivers/gpio/gpio-ml-ioh.c                     |  8 ++------
>  drivers/gpio/gpio-msm-v2.c                     |  5 +----
>  drivers/gpio/gpio-mxc.c                        |  2 +-
>  drivers/gpio/gpio-octeon.c                     |  3 ++-
>  drivers/gpio/gpio-palmas.c                     |  3 ++-
>  drivers/gpio/gpio-pca953x.c                    |  7 +------
>  drivers/gpio/gpio-pcf857x.c                    |  4 +---
>  drivers/gpio/gpio-pch.c                        | 10 ++--------
>  drivers/gpio/gpio-rc5t583.c                    |  3 ++-
>  drivers/gpio/gpio-rcar.c                       |  5 +----
>  drivers/gpio/gpio-rdc321x.c                    |  7 ++-----
>  drivers/gpio/gpio-sch.c                        | 16 +++-------------
>  drivers/gpio/gpio-sch311x.c                    |  6 ++----
>  drivers/gpio/gpio-sodaville.c                  |  4 +---
>  drivers/gpio/gpio-stmpe.c                      |  8 +-------
>  drivers/gpio/gpio-sx150x.c                     |  7 ++-----
>  drivers/gpio/gpio-syscon.c                     |  3 ++-
>  drivers/gpio/gpio-tb10x.c                      |  5 +----
>  drivers/gpio/gpio-tc3589x.c                    |  8 +-------
>  drivers/gpio/gpio-timberdale.c                 |  5 +----
>  drivers/gpio/gpio-tps6586x.c                   |  3 ++-
>  drivers/gpio/gpio-tps65910.c                   |  3 ++-
>  drivers/gpio/gpio-tps65912.c                   |  3 ++-
>  drivers/gpio/gpio-ts5500.c                     |  6 +++---
>  drivers/gpio/gpio-twl4030.c                    |  4 +---
>  drivers/gpio/gpio-twl6040.c                    |  3 ++-
>  drivers/gpio/gpio-ucb1400.c                    |  2 +-
>  drivers/gpio/gpio-viperboard.c                 | 10 +++-------
>  drivers/gpio/gpio-vx855.c                      |  3 +--
>  drivers/gpio/gpio-wm831x.c                     |  3 ++-
>  drivers/gpio/gpio-wm8350.c                     |  3 ++-
>  drivers/gpio/gpio-wm8994.c                     |  3 ++-
>  drivers/gpio/gpiolib.c                         | 24 +++++++-----------------
>  drivers/hid/hid-cp2112.c                       |  6 ++----
>  drivers/input/keyboard/adp5588-keys.c          |  4 +---
>  drivers/input/keyboard/adp5589-keys.c          |  4 +---
>  drivers/input/touchscreen/ad7879.c             | 10 +++-------
>  drivers/leds/leds-pca9532.c                    | 10 ++--------
>  drivers/leds/leds-tca6507.c                    |  7 ++-----
>  drivers/media/dvb-frontends/cxd2820r_core.c    | 10 +++-------
>  drivers/mfd/asic3.c                            |  3 ++-
>  drivers/mfd/htc-i2cpld.c                       |  8 +-------
>  drivers/mfd/sm501.c                            | 17 +++--------------
>  drivers/mfd/tc6393xb.c                         | 13 ++++---------
>  drivers/mfd/ucb1x00-core.c                     |  8 ++------
>  drivers/pinctrl/pinctrl-abx500.c               | 15 +++------------
>  drivers/pinctrl/pinctrl-adi2.c                 |  9 ++++-----
>  drivers/pinctrl/pinctrl-as3722.c               | 11 ++---------
>  drivers/pinctrl/pinctrl-baytrail.c             |  5 +----
>  drivers/pinctrl/pinctrl-coh901.c               | 10 ++--------
>  drivers/pinctrl/pinctrl-exynos5440.c           |  6 +-----
>  drivers/pinctrl/pinctrl-msm.c                  | 11 ++---------
>  drivers/pinctrl/pinctrl-nomadik.c              |  2 +-
>  drivers/pinctrl/pinctrl-rockchip.c             | 16 ++++------------
>  drivers/pinctrl/pinctrl-samsung.c              | 14 ++++----------
>  drivers/pinctrl/pinctrl-sunxi.c                |  3 +--
>  drivers/pinctrl/sh-pfc/gpio.c                  |  9 +++------
>  drivers/pinctrl/spear/pinctrl-plgpio.c         |  3 +--
>  drivers/pinctrl/vt8500/pinctrl-wmt.c           |  9 ++-------
>  drivers/platform/x86/intel_pmic_gpio.c         |  3 +--
>  drivers/ssb/driver_gpio.c                      |  3 ++-
>  drivers/staging/vme/devices/vme_pio2_gpio.c    |  4 +---
>  drivers/tty/serial/max310x.c                   | 10 ++++------
>  drivers/video/fbdev/via/via-gpio.c             | 10 +++-------
>  include/linux/gpio/driver.h                    |  2 +-
>  sound/soc/codecs/wm5100.c                      |  5 +----
>  sound/soc/codecs/wm8903.c                      |  6 +-----
>  sound/soc/codecs/wm8962.c                      |  5 +----
>  sound/soc/codecs/wm8996.c                      |  6 +-----
>  99 files changed, 190 insertions(+), 478 deletions(-)
>
> --
> 1.9.1
>
