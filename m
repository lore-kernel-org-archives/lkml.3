Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaBLLOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:14:38 -0500
Received: from top.free-electrons.com ([176.31.233.9]:43324 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751105AbaBLLOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:14:37 -0500
Message-ID: <52FB5795.9020708@free-electrons.com>
Date: Wed, 12 Feb 2014 12:14:29 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, b.brezillon@overkiz.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/8] Device Tree support for the at91sam9261ek
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Jacques,

On 12/02/2014 11:06, Jean-Jacques Hiblot wrote:
> This patch set aims at bringing a device tree support for the sam9261.
> It's mostly based on the sam9263 and sam9x5 stuff.
> 
> Changes since V3:
> * Added support for the touchscreen
> * Added support for the spi dataflash
> * Activated the TCB by default
> * Reworked the patch organization to reduce the number of patchs
> * changed the default bootargs (no mem description, UBI on mtdpart 5)
> * Changed the xlate implementation of the at91 pinctrl driver to lock the GPIOs
>   for IRQs instead of requesting them (needed for the touchscreen driver)
> * some stylistic changes
> 
> Changes since V2:
> * removed the smc driver from the serie. It'll be posted in an independent
>   serie later.
> * removed the DM9000 support (it'll come with the smc driver)
> * the sam9261 now supports the Common Clock Framework (CCF). Note: to enable
>   the CCF you must remove from the kernel config the platforms that don't
>   support it.
> * Added basic DT binding for the bus matrix
> * Added support for USB host
> * Added support for USB gadget
> * in dts(i), replaced interrupt-parent with interrupts-extended
> * changed the nand partition plan (same as for the sama5d3)
> * removed 'mem' parameter in command line
> * re-ordered dt-nodes in ascending address order.
> * split the lcd support patch in 2 parts (SOC and board)
> 
> 
> Change since V1:
> * changed the DT representation to use address translation and separate the
>   timings' configuration from the device properties by adding a "simple-bus"
>   inetrmediate node.
> * moved the smc driver from drivers/bus to drivers/memmory
> * smc driver now accepts timings in nanoseconds as well as raw register values
> * smc driver can clip the timings if they're out of bound and dump them to the
>   console
> * DM9000 timings are now described in nanosecs (for the virtue of example)
> 
> supported features are:
> * working with the Common Clock Framework and the old at91 clock implementation
> * dbgu
> * lcdc
> * usb host
> * usb gadget,
> * spi dataflash
> * nand flash
> * touchscreen
> * leds
> * user buttons
> 
> In the TODO list:
> * dm9000 (ethernet)
> * audio
> * mmc


Besides the my comment on the 1st patch, all this series
seems pretty neat for me.

It's worth mentioning also that audio and mmc are in the
TODO list by lack of hardware to test it. So what I suggest
here is to send a follow-up patch set and to ask for a
Tested-By from people being able to test it.

For dm9000 the issue is (again) related to an ordering problem:
the Ethernet need an interrupt provided by the gpio driver. Unfortunately,
the gpio driver initialization is called after the dm900 driver
initialization.

Thanks,

Gregory



> 
> This serie relies on the following patchs:
> usb: at91-udc: fix irq and iomem resource retrieval
> ARM: at91: prepare sam9 dt boards transition to common
> 
> Jean-Jacques
> 
> Jean-Jacques Hiblot (8):
>   at91: dt: Adds support for the bus matrix declaration in the DT
>   at91: pinctrl: don't request GPIOs used for interrupts but lock them
>     as IRQ
>   at91: dt: Add at91sam9261 dt SoC support
>   at91: dt: defconfig: Added the sam9261 to the list of DT-enabled SOCs
>   at91: dt: sam9261: Device Tree support for the at91sam9261ek
>   at91: updated the at91_dt_defconfig with support for the ADS7846
>   ARM: at91: prepare common clk transition for sam9261 SoC
>   ARM: at91: move sam9261 SoC to common clk
> 
>  arch/arm/boot/dts/Makefile          |   2 +
>  arch/arm/boot/dts/at91sam9261.dtsi  | 740 ++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9261ek.dts | 204 ++++++++++
>  arch/arm/configs/at91_dt_defconfig  |   2 +
>  arch/arm/mach-at91/Kconfig          |   1 -
>  arch/arm/mach-at91/at91sam9261.c    |  25 +-
>  arch/arm/mach-at91/setup.c          |  23 ++
>  drivers/pinctrl/pinctrl-at91.c      |   5 +-
>  8 files changed, 996 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
