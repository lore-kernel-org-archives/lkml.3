Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaFBQfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:35:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:44133 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaFBQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:35:06 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: <egtvedt@samfundet.no>, <gregkh@linuxfoundation.org>,
        <thierry.reding@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: drivers for 3.16 #1
Date: Mon, 2 Jun 2014 18:35:01 +0200
Message-ID: <1401726901-19093-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Here is an additional AT91 pull-request for 3.16 about drivers and
particularly focused on PWM.
Alexandre did a great job replacing the existing calls to the older,
non-standard drivers by the use of the newer "pwm-atmel" which takes
advantage of the PWM framework.
In addition of removing three obsolete drivers, it also solves an issue with
non existing Kconfig symbols introduced by (misc: atmel_pwm: only build for
supported platforms) which was trying to avoid a build failure... so, all in 
all, a pretty good thing!

The drawback is that this series depends on two git trees:

Obviously, one from Thierry:
git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm

And as well the one from Greg who took Arnd's patch for Kconfig:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc

Tell me if you feel it is the proper way to deal with this or if it is too late
for this round (look at the diffstat, yummy ;-))

Thanks, best regards,

The following changes since commit fa264e615338c423e344d34621f992858b957097:

  Merge branch 'char-misc-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc into at91-3.16-drivers (2014-06-02 18:02:18 +0200)

are available in the git repository at:


  git://github.com/at91linux/linux-at91.git tags/at91-drivers

for you to fetch changes up to 0108e8f47ffb12b2543db62cc6745a33127c712e:

  misc: atmel_pwm: remove obsolete driver (2014-06-02 18:02:27 +0200)

----------------------------------------------------------------
Atmel PWM driver update for 3.16
- move to the new PWM driver which uses PWM framework
- remove 3 obsolete drivers (atmel-pwm-bl.c, leds-atmel-pwm.c and atmel_pwm.c)

----------------------------------------------------------------
Alexandre Belloni (15):
      ARM: at91: at91sam9g45: switch to generic PWM framework
      ARM: at91: sam9m10g45ek: use generic leds_pwm driver
      ARM: at91: at91sam9263: switch to generic PWM framework
      ARM: at91: sam9263ek: use generic leds_pwm driver
      ARM: at91: at91sam9rl: switch to generic PWM framework
      ARM: at91: remove useless at91_pwm_leds()
      PWM: atmel: allow building for AVR32
      avr32/at32ap: switch to the generic PWM framework
      avr32: MRMT: use generic leds_pwm driver
      avr32: merisc: use generic leds_pwm driver
      avr32: favr-32: use generic pwm_bl driver
      avr32: update defconfig to use the generic PWM framework
      backlight: atmel-pwm-bl: remove obsolete driver
      leds: atmel-pwm: remove obsolete driver
      misc: atmel_pwm: remove obsolete driver

 arch/arm/mach-at91/at91sam9263.c           |   1 +
 arch/arm/mach-at91/at91sam9263_devices.c   |  11 +-
 arch/arm/mach-at91/at91sam9g45.c           |   1 +
 arch/arm/mach-at91/at91sam9g45_devices.c   |  11 +-
 arch/arm/mach-at91/at91sam9rl.c            |   1 +
 arch/arm/mach-at91/at91sam9rl_devices.c    |  11 +-
 arch/arm/mach-at91/board-sam9263ek.c       |  55 +++-
 arch/arm/mach-at91/board-sam9m10g45ek.c    |  42 ++-
 arch/arm/mach-at91/board.h                 |   1 -
 arch/arm/mach-at91/leds.c                  |  37 ---
 arch/avr32/boards/atngw100/mrmt.c          |  34 ++-
 arch/avr32/boards/favr-32/setup.c          |  48 ++--
 arch/avr32/boards/merisc/setup.c           |  34 ++-
 arch/avr32/configs/atngw100_mrmt_defconfig |   5 +-
 arch/avr32/configs/atstk1002_defconfig     |   5 +-
 arch/avr32/configs/atstk1003_defconfig     |   5 +-
 arch/avr32/configs/atstk1004_defconfig     |   5 +-
 arch/avr32/configs/atstk1006_defconfig     |   5 +-
 arch/avr32/configs/favr-32_defconfig       |   6 +-
 arch/avr32/configs/merisc_defconfig        |   5 +-
 arch/avr32/mach-at32ap/at32ap700x.c        |   7 +-
 drivers/leds/Kconfig                       |   8 -
 drivers/leds/Makefile                      |   1 -
 drivers/leds/leds-atmel-pwm.c              | 149 -----------
 drivers/misc/Kconfig                       |  10 -
 drivers/misc/Makefile                      |   1 -
 drivers/misc/atmel_pwm.c                   | 402 -----------------------------
 drivers/pwm/Kconfig                        |   2 +-
 drivers/video/backlight/Kconfig            |  11 -
 drivers/video/backlight/Makefile           |   1 -
 drivers/video/backlight/atmel-pwm-bl.c     | 223 ----------------
 include/linux/atmel-pwm-bl.h               |  43 ---
 include/linux/atmel_pwm.h                  |  70 -----
 33 files changed, 186 insertions(+), 1065 deletions(-)
 delete mode 100644 drivers/leds/leds-atmel-pwm.c
 delete mode 100644 drivers/misc/atmel_pwm.c
 delete mode 100644 drivers/video/backlight/atmel-pwm-bl.c
 delete mode 100644 include/linux/atmel-pwm-bl.h
 delete mode 100644 include/linux/atmel_pwm.h

-- 
Nicolas Ferre
