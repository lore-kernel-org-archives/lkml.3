Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaGVPIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:08:19 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:64511 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaGVPIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <1405197014-25225-4-git-send-email-berthe.ab@gmail.com>
References: <CACRpkda6mzVdaN0cvOxpbsxWyCv2nGyDXOjZg_5aT8u7SSQeUw@mail.gmail.com>
	<1405197014-25225-1-git-send-email-berthe.ab@gmail.com>
	<1405197014-25225-4-git-send-email-berthe.ab@gmail.com>
Date: Tue, 22 Jul 2014 17:08:13 +0200
Message-ID: <CACRpkdasp9bLULT7NJM9nYX58rRSsQKXFddOLz9Ah6kp-j-3=Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] driver:gpio remove all usage of gpio_remove retval in driver
From: Linus Walleij <linus.walleij@linaro.org>
To: abdoulaye berthe <berthe.ab@gmail.com>, "arm@kernel.org" <arm@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Michael Buesch <m@bues.ch>, Greg KH <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 10:30 PM, abdoulaye berthe <berthe.ab@gmail.com> wrote:

Heads up. Requesting ACKs for this patch or I'm atleast warning that it will be
applied. We're getting rid of the return value from gpiochip_remove().

> this remove all reference to gpio_remove retval in all driver
> except pinctrl and gpio. the same thing is done for gpio and
> pinctrl in two different patches.
>
> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
(...)

I think this patch probably needs to be broken down per-subsystem as it
hits all over the map. But let's start requesting ACKs for the
individual pieces.
Actually I think it will be OK to merge because there is likely not much churn
around these code sites.

I'm a bit torn between just wanting a big patch for this hitting drivers/gpio
and smaller patches hitting one subsystem at a time. We should be able
to hammer this in one switch strike.

>  arch/arm/common/scoop.c                        | 10 ++--------

ARM SoC folks, can you ACK this?

>  arch/mips/txx9/generic/setup.c                 |  4 ++--

Ralf can you ACK this?

>  arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |  3 ++-

Benji, can you ACK this?

>  arch/sh/boards/mach-x3proto/gpio.c             |  6 ++----

Aha noone can ACK this, whatever...

>  drivers/bcma/driver_gpio.c                     |  3 ++-

Rafał can you ACK this?

>  drivers/hid/hid-cp2112.c                       |  6 ++----

Jiri can you ACK this?

>  drivers/input/keyboard/adp5588-keys.c          |  4 +---
>  drivers/input/keyboard/adp5589-keys.c          |  4 +---
>  drivers/input/touchscreen/ad7879.c             | 10 +++-------

Dmitry can you ACK this?

>  drivers/leds/leds-pca9532.c                    | 10 ++--------
>  drivers/leds/leds-tca6507.c                    |  7 ++-----

Bryan can you ACK this?

>  drivers/media/dvb-frontends/cxd2820r_core.c    | 10 +++-------

Mauro can you ACK this?

(Hm that looks weird. Mental note to look closer at this.)

>  drivers/mfd/asic3.c                            |  3 ++-
>  drivers/mfd/htc-i2cpld.c                       |  8 +-------
>  drivers/mfd/sm501.c                            | 17 +++--------------
>  drivers/mfd/tc6393xb.c                         | 13 ++++---------
>  drivers/mfd/ucb1x00-core.c                     |  8 ++------

Lee/Sam can either of you ACK this?

>  drivers/pinctrl/pinctrl-abx500.c               | 15 +++------------
>  drivers/pinctrl/pinctrl-exynos5440.c           |  6 +-----
>  drivers/pinctrl/pinctrl-msm.c                  | 10 +++-------
>  drivers/pinctrl/pinctrl-nomadik.c              |  2 +-
>  drivers/pinctrl/pinctrl-samsung.c              | 14 ++++----------

Abdoulaye: these should be in the other patch for pinctrl.

>  drivers/platform/x86/intel_pmic_gpio.c         |  3 +--

Matthew can you ACK this?

>  drivers/ssb/driver_gpio.c                      |  3 ++-

Michael can you (A) ACK this and
(B) think of moving this driver to drivers/gpio... Patches welcome.

>  drivers/staging/vme/devices/vme_pio2_gpio.c    |  4 +---
>  drivers/tty/serial/max310x.c                   | 10 ++++------

Greg can you ACK this?

>  drivers/video/fbdev/via/via-gpio.c             | 10 +++-------

Tomi can you ACK this?

>  sound/soc/codecs/wm5100.c                      |  5 +----
>  sound/soc/codecs/wm8903.c                      |  6 +-----
>  sound/soc/codecs/wm8962.c                      |  5 +----
>  sound/soc/codecs/wm8996.c                      |  6 +-----

Liam || Mark can you ACK this?

Yours,
Linus Walleij
