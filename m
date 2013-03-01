Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3CAVO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:14:27 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:37738 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347Ab3CAVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:14:24 -0500
Date: Fri, 1 Mar 2013 22:14:15 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Alessandro Rubini <rubini@gnudd.com>, Arnd Bergmann <arnd@arndb.de>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>, Guenter Roeck <linux@roeck-us.net>,
        Hauke Mehrtens <hauke@hauke-m.de>, Jingoo Han <jg1.han@samsung.com>,
        Joachim Eastwood <manabian@gmail.com>, Kumar@spo001.leaseweb.com,
        Anil <anilkumar.v@ti.com>, Lubomir Rintel <lkundrak@v3.sk>,
        Mrugesh Katepallewar <mrugesh.mk@ti.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Takahisa Tanaka <mc74hc00@gmail.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [GIT PULL REQUEST] watchdog - v3.9 merge window
Message-ID: <20130301211414.GE7867@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This contains:
* fixes and improvements
* devicetree bindings
* conversion to watchdog generic framework of the following drivers:
	- booke_wdt
	- bcm47xx_wdt.c
	- at91sam9_wdt
* Removal of old STMP3xxx driver
* Addition of following new drivers:
	- new driver for STMP3xxx and i.MX23/28
	- Retu watchdog driver

This will update the following files:

 b/Documentation/devicetree/bindings/watchdog/atmel-at91rm9200-wdt.txt |    9 
 b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt            |    4 
 b/Documentation/devicetree/bindings/watchdog/marvel.txt               |    5 
 b/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt          |    4 
 b/Documentation/devicetree/bindings/watchdog/qca-ar7130-wdt.txt       |   13 
 b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt          |    3 
 b/Documentation/watchdog/watchdog-kernel-api.txt                      |   14 
 b/arch/mips/ath79/dev-common.c                                        |   15 
 b/drivers/rtc/rtc-stmp3xxx.c                                          |   64 +
 b/drivers/watchdog/Kconfig                                            |   35 -
 b/drivers/watchdog/Makefile                                           |    3 
 b/drivers/watchdog/at91rm9200_wdt.c                                   |    9 
 b/drivers/watchdog/at91sam9_wdt.c                                     |  168 +---
 b/drivers/watchdog/ath79_wdt.c                                        |   66 +
 b/drivers/watchdog/bcm47xx_wdt.c                                      |  339 ++++------
 b/drivers/watchdog/booke_wdt.c                                        |  185 +----
 b/drivers/watchdog/davinci_wdt.c                                      |   29 
 b/drivers/watchdog/gef_wdt.c                                          |    1 
 b/drivers/watchdog/omap_wdt.c                                         |    6 
 b/drivers/watchdog/orion_wdt.c                                        |   11 
 b/drivers/watchdog/pnx4008_wdt.c                                      |    7 
 b/drivers/watchdog/retu_wdt.c                                         |  178 +++++
 b/drivers/watchdog/s3c2410_wdt.c                                      |   48 -
 b/drivers/watchdog/sp5100_tco.c                                       |   27 
 b/drivers/watchdog/stmp3xxx_rtc_wdt.c                                 |  111 +++
 b/drivers/watchdog/watchdog_core.c                                    |   66 +
 b/drivers/watchdog/watchdog_dev.c                                     |    3 
 b/include/linux/bcm47xx_wdt.h                                         |    9 
 b/include/linux/stmp3xxx_rtc_wdt.h                                    |   15 
 b/include/linux/watchdog.h                                            |    9 
 drivers/watchdog/stmp3xxx_wdt.c                                       |  288 --------
 31 files changed, 888 insertions(+), 856 deletions(-)

with these Changes:

commit 41e9f3f71bc7a5d41a2b925cfdc0dc22a77f7d8c
Author: Alessandro Rubini <rubini@gnudd.com>
Date:   Wed Feb 20 23:41:04 2013 +0100

    watchdog: sp805_wdt depends on ARM
    
    The SP805 driver is only used by the Spear machines, and uses
    writel_relaxed, which is not available on all architectures.
    
    The dependency from CONFIG_ARM avoids compilation problems under
    randomconfig when CONFIG_ARM_AMBA is enabled for x86 builds.
    
    Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
    Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
    Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e20880e60faadc03837f661533135adb4b7cde01
Author: Kumar, Anil <anilkumar.v@ti.com>
Date:   Fri Feb 8 13:09:30 2013 +0530

    watchdog: davinci_wdt: update to devm_* API
    
    Update the code to use devm_* API so that driver
    core will manage resources.
    
    Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 362ce5aeeb1b1828f91c2ca07327f72c24183ec9
Author: Mrugesh Katepallewar <mrugesh.mk@ti.com>
Date:   Wed Feb 6 16:56:01 2013 +0530

    watchdog: davinci_wdt: use devm managed clk get
    
    Get the clock using devm_clk_get().
    
    Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a6a1bcd3700a792d89999a7ec89a9303534ccefc
Author: Joachim Eastwood <manabian@gmail.com>
Date:   Thu Feb 14 23:02:29 2013 +0100

    watchdog: at91rm9200: add DT support
    
    Add DT support for at91rm9200_wdt.
    
    Signed-off-by: Joachim Eastwood <manabian@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c1fd5f6402050b2463d0610b94f050fedf1b5019
Author: Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Thu Feb 14 09:14:25 2013 +0100

    watchdog: add timeout-sec property binding
    
    this patchset add the timeout-sec property to the following drivers:
    orion_wdt, pnx4008_wdt, s3c2410_wdt and at91sam9_wdt.
    
    The at91sam9_wdt is tested on evk-pr3,
    the other drivers are compile tested only.
    
    Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
    Cc: Andrew Lunn <andrew@lunn.ch>
    Cc: Jason Cooper <jason@lakedaemon.net>
    Cc: Wolfram Sang <w.sang@pengutronix.de>
    Cc: Masanari Iida <standby24x7@gmail.com>
    Cc: Ben Dooks <ben-linux@fluff.org>
    Cc: Kukjin Kim <kgene.kim@samsung.com>
    Cc: Andrew Victor <linux@maxim.org.za>
    Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 490ac7af8b71069ba0c733052c5f448ac070c947
Author: Wenyou Yang <wenyou.yang@atmel.com>
Date:   Fri Feb 1 15:06:21 2013 +0800

    watchdog: at91sam9_wdt: Convert to use the watchdog framework
    
    According to Documentation/watchdog/convert_drivers_to_kernel_api.txt,
    remove the file_operations struct, miscdevice, and obsolete includes
    
    Since the at91sam watchdog inherent characteristics, add the watchdog
    operations: at91wdt_start, at91wdt_stop and at91wdt_ping.
    
    Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org
    Cc: linux-kernel@vger.kernel.org

commit 2dd7b24467143c3fd17c6abcaf04fef7976b1528
Author: Pali Rohár <pali.rohar@gmail.com>
Date:   Sun Feb 17 00:49:26 2013 +0100

    watchdog: omap_wdt: Add option nowayout
    
    Like other watchdog drivers, this patch adds new option nowayout
    which overwrite WATCHDOG_NOWAYOUT.
    
    Signed-off-by: Pali Rohar <pali.rohar@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3048253ed957fc6cdc34599178408559aa1e0062
Author: Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Tue Jan 8 11:04:10 2013 +0100

    watchdog: core: dt: add support for the timeout-sec dt property
    
    Add support for watchdog drivers to initialize/set the timeout field
    of the watchdog_device structure. The timeout field is initialised
    either with the module timeout parameter value (if valid) or with the
    timeout-sec dt property (if valid). If both are invalid the initial
    value is unchanged.
    
    Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e3e83d0001a77cdb337be9170e58b55488835ba0
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sat Jan 12 18:14:11 2013 +0100

    watchdog: bcm47xx_wdt.c: add hard timer
    
    The more recent devices have a watchdog timer which could be configured
    for over 2 hours and not just 2 seconds like the first generation
    devices. For those devices do not use the extra software timer, but
    directly program the time into the register. This will automatically be
    used if the timer supports more than a minute.
    
    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 93aed1f02a7a67ce81e6bd2e37c3e1d994d33d5b
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sat Jan 12 18:14:10 2013 +0100

    watchdog: bcm47xx_wdt.c: rename wdt_time to timeout
    
    Rename wdt_time to timeout to name it like the other watchdog
    driver do it.
    
    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a39068929a9a7c418c569c6d22990953b4f75df7
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sat Jan 12 18:14:09 2013 +0100

    watchdog: bcm47xx_wdt.c: rename ops methods
    
    Rename the methods registered to struct watchdog_ops bcm47xx_wdt_ops in
    order to add an other struct watchdog_ops using different ops in the
    next patch.
    Also rename WDT_MAX_TIME to WDT_SOFTTIMER_MAX.
    
    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f82dedf812ecdf0c19c6c240e85a4a487ab62016
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Thu Jan 24 18:13:34 2013 +0100

    watchdog: bcm47xx_wdt.c: use platform device
    
    Instead of accessing the function to set the watchdog timer directly,
    register a platform driver the platform could register to use this
    watchdog driver.
    
    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5434a04db905bb0af281cdb758d1357fbecd0fe8
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sat Jan 12 18:14:07 2013 +0100

    watchdog: bcm47xx_wdt.c: convert to watchdog core api
    
    Convert the bcm47xx_wdt.c driver to the new watchdog core api.
    
    The nowayout parameter is now added unconditionally to the module.
    
    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 52e5cc4efa576223174ad4c08a335802a36cb18c
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Tue Feb 5 12:14:23 2013 -0800

    watchdog: Convert BookE watchdog driver to watchdog infrastructure
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 04ecc7dc8ee62580d7c2f039bfb6eab41e8b2a7d
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu Jan 10 11:06:33 2013 +0900

    watchdog: s3c2410_wdt: Use devm_* functions
    
    Use devm_* functions to make cleanup paths more simple.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e4504daba1d9391968df4698406bb81318b340a0
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Tue Sep 27 22:53:15 2011 +0200

    watchdog: remove old STMP3xxx driver
    
    Now that the new driver is in place, we can remove the old one.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit de6303ab934b1386cad1f62ea6e2200ab7be7d78
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Tue Sep 27 22:35:40 2011 +0200

    watchdog: add new driver for STMP3xxx and i.MX23/28
    
    Replace the existing STMP3xxx driver because it has enough drawbacks
    that a rewrite is apropriate. The new driver is designed to use the
    watchdog framework which makes it a lot smaller and avoids open coding
    the watchdog API again. It also uses now an explicitly exported function
    from the RTC driver to set up its registers (the old driver silently
    reused the hopefully(!) already remapped RTC registers). Also, this
    driver is mach independent, while the old one depends on a mach replaced
    by another one a year ago. Since the user interface is still the
    standard watchdog API, users don't need to adapt.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1a71fb84fda651105e1e194c2d3a3a13a38210a9
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Tue Sep 27 22:21:37 2011 +0200

    rtc: stmp3xxx: add wdt-accessor function
    
    This RTC also includes a watchdog timer. Provide an accessor function
    for setting the watchdog timeout value which will be picked up by a
    watchdog driver. Also register the platform_device for the watchdog here
    to get the boot-time dependencies right.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Acked-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3d3a6d18abc66ba38e554fd5cb5991dfa805cd23
Author: Aaro Koskinen <aaro.koskinen@iki.fi>
Date:   Thu Dec 27 22:58:29 2012 +0200

    watchdog: introduce retu_wdt driver
    
    Introduce Retu watchdog driver.
    
    Cc: linux-watchdog@vger.kernel.org
    Acked-by: Felipe Balbi <balbi@ti.com>
    Acked-by: Tony Lindgren <tony@atomide.com>
    Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d1ec74ab5a48d794c5e3671a895d49d162d0f916
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Feb 7 21:14:36 2013 +0100

    watchdog: intel_scu_watchdog: fix Kconfig dependency
    
    Kernel symbol X86_MRST has been removed from the kernel.
    INTEL_SCU_WATCHDOG driver can never be compiled due dependence of X86_MRST
    which remained in the drivers/watchdog/Kconfig.
    
    Reported-by: Alexander Shiyan <shc_work@mail.ru>
    Cc: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f3ea733e2e42fd11ea3bc6a468a325ae5878651a
Author: Lubomir Rintel <lkundrak@v3.sk>
Date:   Fri Jan 4 15:06:28 2013 +0100

    watchdog: orion_wdt: Add platform alias
    
    ...so that it's automatically picked up on relevant platforms.
    Tested on Kirkwood-based GuruPlug.
    
    Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 15920d12998a408efe4b1b25a28c21dfc48f6e69
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Sat Feb 2 10:34:54 2013 +0100

    watchdog: ath79_wdt: add device tree matching
    
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Cc: devicetree-discuss@lists.ozlabs.org
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 09f5100a592d11dad06b218f41d560ff1f87f666
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Thu Dec 27 15:38:26 2012 +0100

    watchdog: ath79_wdt: get register base from platform device's resources
    
    The ath79_wdt driver uses a fixed memory address
    currently. Although this is working with each
    currently supported SoCs, but this may change
    in the future. Additionally, the driver includes
    platform specific header files in order to be
    able to get the memory base of the watchdog
    device.
    
    The patch adds a memory resource to the platform
    device, and converts the driver to get the base
    address of the watchdog device from that.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0f2ad9ed7c6fecb008372e8a709595a2a21059aa
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Thu Dec 27 15:38:25 2012 +0100

    MIPS: ath79: use dynamically allocated watchdog device
    
    Remove the static watchdog device variable and use
    the 'platform_device_register_simple' helper to
    allocate and register the device in one step.
    
    This allows us to save a few bytes in the kernel image.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5071a88475b758bf60191e53606463fe7290c71e
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Thu Dec 27 15:38:24 2012 +0100

    watchdog: ath79_wdt: convert to use devm_clk_get
    
    Use the managed version of clk_get. This allows to
    simplify the probe/remove functions a bit.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 41adafbd7b84c66c2cdad857b75d5d45032310a6
Author: Takahisa Tanaka <mc74hc00@gmail.com>
Date:   Mon Jan 14 11:01:58 2013 +0900

    watchdog: sp5100_tco: Write back the original value to reserved bits, instead of zero
    
    In case of SP5100 or SB7x0 chipsets, the sp5100_tco module writes zero to
    reserved bits. The module, however, shouldn't depend on specific default
    value, and should perform a read-merge-write operation for the reserved
    bits.
    
    This patch makes the sp5100_tco module perform a read-merge-write operation
    on all the chipset (sp5100, sb7x0, sb8x0 or later).
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
    Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
    Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@vger.kernel.org>

commit 10ab329b5db7e592a3a60b4594e4e5f40b60c45c
Author: Takahisa Tanaka <mc74hc00@gmail.com>
Date:   Mon Jan 14 11:01:57 2013 +0900

    watchdog: sp5100_tco: Fix wrong indirect I/O access for getting value of reserved bits
    
    In case of SB800 or later chipset and re-programming MMIO address(*),
    sp5100_tco module may read incorrect value of reserved bit, because the module
    reads a value from an incorrect I/O address. However, this bug doesn't cause
    a problem, because when re-programming MMIO address, by chance the module
    writes zero (this is BIOS's default value) to the low three bits of register.
    * In most cases, PC with SB8x0 or later chipset doesn't need to re-programming
      MMIO address, because such PC can enable AcpiMmio and can use 0xfed80b00 for
      watchdog register base address.
    
    This patch fixes this bug.
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
    Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
    Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@vger.kernel.org>

commit 6737176569d1d6356c644694d60ea2b265cb3870
Author: Devendra Naga <devendra.aaru@gmail.com>
Date:   Fri Nov 2 14:15:39 2012 -0400

    watchdog: gef_wdt.c: add missing remove callback
    
    this module missed a remove callback in the platform ops.
    
    Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6c41e4748662b47d46331e0e79f3b62b6786d3b9
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Jan 25 14:14:27 2013 +0000

    watchdog: at91sam9: at91_wdt_dt_ids cannot be __init
    
    The device IDs are referenced by the driver and potentially
    used beyond the init time, as kbuild correctly warns
    about. Remove the __initconst annotation.
    
    Without this patch, building at91_dt_defconfig results in:
    
    WARNING: drivers/watchdog/built-in.o(.data+0x28): Section mismatch in reference from the variable at91wdt_driver to the (unknown reference) .init.rodata:(unknown)
    The variable at91wdt_driver references
    the (unknown reference) __initconst (unknown)
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Tested-by: Fabio Porcedda <fabio.porcedda@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org

commit 12a5c05cb143105d989abf728a8c769830670e54
Author: Randy Dunlap <rdunlap@infradead.org>
Date:   Mon Jan 28 08:29:48 2013 -0800

    watchdog: da9055_wdt needs to select WATCHDOG_CORE
    
    DA9055_WATCHDOG (introduced in v3.8) needs to select WATCHDOG_CORE so that it will
    build cleanly.  Fixes these build errors:
    
    da9055_wdt.c:(.text+0xe9bc7): undefined reference to `watchdog_unregister_device'
    da9055_wdt.c:(.text+0xe9f4b): undefined reference to `watchdog_register_device'
    
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Cc: David Dajun Chen <dchen@diasemi.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org
    Cc: stable <stable@vger.kernel.org>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/atmel-at91rm9200-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-at91rm9200-wdt.txt
new file mode 100644
index 0000000..d4d86cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/atmel-at91rm9200-wdt.txt
@@ -0,0 +1,9 @@
+Atmel AT91RM9200 System Timer Watchdog
+
+Required properties:
+- compatible: must be "atmel,at91sam9260-wdt".
+
+Example:
+	watchdog@fffffd00 {
+		compatible = "atmel,at91rm9200-wdt";
+	};
diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
index 2957ebb..fcdd48f 100644
--- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
@@ -7,9 +7,13 @@ Required properties:
 - reg: physical base address of the controller and length of memory mapped
   region.
 
+Optional properties:
+- timeout-sec: contains the watchdog timeout in seconds.
+
 Example:
 
 	watchdog@fffffd40 {
 		compatible = "atmel,at91sam9260-wdt";
 		reg = <0xfffffd40 0x10>;
+		timeout-sec = <10>;
 	};
diff --git a/Documentation/devicetree/bindings/watchdog/marvel.txt b/Documentation/devicetree/bindings/watchdog/marvel.txt
index 0b2503a..5dc8d30 100644
--- a/Documentation/devicetree/bindings/watchdog/marvel.txt
+++ b/Documentation/devicetree/bindings/watchdog/marvel.txt
@@ -5,10 +5,15 @@ Required Properties:
 - Compatibility : "marvell,orion-wdt"
 - reg		: Address of the timer registers
 
+Optional properties:
+
+- timeout-sec	: Contains the watchdog timeout in seconds
+
 Example:
 
 	wdt@20300 {
 		compatible = "marvell,orion-wdt";
 		reg = <0x20300 0x28>;
+		timeout-sec = <10>;
 		status = "okay";
 	};
diff --git a/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt b/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt
index 7c7f688..556d06c 100644
--- a/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt
@@ -5,9 +5,13 @@ Required properties:
 - reg: physical base address of the controller and length of memory mapped
   region.
 
+Optional properties:
+- timeout-sec: contains the watchdog timeout in seconds.
+
 Example:
 
 	watchdog@4003C000 {
 		compatible = "nxp,pnx4008-wdt";
 		reg = <0x4003C000 0x1000>;
+		timeout-sec = <10>;
 	};
diff --git a/Documentation/devicetree/bindings/watchdog/qca-ar7130-wdt.txt b/Documentation/devicetree/bindings/watchdog/qca-ar7130-wdt.txt
new file mode 100644
index 0000000..7a89e5f
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/qca-ar7130-wdt.txt
@@ -0,0 +1,13 @@
+* Qualcomm Atheros AR7130 Watchdog Timer (WDT) Controller
+
+Required properties:
+- compatible: must be "qca,ar7130-wdt"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+Example:
+
+wdt@18060008 {
+	compatible = "qca,ar9330-wdt", "qca,ar7130-wdt";
+	reg = <0x18060008 0x8>;
+};
diff --git a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
index ce0d8e7..2aa486c 100644
--- a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
@@ -9,3 +9,6 @@ Required properties:
 - reg : base physical address of the controller and length of memory mapped
 	region.
 - interrupts : interrupt number to the cpu.
+
+Optional properties:
+- timeout-sec : contains the watchdog timeout in seconds.
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 086638f..a0438f3 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -1,6 +1,6 @@
 The Linux WatchDog Timer Driver Core kernel API.
 ===============================================
-Last reviewed: 22-May-2012
+Last reviewed: 12-Feb-2013
 
 Wim Van Sebroeck <wim@iguana.be>
 
@@ -212,3 +212,15 @@ driver specific data to and a pointer to the data itself.
 The watchdog_get_drvdata function allows you to retrieve driver specific data.
 The argument of this function is the watchdog device where you want to retrieve
 data from. The function returns the pointer to the driver specific data.
+
+To initialize the timeout field, the following function can be used:
+
+extern int watchdog_init_timeout(struct watchdog_device *wdd,
+                                  unsigned int timeout_parm, struct device *dev);
+
+The watchdog_init_timeout function allows you to initialize the timeout field
+using the module timeout parameter or by retrieving the timeout-sec property from
+the device tree (if the module timeout parameter is invalid). Best practice is
+to set the default timeout value as timeout value in the watchdog_device and
+then use this function to set the user "preferred" timeout value.
+This routine returns zero on success and a negative errno code for failure.
diff --git a/arch/mips/ath79/dev-common.c b/arch/mips/ath79/dev-common.c
index 45efc63..ea3a814 100644
--- a/arch/mips/ath79/dev-common.c
+++ b/arch/mips/ath79/dev-common.c
@@ -101,12 +101,15 @@ void __init ath79_register_uart(void)
 	}
 }
 
-static struct platform_device ath79_wdt_device = {
-	.name		= "ath79-wdt",
-	.id		= -1,
-};
-
 void __init ath79_register_wdt(void)
 {
-	platform_device_register(&ath79_wdt_device);
+	struct resource res;
+
+	memset(&res, 0, sizeof(res));
+
+	res.flags = IORESOURCE_MEM;
+	res.start = AR71XX_RESET_BASE + AR71XX_RESET_REG_WDOG_CTRL;
+	res.end = res.start + 0x8 - 1;
+
+	platform_device_register_simple("ath79-wdt", -1, &res, 1);
 }
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index b2a8ed9..98f0d3c 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -27,6 +27,8 @@
 #include <linux/slab.h>
 #include <linux/of_device.h>
 #include <linux/of.h>
+#include <linux/stmp_device.h>
+#include <linux/stmp3xxx_rtc_wdt.h>
 
 #include <mach/common.h>
 
@@ -36,6 +38,7 @@
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ_EN		0x00000001
 #define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN	0x00000002
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ		0x00000004
+#define STMP3XXX_RTC_CTRL_WATCHDOGEN		0x00000010
 
 #define STMP3XXX_RTC_STAT			0x10
 #define STMP3XXX_RTC_STAT_STALE_SHIFT		16
@@ -45,6 +48,8 @@
 
 #define STMP3XXX_RTC_ALARM			0x40
 
+#define STMP3XXX_RTC_WATCHDOG			0x50
+
 #define STMP3XXX_RTC_PERSISTENT0		0x60
 #define STMP3XXX_RTC_PERSISTENT0_SET		0x64
 #define STMP3XXX_RTC_PERSISTENT0_CLR		0x68
@@ -52,12 +57,70 @@
 #define STMP3XXX_RTC_PERSISTENT0_ALARM_EN	0x00000004
 #define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE	0x00000080
 
+#define STMP3XXX_RTC_PERSISTENT1		0x70
+/* missing bitmask in headers */
+#define STMP3XXX_RTC_PERSISTENT1_FORCE_UPDATER	0x80000000
+
 struct stmp3xxx_rtc_data {
 	struct rtc_device *rtc;
 	void __iomem *io;
 	int irq_alarm;
 };
 
+#if IS_ENABLED(CONFIG_STMP3XXX_RTC_WATCHDOG)
+/**
+ * stmp3xxx_wdt_set_timeout - configure the watchdog inside the STMP3xxx RTC
+ * @dev: the parent device of the watchdog (= the RTC)
+ * @timeout: the desired value for the timeout register of the watchdog.
+ *           0 disables the watchdog
+ *
+ * The watchdog needs one register and two bits which are in the RTC domain.
+ * To handle the resource conflict, the RTC driver will create another
+ * platform_device for the watchdog driver as a child of the RTC device.
+ * The watchdog driver is passed the below accessor function via platform_data
+ * to configure the watchdog. Locking is not needed because accessing SET/CLR
+ * registers is atomic.
+ */
+
+static void stmp3xxx_wdt_set_timeout(struct device *dev, u32 timeout)
+{
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+
+	if (timeout) {
+		writel(timeout, rtc_data->io + STMP3XXX_RTC_WATCHDOG);
+		writel(STMP3XXX_RTC_CTRL_WATCHDOGEN,
+		       rtc_data->io + STMP3XXX_RTC_CTRL + STMP_OFFSET_REG_SET);
+		writel(STMP3XXX_RTC_PERSISTENT1_FORCE_UPDATER,
+		       rtc_data->io + STMP3XXX_RTC_PERSISTENT1 + STMP_OFFSET_REG_SET);
+	} else {
+		writel(STMP3XXX_RTC_CTRL_WATCHDOGEN,
+		       rtc_data->io + STMP3XXX_RTC_CTRL + STMP_OFFSET_REG_CLR);
+		writel(STMP3XXX_RTC_PERSISTENT1_FORCE_UPDATER,
+		       rtc_data->io + STMP3XXX_RTC_PERSISTENT1 + STMP_OFFSET_REG_CLR);
+	}
+}
+
+static struct stmp3xxx_wdt_pdata wdt_pdata = {
+	.wdt_set_timeout = stmp3xxx_wdt_set_timeout,
+};
+
+static void stmp3xxx_wdt_register(struct platform_device *rtc_pdev)
+{
+	struct platform_device *wdt_pdev =
+		platform_device_alloc("stmp3xxx_rtc_wdt", rtc_pdev->id);
+
+	if (wdt_pdev) {
+		wdt_pdev->dev.parent = &rtc_pdev->dev;
+		wdt_pdev->dev.platform_data = &wdt_pdata;
+		platform_device_add(wdt_pdev);
+	}
+}
+#else
+static void stmp3xxx_wdt_register(struct platform_device *rtc_pdev)
+{
+}
+#endif /* CONFIG_STMP3XXX_RTC_WATCHDOG */
+
 static void stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
 {
 	/*
@@ -233,6 +296,7 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 		goto out_irq_alarm;
 	}
 
+	stmp3xxx_wdt_register(pdev);
 	return 0;
 
 out_irq_alarm:
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 26e1fdb..9fcc70c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -79,6 +79,7 @@ config DA9052_WATCHDOG
 config DA9055_WATCHDOG
 	tristate "Dialog Semiconductor DA9055 Watchdog"
 	depends on MFD_DA9055
+	select WATCHDOG_CORE
 	help
 	  If you say yes here you get support for watchdog on the Dialog
 	  Semiconductor DA9055 PMIC.
@@ -108,7 +109,7 @@ config WM8350_WATCHDOG
 
 config ARM_SP805_WATCHDOG
 	tristate "ARM SP805 Watchdog"
-	depends on ARM_AMBA
+	depends on ARM && ARM_AMBA
 	select WATCHDOG_CORE
 	help
 	  ARM Primecell SP805 Watchdog timer. This will reboot your system when
@@ -116,7 +117,7 @@ config ARM_SP805_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on ARCH_AT91RM9200
+	depends on ARCH_AT91
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
@@ -124,6 +125,7 @@ config AT91RM9200_WATCHDOG
 config AT91SAM9X_WATCHDOG
 	tristate "AT91SAM9X / AT91CAP9 watchdog"
 	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	select WATCHDOG_CORE
 	help
 	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
 	  reboot your system when the timeout is reached.
@@ -316,14 +318,15 @@ config TWL4030_WATCHDOG
 	  Support for TI TWL4030 watchdog.  Say 'Y' here to enable the
 	  watchdog timer support for TWL4030 chips.
 
-config STMP3XXX_WATCHDOG
-	tristate "Freescale STMP3XXX watchdog"
-	depends on ARCH_STMP3XXX
+config STMP3XXX_RTC_WATCHDOG
+	tristate "Freescale STMP3XXX & i.MX23/28 watchdog"
+	depends on RTC_DRV_STMP
+	select WATCHDOG_CORE
 	help
-	  Say Y here if to include support for the watchdog timer
-	  for the Sigmatel STMP37XX/378X SoC.
+	  Say Y here to include support for the watchdog timer inside
+	  the RTC for the STMP37XX/378X or i.MX23/28 SoC.
 	  To compile this driver as a module, choose M here: the
-	  module will be called stmp3xxx_wdt.
+	  module will be called stmp3xxx_rtc_wdt.
 
 config NUC900_WATCHDOG
 	tristate "Nuvoton NUC900 watchdog"
@@ -376,6 +379,18 @@ config UX500_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called ux500_wdt.
 
+config RETU_WATCHDOG
+	tristate "Retu watchdog"
+	depends on MFD_RETU
+	select WATCHDOG_CORE
+	help
+	  Retu watchdog driver for Nokia Internet Tablets (770, N800,
+	  N810). At least on N800 the watchdog cannot be disabled, so
+	  this driver is essential and you should enable it.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called retu_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
@@ -593,7 +608,7 @@ config IE6XX_WDT
 
 config INTEL_SCU_WATCHDOG
 	bool "Intel SCU Watchdog for Mobile Platforms"
-	depends on X86_MRST
+	depends on X86_INTEL_MID
 	---help---
 	  Hardware driver for the watchdog time built into the Intel SCU
 	  for Intel Mobile Platforms.
@@ -983,6 +998,7 @@ config ATH79_WDT
 config BCM47XX_WDT
 	tristate "Broadcom BCM47xx Watchdog Timer"
 	depends on BCM47XX
+	select WATCHDOG_CORE
 	help
 	  Hardware driver for the Broadcom BCM47xx Watchdog Timer.
 
@@ -1131,6 +1147,7 @@ config PIKA_WDT
 config BOOKE_WDT
 	tristate "PowerPC Book-E Watchdog Timer"
 	depends on BOOKE || 4xx
+	select WATCHDOG_CORE
 	---help---
 	  Watchdog driver for PowerPC Book-E chips, such as the Freescale
 	  MPC85xx SOCs and the IBM PowerPC 440.
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index bec86ee..a300b94 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -48,11 +48,12 @@ obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
-obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
+obj-$(CONFIG_STMP3XXX_RTC_WATCHDOG) += stmp3xxx_rtc_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
 obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
+obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index 89831ed..1c75260 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -24,6 +24,8 @@
 #include <linux/types.h>
 #include <linux/watchdog.h>
 #include <linux/uaccess.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <mach/at91_st.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
@@ -252,6 +254,12 @@ static int at91wdt_resume(struct platform_device *pdev)
 #define at91wdt_resume	NULL
 #endif
 
+static const struct of_device_id at91_wdt_dt_ids[] = {
+	{ .compatible = "atmel,at91rm9200-wdt" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, at91_wdt_dt_ids);
+
 static struct platform_driver at91wdt_driver = {
 	.probe		= at91wdt_probe,
 	.remove		= at91wdt_remove,
@@ -261,6 +269,7 @@ static struct platform_driver at91wdt_driver = {
 	.driver		= {
 		.name	= "at91_wdt",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(at91_wdt_dt_ids),
 	},
 };
 
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index c08933c..be37dde 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -18,11 +18,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
@@ -58,7 +56,7 @@
 
 /* User land timeout */
 #define WDT_HEARTBEAT 15
-static int heartbeat = WDT_HEARTBEAT;
+static int heartbeat;
 module_param(heartbeat, int, 0);
 MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
 	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
@@ -68,19 +66,17 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static struct watchdog_device at91_wdt_dev;
 static void at91_ping(unsigned long data);
 
 static struct {
 	void __iomem *base;
 	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
-	unsigned long open;
-	char expect_close;
 	struct timer_list timer;	/* The timer that pings the watchdog */
 } at91wdt_private;
 
 /* ......................................................................... */
 
-
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
@@ -95,39 +91,37 @@ static inline void at91_wdt_reset(void)
 static void at91_ping(unsigned long data)
 {
 	if (time_before(jiffies, at91wdt_private.next_heartbeat) ||
-			(!nowayout && !at91wdt_private.open)) {
+	    (!watchdog_active(&at91_wdt_dev))) {
 		at91_wdt_reset();
 		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
 		pr_crit("I will reset your machine !\n");
 }
 
-/*
- * Watchdog device is opened, and watchdog starts running.
- */
-static int at91_wdt_open(struct inode *inode, struct file *file)
+static int at91_wdt_ping(struct watchdog_device *wdd)
 {
-	if (test_and_set_bit(0, &at91wdt_private.open))
-		return -EBUSY;
+	/* calculate when the next userspace timeout will be */
+	at91wdt_private.next_heartbeat = jiffies + wdd->timeout * HZ;
+	return 0;
+}
 
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+static int at91_wdt_start(struct watchdog_device *wdd)
+{
+	/* calculate the next userspace timeout and modify the timer */
+	at91_wdt_ping(wdd);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
-
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-/*
- * Close the watchdog device.
- */
-static int at91_wdt_close(struct inode *inode, struct file *file)
+static int at91_wdt_stop(struct watchdog_device *wdd)
 {
-	clear_bit(0, &at91wdt_private.open);
-
-	/* stop internal ping */
-	if (!at91wdt_private.expect_close)
-		del_timer(&at91wdt_private.timer);
+	/* The watchdog timer hardware can not be stopped... */
+	return 0;
+}
 
-	at91wdt_private.expect_close = 0;
+static int at91_wdt_set_timeout(struct watchdog_device *wdd, unsigned int new_timeout)
+{
+	wdd->timeout = new_timeout;
 	return 0;
 }
 
@@ -163,96 +157,28 @@ static int at91_wdt_settimeout(unsigned int timeout)
 	return 0;
 }
 
+/* ......................................................................... */
+
 static const struct watchdog_info at91_wdt_info = {
 	.identity	= DRV_NAME,
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
 						WDIOF_MAGICCLOSE,
 };
 
-/*
- * Handle commands from user-space.
- */
-static long at91_wdt_ioctl(struct file *file,
-		unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_value;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &at91_wdt_info,
-				    sizeof(at91_wdt_info)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_value, p))
-			return -EFAULT;
-
-		heartbeat = new_value;
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-
-		return put_user(new_value, p);  /* return current value */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	}
-	return -ENOTTY;
-}
-
-/*
- * Pat the watchdog whenever device is written to.
- */
-static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len,
-								loff_t *ppos)
-{
-	if (!len)
-		return 0;
-
-	/* Scan for magic character */
-	if (!nowayout) {
-		size_t i;
-
-		at91wdt_private.expect_close = 0;
-
-		for (i = 0; i < len; i++) {
-			char c;
-			if (get_user(c, data + i))
-				return -EFAULT;
-			if (c == 'V') {
-				at91wdt_private.expect_close = 42;
-				break;
-			}
-		}
-	}
-
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-
-	return len;
-}
-
-/* ......................................................................... */
-
-static const struct file_operations at91wdt_fops = {
-	.owner			= THIS_MODULE,
-	.llseek			= no_llseek,
-	.unlocked_ioctl	= at91_wdt_ioctl,
-	.open			= at91_wdt_open,
-	.release		= at91_wdt_close,
-	.write			= at91_wdt_write,
+static const struct watchdog_ops at91_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	at91_wdt_start,
+	.stop =		at91_wdt_stop,
+	.ping =		at91_wdt_ping,
+	.set_timeout =	at91_wdt_set_timeout,
 };
 
-static struct miscdevice at91wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &at91wdt_fops,
+static struct watchdog_device at91_wdt_dev = {
+	.info =		&at91_wdt_info,
+	.ops =		&at91_wdt_ops,
+	.timeout =	WDT_HEARTBEAT,
+	.min_timeout =	1,
+	.max_timeout =	0xFFFF,
 };
 
 static int __init at91wdt_probe(struct platform_device *pdev)
@@ -260,10 +186,6 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	struct resource	*r;
 	int res;
 
-	if (at91wdt_miscdev.parent)
-		return -EBUSY;
-	at91wdt_miscdev.parent = &pdev->dev;
-
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENODEV;
@@ -273,38 +195,41 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	at91_wdt_dev.parent = &pdev->dev;
+	watchdog_init_timeout(&at91_wdt_dev, heartbeat, &pdev->dev);
+	watchdog_set_nowayout(&at91_wdt_dev, nowayout);
+
 	/* Set watchdog */
 	res = at91_wdt_settimeout(ms_to_ticks(WDT_HW_TIMEOUT * 1000));
 	if (res)
 		return res;
 
-	res = misc_register(&at91wdt_miscdev);
+	res = watchdog_register_device(&at91_wdt_dev);
 	if (res)
 		return res;
 
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+	at91wdt_private.next_heartbeat = jiffies + at91_wdt_dev.timeout * HZ;
 	setup_timer(&at91wdt_private.timer, at91_ping, 0);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 
 	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
-		heartbeat, nowayout);
+		at91_wdt_dev.timeout, nowayout);
 
 	return 0;
 }
 
 static int __exit at91wdt_remove(struct platform_device *pdev)
 {
-	int res;
+	watchdog_unregister_device(&at91_wdt_dev);
 
-	res = misc_deregister(&at91wdt_miscdev);
-	if (!res)
-		at91wdt_miscdev.parent = NULL;
+	pr_warn("I quit now, hardware will probably reboot!\n");
+	del_timer(&at91wdt_private.timer);
 
-	return res;
+	return 0;
 }
 
 #if defined(CONFIG_OF)
-static const struct of_device_id at91_wdt_dt_ids[] __initconst = {
+static const struct of_device_id at91_wdt_dt_ids[] = {
 	{ .compatible = "atmel,at91sam9260-wdt" },
 	{ /* sentinel */ }
 };
@@ -326,4 +251,3 @@ module_platform_driver_probe(at91wdt_driver, at91wdt_probe);
 MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 38a999e..8987990 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -32,14 +33,16 @@
 #include <linux/watchdog.h>
 #include <linux/clk.h>
 #include <linux/err.h>
-
-#include <asm/mach-ath79/ath79.h>
-#include <asm/mach-ath79/ar71xx_regs.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 #define DRIVER_NAME	"ath79-wdt"
 
 #define WDT_TIMEOUT	15	/* seconds */
 
+#define WDOG_REG_CTRL		0x00
+#define WDOG_REG_TIMER		0x04
+
 #define WDOG_CTRL_LAST_RESET	BIT(31)
 #define WDOG_CTRL_ACTION_MASK	3
 #define WDOG_CTRL_ACTION_NONE	0	/* no action */
@@ -66,27 +69,38 @@ static struct clk *wdt_clk;
 static unsigned long wdt_freq;
 static int boot_status;
 static int max_timeout;
+static void __iomem *wdt_base;
+
+static inline void ath79_wdt_wr(unsigned reg, u32 val)
+{
+	iowrite32(val, wdt_base + reg);
+}
+
+static inline u32 ath79_wdt_rr(unsigned reg)
+{
+	return ioread32(wdt_base + reg);
+}
 
 static inline void ath79_wdt_keepalive(void)
 {
-	ath79_reset_wr(AR71XX_RESET_REG_WDOG, wdt_freq * timeout);
+	ath79_wdt_wr(WDOG_REG_TIMER, wdt_freq * timeout);
 	/* flush write */
-	ath79_reset_rr(AR71XX_RESET_REG_WDOG);
+	ath79_wdt_rr(WDOG_REG_TIMER);
 }
 
 static inline void ath79_wdt_enable(void)
 {
 	ath79_wdt_keepalive();
-	ath79_reset_wr(AR71XX_RESET_REG_WDOG_CTRL, WDOG_CTRL_ACTION_FCR);
+	ath79_wdt_wr(WDOG_REG_CTRL, WDOG_CTRL_ACTION_FCR);
 	/* flush write */
-	ath79_reset_rr(AR71XX_RESET_REG_WDOG_CTRL);
+	ath79_wdt_rr(WDOG_REG_CTRL);
 }
 
 static inline void ath79_wdt_disable(void)
 {
-	ath79_reset_wr(AR71XX_RESET_REG_WDOG_CTRL, WDOG_CTRL_ACTION_NONE);
+	ath79_wdt_wr(WDOG_REG_CTRL, WDOG_CTRL_ACTION_NONE);
 	/* flush write */
-	ath79_reset_rr(AR71XX_RESET_REG_WDOG_CTRL);
+	ath79_wdt_rr(WDOG_REG_CTRL);
 }
 
 static int ath79_wdt_set_timeout(int val)
@@ -226,16 +240,32 @@ static struct miscdevice ath79_wdt_miscdev = {
 
 static int ath79_wdt_probe(struct platform_device *pdev)
 {
+	struct resource *res;
 	u32 ctrl;
 	int err;
 
-	wdt_clk = clk_get(&pdev->dev, "wdt");
+	if (wdt_base)
+		return -EBUSY;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no memory resource found\n");
+		return -EINVAL;
+	}
+
+	wdt_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!wdt_base) {
+		dev_err(&pdev->dev, "unable to remap memory region\n");
+		return -ENOMEM;
+	}
+
+	wdt_clk = devm_clk_get(&pdev->dev, "wdt");
 	if (IS_ERR(wdt_clk))
 		return PTR_ERR(wdt_clk);
 
 	err = clk_enable(wdt_clk);
 	if (err)
-		goto err_clk_put;
+		return err;
 
 	wdt_freq = clk_get_rate(wdt_clk);
 	if (!wdt_freq) {
@@ -251,7 +281,7 @@ static int ath79_wdt_probe(struct platform_device *pdev)
 			max_timeout, timeout);
 	}
 
-	ctrl = ath79_reset_rr(AR71XX_RESET_REG_WDOG_CTRL);
+	ctrl = ath79_wdt_rr(WDOG_REG_CTRL);
 	boot_status = (ctrl & WDOG_CTRL_LAST_RESET) ? WDIOF_CARDRESET : 0;
 
 	err = misc_register(&ath79_wdt_miscdev);
@@ -265,8 +295,6 @@ static int ath79_wdt_probe(struct platform_device *pdev)
 
 err_clk_disable:
 	clk_disable(wdt_clk);
-err_clk_put:
-	clk_put(wdt_clk);
 	return err;
 }
 
@@ -274,7 +302,6 @@ static int ath79_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&ath79_wdt_miscdev);
 	clk_disable(wdt_clk);
-	clk_put(wdt_clk);
 	return 0;
 }
 
@@ -283,6 +310,14 @@ static void ath97_wdt_shutdown(struct platform_device *pdev)
 	ath79_wdt_disable();
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id ath79_wdt_match[] = {
+	{ .compatible = "qca,ar7130-wdt" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ath79_wdt_match);
+#endif
+
 static struct platform_driver ath79_wdt_driver = {
 	.probe		= ath79_wdt_probe,
 	.remove		= ath79_wdt_remove,
@@ -290,6 +325,7 @@ static struct platform_driver ath79_wdt_driver = {
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ath79_wdt_match),
 	},
 };
 
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index bc0e91e..b4021a2 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2008 Aleksandar Radovanovic <biblbroks@sezampro.rs>
  *  Copyright (C) 2009 Matthieu CASTET <castet.matthieu@free.fr>
+ *  Copyright (C) 2012-2013 Hauke Mehrtens <hauke@hauke-m.de>
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -12,165 +13,143 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/bcm47xx_wdt.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/platform_device.h>
 #include <linux/reboot.h>
 #include <linux/types.h>
-#include <linux/uaccess.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
-#include <linux/ssb/ssb_embedded.h>
-#include <asm/mach-bcm47xx/bcm47xx.h>
 
 #define DRV_NAME		"bcm47xx_wdt"
 
 #define WDT_DEFAULT_TIME	30	/* seconds */
-#define WDT_MAX_TIME		255	/* seconds */
+#define WDT_SOFTTIMER_MAX	255	/* seconds */
+#define WDT_SOFTTIMER_THRESHOLD	60	/* seconds */
 
-static int wdt_time = WDT_DEFAULT_TIME;
+static int timeout = WDT_DEFAULT_TIME;
 static bool nowayout = WATCHDOG_NOWAYOUT;
 
-module_param(wdt_time, int, 0);
-MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog time in seconds. (default="
 				__MODULE_STRING(WDT_DEFAULT_TIME) ")");
 
-#ifdef CONFIG_WATCHDOG_NOWAYOUT
 module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-#endif
 
-static unsigned long bcm47xx_wdt_busy;
-static char expect_release;
-static struct timer_list wdt_timer;
-static atomic_t ticks;
-
-static inline void bcm47xx_wdt_hw_start(void)
+static inline struct bcm47xx_wdt *bcm47xx_wdt_get(struct watchdog_device *wdd)
 {
-	/* this is 2,5s on 100Mhz clock  and 2s on 133 Mhz */
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0xfffffff);
-		break;
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.bus.drv_cc,
-					       0xfffffff);
-		break;
-#endif
-	}
+	return container_of(wdd, struct bcm47xx_wdt, wdd);
 }
 
-static inline int bcm47xx_wdt_hw_stop(void)
+static int bcm47xx_wdt_hard_keepalive(struct watchdog_device *wdd)
 {
-	switch (bcm47xx_bus_type) {
-#ifdef CONFIG_BCM47XX_SSB
-	case BCM47XX_BUS_TYPE_SSB:
-		return ssb_watchdog_timer_set(&bcm47xx_bus.ssb, 0);
-#endif
-#ifdef CONFIG_BCM47XX_BCMA
-	case BCM47XX_BUS_TYPE_BCMA:
-		bcma_chipco_watchdog_timer_set(&bcm47xx_bus.bcma.bus.drv_cc, 0);
-		return 0;
-#endif
-	}
-	return -EINVAL;
-}
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
 
-static void bcm47xx_timer_tick(unsigned long unused)
-{
-	if (!atomic_dec_and_test(&ticks)) {
-		bcm47xx_wdt_hw_start();
-		mod_timer(&wdt_timer, jiffies + HZ);
-	} else {
-		pr_crit("Watchdog will fire soon!!!\n");
-	}
+	wdt->timer_set_ms(wdt, wdd->timeout * 1000);
+
+	return 0;
 }
 
-static inline void bcm47xx_wdt_pet(void)
+static int bcm47xx_wdt_hard_start(struct watchdog_device *wdd)
 {
-	atomic_set(&ticks, wdt_time);
+	return 0;
 }
 
-static void bcm47xx_wdt_start(void)
+static int bcm47xx_wdt_hard_stop(struct watchdog_device *wdd)
 {
-	bcm47xx_wdt_pet();
-	bcm47xx_timer_tick(0);
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+
+	wdt->timer_set(wdt, 0);
+
+	return 0;
 }
 
-static void bcm47xx_wdt_pause(void)
+static int bcm47xx_wdt_hard_set_timeout(struct watchdog_device *wdd,
+					unsigned int new_time)
 {
-	del_timer_sync(&wdt_timer);
-	bcm47xx_wdt_hw_stop();
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+	u32 max_timer = wdt->max_timer_ms;
+
+	if (new_time < 1 || new_time > max_timer / 1000) {
+		pr_warn("timeout value must be 1<=x<=%d, using %d\n",
+			max_timer / 1000, new_time);
+		return -EINVAL;
+	}
+
+	wdd->timeout = new_time;
+	return 0;
 }
 
-static void bcm47xx_wdt_stop(void)
+static struct watchdog_ops bcm47xx_wdt_hard_ops = {
+	.owner		= THIS_MODULE,
+	.start		= bcm47xx_wdt_hard_start,
+	.stop		= bcm47xx_wdt_hard_stop,
+	.ping		= bcm47xx_wdt_hard_keepalive,
+	.set_timeout	= bcm47xx_wdt_hard_set_timeout,
+};
+
+static void bcm47xx_wdt_soft_timer_tick(unsigned long data)
 {
-	bcm47xx_wdt_pause();
+	struct bcm47xx_wdt *wdt = (struct bcm47xx_wdt *)data;
+	u32 next_tick = min(wdt->wdd.timeout * 1000, wdt->max_timer_ms);
+
+	if (!atomic_dec_and_test(&wdt->soft_ticks)) {
+		wdt->timer_set_ms(wdt, next_tick);
+		mod_timer(&wdt->soft_timer, jiffies + HZ);
+	} else {
+		pr_crit("Watchdog will fire soon!!!\n");
+	}
 }
 
-static int bcm47xx_wdt_settimeout(int new_time)
+static int bcm47xx_wdt_soft_keepalive(struct watchdog_device *wdd)
 {
-	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
-		return -EINVAL;
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+
+	atomic_set(&wdt->soft_ticks, wdd->timeout);
 
-	wdt_time = new_time;
 	return 0;
 }
 
-static int bcm47xx_wdt_open(struct inode *inode, struct file *file)
+static int bcm47xx_wdt_soft_start(struct watchdog_device *wdd)
 {
-	if (test_and_set_bit(0, &bcm47xx_wdt_busy))
-		return -EBUSY;
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+
+	bcm47xx_wdt_soft_keepalive(wdd);
+	bcm47xx_wdt_soft_timer_tick((unsigned long)wdt);
 
-	bcm47xx_wdt_start();
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-static int bcm47xx_wdt_release(struct inode *inode, struct file *file)
+static int bcm47xx_wdt_soft_stop(struct watchdog_device *wdd)
 {
-	if (expect_release == 42) {
-		bcm47xx_wdt_stop();
-	} else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		bcm47xx_wdt_start();
-	}
+	struct bcm47xx_wdt *wdt = bcm47xx_wdt_get(wdd);
+
+	del_timer_sync(&wdt->soft_timer);
+	wdt->timer_set(wdt, 0);
 
-	clear_bit(0, &bcm47xx_wdt_busy);
-	expect_release = 0;
 	return 0;
 }
 
-static ssize_t bcm47xx_wdt_write(struct file *file, const char __user *data,
-				size_t len, loff_t *ppos)
+static int bcm47xx_wdt_soft_set_timeout(struct watchdog_device *wdd,
+					unsigned int new_time)
 {
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			expect_release = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_release = 42;
-			}
-		}
-		bcm47xx_wdt_pet();
+	if (new_time < 1 || new_time > WDT_SOFTTIMER_MAX) {
+		pr_warn("timeout value must be 1<=x<=%d, using %d\n",
+			WDT_SOFTTIMER_MAX, new_time);
+		return -EINVAL;
 	}
-	return len;
+
+	wdd->timeout = new_time;
+	return 0;
 }
 
 static const struct watchdog_info bcm47xx_wdt_info = {
@@ -180,130 +159,100 @@ static const struct watchdog_info bcm47xx_wdt_info = {
 				WDIOF_MAGICCLOSE,
 };
 
-static long bcm47xx_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_value, retval = -EINVAL;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &bcm47xx_wdt_info,
-				sizeof(bcm47xx_wdt_info)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_SETOPTIONS:
-		if (get_user(new_value, p))
-			return -EFAULT;
-
-		if (new_value & WDIOS_DISABLECARD) {
-			bcm47xx_wdt_stop();
-			retval = 0;
-		}
-
-		if (new_value & WDIOS_ENABLECARD) {
-			bcm47xx_wdt_start();
-			retval = 0;
-		}
-
-		return retval;
-
-	case WDIOC_KEEPALIVE:
-		bcm47xx_wdt_pet();
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_value, p))
-			return -EFAULT;
-
-		if (bcm47xx_wdt_settimeout(new_value))
-			return -EINVAL;
-
-		bcm47xx_wdt_pet();
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(wdt_time, p);
-
-	default:
-		return -ENOTTY;
-	}
-}
-
 static int bcm47xx_wdt_notify_sys(struct notifier_block *this,
-	unsigned long code, void *unused)
+				  unsigned long code, void *unused)
 {
+	struct bcm47xx_wdt *wdt;
+
+	wdt = container_of(this, struct bcm47xx_wdt, notifier);
 	if (code == SYS_DOWN || code == SYS_HALT)
-		bcm47xx_wdt_stop();
+		wdt->wdd.ops->stop(&wdt->wdd);
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations bcm47xx_wdt_fops = {
+static struct watchdog_ops bcm47xx_wdt_soft_ops = {
 	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.unlocked_ioctl	= bcm47xx_wdt_ioctl,
-	.open		= bcm47xx_wdt_open,
-	.release	= bcm47xx_wdt_release,
-	.write		= bcm47xx_wdt_write,
-};
-
-static struct miscdevice bcm47xx_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &bcm47xx_wdt_fops,
-};
-
-static struct notifier_block bcm47xx_wdt_notifier = {
-	.notifier_call = bcm47xx_wdt_notify_sys,
+	.start		= bcm47xx_wdt_soft_start,
+	.stop		= bcm47xx_wdt_soft_stop,
+	.ping		= bcm47xx_wdt_soft_keepalive,
+	.set_timeout	= bcm47xx_wdt_soft_set_timeout,
 };
 
-static int __init bcm47xx_wdt_init(void)
+static int bcm47xx_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
+	bool soft;
+	struct bcm47xx_wdt *wdt = dev_get_platdata(&pdev->dev);
 
-	if (bcm47xx_wdt_hw_stop() < 0)
-		return -ENODEV;
+	if (!wdt)
+		return -ENXIO;
 
-	setup_timer(&wdt_timer, bcm47xx_timer_tick, 0L);
+	soft = wdt->max_timer_ms < WDT_SOFTTIMER_THRESHOLD * 1000;
 
-	if (bcm47xx_wdt_settimeout(wdt_time)) {
-		bcm47xx_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info("wdt_time value must be 0 < wdt_time < %d, using %d\n",
-			(WDT_MAX_TIME + 1), wdt_time);
+	if (soft) {
+		wdt->wdd.ops = &bcm47xx_wdt_soft_ops;
+		setup_timer(&wdt->soft_timer, bcm47xx_wdt_soft_timer_tick,
+			    (long unsigned int)wdt);
+	} else {
+		wdt->wdd.ops = &bcm47xx_wdt_hard_ops;
 	}
 
-	ret = register_reboot_notifier(&bcm47xx_wdt_notifier);
+	wdt->wdd.info = &bcm47xx_wdt_info;
+	wdt->wdd.timeout = WDT_DEFAULT_TIME;
+	ret = wdt->wdd.ops->set_timeout(&wdt->wdd, timeout);
 	if (ret)
-		return ret;
+		goto err_timer;
+	watchdog_set_nowayout(&wdt->wdd, nowayout);
 
-	ret = misc_register(&bcm47xx_wdt_miscdev);
-	if (ret) {
-		unregister_reboot_notifier(&bcm47xx_wdt_notifier);
-		return ret;
-	}
+	wdt->notifier.notifier_call = &bcm47xx_wdt_notify_sys;
+
+	ret = register_reboot_notifier(&wdt->notifier);
+	if (ret)
+		goto err_timer;
 
-	pr_info("BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
-		wdt_time, nowayout ? ", nowayout" : "");
+	ret = watchdog_register_device(&wdt->wdd);
+	if (ret)
+		goto err_notifier;
+
+	dev_info(&pdev->dev, "BCM47xx Watchdog Timer enabled (%d seconds%s%s)\n",
+		timeout, nowayout ? ", nowayout" : "",
+		soft ? ", Software Timer" : "");
 	return 0;
+
+err_notifier:
+	unregister_reboot_notifier(&wdt->notifier);
+err_timer:
+	if (soft)
+		del_timer_sync(&wdt->soft_timer);
+
+	return ret;
 }
 
-static void __exit bcm47xx_wdt_exit(void)
+static int bcm47xx_wdt_remove(struct platform_device *pdev)
 {
-	if (!nowayout)
-		bcm47xx_wdt_stop();
+	struct bcm47xx_wdt *wdt = dev_get_platdata(&pdev->dev);
 
-	misc_deregister(&bcm47xx_wdt_miscdev);
+	if (!wdt)
+		return -ENXIO;
 
-	unregister_reboot_notifier(&bcm47xx_wdt_notifier);
+	watchdog_unregister_device(&wdt->wdd);
+	unregister_reboot_notifier(&wdt->notifier);
+
+	return 0;
 }
 
-module_init(bcm47xx_wdt_init);
-module_exit(bcm47xx_wdt_exit);
+static struct platform_driver bcm47xx_wdt_driver = {
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "bcm47xx-wdt",
+	},
+	.probe		= bcm47xx_wdt_probe,
+	.remove		= bcm47xx_wdt_remove,
+};
+
+module_platform_driver(bcm47xx_wdt_driver);
 
 MODULE_AUTHOR("Aleksandar Radovanovic");
+MODULE_AUTHOR("Hauke Mehrtens <hauke@hauke-m.de>");
 MODULE_DESCRIPTION("Watchdog driver for Broadcom BCM47xx");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index c0bc92d..a8dbceb 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -15,12 +15,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/fs.h>
 #include <linux/smp.h>
-#include <linux/miscdevice.h>
-#include <linux/notifier.h>
 #include <linux/watchdog.h>
-#include <linux/uaccess.h>
 
 #include <asm/reg_booke.h>
 #include <asm/time.h>
@@ -45,7 +41,7 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 #define WDTP_MASK	(TCR_WP_MASK)
 #endif
 
-static DEFINE_SPINLOCK(booke_wdt_lock);
+#ifdef CONFIG_PPC_FSL_BOOK3E
 
 /* For the specified period, determine the number of seconds
  * corresponding to the reset time.  There will be a watchdog
@@ -86,6 +82,24 @@ static unsigned int sec_to_period(unsigned int secs)
 	return 0;
 }
 
+#define MAX_WDT_TIMEOUT		period_to_sec(1)
+
+#else /* CONFIG_PPC_FSL_BOOK3E */
+
+static unsigned long long period_to_sec(unsigned int period)
+{
+	return period;
+}
+
+static unsigned int sec_to_period(unsigned int secs)
+{
+	return secs;
+}
+
+#define MAX_WDT_TIMEOUT		3	/* from Kconfig */
+
+#endif /* !CONFIG_PPC_FSL_BOOK3E */
+
 static void __booke_wdt_set(void *data)
 {
 	u32 val;
@@ -107,9 +121,11 @@ static void __booke_wdt_ping(void *data)
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
 }
 
-static void booke_wdt_ping(void)
+static int booke_wdt_ping(struct watchdog_device *wdog)
 {
 	on_each_cpu(__booke_wdt_ping, NULL, 0);
+
+	return 0;
 }
 
 static void __booke_wdt_enable(void *data)
@@ -146,152 +162,81 @@ static void __booke_wdt_disable(void *data)
 
 }
 
-static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
+static void __booke_wdt_start(struct watchdog_device *wdog)
 {
-	booke_wdt_ping();
-	return count;
+	on_each_cpu(__booke_wdt_enable, NULL, 0);
+	pr_debug("watchdog enabled (timeout = %u sec)\n", wdog->timeout);
 }
 
-static struct watchdog_info ident = {
-	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-	.identity = "PowerPC Book-E Watchdog",
-};
-
-static long booke_wdt_ioctl(struct file *file,
-				unsigned int cmd, unsigned long arg)
+static int booke_wdt_start(struct watchdog_device *wdog)
 {
-	u32 tmp = 0;
-	u32 __user *p = (u32 __user *)arg;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(p, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-		return put_user(0, p);
-	case WDIOC_GETBOOTSTATUS:
-		/* XXX: something is clearing TSR */
-		tmp = mfspr(SPRN_TSR) & TSR_WRS(3);
-		/* returns CARDRESET if last reset was caused by the WDT */
-		return put_user((tmp ? WDIOF_CARDRESET : 0), p);
-	case WDIOC_SETOPTIONS:
-		if (get_user(tmp, p))
-			return -EFAULT;
-		if (tmp == WDIOS_ENABLECARD) {
-			booke_wdt_ping();
-			break;
-		} else
-			return -EINVAL;
-		return 0;
-	case WDIOC_KEEPALIVE:
-		booke_wdt_ping();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(tmp, p))
-			return -EFAULT;
-#ifdef	CONFIG_PPC_FSL_BOOK3E
-		/* period of 1 gives the largest possible timeout */
-		if (tmp > period_to_sec(1))
-			return -EINVAL;
-		booke_wdt_period = sec_to_period(tmp);
-#else
-		booke_wdt_period = tmp;
-#endif
-		booke_wdt_set();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-#ifdef	CONFIG_FSL_BOOKE
-		return put_user(period_to_sec(booke_wdt_period), p);
-#else
-		return put_user(booke_wdt_period, p);
-#endif
-	default:
-		return -ENOTTY;
-	}
-
-	return 0;
-}
-
-/* wdt_is_active stores whether or not the /dev/watchdog device is opened */
-static unsigned long wdt_is_active;
-
-static int booke_wdt_open(struct inode *inode, struct file *file)
-{
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &wdt_is_active))
-		return -EBUSY;
-
-	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		on_each_cpu(__booke_wdt_enable, NULL, 0);
-		pr_debug("watchdog enabled (timeout = %llu sec)\n",
-			 period_to_sec(booke_wdt_period));
+		__booke_wdt_start(wdog);
 	}
-	spin_unlock(&booke_wdt_lock);
-
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-static int booke_wdt_release(struct inode *inode, struct file *file)
+static int booke_wdt_stop(struct watchdog_device *wdog)
 {
-#ifndef CONFIG_WATCHDOG_NOWAYOUT
-	/* Normally, the watchdog is disabled when /dev/watchdog is closed, but
-	 * if CONFIG_WATCHDOG_NOWAYOUT is defined, then it means that the
-	 * watchdog should remain enabled.  So we disable it only if
-	 * CONFIG_WATCHDOG_NOWAYOUT is not defined.
-	 */
 	on_each_cpu(__booke_wdt_disable, NULL, 0);
 	booke_wdt_enabled = 0;
 	pr_debug("watchdog disabled\n");
-#endif
 
-	clear_bit(0, &wdt_is_active);
+	return 0;
+}
+
+static int booke_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				 unsigned int timeout)
+{
+	if (timeout > MAX_WDT_TIMEOUT)
+		return -EINVAL;
+	booke_wdt_period = sec_to_period(timeout);
+	wdt_dev->timeout = timeout;
+	booke_wdt_set();
 
 	return 0;
 }
 
-static const struct file_operations booke_wdt_fops = {
+static struct watchdog_info booke_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "PowerPC Book-E Watchdog",
+};
+
+static struct watchdog_ops booke_wdt_ops = {
 	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = booke_wdt_write,
-	.unlocked_ioctl = booke_wdt_ioctl,
-	.open = booke_wdt_open,
-	.release = booke_wdt_release,
+	.start = booke_wdt_start,
+	.stop = booke_wdt_stop,
+	.ping = booke_wdt_ping,
+	.set_timeout = booke_wdt_set_timeout,
 };
 
-static struct miscdevice booke_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &booke_wdt_fops,
+static struct watchdog_device booke_wdt_dev = {
+	.info = &booke_wdt_info,
+	.ops = &booke_wdt_ops,
+	.min_timeout = 1,
+	.max_timeout = 0xFFFF
 };
 
 static void __exit booke_wdt_exit(void)
 {
-	misc_deregister(&booke_wdt_miscdev);
+	watchdog_unregister_device(&booke_wdt_dev);
 }
 
 static int __init booke_wdt_init(void)
 {
 	int ret = 0;
+	bool nowayout = WATCHDOG_NOWAYOUT;
 
 	pr_info("powerpc book-e watchdog driver loaded\n");
-	ident.firmware_version = cur_cpu_spec->pvr_value;
-
-	ret = misc_register(&booke_wdt_miscdev);
-	if (ret) {
-		pr_err("cannot register device (minor=%u, ret=%i)\n",
-		       WATCHDOG_MINOR, ret);
-		return ret;
-	}
-
-	spin_lock(&booke_wdt_lock);
-	if (booke_wdt_enabled == 1) {
-		pr_info("watchdog enabled (timeout = %llu sec)\n",
-			period_to_sec(booke_wdt_period));
-		on_each_cpu(__booke_wdt_enable, NULL, 0);
-	}
-	spin_unlock(&booke_wdt_lock);
+	booke_wdt_info.firmware_version = cur_cpu_spec->pvr_value;
+	booke_wdt_set_timeout(&booke_wdt_dev,
+			      period_to_sec(CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT));
+	watchdog_set_nowayout(&booke_wdt_dev, nowayout);
+	if (booke_wdt_enabled)
+		__booke_wdt_start(&booke_wdt_dev);
+
+	ret = watchdog_register_device(&booke_wdt_dev);
 
 	return ret;
 }
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index e8e8724..7df1fdc 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -69,7 +69,6 @@ static unsigned long wdt_status;
 #define WDT_REGION_INITED 2
 #define WDT_DEVICE_INITED 3
 
-static struct resource	*wdt_mem;
 static void __iomem	*wdt_base;
 struct clk		*wdt_clk;
 
@@ -201,10 +200,11 @@ static struct miscdevice davinci_wdt_miscdev = {
 
 static int davinci_wdt_probe(struct platform_device *pdev)
 {
-	int ret = 0, size;
+	int ret = 0;
 	struct device *dev = &pdev->dev;
+	struct resource  *wdt_mem;
 
-	wdt_clk = clk_get(dev, NULL);
+	wdt_clk = devm_clk_get(dev, NULL);
 	if (WARN_ON(IS_ERR(wdt_clk)))
 		return PTR_ERR(wdt_clk);
 
@@ -221,43 +221,26 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = resource_size(wdt_mem);
-	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
-		dev_err(dev, "failed to get memory region\n");
-		return -ENOENT;
-	}
-
-	wdt_base = ioremap(wdt_mem->start, size);
+	wdt_base = devm_request_and_ioremap(dev, wdt_mem);
 	if (!wdt_base) {
-		dev_err(dev, "failed to map memory region\n");
-		release_mem_region(wdt_mem->start, size);
-		wdt_mem = NULL;
-		return -ENOMEM;
+		dev_err(dev, "ioremap failed\n");
+		return -EADDRNOTAVAIL;
 	}
 
 	ret = misc_register(&davinci_wdt_miscdev);
 	if (ret < 0) {
 		dev_err(dev, "cannot register misc device\n");
-		release_mem_region(wdt_mem->start, size);
-		wdt_mem = NULL;
 	} else {
 		set_bit(WDT_DEVICE_INITED, &wdt_status);
 	}
 
-	iounmap(wdt_base);
 	return ret;
 }
 
 static int davinci_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&davinci_wdt_miscdev);
-	if (wdt_mem) {
-		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
-		wdt_mem = NULL;
-	}
-
 	clk_disable_unprepare(wdt_clk);
-	clk_put(wdt_clk);
 
 	return 0;
 }
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index b9c5b58..257cfba 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -310,6 +310,7 @@ static struct platform_driver gef_wdt_driver = {
 		.of_match_table = gef_wdt_ids,
 	},
 	.probe		= gef_wdt_probe,
+	.remove		= gef_wdt_remove,
 };
 
 static int __init gef_wdt_init(void)
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index b0e541d..af88ffd 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -45,6 +45,11 @@
 
 #include "omap_wdt.h"
 
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
 static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
@@ -201,7 +206,6 @@ static const struct watchdog_ops omap_wdt_ops = {
 static int omap_wdt_probe(struct platform_device *pdev)
 {
 	struct omap_wd_timer_platform_data *pdata = pdev->dev.platform_data;
-	bool nowayout = WATCHDOG_NOWAYOUT;
 	struct watchdog_device *omap_wdt;
 	struct resource *res, *mem;
 	struct omap_wdt_dev *wdev;
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 7c18b3b..da57798 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -140,6 +140,7 @@ static const struct watchdog_ops orion_wdt_ops = {
 static struct watchdog_device orion_wdt = {
 	.info = &orion_wdt_info,
 	.ops = &orion_wdt_ops,
+	.min_timeout = 1,
 };
 
 static int orion_wdt_probe(struct platform_device *pdev)
@@ -164,12 +165,9 @@ static int orion_wdt_probe(struct platform_device *pdev)
 
 	wdt_max_duration = WDT_MAX_CYCLE_COUNT / wdt_tclk;
 
-	if ((heartbeat < 1) || (heartbeat > wdt_max_duration))
-		heartbeat = wdt_max_duration;
-
-	orion_wdt.timeout = heartbeat;
-	orion_wdt.min_timeout = 1;
+	orion_wdt.timeout = wdt_max_duration;
 	orion_wdt.max_timeout = wdt_max_duration;
+	watchdog_init_timeout(&orion_wdt, heartbeat, &pdev->dev);
 
 	watchdog_set_nowayout(&orion_wdt, nowayout);
 	ret = watchdog_register_device(&orion_wdt);
@@ -179,7 +177,7 @@ static int orion_wdt_probe(struct platform_device *pdev)
 	}
 
 	pr_info("Initial timeout %d sec%s\n",
-		heartbeat, nowayout ? ", nowayout" : "");
+		orion_wdt.timeout, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -225,4 +223,5 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:orion_wdt");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index de1f3fa..a3684a3 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -142,6 +142,7 @@ static const struct watchdog_ops pnx4008_wdt_ops = {
 static struct watchdog_device pnx4008_wdd = {
 	.info = &pnx4008_wdt_ident,
 	.ops = &pnx4008_wdt_ops,
+	.timeout = DEFAULT_HEARTBEAT,
 	.min_timeout = 1,
 	.max_timeout = MAX_HEARTBEAT,
 };
@@ -151,8 +152,7 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 	struct resource *r;
 	int ret = 0;
 
-	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
-		heartbeat = DEFAULT_HEARTBEAT;
+	watchdog_init_timeout(&pnx4008_wdd, heartbeat, &pdev->dev);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	wdt_base = devm_ioremap_resource(&pdev->dev, r);
@@ -167,7 +167,6 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		goto out;
 
-	pnx4008_wdd.timeout = heartbeat;
 	pnx4008_wdd.bootstatus = (readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
 			WDIOF_CARDRESET : 0;
 	watchdog_set_nowayout(&pnx4008_wdd, nowayout);
@@ -181,7 +180,7 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 	}
 
 	dev_info(&pdev->dev, "PNX4008 Watchdog Timer: heartbeat %d sec\n",
-			heartbeat);
+		 pnx4008_wdd.timeout);
 
 	return 0;
 
diff --git a/drivers/watchdog/retu_wdt.c b/drivers/watchdog/retu_wdt.c
new file mode 100644
index 0000000..f53615d
--- /dev/null
+++ b/drivers/watchdog/retu_wdt.c
@@ -0,0 +1,178 @@
+/*
+ * Retu watchdog driver
+ *
+ * Copyright (C) 2004, 2005 Nokia Corporation
+ *
+ * Based on code written by Amit Kucheria and Michael Buesch.
+ * Rewritten by Aaro Koskinen.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/retu.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+
+/* Watchdog timer values in seconds */
+#define RETU_WDT_MAX_TIMER	63
+
+struct retu_wdt_dev {
+	struct retu_dev		*rdev;
+	struct device		*dev;
+	struct delayed_work	ping_work;
+};
+
+/*
+ * Since Retu watchdog cannot be disabled in hardware, we must kick it
+ * with a timer until userspace watchdog software takes over. If
+ * CONFIG_WATCHDOG_NOWAYOUT is set, we never start the feeding.
+ */
+static void retu_wdt_ping_enable(struct retu_wdt_dev *wdev)
+{
+	retu_write(wdev->rdev, RETU_REG_WATCHDOG, RETU_WDT_MAX_TIMER);
+	schedule_delayed_work(&wdev->ping_work,
+			round_jiffies_relative(RETU_WDT_MAX_TIMER * HZ / 2));
+}
+
+static void retu_wdt_ping_disable(struct retu_wdt_dev *wdev)
+{
+	retu_write(wdev->rdev, RETU_REG_WATCHDOG, RETU_WDT_MAX_TIMER);
+	cancel_delayed_work_sync(&wdev->ping_work);
+}
+
+static void retu_wdt_ping_work(struct work_struct *work)
+{
+	struct retu_wdt_dev *wdev = container_of(to_delayed_work(work),
+						struct retu_wdt_dev, ping_work);
+	retu_wdt_ping_enable(wdev);
+}
+
+static int retu_wdt_start(struct watchdog_device *wdog)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	retu_wdt_ping_disable(wdev);
+
+	return retu_write(wdev->rdev, RETU_REG_WATCHDOG, wdog->timeout);
+}
+
+static int retu_wdt_stop(struct watchdog_device *wdog)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	retu_wdt_ping_enable(wdev);
+
+	return 0;
+}
+
+static int retu_wdt_ping(struct watchdog_device *wdog)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	return retu_write(wdev->rdev, RETU_REG_WATCHDOG, wdog->timeout);
+}
+
+static int retu_wdt_set_timeout(struct watchdog_device *wdog,
+				unsigned int timeout)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	wdog->timeout = timeout;
+	return retu_write(wdev->rdev, RETU_REG_WATCHDOG, wdog->timeout);
+}
+
+static const struct watchdog_info retu_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "Retu watchdog",
+};
+
+static const struct watchdog_ops retu_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= retu_wdt_start,
+	.stop		= retu_wdt_stop,
+	.ping		= retu_wdt_ping,
+	.set_timeout	= retu_wdt_set_timeout,
+};
+
+static int retu_wdt_probe(struct platform_device *pdev)
+{
+	struct retu_dev *rdev = dev_get_drvdata(pdev->dev.parent);
+	bool nowayout = WATCHDOG_NOWAYOUT;
+	struct watchdog_device *retu_wdt;
+	struct retu_wdt_dev *wdev;
+	int ret;
+
+	retu_wdt = devm_kzalloc(&pdev->dev, sizeof(*retu_wdt), GFP_KERNEL);
+	if (!retu_wdt)
+		return -ENOMEM;
+
+	wdev = devm_kzalloc(&pdev->dev, sizeof(*wdev), GFP_KERNEL);
+	if (!wdev)
+		return -ENOMEM;
+
+	retu_wdt->info		= &retu_wdt_info;
+	retu_wdt->ops		= &retu_wdt_ops;
+	retu_wdt->timeout	= RETU_WDT_MAX_TIMER;
+	retu_wdt->min_timeout	= 0;
+	retu_wdt->max_timeout	= RETU_WDT_MAX_TIMER;
+
+	watchdog_set_drvdata(retu_wdt, wdev);
+	watchdog_set_nowayout(retu_wdt, nowayout);
+
+	wdev->rdev		= rdev;
+	wdev->dev		= &pdev->dev;
+
+	INIT_DELAYED_WORK(&wdev->ping_work, retu_wdt_ping_work);
+
+	ret = watchdog_register_device(retu_wdt);
+	if (ret < 0)
+		return ret;
+
+	if (nowayout)
+		retu_wdt_ping(retu_wdt);
+	else
+		retu_wdt_ping_enable(wdev);
+
+	platform_set_drvdata(pdev, retu_wdt);
+
+	return 0;
+}
+
+static int retu_wdt_remove(struct platform_device *pdev)
+{
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	watchdog_unregister_device(wdog);
+	cancel_delayed_work_sync(&wdev->ping_work);
+
+	return 0;
+}
+
+static struct platform_driver retu_wdt_driver = {
+	.probe		= retu_wdt_probe,
+	.remove		= retu_wdt_remove,
+	.driver		= {
+		.name	= "retu-wdt",
+	},
+};
+module_platform_driver(retu_wdt_driver);
+
+MODULE_ALIAS("platform:retu-wdt");
+MODULE_DESCRIPTION("Retu watchdog");
+MODULE_AUTHOR("Amit Kucheria");
+MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 27bcd4e..c1a221c 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -53,7 +53,7 @@
 #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
 
 static bool nowayout	= WATCHDOG_NOWAYOUT;
-static int tmr_margin	= CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME;
+static int tmr_margin;
 static int tmr_atboot	= CONFIG_S3C2410_WATCHDOG_ATBOOT;
 static int soft_noboot;
 static int debug;
@@ -226,6 +226,7 @@ static struct watchdog_ops s3c2410wdt_ops = {
 static struct watchdog_device s3c2410_wdd = {
 	.info = &s3c2410_wdt_ident,
 	.ops = &s3c2410wdt_ops,
+	.timeout = CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME,
 };
 
 /* interrupt handler code */
@@ -309,7 +310,6 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	unsigned int wtcon;
 	int started = 0;
 	int ret;
-	int size;
 
 	DBG("%s: probe=%p\n", __func__, pdev);
 
@@ -330,28 +330,20 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	}
 
 	/* get the memory region for the watchdog timer */
-
-	size = resource_size(wdt_mem);
-	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
-		dev_err(dev, "failed to get memory region\n");
-		ret = -EBUSY;
-		goto err;
-	}
-
-	wdt_base = ioremap(wdt_mem->start, size);
+	wdt_base = devm_request_and_ioremap(dev, wdt_mem);
 	if (wdt_base == NULL) {
-		dev_err(dev, "failed to ioremap() region\n");
-		ret = -EINVAL;
-		goto err_req;
+		dev_err(dev, "failed to devm_request_and_ioremap() region\n");
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	DBG("probe: mapped wdt_base=%p\n", wdt_base);
 
-	wdt_clock = clk_get(&pdev->dev, "watchdog");
+	wdt_clock = devm_clk_get(dev, "watchdog");
 	if (IS_ERR(wdt_clock)) {
 		dev_err(dev, "failed to find watchdog clock source\n");
 		ret = PTR_ERR(wdt_clock);
-		goto err_map;
+		goto err;
 	}
 
 	clk_prepare_enable(wdt_clock);
@@ -365,7 +357,8 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	/* see if we can actually set the requested timer margin, and if
 	 * not, try the default value */
 
-	if (s3c2410wdt_set_heartbeat(&s3c2410_wdd, tmr_margin)) {
+	watchdog_init_timeout(&s3c2410_wdd, tmr_margin,  &pdev->dev);
+	if (s3c2410wdt_set_heartbeat(&s3c2410_wdd, s3c2410_wdd.timeout)) {
 		started = s3c2410wdt_set_heartbeat(&s3c2410_wdd,
 					CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 
@@ -378,7 +371,8 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 							"cannot start\n");
 	}
 
-	ret = request_irq(wdt_irq->start, s3c2410wdt_irq, 0, pdev->name, pdev);
+	ret = devm_request_irq(dev, wdt_irq->start, s3c2410wdt_irq, 0,
+				pdev->name, pdev);
 	if (ret != 0) {
 		dev_err(dev, "failed to install irq (%d)\n", ret);
 		goto err_cpufreq;
@@ -389,7 +383,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	ret = watchdog_register_device(&s3c2410_wdd);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
-		goto err_irq;
+		goto err_cpufreq;
 	}
 
 	if (tmr_atboot && started == 0) {
@@ -414,23 +408,13 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
- err_irq:
-	free_irq(wdt_irq->start, pdev);
-
  err_cpufreq:
 	s3c2410wdt_cpufreq_deregister();
 
  err_clk:
 	clk_disable_unprepare(wdt_clock);
-	clk_put(wdt_clock);
 	wdt_clock = NULL;
 
- err_map:
-	iounmap(wdt_base);
-
- err_req:
-	release_mem_region(wdt_mem->start, size);
-
  err:
 	wdt_irq = NULL;
 	wdt_mem = NULL;
@@ -441,17 +425,11 @@ static int s3c2410wdt_remove(struct platform_device *dev)
 {
 	watchdog_unregister_device(&s3c2410_wdd);
 
-	free_irq(wdt_irq->start, dev);
-
 	s3c2410wdt_cpufreq_deregister();
 
 	clk_disable_unprepare(wdt_clock);
-	clk_put(wdt_clock);
 	wdt_clock = NULL;
 
-	iounmap(wdt_base);
-
-	release_mem_region(wdt_mem->start, resource_size(wdt_mem));
 	wdt_irq = NULL;
 	wdt_mem = NULL;
 	return 0;
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 2b0e000..e3b8f75 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -361,7 +361,7 @@ static unsigned char sp5100_tco_setupdevice(void)
 {
 	struct pci_dev *dev = NULL;
 	const char *dev_name = NULL;
-	u32 val;
+	u32 val, tmp_val;
 	u32 index_reg, data_reg, base_addr;
 
 	/* Match the PCI device */
@@ -497,30 +497,19 @@ static unsigned char sp5100_tco_setupdevice(void)
 		pr_debug("Got 0x%04x from resource tree\n", val);
 	}
 
-	/* Restore to the low three bits, if chipset is SB8x0(or later) */
-	if (sp5100_tco_pci->revision >= 0x40) {
-		u8 reserved_bit;
-		reserved_bit = inb(base_addr) & 0x7;
-		val |= (u32)reserved_bit;
-	}
+	/* Restore to the low three bits */
+	outb(base_addr+0, index_reg);
+	tmp_val = val | (inb(data_reg) & 0x7);
 
 	/* Re-programming the watchdog timer base address */
 	outb(base_addr+0, index_reg);
-	/* Low three bits of BASE are reserved */
-	outb((val >>  0) & 0xf8, data_reg);
+	outb((tmp_val >>  0) & 0xff, data_reg);
 	outb(base_addr+1, index_reg);
-	outb((val >>  8) & 0xff, data_reg);
+	outb((tmp_val >>  8) & 0xff, data_reg);
 	outb(base_addr+2, index_reg);
-	outb((val >> 16) & 0xff, data_reg);
+	outb((tmp_val >> 16) & 0xff, data_reg);
 	outb(base_addr+3, index_reg);
-	outb((val >> 24) & 0xff, data_reg);
-
-	/*
-	 * Clear unnecessary the low three bits,
-	 * if chipset is SB8x0(or later)
-	 */
-	if (sp5100_tco_pci->revision >= 0x40)
-		val &= ~0x7;
+	outb((tmp_val >> 24) & 0xff, data_reg);
 
 	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
 								   dev_name)) {
diff --git a/drivers/watchdog/stmp3xxx_rtc_wdt.c b/drivers/watchdog/stmp3xxx_rtc_wdt.c
new file mode 100644
index 0000000..c97e98d
--- /dev/null
+++ b/drivers/watchdog/stmp3xxx_rtc_wdt.c
@@ -0,0 +1,111 @@
+/*
+ * Watchdog driver for the RTC based watchdog in STMP3xxx and i.MX23/28
+ *
+ * Author: Wolfram Sang <w.sang@pengutronix.de>
+ *
+ * Copyright (C) 2011-12 Wolfram Sang, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/stmp3xxx_rtc_wdt.h>
+
+#define WDOG_TICK_RATE 1000 /* 1 kHz clock */
+#define STMP3XXX_DEFAULT_TIMEOUT 19
+#define STMP3XXX_MAX_TIMEOUT (UINT_MAX / WDOG_TICK_RATE)
+
+static int heartbeat = STMP3XXX_DEFAULT_TIMEOUT;
+module_param(heartbeat, uint, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat period in seconds from 1 to "
+		 __MODULE_STRING(STMP3XXX_MAX_TIMEOUT) ", default "
+		 __MODULE_STRING(STMP3XXX_DEFAULT_TIMEOUT));
+
+static int wdt_start(struct watchdog_device *wdd)
+{
+	struct device *dev = watchdog_get_drvdata(wdd);
+	struct stmp3xxx_wdt_pdata *pdata = dev->platform_data;
+
+	pdata->wdt_set_timeout(dev->parent, wdd->timeout * WDOG_TICK_RATE);
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *wdd)
+{
+	struct device *dev = watchdog_get_drvdata(wdd);
+	struct stmp3xxx_wdt_pdata *pdata = dev->platform_data;
+
+	pdata->wdt_set_timeout(dev->parent, 0);
+	return 0;
+}
+
+static int wdt_set_timeout(struct watchdog_device *wdd, unsigned new_timeout)
+{
+	wdd->timeout = new_timeout;
+	return wdt_start(wdd);
+}
+
+static const struct watchdog_info stmp3xxx_wdt_ident = {
+	.options = WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "STMP3XXX RTC Watchdog",
+};
+
+static const struct watchdog_ops stmp3xxx_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = wdt_start,
+	.stop = wdt_stop,
+	.set_timeout = wdt_set_timeout,
+};
+
+static struct watchdog_device stmp3xxx_wdd = {
+	.info = &stmp3xxx_wdt_ident,
+	.ops = &stmp3xxx_wdt_ops,
+	.min_timeout = 1,
+	.max_timeout = STMP3XXX_MAX_TIMEOUT,
+	.status = WATCHDOG_NOWAYOUT_INIT_STATUS,
+};
+
+static int stmp3xxx_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	watchdog_set_drvdata(&stmp3xxx_wdd, &pdev->dev);
+
+	stmp3xxx_wdd.timeout = clamp_t(unsigned, heartbeat, 1, STMP3XXX_MAX_TIMEOUT);
+
+	ret = watchdog_register_device(&stmp3xxx_wdd);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot register watchdog device\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "initialized watchdog with heartbeat %ds\n",
+			stmp3xxx_wdd.timeout);
+	return 0;
+}
+
+static int stmp3xxx_wdt_remove(struct platform_device *pdev)
+{
+	watchdog_unregister_device(&stmp3xxx_wdd);
+	return 0;
+}
+
+static struct platform_driver stmp3xxx_wdt_driver = {
+	.driver = {
+		.name = "stmp3xxx_rtc_wdt",
+	},
+	.probe = stmp3xxx_wdt_probe,
+	.remove = stmp3xxx_wdt_remove,
+};
+module_platform_driver(stmp3xxx_wdt_driver);
+
+MODULE_DESCRIPTION("STMP3XXX RTC Watchdog Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
deleted file mode 100644
index 1f4f697..0000000
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ /dev/null
@@ -1,288 +0,0 @@
-/*
- * Watchdog driver for Freescale STMP37XX/STMP378X
- *
- * Author: Vitaly Wool <vital@embeddedalley.com>
- *
- * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
- * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/platform_device.h>
-#include <linux/spinlock.h>
-#include <linux/uaccess.h>
-#include <linux/module.h>
-
-#include <mach/platform.h>
-#include <mach/regs-rtc.h>
-
-#define DEFAULT_HEARTBEAT	19
-#define MAX_HEARTBEAT		(0x10000000 >> 6)
-
-/* missing bitmask in headers */
-#define BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER     0x80000000
-
-#define WDT_IN_USE		0
-#define WDT_OK_TO_CLOSE		1
-
-#define WDOG_COUNTER_RATE	1000 /* 1 kHz clock */
-
-static DEFINE_SPINLOCK(stmp3xxx_wdt_io_lock);
-static unsigned long wdt_status;
-static const bool nowayout = WATCHDOG_NOWAYOUT;
-static int heartbeat = DEFAULT_HEARTBEAT;
-static unsigned long boot_status;
-
-static void wdt_enable(u32 value)
-{
-	spin_lock(&stmp3xxx_wdt_io_lock);
-	__raw_writel(value, REGS_RTC_BASE + HW_RTC_WATCHDOG);
-	stmp3xxx_setl(BM_RTC_CTRL_WATCHDOGEN, REGS_RTC_BASE + HW_RTC_CTRL);
-	stmp3xxx_setl(BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER,
-			REGS_RTC_BASE + HW_RTC_PERSISTENT1);
-	spin_unlock(&stmp3xxx_wdt_io_lock);
-}
-
-static void wdt_disable(void)
-{
-	spin_lock(&stmp3xxx_wdt_io_lock);
-	stmp3xxx_clearl(BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER,
-			REGS_RTC_BASE + HW_RTC_PERSISTENT1);
-	stmp3xxx_clearl(BM_RTC_CTRL_WATCHDOGEN, REGS_RTC_BASE + HW_RTC_CTRL);
-	spin_unlock(&stmp3xxx_wdt_io_lock);
-}
-
-static void wdt_ping(void)
-{
-	wdt_enable(heartbeat * WDOG_COUNTER_RATE);
-}
-
-static int stmp3xxx_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-	wdt_ping();
-
-	return nonseekable_open(inode, file);
-}
-
-static ssize_t stmp3xxx_wdt_write(struct file *file, const char __user *data,
-	size_t len, loff_t *ppos)
-{
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		wdt_ping();
-	}
-
-	return len;
-}
-
-static const struct watchdog_info ident = {
-	.options	= WDIOF_CARDRESET |
-			  WDIOF_MAGICCLOSE |
-			  WDIOF_SETTIMEOUT |
-			  WDIOF_KEEPALIVEPING,
-	.identity	= "STMP3XXX Watchdog",
-};
-
-static long stmp3xxx_wdt_ioctl(struct file *file, unsigned int cmd,
-	unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_heartbeat, opts;
-	int ret = -ENOTTY;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-		ret = put_user(0, p);
-		break;
-
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(boot_status, p);
-		break;
-
-	case WDIOC_SETOPTIONS:
-		if (get_user(opts, p)) {
-			ret = -EFAULT;
-			break;
-		}
-		if (opts & WDIOS_DISABLECARD)
-			wdt_disable();
-		else if (opts & WDIOS_ENABLECARD)
-			wdt_ping();
-		else {
-			pr_debug("%s: unknown option 0x%x\n", __func__, opts);
-			ret = -EINVAL;
-			break;
-		}
-		ret = 0;
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_ping();
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_heartbeat, p)) {
-			ret = -EFAULT;
-			break;
-		}
-		if (new_heartbeat <= 0 || new_heartbeat > MAX_HEARTBEAT) {
-			ret = -EINVAL;
-			break;
-		}
-
-		heartbeat = new_heartbeat;
-		wdt_ping();
-		/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, p);
-		break;
-	}
-	return ret;
-}
-
-static int stmp3xxx_wdt_release(struct inode *inode, struct file *file)
-{
-	int ret = 0;
-
-	if (!nowayout) {
-		if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
-			wdt_ping();
-			pr_debug("%s: Device closed unexpectedly\n", __func__);
-			ret = -EINVAL;
-		} else {
-			wdt_disable();
-			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-		}
-	}
-	clear_bit(WDT_IN_USE, &wdt_status);
-
-	return ret;
-}
-
-static const struct file_operations stmp3xxx_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = stmp3xxx_wdt_write,
-	.unlocked_ioctl = stmp3xxx_wdt_ioctl,
-	.open = stmp3xxx_wdt_open,
-	.release = stmp3xxx_wdt_release,
-};
-
-static struct miscdevice stmp3xxx_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &stmp3xxx_wdt_fops,
-};
-
-static int stmp3xxx_wdt_probe(struct platform_device *pdev)
-{
-	int ret = 0;
-
-	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
-		heartbeat = DEFAULT_HEARTBEAT;
-
-	boot_status = __raw_readl(REGS_RTC_BASE + HW_RTC_PERSISTENT1) &
-			BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER;
-	boot_status = !!boot_status;
-	stmp3xxx_clearl(BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER,
-			REGS_RTC_BASE + HW_RTC_PERSISTENT1);
-	wdt_disable();		/* disable for now */
-
-	ret = misc_register(&stmp3xxx_wdt_miscdev);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot register misc device\n");
-		return ret;
-	}
-
-	pr_info("initialized, heartbeat %d sec\n", heartbeat);
-
-	return ret;
-}
-
-static int stmp3xxx_wdt_remove(struct platform_device *pdev)
-{
-	misc_deregister(&stmp3xxx_wdt_miscdev);
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int wdt_suspended;
-static u32 wdt_saved_time;
-
-static int stmp3xxx_wdt_suspend(struct platform_device *pdev,
-				pm_message_t state)
-{
-	if (__raw_readl(REGS_RTC_BASE + HW_RTC_CTRL) &
-		BM_RTC_CTRL_WATCHDOGEN) {
-		wdt_suspended = 1;
-		wdt_saved_time = __raw_readl(REGS_RTC_BASE + HW_RTC_WATCHDOG);
-		wdt_disable();
-	}
-	return 0;
-}
-
-static int stmp3xxx_wdt_resume(struct platform_device *pdev)
-{
-	if (wdt_suspended) {
-		wdt_enable(wdt_saved_time);
-		wdt_suspended = 0;
-	}
-	return 0;
-}
-#else
-#define stmp3xxx_wdt_suspend	NULL
-#define stmp3xxx_wdt_resume	NULL
-#endif
-
-static struct platform_driver platform_wdt_driver = {
-	.driver = {
-		.name = "stmp3xxx_wdt",
-	},
-	.probe = stmp3xxx_wdt_probe,
-	.remove = stmp3xxx_wdt_remove,
-	.suspend = stmp3xxx_wdt_suspend,
-	.resume = stmp3xxx_wdt_resume,
-};
-
-module_platform_driver(platform_wdt_driver);
-
-MODULE_DESCRIPTION("STMP3XXX Watchdog Driver");
-MODULE_LICENSE("GPL");
-
-module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat,
-		 "Watchdog heartbeat period in seconds from 1 to "
-		 __MODULE_STRING(MAX_HEARTBEAT) ", default "
-		 __MODULE_STRING(DEFAULT_HEARTBEAT));
-
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 3796434..05d18b4 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -36,12 +36,68 @@
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/idr.h>		/* For ida_* macros */
 #include <linux/err.h>		/* For IS_ERR macros */
+#include <linux/of.h>		/* For of_get_timeout_sec */
 
 #include "watchdog_core.h"	/* For watchdog_dev_register/... */
 
 static DEFINE_IDA(watchdog_ida);
 static struct class *watchdog_class;
 
+static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
+{
+	/*
+	 * Check that we have valid min and max timeout values, if
+	 * not reset them both to 0 (=not used or unknown)
+	 */
+	if (wdd->min_timeout > wdd->max_timeout) {
+		pr_info("Invalid min and max timeout values, resetting to 0!\n");
+		wdd->min_timeout = 0;
+		wdd->max_timeout = 0;
+	}
+}
+
+/**
+ * watchdog_init_timeout() - initialize the timeout field
+ * @timeout_parm: timeout module parameter
+ * @dev: Device that stores the timeout-sec property
+ *
+ * Initialize the timeout field of the watchdog_device struct with either the
+ * timeout module parameter (if it is valid value) or the timeout-sec property
+ * (only if it is a valid value and the timeout_parm is out of bounds).
+ * If none of them are valid then we keep the old value (which should normally
+ * be the default timeout value.
+ *
+ * A zero is returned on success and -EINVAL for failure.
+ */
+int watchdog_init_timeout(struct watchdog_device *wdd,
+				unsigned int timeout_parm, struct device *dev)
+{
+	unsigned int t = 0;
+	int ret = 0;
+
+	watchdog_check_min_max_timeout(wdd);
+
+	/* try to get the tiemout module parameter first */
+	if (!watchdog_timeout_invalid(wdd, timeout_parm)) {
+		wdd->timeout = timeout_parm;
+		return ret;
+	}
+	if (timeout_parm)
+		ret = -EINVAL;
+
+	/* try to get the timeout_sec property */
+	if (dev == NULL || dev->of_node == NULL)
+		return ret;
+	of_property_read_u32(dev->of_node, "timeout-sec", &t);
+	if (!watchdog_timeout_invalid(wdd, t))
+		wdd->timeout = t;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(watchdog_init_timeout);
+
 /**
  * watchdog_register_device() - register a watchdog device
  * @wdd: watchdog device
@@ -63,15 +119,7 @@ int watchdog_register_device(struct watchdog_device *wdd)
 	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
 		return -EINVAL;
 
-	/*
-	 * Check that we have valid min and max timeout values, if
-	 * not reset them both to 0 (=not used or unknown)
-	 */
-	if (wdd->min_timeout > wdd->max_timeout) {
-		pr_info("Invalid min and max timeout values, resetting to 0!\n");
-		wdd->min_timeout = 0;
-		wdd->max_timeout = 0;
-	}
+	watchdog_check_min_max_timeout(wdd);
 
 	/*
 	 * Note: now that all watchdog_device data has been verified, we
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ef8edec..08b48bb 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -200,8 +200,7 @@ static int watchdog_set_timeout(struct watchdog_device *wddev,
 	    !(wddev->info->options & WDIOF_SETTIMEOUT))
 		return -EOPNOTSUPP;
 
-	if ((wddev->max_timeout != 0) &&
-	    (timeout < wddev->min_timeout || timeout > wddev->max_timeout))
+	if (watchdog_timeout_invalid(wddev, timeout))
 		return -EINVAL;
 
 	mutex_lock(&wddev->lock);
diff --git a/include/linux/bcm47xx_wdt.h b/include/linux/bcm47xx_wdt.h
index e5dfc25..b708786 100644
--- a/include/linux/bcm47xx_wdt.h
+++ b/include/linux/bcm47xx_wdt.h
@@ -1,7 +1,10 @@
 #ifndef LINUX_BCM47XX_WDT_H_
 #define LINUX_BCM47XX_WDT_H_
 
+#include <linux/notifier.h>
+#include <linux/timer.h>
 #include <linux/types.h>
+#include <linux/watchdog.h>
 
 
 struct bcm47xx_wdt {
@@ -10,6 +13,12 @@ struct bcm47xx_wdt {
 	u32 max_timer_ms;
 
 	void *driver_data;
+
+	struct watchdog_device wdd;
+	struct notifier_block notifier;
+
+	struct timer_list soft_timer;
+	atomic_t soft_ticks;
 };
 
 static inline void *bcm47xx_wdt_get_drvdata(struct bcm47xx_wdt *wdt)
diff --git a/include/linux/stmp3xxx_rtc_wdt.h b/include/linux/stmp3xxx_rtc_wdt.h
new file mode 100644
index 0000000..1dd12c9
--- /dev/null
+++ b/include/linux/stmp3xxx_rtc_wdt.h
@@ -0,0 +1,15 @@
+/*
+ * stmp3xxx_rtc_wdt.h
+ *
+ * Copyright (C) 2011 Wolfram Sang, Pengutronix e.K.
+ *
+ * This file is released under the GPLv2.
+ */
+#ifndef __LINUX_STMP3XXX_RTC_WDT_H
+#define __LINUX_STMP3XXX_RTC_WDT_H
+
+struct stmp3xxx_wdt_pdata {
+	void (*wdt_set_timeout)(struct device *dev, u32 timeout);
+};
+
+#endif /* __LINUX_STMP3XXX_RTC_WDT_H */
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 3a9df2f..2a3038e 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -118,6 +118,13 @@ static inline void watchdog_set_nowayout(struct watchdog_device *wdd, bool noway
 		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
 }
 
+/* Use the following function to check if a timeout value is invalid */
+static inline bool watchdog_timeout_invalid(struct watchdog_device *wdd, unsigned int t)
+{
+	return ((wdd->max_timeout != 0) &&
+		(t < wdd->min_timeout || t > wdd->max_timeout));
+}
+
 /* Use the following functions to manipulate watchdog driver specific data */
 static inline void watchdog_set_drvdata(struct watchdog_device *wdd, void *data)
 {
@@ -130,6 +137,8 @@ static inline void *watchdog_get_drvdata(struct watchdog_device *wdd)
 }
 
 /* drivers/watchdog/watchdog_core.c */
+extern int watchdog_init_timeout(struct watchdog_device *wdd,
+				  unsigned int timeout_parm, struct device *dev);
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
