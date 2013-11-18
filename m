Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3KRUxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:53:21 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:42360 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751883Ab3KRUxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:53:19 -0500
Date: Mon, 18 Nov 2013 21:53:00 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dinh Nguyen <dinguyen@altera.com>, Guenter Roeck <linux@roeck-us.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Jean Delvare <jdelvare@suse.de>, Jingoo Han <jg1.han@samsung.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        John Crispin <blogic@openwrt.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Niels de Vos <ndevos@redhat.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Xianglong Du <Xianglong.Du@csr.com>
Subject: [GIT PULL REQUEST] watchdog - v3.12 merge window
Message-ID: <20131118205300.GK10136@spo001.leaseweb.com>
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

This pull request contains:
* addition of MOXA ART watchdog driver (moxart_wdt)
* addition of CSR SiRFprimaII and SiRFatlasVI watchdog driver (sirfsoc_wdt)
* addition of ralink watchdog driver (rt2880_wdt)
* various fixes and cleanups (__user annotation, ioctl return codes,
  removal of redundant of_match_ptr, removal of unnecessary amba_set_drvdata(),
  use allocated buffer for usb_control_msg, ...)
* removal of MODULE_ALIAS_MISCDEV statements
* watchdog related DT bindings
* first set of improvements on the w83627hf_wdt driver

This will update the following files:

 Documentation/devicetree/bindings/gpio/men-a021-wdt.txt               |   22 
 b/Documentation/devicetree/bindings/watchdog/dw_wdt.txt               |   21 
 b/Documentation/devicetree/bindings/watchdog/men-a021-wdt.txt         |   25 
 b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt |   15 
 b/Documentation/devicetree/bindings/watchdog/rt2880-wdt.txt           |   19 
 b/Documentation/devicetree/bindings/watchdog/sirfsoc_wdt.txt          |   14 
 b/arch/arm/configs/prima2_defconfig                                   |    1 
 b/drivers/watchdog/Kconfig                                            |   27 
 b/drivers/watchdog/Makefile                                           |    3 
 b/drivers/watchdog/acquirewdt.c                                       |    4 
 b/drivers/watchdog/advantechwdt.c                                     |    1 
 b/drivers/watchdog/alim1535_wdt.c                                     |    1 
 b/drivers/watchdog/alim7101_wdt.c                                     |    1 
 b/drivers/watchdog/ar7_wdt.c                                          |    1 
 b/drivers/watchdog/at32ap700x_wdt.c                                   |    1 
 b/drivers/watchdog/at91rm9200_wdt.c                                   |    3 
 b/drivers/watchdog/ath79_wdt.c                                        |    1 
 b/drivers/watchdog/bcm2835_wdt.c                                      |    1 
 b/drivers/watchdog/bcm63xx_wdt.c                                      |    1 
 b/drivers/watchdog/bfin_wdt.c                                         |    1 
 b/drivers/watchdog/cpu5wdt.c                                          |    1 
 b/drivers/watchdog/davinci_wdt.c                                      |    1 
 b/drivers/watchdog/dw_wdt.c                                           |   36 -
 b/drivers/watchdog/ep93xx_wdt.c                                       |    1 
 b/drivers/watchdog/eurotechwdt.c                                      |    1 
 b/drivers/watchdog/gef_wdt.c                                          |    1 
 b/drivers/watchdog/geodewdt.c                                         |    1 
 b/drivers/watchdog/hpwdt.c                                            |    1 
 b/drivers/watchdog/i6300esb.c                                         |    1 
 b/drivers/watchdog/iTCO_wdt.c                                         |    5 
 b/drivers/watchdog/ib700wdt.c                                         |    1 
 b/drivers/watchdog/ibmasr.c                                           |    1 
 b/drivers/watchdog/ie6xx_wdt.c                                        |    1 
 b/drivers/watchdog/imx2_wdt.c                                         |    2 
 b/drivers/watchdog/indydog.c                                          |    1 
 b/drivers/watchdog/intel_scu_watchdog.c                               |    1 
 b/drivers/watchdog/iop_wdt.c                                          |    1 
 b/drivers/watchdog/it8712f_wdt.c                                      |    1 
 b/drivers/watchdog/it87_wdt.c                                         |    1 
 b/drivers/watchdog/ixp4xx_wdt.c                                       |    2 
 b/drivers/watchdog/jz4740_wdt.c                                       |    1 
 b/drivers/watchdog/kempld_wdt.c                                       |    5 
 b/drivers/watchdog/ks8695_wdt.c                                       |    1 
 b/drivers/watchdog/lantiq_wdt.c                                       |    1 
 b/drivers/watchdog/m54xx_wdt.c                                        |    1 
 b/drivers/watchdog/machzwd.c                                          |    1 
 b/drivers/watchdog/max63xx_wdt.c                                      |    1 
 b/drivers/watchdog/mixcomwd.c                                         |    1 
 b/drivers/watchdog/moxart_wdt.c                                       |  165 ++++
 b/drivers/watchdog/mpc8xxx_wdt.c                                      |    1 
 b/drivers/watchdog/mtx-1_wdt.c                                        |    1 
 b/drivers/watchdog/mv64x60_wdt.c                                      |    3 
 b/drivers/watchdog/nuc900_wdt.c                                       |    1 
 b/drivers/watchdog/nv_tco.c                                           |    1 
 b/drivers/watchdog/of_xilinx_wdt.c                                    |    1 
 b/drivers/watchdog/omap_wdt.c                                         |   38 -
 b/drivers/watchdog/orion_wdt.c                                        |    3 
 b/drivers/watchdog/pc87413_wdt.c                                      |    2 
 b/drivers/watchdog/pcwd.c                                             |    4 
 b/drivers/watchdog/pcwd_pci.c                                         |    4 
 b/drivers/watchdog/pcwd_usb.c                                         |   16 
 b/drivers/watchdog/pika_wdt.c                                         |    2 
 b/drivers/watchdog/pnx4008_wdt.c                                      |    1 
 b/drivers/watchdog/pnx833x_wdt.c                                      |    1 
 b/drivers/watchdog/rc32434_wdt.c                                      |    4 
 b/drivers/watchdog/rdc321x_wdt.c                                      |    3 
 b/drivers/watchdog/rt2880_wdt.c                                       |  207 ++++++
 b/drivers/watchdog/s3c2410_wdt.c                                      |    2 
 b/drivers/watchdog/sa1100_wdt.c                                       |    1 
 b/drivers/watchdog/sb_wdog.c                                          |    1 
 b/drivers/watchdog/sbc60xxwdt.c                                       |    1 
 b/drivers/watchdog/sbc7240_wdt.c                                      |    2 
 b/drivers/watchdog/sbc8360.c                                          |    1 
 b/drivers/watchdog/sbc_epx_c3.c                                       |    1 
 b/drivers/watchdog/sbc_fitpc2_wdt.c                                   |    2 
 b/drivers/watchdog/sc1200wdt.c                                        |    1 
 b/drivers/watchdog/sc520_wdt.c                                        |    1 
 b/drivers/watchdog/sch311x_wdt.c                                      |    5 
 b/drivers/watchdog/scx200_wdt.c                                       |    1 
 b/drivers/watchdog/shwdt.c                                            |    1 
 b/drivers/watchdog/sirfsoc_wdt.c                                      |  226 ++++++
 b/drivers/watchdog/smsc37b787_wdt.c                                   |    2 
 b/drivers/watchdog/softdog.c                                          |    1 
 b/drivers/watchdog/sp5100_tco.c                                       |    1 
 b/drivers/watchdog/sp805_wdt.c                                        |    1 
 b/drivers/watchdog/stmp3xxx_rtc_wdt.c                                 |    5 
 b/drivers/watchdog/sunxi_wdt.c                                        |    2 
 b/drivers/watchdog/ts72xx_wdt.c                                       |   38 -
 b/drivers/watchdog/txx9wdt.c                                          |    1 
 b/drivers/watchdog/ux500_wdt.c                                        |    3 
 b/drivers/watchdog/w83627hf_wdt.c                                     |  341 +++-------
 b/drivers/watchdog/w83697hf_wdt.c                                     |    1 
 b/drivers/watchdog/w83697ug_wdt.c                                     |    1 
 b/drivers/watchdog/w83877f_wdt.c                                      |    1 
 b/drivers/watchdog/w83977f_wdt.c                                      |    1 
 b/drivers/watchdog/wafer5823wdt.c                                     |    1 
 b/drivers/watchdog/watchdog_core.c                                    |    2 
 b/drivers/watchdog/wdrtas.c                                           |    2 
 b/drivers/watchdog/wdt.c                                              |    2 
 b/drivers/watchdog/wdt285.c                                           |    1 
 b/drivers/watchdog/wdt977.c                                           |    1 
 b/drivers/watchdog/wdt_pci.c                                          |    2 
 b/drivers/watchdog/wm831x_wdt.c                                       |    8 
 b/drivers/watchdog/xen_wdt.c                                          |    1 
 104 files changed, 930 insertions(+), 429 deletions(-)

with these Changes:

commit ef0c1a6b1b05f85f0a1cf6ef283512fd25d86ad4
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Aug 17 13:58:42 2013 -0700

    watchdog: w83627hf: Use helper functions to access superio registers
    
    Use helper functions named similar to other drivers to access
    superio registers.
    
    Request memory region only when needed, and use request_muxed_region().
    This lets other devices (hwmon, gpio) use the same region.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ac461103c57ac46cd6778f1fd0352ff0e4a2d38e
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Aug 17 13:58:41 2013 -0700

    watchdog: w83627hf: Enable watchdog device only if not already enabled
    
    There is no need to enable the watchdog device if it is already enabled.
    Also, when enabling the watchdog device, only set the watchdog device
    enable bit and do not touch other bits; depending on the chip type,
    those bits may enable other functionality.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8f526389599fc543b204c12a36de8345eb298085
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Aug 17 13:58:40 2013 -0700

    watchdog: w83627hf: Enable watchdog only once
    
    It is unnecessary to enable the logical device and WDT0 each time
    the watchdog is accessed. Do it only once during initialization.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 30a83695aa2ed3ffb1445d6daef1e620c3ca4e6d
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Mon Oct 28 19:43:57 2013 -0700

    watchdog: w83627hf: Convert to watchdog infrastructure
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4a7e94a0637da7e1ddce748da49ae780c370eeef
Author: Victor Kamensky <victor.kamensky@linaro.org>
Date:   Sat Nov 16 02:01:05 2013 +0200

    watchdog: omap_wdt: raw read and write endian fix
    
    All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
    Need to use endian neutral functions to read/write h/w registers.
    I.e instead of __raw_read[lw] and __raw_write[lw] functions code
    need to use read[lw]_relaxed and write[lw]_relaxed functions.
    If the first simply reads/writes register, the second will byteswap
    it if host operates in BE mode.
    
    Changes are trivial sed like replacement of __raw_xxx functions
    with xxx_relaxed variant.
    
    Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
    Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b0df38dd3554d47fcfd5c1183951c2fe7dd07eda
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Mon Nov 11 21:33:44 2013 +0100

    watchdog: sirf: don't depend on dummy value of CLOCK_TICK_RATE
    
    As CSR SiRF is converted to multi platform CLOCK_TICK_RATE is a dummy
    value that seems to match the right value is used.
    (arch/arm/mach-prima2/include/mach/timex.h which defined CLOCK_TICK_RATE
    to 1000000 was removed in commit cf82e0e (ARM: sirf: enable
    multiplatform support); marco used the same file.)
    
    To not depend on that dummy value use a local #define instead.
    
    Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ab5bbdc7015bb35c364ad5f3c955736b17d1acb6
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri Nov 8 01:24:19 2013 -0800

    watchdog: pcwd_usb: overflow in usb_pcwd_send_command()
    
    We changed "buf" from being an array of 6 chars to being a pointer this
    sizeof(buf) needs to be updated as well.
    
    Fixes: 2ddb8089a7e5 ('watchdog: pcwd_usb: Use allocated buffer for usb_control_msg')
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0859ffc3b3cb673ac1d3f33b0265cf60d1e3836d
Author: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Date:   Thu Oct 31 15:50:55 2013 +0800

    watchdog: rt2880_wdt: fix return value check in rt288x_wdt_probe()
    
    In case of error, the function devm_request_and_ioremap() returns NULL
    pointer not ERR_PTR(). Fix it by using devm_ioremap_resource() instead
    of devm_request_and_ioremap().
    
    Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6ffcff931971ce78d08220a7a3bbaddaea207598
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Mon Oct 28 14:17:17 2013 +0530

    watchdog: watchdog_core: Fix a trivial typo
    
    Fixed a trivial typo.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 58e5637333afc2bb024ff8aef212311be0614d47
Author: Dinh Nguyen <dinguyen@altera.com>
Date:   Tue Oct 22 11:59:12 2013 -0500

    watchdog: dw: Enable OF support for DW watchdog timer
    
    Add device tree support to the DW watchdog timer.
    
    Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
    Acked-by: Jamie Iles <jamie@jamieiles.com>
    Acked-by: Mark Rutland <mark.rutland@arm.com>
    Reviewed-by: Pavel Machek <pavel@denx.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Viresh Kumar <viresh.linux@gmail.com>
    Cc: Rob Herring <rob.herring@calxeda.com>
    Cc: Pawel Moll <pawel.moll@arm.com>
    Cc: Stephen Warren <swarren@wwwdotorg.org>
    Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
    Cc: devicetree@vger.kernel.org
    Cc: linux-watchdog@vger.kernel.org

commit 487722cf2d66126338217896642bd5eec832c34b
Author: Jean Delvare <jdelvare@suse.de>
Date:   Mon Oct 21 17:38:49 2013 +0200

    watchdog: Get rid of MODULE_ALIAS_MISCDEV statements
    
    I just can't find any value in MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR)
    and MODULE_ALIAS_MISCDEV(TEMP_MINOR) statements.
    
    Either the device is enumerated and the driver already has a module
    alias (e.g. PCI, USB etc.) that will get the right driver loaded
    automatically.
    
    Or the device is not enumerated and loading its driver will lead to
    more or less intrusive hardware poking. Such hardware poking should be
    limited to a bare minimum, so the user should really decide which
    drivers should be tried and in what order. Trying them all in
    arbitrary order can't do any good.
    
    On top of that, loading that many drivers at once bloats the kernel
    log. Also many drivers will stay loaded afterward, bloating the output
    of "lsmod" and wasting memory. Some modules (cs5535_mfgpt which gets
    loaded as a dependency) can't even be unloaded!
    
    If defining char-major-10-130 is needed then it should happen in
    user-space.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Stephen Warren <swarren@wwwdotorg.org>
    Cc: Mike Frysinger <vapier.adi@gmail.com>
    Cc: Wan ZongShun <mcuos.com@gmail.com>
    Cc: Ben Dooks <ben-linux@fluff.org>
    Cc: Kukjin Kim <kgene.kim@samsung.com>
    Cc: Zwane Mwaikambo <zwane@arm.linux.org.uk>
    Cc: Jim Cromie <jim.cromie@gmail.com>

commit 67b9fbdf3602dfd525371d7b1f49346f1d11d37d
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Mon Oct 14 09:32:48 2013 -0700

    watchdog: ts72xx_wdt: Propagate return value from timeout_to_regval
    
    timeout_to_regval() returns a valid error code. Might as well use it.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5412df0bda90a2bdcef2771849ad5472b9ef8100
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Mon Oct 14 09:29:34 2013 -0700

    watchdog: pcwd_usb: Use allocated buffer for usb_control_msg
    
    usb_control_msg() must use a dma-capable buffer.
    
    This fixes the following error reported by smatch:
    
    drivers/watchdog/pcwd_usb.c:257 usb_pcwd_send_command() error: doing dma on the
    stack (buf)
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b1f9cd3225ae2e8626fe7503ae7be92240873049
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Thu Oct 3 11:46:30 2013 +0200

    watchdog: sp805_wdt: Remove unnecessary amba_set_drvdata()
    
    Driver core clears the driver data to NULL after device_release
    or on probe failure, so just remove it from here.
    
    Driver core change:
    "device-core: Ensure drvdata = NULL when no driver is bound"
    (sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f0fcbdbf202e2be36c8eb6d1f5c01f95805777de
Author: Xianglong Du <Xianglong.Du@csr.com>
Date:   Wed Oct 2 08:13:49 2013 +0800

    watchdog: sirf: add watchdog driver of CSR SiRFprimaII and SiRFatlasVI
    
    On CSR SiRFprimaII and SiRFatlasVI, the 6th timer can act as a watchdog
    timer when the Watchdog mode is enabled.
    
    watchdog occur when TIMER watchdog counter matches the value software
    pre-set, when this event occurs, the effect is the same as the system
    software reset.
    
    Signed-off-by: Xianglong Du <Xianglong.Du@csr.com>
    Signed-off-by: Barry Song <Baohua.Song@csr.com>
    Cc: Romain Izard <romain.izard.pro@gmail.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 85eee81922399ec0be1b2c870f9333b4bca56650
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Mon Sep 30 10:12:51 2013 +0530

    watchdog: Remove redundant of_match_ptr
    
    of_match_ptr() is a macro used to avoid undefined reference error if
    CONFIG_OF is used to selectively compile in or out the
    data structure. It is defined as follows:
    
    #ifdef CONFIG_OF
    #define of_match_ptr(ptr) ptr
    #else
    #define of_match_ptr(ptr) NULL
    #endif
    
    In the case of this series, none of the drivers use CONFIG_OF macro to
    compile out the data structure (i.e., the data structure is always
    defined).
    Hence the use of of_match_ptr() does not make any sense. Thus removing
    it to make the code look simpler for readability.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a20a99fbb88ac58c2e118e8759967d1cd7355322
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri Aug 23 12:38:32 2013 +0300

    watchdog: ts72xx_wdt: cleanup return codes in ioctl
    
    There seems to be some confusion here which functions return positive
    numbers and which return negative error codes.
    
    copy_to_user() returns the number of bytes remaining to be copied but we
    want to return -EFAULT.
    
    The rest is just clean up.  get_user() actually returns zero on success
    and -EFAULT on error so we can preserve the error code.  The
    timeout_to_regval() function returns -EINVAL on failure, but we can
    propogate that back instead of hardcoding -EINVAL ourselves.
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    --

commit cfff96e69f05176afd0e58d3a8c853a6d68ce544
Author: Johannes Thumshirn <johannes.thumshirn@men.de>
Date:   Wed Aug 21 14:42:09 2013 +0200

    documentation/devicetree: Move DT bindings from gpio to watchdog
    
    I accidently put the devicetree bindings for the MEN A21 watchdog driver in
    Documentation/devicetree/bindings/gpio instead of
    Documentation/devicetree/bindings/watchdog, this patch addresses this error.
    
    Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
    Acked-by: Stephen Warren <swarren@nvidia.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Rob Herring <rob.herring@calxeda.com>
    Cc: Pawel Moll <pawel.moll@arm.com>
    Cc: Mark Rutland <mark.rutland@arm.com>
    Cc: Ian Campbell <ian.campbell@citrix.com>
    Cc: Rob Landley <rob@landley.net>

commit 473cf939ff3442dc86d531f3bb152a2f129ea9d1
Author: John Crispin <blogic@openwrt.org>
Date:   Thu Aug 8 11:31:43 2013 +0200

    watchdog: add ralink watchdog driver
    
    Add a driver for the watchdog timer found on Ralink SoC
    
    Signed-off-by: John Crispin <blogic@openwrt.org>
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org
    Cc: linux-mips@linux-mips.org
    Cc: devicetree-discuss@lists.ozlabs.org

commit e14538e0db8d880291064348bda7d52ec8322675
Author: Jonas Jensen <jonas.jensen@gmail.com>
Date:   Fri Aug 2 16:40:45 2013 +0200

    watchdog: Add MOXA ART watchdog driver
    
    This patch adds a watchdog driver for the main hardware watchdog timer
    found on MOXA ART SoCs.
    
    The MOXA ART SoC provides one writable timer register, restarting
    the hardware once it reaches zero. The register is auto decremented
    every APB clock cycle.
    
    Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b3970bdebbb2901becca7cb82e44b5c5976f0fae
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu Aug 1 14:39:46 2013 +0900

    watchdog: kempld_wdt: Add __user annotation
    
    Added __user annotation to fix the following sparse warnings.
    Also, it makes 'kempld_prescaler' static because it is used
    only in this file.
    
    drivers/watchdog/kempld_wdt.c:70:11: warning: symbol 'kempld_prescaler' was not declared. Should it be static?
    drivers/watchdog/kempld_wdt.c:364:23: warning: incorrect type in initializer (different address spaces)
    drivers/watchdog/kempld_wdt.c:364:23:    expected int const [noderef] <asn:1>*register __p
    drivers/watchdog/kempld_wdt.c:364:23:    got int *<noident>
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 60295507f6abf47a40d1fd758cd4401e7193f16e
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu Aug 1 14:38:36 2013 +0900

    watchdog: dw_wdt: Add __user annotation
    
    Added __user annotation to fix the following sparse warnings.
    
    drivers/watchdog/dw_wdt.c:206:38: warning: incorrect type in argument 1 (different address spaces)
    drivers/watchdog/dw_wdt.c:206:38:    expected void [noderef] <asn:1>*to
    drivers/watchdog/dw_wdt.c:206:38:    got struct watchdog_info *<noident>
    drivers/watchdog/dw_wdt.c:211:24: warning: incorrect type in initializer (different address spaces)
    drivers/watchdog/dw_wdt.c:211:24:    expected int const [noderef] <asn:1>*register __p
    drivers/watchdog/dw_wdt.c:211:24:    got int *<noident>
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Acked-by: Jamie Iles <jamie@jamieiles.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit bc8fdfbe75058c6569dd6a08bdc2a411db533c47
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Jul 30 19:58:51 2013 +0900

    watchdog: use dev_get_platdata()
    
    Use the wrapper function for retrieving the platform data instead of
    accessing dev->platform_data directly.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 813296a1a209baaf1471c360591946edd795bcbe
Author: Niels de Vos <ndevos@redhat.com>
Date:   Mon Jul 29 09:38:18 2013 +0200

    watchdog: imx2_wdt: expose module alias for loading from device-tree
    
    Enable auto loading by udev when imx2_wdt is compiled as a module.
    
    Signed-off-by: Niels de Vos <ndevos@redhat.com>
    Acked-by: Shawn Guo <shawn.guo@linaro.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 280103e6b5de6ae1e23d9067202cdd67dd06b490
Author: Heiko Stübner <heiko@sntech.de>
Date:   Wed Jun 26 20:04:31 2013 +0200

    watchdog: dw_wdt: use clk_prepare_enable and clk_disable_unprepare
    
    This is necessary to make the driver work with platforms using the
    common clock framework.
    
    Signed-off-by: Heiko Stuebner <heiko@sntech.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ad83c6cbf30eba322fbc822453316a4954d9b607
Author: Heiko Stübner <heiko@sntech.de>
Date:   Wed Jun 26 20:03:52 2013 +0200

    watchdog: dw_wdt: convert to SIMPLE_DEV_PM_OPS
    
    The dw_wdt only provides PM_SLEEP operations, so convert the driver
    to use SIMPLE_DEV_PM_OPS instead of populating the struct manually.
    This has the added effect of simplifying the CONFIG_PM ifdefs.
    
    Signed-off-by: Heiko Stuebner <heiko@sntech.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Greetings,
Wim.

