Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaEGRjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:39:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:32215 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaEGRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:39:41 -0400
Message-ID: <536A6FD7.40402@atmel.com>
Date: Wed, 7 May 2014 19:39:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <alexandre.belloni@free-electrons.com>,
        <boris.brezillon@free-electrons.com>, <linus.walleij@linaro.org>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.16 #1
References: <1399484042-27432-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1399484042-27432-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2014 19:34, Nicolas Ferre :
> Arnd, Olof, Kevin,
> 
> This is the first cleanup pull-request for 3.16. It is pretty big because it
> integrates the work from Boris about CCF and Alexandre about IIO/ADC. I
> integrated them in this cleanup topic because they both touch the core at91
> code, the clk and IIO drivers as well as the DT. The concerned maintainers
> added their tags.
> 
> The patch by Linus is a move of at91 specific GPIO definitions out of the
> include/mach directory which is an step towards single zImage.
> 
> Thanks, best regards,
> 
> The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:
> 
>   Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-cleanup

There is a little conflict with at91-3.16-dt that you already pulled in
arm-soc: here is the branch that resolves it:

https://github.com/at91linux/linux-at91/commits/at91-3.16-resolved

Best regards,

> for you to fetch changes up to 138e8f1c4e99cd349e50fd8b18aebbd2716ceb87:
> 
>   ARM: at91/dt: at91-cosino_mega2560 remove useless tsadcc node (2014-05-07 18:28:41 +0200)
> 
> ----------------------------------------------------------------
> First cleanup series for 3.15
> - localize GPIO header in mach-at91 directory
> - big update on the CCF front with main and slow clocks
> - a cleanup of ADC and touchscreen driver with unification on IIO and
>   removal of old driver
> 
> ----------------------------------------------------------------
> Alexandre Belloni (15):
>       ARM: at91: sam9g45: remove unused platform_data
>       ARM: at91: sam9260: remove unused platform_data
>       iio: adc: at91: cleanup platform_data
>       iio: adc: at91_adc: Add support for touchscreens without TSMR
>       ARM: at91: sam9m10g45ek: Add touchscreen support through at91_adc
>       iio: adc: at91: remove unused include from include/mach
>       iio: adc: at91: add sam9rl support
>       ARM: at91: sam9rl: add at91_adc to support adc and touchscreen
>       ARM: at91: sam9rlek add touchscreen support through at91_adc
>       ARM: at91: sam9g45: switch from atmel_tsadcc to at91_adc
>       ARM: at91: sam9rl: switch from atmel_tsadcc to at91_adc
>       ARM: at91: remove atmel_tsadcc from sama5_defconfig
>       Input: atmel_tsadcc: remove driver
>       ARM: at91: remove atmel_tsadcc platform_data
>       ARM: at91/dt: at91-cosino_mega2560 remove useless tsadcc node
> 
> Boris BREZILLON (11):
>       clk: at91: rework main clk implementation
>       clk: at91: update main clk documentation
>       clk: at91: add slow clks driver
>       clk: at91: add slow clk documentation
>       ARM: at91/dt: move sama5d3 SoC to the new main/slow clk model
>       ARM: at91/dt: add xtal frequencies to sama5d3xcm boards
>       ARM: at91/dt: add xtal frequencies to sama5d3 xplained board
>       ARM: at91/dt: move at91sam9261 SoC to the new main clock model
>       ARM: at91/dt: define main xtal frequency of the at91sam9261ek board
>       ARM: at91/dt: move at91sam9rl SoC to the new slow/main clock models
>       ARM: at91/dt: define sam9rlek crystal frequencies
> 
> Linus Walleij (1):
>       ARM: at91: localize GPIO header
> 
> Nicolas Ferre (1):
>       ASoC: sam9g20_wm8731: remove useless mach/gpio.h
> 
>  .../devicetree/bindings/clock/at91-clock.txt       | 128 ++++-
>  MAINTAINERS                                        |   6 -
>  arch/arm/Kconfig                                   |   1 -
>  arch/arm/boot/dts/at91-cosino_mega2560.dts         |   5 -
>  arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   8 +
>  arch/arm/boot/dts/at91sam9261.dtsi                 |  23 +-
>  arch/arm/boot/dts/at91sam9261ek.dts                |   4 +
>  arch/arm/boot/dts/at91sam9rl.dtsi                  |  46 +-
>  arch/arm/boot/dts/at91sam9rlek.dts                 |   9 +
>  arch/arm/boot/dts/sama5d3.dtsi                     |  61 ++-
>  arch/arm/boot/dts/sama5d3xcm.dtsi                  |   8 +
>  arch/arm/configs/at91sam9g45_defconfig             |   3 +-
>  arch/arm/configs/at91sam9rl_defconfig              |   3 +-
>  arch/arm/configs/sama5_defconfig                   |   1 -
>  arch/arm/mach-at91/at91rm9200_devices.c            |   1 +
>  arch/arm/mach-at91/at91sam9260_devices.c           |  12 +-
>  arch/arm/mach-at91/at91sam9261_devices.c           |   2 +-
>  arch/arm/mach-at91/at91sam9263_devices.c           |   1 +
>  arch/arm/mach-at91/at91sam9g45.c                   |   2 +-
>  arch/arm/mach-at91/at91sam9g45_devices.c           |  64 +--
>  arch/arm/mach-at91/at91sam9rl.c                    |   7 +
>  arch/arm/mach-at91/at91sam9rl_devices.c            |  84 ++-
>  arch/arm/mach-at91/board-1arm.c                    |   2 +-
>  arch/arm/mach-at91/board-afeb-9260v1.c             |   1 +
>  arch/arm/mach-at91/board-cam60.c                   |   1 +
>  arch/arm/mach-at91/board-carmeva.c                 |   1 +
>  arch/arm/mach-at91/board-cpu9krea.c                |   1 +
>  arch/arm/mach-at91/board-cpuat91.c                 |   2 +
>  arch/arm/mach-at91/board-csb337.c                  |   2 +-
>  arch/arm/mach-at91/board-csb637.c                  |   1 +
>  arch/arm/mach-at91/board-eb9200.c                  |   1 +
>  arch/arm/mach-at91/board-ecbat91.c                 |   1 +
>  arch/arm/mach-at91/board-eco920.c                  |   2 +
>  arch/arm/mach-at91/board-flexibity.c               |   1 +
>  arch/arm/mach-at91/board-foxg20.c                  |   1 +
>  arch/arm/mach-at91/board-gsia18s.c                 |   1 +
>  arch/arm/mach-at91/board-kafa.c                    |   1 +
>  arch/arm/mach-at91/board-kb9202.c                  |   1 +
>  arch/arm/mach-at91/board-pcontrol-g20.c            |   1 +
>  arch/arm/mach-at91/board-picotux200.c              |   1 +
>  arch/arm/mach-at91/board-rm9200ek.c                |   1 +
>  arch/arm/mach-at91/board-rsi-ews.c                 |   1 +
>  arch/arm/mach-at91/board-sam9-l9260.c              |   1 +
>  arch/arm/mach-at91/board-sam9260ek.c               |   1 +
>  arch/arm/mach-at91/board-sam9261ek.c               |   1 +
>  arch/arm/mach-at91/board-sam9263ek.c               |   1 +
>  arch/arm/mach-at91/board-sam9g20ek.c               |   1 +
>  arch/arm/mach-at91/board-sam9m10g45ek.c            |  17 +-
>  arch/arm/mach-at91/board-sam9rlek.c                |  17 +-
>  arch/arm/mach-at91/board-snapper9260.c             |   1 +
>  arch/arm/mach-at91/board-stamp9g20.c               |   1 +
>  arch/arm/mach-at91/board-yl-9200.c                 |   1 +
>  arch/arm/mach-at91/board.h                         |   3 -
>  arch/arm/mach-at91/gpio.c                          |   1 +
>  arch/arm/mach-at91/{include/mach => }/gpio.h       |   8 -
>  arch/arm/mach-at91/include/mach/at91_adc.h         | 107 ----
>  arch/arm/mach-at91/include/mach/hardware.h         |  15 +
>  arch/arm/mach-at91/leds.c                          |   1 +
>  arch/arm/mach-at91/pm.c                            |   1 +
>  drivers/clk/at91/Makefile                          |   4 +-
>  drivers/clk/at91/clk-main.c                        | 577 ++++++++++++++++++---
>  drivers/clk/at91/clk-slow.c                        | 467 +++++++++++++++++
>  drivers/clk/at91/pmc.c                             |  17 +
>  drivers/clk/at91/pmc.h                             |   9 +
>  drivers/clk/at91/sckc.c                            |  57 ++
>  drivers/clk/at91/sckc.h                            |  22 +
>  drivers/iio/adc/at91_adc.c                         | 340 ++++++++++--
>  drivers/input/touchscreen/Kconfig                  |  12 -
>  drivers/input/touchscreen/Makefile                 |   1 -
>  drivers/input/touchscreen/atmel_tsadcc.c           | 358 -------------
>  include/linux/clk/at91_pmc.h                       |   1 +
>  include/linux/platform_data/at91_adc.h             |  27 +-
>  include/linux/platform_data/atmel.h                |   7 -
>  sound/soc/atmel/sam9g20_wm8731.c                   |   1 -
>  74 files changed, 1790 insertions(+), 791 deletions(-)
>  rename arch/arm/mach-at91/{include/mach => }/gpio.h (96%)
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91_adc.h
>  create mode 100644 drivers/clk/at91/clk-slow.c
>  create mode 100644 drivers/clk/at91/sckc.c
>  create mode 100644 drivers/clk/at91/sckc.h
>  delete mode 100644 drivers/input/touchscreen/atmel_tsadcc.c
> 


-- 
Nicolas Ferre
