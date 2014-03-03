Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaCCSlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:41:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:36464 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752755AbaCCSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:41:11 -0500
Date: Mon, 3 Mar 2014 19:41:09 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com
Subject: Re: [PATCH v5 0/9] Device Tree support for the at91sam9261ek
Message-ID: <20140303184109.GH3155@piout.net>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Apart from my two nitpicks, the whole series is
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

On 03/03/2014 at 11:05:53 +0100, Jean-Jacques Hiblot wrote :
> This patch set aims at bringing a device tree support for the sam9261.
> It's mostly based on the sam9263 and sam9x5 stuff.
> 
> Changes since V4:
> * change the compatibilty string for the bus matrix to
>   'atmel,at91sam9260-bus-matrix'
> * add a documentation for the bus matrix DT binding
> * panic if the DT description of the bus matrix is not found
> * Fixed the GPIO banks' address range
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
> 
> This serie relies on the following patchs:
> usb: at91-udc: fix irq and iomem resource retrieval
> ARM: at91: prepare sam9 dt boards transition to common
> 
> Jean-Jacques
> 
> Jean-Jacques Hiblot (9):
>   at91: dt: Adds support for the bus matrix declaration in the DT
>   dt: bindings: at91: Add a new binding for the bus matrix
>   at91: pinctrl: don't request GPIOs used for interrupts but lock them
>     as IRQ
>   at91: dt: Add at91sam9261 dt SoC support
>   at91: dt: defconfig: Added the sam9261 to the list of DT-enabled SOCs
>   at91: dt: sam9261: Device Tree support for the at91sam9261ek
>   at91: updated the at91_dt_defconfig with support for the ADS7846
>   ARM: at91: prepare common clk transition for sam9261 SoC
>   ARM: at91: move sam9261 SoC to common clk
> 
>  .../devicetree/bindings/arm/atmel-at91.txt         |  14 +
>  arch/arm/boot/dts/Makefile                         |   2 +
>  arch/arm/boot/dts/at91sam9261.dtsi                 | 740 +++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9261ek.dts                | 204 ++++++
>  arch/arm/configs/at91_dt_defconfig                 |   2 +
>  arch/arm/mach-at91/Kconfig                         |   1 -
>  arch/arm/mach-at91/at91sam9261.c                   |  25 +-
>  arch/arm/mach-at91/setup.c                         |  21 +
>  drivers/pinctrl/pinctrl-at91.c                     |   5 +-
>  9 files changed, 1008 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
> 
> -- 
> 1.9.0
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
