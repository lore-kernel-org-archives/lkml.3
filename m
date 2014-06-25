Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaFYKOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:14:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:46961 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaFYKOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:14:02 -0400
Message-ID: <53AAA0E5.1000608@atmel.com>
Date: Wed, 25 Jun 2014 12:13:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <egtvedt@samfundet.no>, <gregkh@linuxfoundation.org>,
        <thierry.reding@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.16 (drivers) #1
References: <CAOesGMj1FuozbydRf=J7jWFt_8GZ8ZKZReg_1BmvPC706cZ7rQ@mail.gmail.com> <1402994561-29492-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1402994561-29492-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/2014 10:42, Nicolas Ferre :
> Arnd, Olof, Kevin,
> 
> As advised by Olof, here is the interesting updated on PWM drivers for AT91
> resent after 3.16-rc1 release. Delaying the inclusion of this material has
> solved all the issues with dependecies that previous pull-request had ([GIT
> PULL] at91: drivers for 3.16 #1).
> 
> I remind you what it's about: Alexandre did a great job replacing the existing
> calls to the older, non-standard drivers by the use of the newer "pwm-atmel"
> which takes advantage of the PWM framework.
> In addition of removing three obsolete drivers, it also solves an issue with
> non existing Kconfig symbols introduced by (misc: atmel_pwm: only build for
> supported platforms) which was trying to avoid a build failure... so, all in 
> all, a pretty good thing!
> The diffstat is pretty nice as well ;-)
> 
> Thanks, best regards,

After talking to Arnd on IRC. I'll re-spin this series for 3.17, so you
can forget it for now on...

Bye,


> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> for you to fetch changes up to be6ef50d11bfeec5cce3cf6b463f9094fad1de14:
> 
>   misc: atmel_pwm: remove obsolete driver (2014-06-17 10:24:08 +0200)
> 
> ----------------------------------------------------------------
> Atmel PWM driver update for 3.16
> - move to the new PWM driver which uses PWM framework
> - remove 3 obsolete drivers (atmel-pwm-bl.c, leds-atmel-pwm.c and atmel_pwm.c)
> 
> ----------------------------------------------------------------
> Alexandre Belloni (15):
>       ARM: at91: at91sam9g45: switch to generic PWM framework
>       ARM: at91: sam9m10g45ek: use generic leds_pwm driver
>       ARM: at91: at91sam9263: switch to generic PWM framework
>       ARM: at91: sam9263ek: use generic leds_pwm driver
>       ARM: at91: at91sam9rl: switch to generic PWM framework
>       ARM: at91: remove useless at91_pwm_leds()
>       PWM: atmel: allow building for AVR32
>       avr32/at32ap: switch to the generic PWM framework
>       avr32: MRMT: use generic leds_pwm driver
>       avr32: merisc: use generic leds_pwm driver
>       avr32: favr-32: use generic pwm_bl driver
>       avr32: update defconfig to use the generic PWM framework
>       backlight: atmel-pwm-bl: remove obsolete driver
>       leds: atmel-pwm: remove obsolete driver
>       misc: atmel_pwm: remove obsolete driver
> 
>  arch/arm/mach-at91/at91sam9263.c           |   1 +
>  arch/arm/mach-at91/at91sam9263_devices.c   |  11 +-
>  arch/arm/mach-at91/at91sam9g45.c           |   1 +
>  arch/arm/mach-at91/at91sam9g45_devices.c   |  11 +-
>  arch/arm/mach-at91/at91sam9rl.c            |   1 +
>  arch/arm/mach-at91/at91sam9rl_devices.c    |  11 +-
>  arch/arm/mach-at91/board-sam9263ek.c       |  55 +++-
>  arch/arm/mach-at91/board-sam9m10g45ek.c    |  42 ++-
>  arch/arm/mach-at91/board.h                 |   1 -
>  arch/arm/mach-at91/leds.c                  |  37 ---
>  arch/avr32/boards/atngw100/mrmt.c          |  34 ++-
>  arch/avr32/boards/favr-32/setup.c          |  48 ++--
>  arch/avr32/boards/merisc/setup.c           |  34 ++-
>  arch/avr32/configs/atngw100_mrmt_defconfig |   5 +-
>  arch/avr32/configs/atstk1002_defconfig     |   5 +-
>  arch/avr32/configs/atstk1003_defconfig     |   5 +-
>  arch/avr32/configs/atstk1004_defconfig     |   5 +-
>  arch/avr32/configs/atstk1006_defconfig     |   5 +-
>  arch/avr32/configs/favr-32_defconfig       |   6 +-
>  arch/avr32/configs/merisc_defconfig        |   5 +-
>  arch/avr32/mach-at32ap/at32ap700x.c        |   7 +-
>  drivers/leds/Kconfig                       |   8 -
>  drivers/leds/Makefile                      |   1 -
>  drivers/leds/leds-atmel-pwm.c              | 149 -----------
>  drivers/misc/Kconfig                       |  10 -
>  drivers/misc/Makefile                      |   1 -
>  drivers/misc/atmel_pwm.c                   | 402 -----------------------------
>  drivers/pwm/Kconfig                        |   2 +-
>  drivers/video/backlight/Kconfig            |  11 -
>  drivers/video/backlight/Makefile           |   1 -
>  drivers/video/backlight/atmel-pwm-bl.c     | 223 ----------------
>  include/linux/atmel-pwm-bl.h               |  43 ---
>  include/linux/atmel_pwm.h                  |  70 -----
>  33 files changed, 186 insertions(+), 1065 deletions(-)
>  delete mode 100644 drivers/leds/leds-atmel-pwm.c
>  delete mode 100644 drivers/misc/atmel_pwm.c
>  delete mode 100644 drivers/video/backlight/atmel-pwm-bl.c
>  delete mode 100644 include/linux/atmel-pwm-bl.h
>  delete mode 100644 include/linux/atmel_pwm.h
> 


-- 
Nicolas Ferre
