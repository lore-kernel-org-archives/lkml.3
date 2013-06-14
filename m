Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3FNJhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:37:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43093 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3FNJhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:37:15 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/7] Convert GPIO Davinci to platform driver
Thread-Topic: [PATCH v2 0/7] Convert GPIO Davinci to platform driver
Thread-Index: AQHOaOId2keRY1h3e0qqO66QU0Rh0Zk08q9Q
Date: Fri, 14 Jun 2013 09:35:38 +0000
Deferred-Delivery: Fri, 14 Jun 2013 09:35:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EADAF06@DBDE04.ent.ti.com>
References: <1371202481-14585-1-git-send-email-y>
In-Reply-To: <1371202481-14585-1-git-send-email-y>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sender mail id got corrupted. I will send another.

Thanks
Avinash

On Fri, Jun 14, 2013 at 15:04:34, y@symphony.india.ext.ti.com wrote:
> From: Philip Avinash <avinashphilip@ti.com>
> 
> To support DT booting of da850 EVM, davinci gpio driver converted to platform
> driver. Also when here, start using gpiolib API for gpio get/set functionalities.
> Hence removing gpio inline functionalities. However usage of gpiolib API will
> cause an additional software latencies.
> 
> In this patch series
> - Cleaned gpio Davinci driver code with proper commenting style.
> - Create platform driver for GPIO Davinci in da8xx and dmxxx platforms and
>   removed gpio related member updation in davinci_soc_info structure.
> - Remove soc_info reference in the gpio davinci driver and start uses
>   gpiolib interface.
> - gpio-tnetv107x driver also modified to use gpiolib API interface.
> 
> This series has been tested on da850 EVM for gpio interrupt generation.
> This patch series is based on Linux 3.10-rc4 and is availabel at [1].
> 
> 1. https://github.com/avinashphilip/am335x_linux/tree/linux_davinci_v3.10_soc_gpio_v310-rc4
> 
> KV Sujith (2):
>   gpio: davinci: move to platform device
>   ARM: davinci: da8xx: creation of gpio platform device
> 
> Philip Avinash (5):
>   gpio: davinci: coding style correction
>   ARM: davinci: creation of gpio platform device for dmxxx platforms
>   ARM: davinci: da8xx: gpio device creation
>   ARM: davinci: dmxxx: gpio device creation
>   ARM: davinci: Start using gpiolib API inplace of inline functions
> 
>  arch/arm/Kconfig                                  |    1 -
>  arch/arm/mach-davinci/board-da830-evm.c           |   19 ++-
>  arch/arm/mach-davinci/board-da850-evm.c           |   11 ++
>  arch/arm/mach-davinci/board-dm355-evm.c           |   27 ++++
>  arch/arm/mach-davinci/board-dm355-leopard.c       |    1 +
>  arch/arm/mach-davinci/board-dm365-evm.c           |   28 ++++
>  arch/arm/mach-davinci/board-dm644x-evm.c          |   26 ++++
>  arch/arm/mach-davinci/board-dm646x-evm.c          |   27 ++++
>  arch/arm/mach-davinci/board-neuros-osd2.c         |    1 +
>  arch/arm/mach-davinci/board-omapl138-hawk.c       |    2 +
>  arch/arm/mach-davinci/da830.c                     |    5 -
>  arch/arm/mach-davinci/da850.c                     |    5 -
>  arch/arm/mach-davinci/devices-da8xx.c             |   26 ++++
>  arch/arm/mach-davinci/devices.c                   |   13 ++
>  arch/arm/mach-davinci/dm355.c                     |    5 -
>  arch/arm/mach-davinci/dm365.c                     |    6 -
>  arch/arm/mach-davinci/dm644x.c                    |    5 -
>  arch/arm/mach-davinci/dm646x.c                    |    5 -
>  arch/arm/mach-davinci/include/mach/common.h       |    4 +
>  arch/arm/mach-davinci/include/mach/da8xx.h        |    1 +
>  arch/arm/mach-davinci/include/mach/gpio-davinci.h |   91 -------------
>  arch/arm/mach-davinci/include/mach/gpio.h         |   88 -------------
>  arch/arm/mach-davinci/tnetv107x.c                 |    2 +-
>  drivers/gpio/gpio-davinci.c                       |  144 ++++++++++++++-------
>  drivers/gpio/gpio-tnetv107x.c                     |    1 +
>  include/linux/platform_data/gpio-davinci.h        |   59 +++++++++
>  26 files changed, 341 insertions(+), 262 deletions(-)
>  delete mode 100644 arch/arm/mach-davinci/include/mach/gpio-davinci.h
>  delete mode 100644 arch/arm/mach-davinci/include/mach/gpio.h
>  create mode 100644 include/linux/platform_data/gpio-davinci.h
> 
> -- 
> 1.7.9.5
> 
> 

