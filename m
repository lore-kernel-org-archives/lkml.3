Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBZMoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:44:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:54630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaBZMoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:44:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Cyril Chemparathy <cyril@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: [PATCH 0/5] ARM: davinci: tnetv107x removal
Date: Wed, 26 Feb 2014 13:43:29 +0100
Message-Id: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:B57rR+A5iH3JWjy1vZHfbTy+UH8lFO6zMPe5MtMkyiP
 25+FVGiC1QV4jNHz3irpJQLrK0VApjAStQdRLzRwKIRYm2Myd6
 6yy4jL6+o93wt92PKsSeHiTXTUPGUwn4RtvbavNVv1V07EgE9J
 a248KdjbOJWq49zh1seoY0YZIEBDWim40Xvqht+pduA3KTnlFQ
 YT5lDHqRlpmjAmnpqhku2aqQ8ML4FPfKvkFSmBVW+5BYp0JWFY
 9f54CKcRubWKaGYmteGRrxZg9YqvaPZB5g3fDjl5rNBFnY7WUe
 lpQ0b05IjDbnlx6y5ONjDxhhAnmd88WaKcJv0Vufv07wJ08Tzz
 3I4rw4bb6Rg/IjZTVYx4fcOB6RBbDJg6WP7uJ1M1o
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes the TI davinci/tnetv107x platform that
has evidently bitrotted to the point where it's completely
useless. While we could probably fix it and add a defconfig,
it appears that there are actually no users of this platform,
and it complicates the davinci code base because it's
incompatible with all the other SoCs in there that are
based on ARM926T.

The five patches are completely independent of one another,
and applying them out of order is fine since we just want
to remove the code. However, I'm looking for an Ack from
Cyril Chemparathy and Sekhar Nori first, to be sure we
won't need this code in the future. Kevin Hilman has
already mentioned that he sees no reason to keep this
code.

I can apply the first patch directly into arm-soc once
I have an Ack, and I'd like the other patches to get picked
up by the respective subsystem maintainers.

	Arnd

Arnd Bergmann (5):
  ARM: davinci: remove tnetv107x support
  gpio: remove obsolete tnetv107x driver
  spi: remove obsolete spi-ti-ssp driver
  mfd: remove obsolete ti-ssp driver
  input: remove obsolete tnetv107x drivers

 arch/arm/Kconfig.debug                          |  13 +-
 arch/arm/mach-davinci/Kconfig                   |  12 -
 arch/arm/mach-davinci/Makefile                  |   2 -
 arch/arm/mach-davinci/board-tnetv107x-evm.c     | 287 ---------
 arch/arm/mach-davinci/devices-tnetv107x.c       | 434 --------------
 arch/arm/mach-davinci/include/mach/cputype.h    |   8 -
 arch/arm/mach-davinci/include/mach/irqs.h       |  97 ---
 arch/arm/mach-davinci/include/mach/mux.h        | 269 ---------
 arch/arm/mach-davinci/include/mach/psc.h        |  47 --
 arch/arm/mach-davinci/include/mach/serial.h     |   8 -
 arch/arm/mach-davinci/include/mach/tnetv107x.h  |  61 --
 arch/arm/mach-davinci/include/mach/uncompress.h |   6 -
 arch/arm/mach-davinci/tnetv107x.c               | 766 ------------------------
 drivers/gpio/Makefile                           |   1 -
 drivers/gpio/gpio-tnetv107x.c                   | 206 -------
 drivers/input/keyboard/Kconfig                  |  10 -
 drivers/input/keyboard/Makefile                 |   1 -
 drivers/input/keyboard/tnetv107x-keypad.c       | 329 ----------
 drivers/input/touchscreen/Kconfig               |   9 -
 drivers/input/touchscreen/Makefile              |   1 -
 drivers/input/touchscreen/tnetv107x-ts.c        | 384 ------------
 drivers/mfd/Kconfig                             |  11 -
 drivers/mfd/Makefile                            |   1 -
 drivers/mfd/ti-ssp.c                            | 465 --------------
 drivers/spi/Kconfig                             |   7 -
 drivers/spi/Makefile                            |   1 -
 drivers/spi/spi-ti-ssp.c                        | 378 ------------
 include/linux/platform_data/gpio-davinci.h      |   4 -
 28 files changed, 1 insertion(+), 3817 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/board-tnetv107x-evm.c
 delete mode 100644 arch/arm/mach-davinci/devices-tnetv107x.c
 delete mode 100644 arch/arm/mach-davinci/include/mach/tnetv107x.h
 delete mode 100644 arch/arm/mach-davinci/tnetv107x.c
 delete mode 100644 drivers/gpio/gpio-tnetv107x.c
 delete mode 100644 drivers/input/keyboard/tnetv107x-keypad.c
 delete mode 100644 drivers/input/touchscreen/tnetv107x-ts.c
 delete mode 100644 drivers/mfd/ti-ssp.c
 delete mode 100644 drivers/spi/spi-ti-ssp.c

Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-gpio@vger.kernel.org
Cc: linux-input@vger.kernel.org
Cc: linux-spi@vger.kernel.org

-- 
1.8.3.2

