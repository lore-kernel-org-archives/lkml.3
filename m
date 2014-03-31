Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaCaLxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:53:50 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:36889 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753018AbaCaLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:53:46 -0400
Date: Mon, 31 Mar 2014 13:53:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alexander Shiyan <shc_work@mail.ru>, Andrew Chew <achew@nvidia.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Jean Delvare <jdelvare@suse.de>, Jingoo Han <jg1.han@samsung.com>,
        Marc van der Wal <x0r+kernel@x0r.fr>,
        Markus Mayer <markus.mayer@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [GIT PULL REQUEST] watchdog - v3.15-rc1 Patches
Message-ID: <20140331115337.GV1484@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This patchset contains:
* Various small clean-ups and fixes
* boot logic hanegs for mpc8xxx_wdt
* it87_wdt: Work around non-working CIR interrupts
* iTCO_wdt: Fix the parent device
* Kconfig dependencies
* simplification of code with devm_ioremap_resource() or platform_driver_probe()
* conversion of xilinx watchdog driver to Generic watchdog Framework
* addition of extra functionality and devices for the xilinx watchdog driver
* Addition of Tegra watchdog

This will update the following files:

 Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt |   23 
 Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt     |    5 
 Documentation/watchdog/watchdog-parameters.txt               |    7 
 drivers/watchdog/Kconfig                                     |   38 -
 drivers/watchdog/Makefile                                    |    1 
 drivers/watchdog/acquirewdt.c                                |   21 
 drivers/watchdog/advantechwdt.c                              |   21 
 drivers/watchdog/ar7_wdt.c                                   |    1 
 drivers/watchdog/at32ap700x_wdt.c                            |    4 
 drivers/watchdog/ath79_wdt.c                                 |    1 
 drivers/watchdog/bcm2835_wdt.c                               |    4 
 drivers/watchdog/bcm47xx_wdt.c                               |    1 
 drivers/watchdog/bcm63xx_wdt.c                               |    2 
 drivers/watchdog/cpu5wdt.c                                   |    1 
 drivers/watchdog/cpwd.c                                      |    1 
 drivers/watchdog/da9052_wdt.c                                |    1 
 drivers/watchdog/da9055_wdt.c                                |    4 
 drivers/watchdog/davinci_wdt.c                               |    1 
 drivers/watchdog/ep93xx_wdt.c                                |   19 
 drivers/watchdog/geodewdt.c                                  |   17 
 drivers/watchdog/hpwdt.c                                     |    1 
 drivers/watchdog/i6300esb.c                                  |    1 
 drivers/watchdog/iTCO_wdt.c                                  |    8 
 drivers/watchdog/ib700wdt.c                                  |   21 
 drivers/watchdog/ibmasr.c                                    |    2 
 drivers/watchdog/indydog.c                                   |   13 
 drivers/watchdog/intel_scu_watchdog.c                        |    4 
 drivers/watchdog/it87_wdt.c                                  |   41 -
 drivers/watchdog/jz4740_wdt.c                                |    1 
 drivers/watchdog/max63xx_wdt.c                               |    1 
 drivers/watchdog/mpc8xxx_wdt.c                               |    1 
 drivers/watchdog/mtx-1_wdt.c                                 |    1 
 drivers/watchdog/nuc900_wdt.c                                |    1 
 drivers/watchdog/of_xilinx_wdt.c                             |  390 +++--------
 drivers/watchdog/omap_wdt.c                                  |   23 
 drivers/watchdog/orion_wdt.c                                 |    1 
 drivers/watchdog/pc87413_wdt.c                               |    7 
 drivers/watchdog/pcwd_usb.c                                  |    4 
 drivers/watchdog/pnx4008_wdt.c                               |    1 
 drivers/watchdog/rdc321x_wdt.c                               |    1 
 drivers/watchdog/retu_wdt.c                                  |    1 
 drivers/watchdog/riowd.c                                     |    1 
 drivers/watchdog/s3c2410_wdt.c                               |    9 
 drivers/watchdog/sc520_wdt.c                                 |    3 
 drivers/watchdog/shwdt.c                                     |    2 
 drivers/watchdog/softdog.c                                   |    2 
 drivers/watchdog/sp805_wdt.c                                 |   19 
 drivers/watchdog/stmp3xxx_rtc_wdt.c                          |    1 
 drivers/watchdog/sunxi_wdt.c                                 |    2 
 drivers/watchdog/tegra_wdt.c                                 |  302 ++++++++
 drivers/watchdog/ts72xx_wdt.c                                |    6 
 drivers/watchdog/w83697hf_wdt.c                              |    4 
 drivers/watchdog/wdt285.c                                    |    3 
 drivers/watchdog/wdt_pci.c                                   |    1 
 drivers/watchdog/wm831x_wdt.c                                |    1 
 55 files changed, 584 insertions(+), 469 deletions(-)

with these Changes:

commit 6d956e422bf1848e430e0ec3610096215217cb02
Author: Jean Delvare <jdelvare@suse.de>
Date:   Fri Mar 14 20:25:29 2014 +0100

    watchdog: Fix Elan SC520 dependencies
    
    Anyone using a system based on an AMD Elan SC520 processor would be
    building a dedicated kernel for it, so we can make the sc520_wdt
    driver depend on MELAN. SC520_CPUFREQ already depends on MELAN so it
    makes things more consistent. It also makes kernel configuration for
    every other x86 user easier.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 996735ffd4560ee12d8dd98ad9d27379ee943890
Author: Jean Delvare <jdelvare@suse.de>
Date:   Fri Mar 14 13:18:47 2014 +0100

    watchdog: ib700wdt: Use platform_driver_probe
    
    Using platform_driver_probe instead of platform_driver_register has
    two benefits:
    * The driver will fail to load if device probing fails.
    * The probe function can be marked __init.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 78411be4c7136054dab4635d2dbd848c3c9f7eae
Author: Jean Delvare <jdelvare@suse.de>
Date:   Fri Mar 14 13:16:47 2014 +0100

    watchdog: geodewdt: Use platform_driver_probe
    
    Using platform_driver_probe instead of platform_driver_register has
    two benefits:
    * The driver will fail to load if device probing fails.
    * The probe function can be marked __init.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit acaaaf62c94a786f68b35cd06979fbd2fcedc89b
Author: Jean Delvare <jdelvare@suse.de>
Date:   Fri Mar 14 13:07:40 2014 +0100

    watchdog: advantechwdt: Use platform_driver_probe
    
    Using platform_driver_probe instead of platform_driver_register has
    two benefits:
    * The driver will fail to load if device probing fails.
    * The probe function can be marked __init.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b0e0b4b5984ab1d59bc8569d28e499820b8ea8d8
Author: Jean Delvare <jdelvare@suse.de>
Date:   Fri Mar 14 13:04:37 2014 +0100

    watchdog: acquirewdt: Use platform_driver_probe
    
    Using platform_driver_probe instead of platform_driver_register has
    two benefits:
    * The driver will fail to load if device probing fails.
    * The probe function can be marked __init.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c90789baa8cec363093c5ec292c989b6f22d8f32
Author: Jean Delvare <jdelvare@suse.de>
Date:   Mon Mar 10 21:28:17 2014 +0100

    watchdog: iTCO_wdt: Fix the parent device
    
    The watchdog's parent is iTCO_wdt (the platform device) not lpc_ich
    (the PCI device.) Setting the parent right makes it much easier for
    the user to figure out which driver/module is handling the watchdog
    device node.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0bcd0b6a47431d9895dc2dd6a8c4185008849131
Author: Marc van der Wal <x0r+kernel@x0r.fr>
Date:   Thu Mar 6 10:36:59 2014 +0100

    watchdog: it87_wdt: Work around non-working CIR interrupts
    
    On some hardware platforms, the it87_wdt watchdog resets the machine
    despite the watchdog daemon running and writing to /dev/watchdog.
    
    This is due to Consumer IR buffer underrun interrupts being used as
    triggers to reset the timer.  On some buggy hardware implementations
    such as the iEi AFL-12A-N270 single-board computer, this method does
    not work.
    
    However, resetting the timer by writing its original timeout value in
    its configuration register over and over again suppresses the unwanted
    reboots.
    
    Add a module option (nocir), 0 by default in order not to break existing
    setups.  Setting it to 1 enables the workaround.
    
    Fixes bug #42801 <https://bugzilla.kernel.org/show_bug.cgi?id=42801>.
    Tested primarily on Linux 3.5.7, applies cleanly on Linux 3.13.5.
    
    Signed-off-by: Marc van der Wal <x0r+kernel@x0r.fr>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5e82ec94ac5d2d941414861654032543a75cf823
Author: Markus Mayer <markus.mayer@linaro.org>
Date:   Wed Mar 5 18:57:41 2014 +0800

    watchdog: bcm281xx: Fix Kconfig dependency
    
    Use more the applicable ARCH_BCM_MOBILE option instead of ARCH_BCM as
    dependency for bcm_kona_wdt.c.
    
    Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 01b6af91593629224490b76c4bf4b0eb8cfbfb31
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Tue Mar 4 15:04:35 2014 +0530

    watchdog: s3c2410_wdt: Check return value of clk_prepare_enable
    
    clk_prepare_enable can fail. Check its return value.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a94dd879e2939798294c56468add3d6a8ef04137
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Tue Mar 4 15:04:34 2014 +0530

    watchdog: s3c2410_wdt: Remove unneeded initialization
    
    Initializing clk to NULL as a reset/error condition does not
    help as NULL is not an invalid condition w.r.t clk. Remove this
    initialization altogether as there is no state retention.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b0f1d8bec712b4267995764b34ced2c148ecfacb
Author: Maxime Ripard <maxime.ripard@free-electrons.com>
Date:   Fri Feb 7 22:29:24 2014 +0100

    watchdog: sunxi: Change compatibles
    
    The Allwinner A10 and A31 compatibles were following a slightly different
    compatible patterns than the rest of the SoCs for historical reasons. Change
    the compatibles to match the other pattern in the watchdog controller driver
    for consistency.
    
    Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0187cca30c5d85e39b2da28806acef7db8a88ae2
Author: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date:   Sat Mar 1 09:33:18 2014 +0100

    watchdog: orion: prepare new Dove DT Kconfig variable
    
    DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
    mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
    DT-only MACH_DOVE Kconfig.
    
    Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5f5e19093b2fa592720810154f15ffe51aa9277f
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu Feb 27 14:41:42 2014 +0900

    watchdog: fix checkpatch warnings and error
    
    Fix the following checkpatch warnings and error:
      WARNING: quoted string split across lines
      WARNING: braces {} are not necessary for single statement blocks
      WARNING: __initdata should be placed after ibmasr_id_table[]
      WARNING: please, no space before tabs
      ERROR: do not initialise statics to 0 or NULL
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c33a15974c1a326b0034cc2a2e73fac92ae8d001
Author: Andrew Chew <achew@nvidia.com>
Date:   Fri Feb 14 12:03:05 2014 -0800

    watchdog: Add tegra watchdog
    
    Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (Tegra30 and
    later).  This driver will configure one watchdog timer that will reset the
    system in the case of a watchdog timeout.
    
    This driver binds to the nvidia,tegra30-timer device node and gets its
    register base from there.
    
    Signed-off-by: Andrew Chew <achew@nvidia.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Tested-by: Stephen Warren <swarren@nvidia.com>
    Reviewed-by: Stephen Warren <swarren@nvidia.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8d6a140b5f0def8c34d803474780b7b11fe0fab4
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:41:25 2014 +0100

    watchdog: xilinx: Remove no_timeout variable
    
    Remove no_timeout variable and check variables
    directly.
    
    Suggested-by: Rob Herring <robherring2@gmail.com>
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c9dcf9f2ea3d64602fe6230daba80f2ed811535b
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:41:24 2014 +0100

    watchdog: xilinx: Enable this driver for Zynq
    
    Enable this driver for Zynq.
    Move it to architecture independent Kconfig part.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a8b84b01e4af2baad3cef46bc86dcb2718c79e72
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:41:23 2014 +0100

    watchdog: xilinx: Add missing binding
    
    Document current driver binding.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 75b3c5a827de11620f9bf7cbd6c3e4208bd3ddf5
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:41:22 2014 +0100

    watchdog: xilinx: Use correct comment indentation
    
    No functional changes.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2e79a368473d55db3237120dea0f561660dac5bd
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:41:21 2014 +0100

    watchdog: xilinx: Use of_property_read_u32
    
    Use of_property_read_u32 functions to clean probe function.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4c7fbbc4a57a35ed109f58f52eff1a04660789e9
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:41:20 2014 +0100

    watchdog: xilinx: Fix all printk messages
    
    Use dev_ functions for printk messages.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 9066317178ca87b9d958f801c8fcf784ec31c6c3
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:41:19 2014 +0100

    watchdog: xilinx: Allocate private structure per device
    
    Only one watchdog could be used by this driver.
    Create driver private data structure and move there
    all variables for one instance.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ffb8eee4f140bbfc333381168d6fe1a7e7dc7af7
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:34:35 2014 +0100

    watchdog: xilinx: Move no_timeout to probe function
    
    no_timeout should be local variable because it is used
    only in probe function.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f06cdfd184d845e1f01df7f636c0e3b5c5cc8d18
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:34:34 2014 +0100

    watchdog: xilinx: Simplify probe and remove functions
    
    Use devm_ helper function to simplify probe and error path.
    Move ioremap to the beginning of probe function.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5cf4e69d39f6a31a5305d01690c1607356b1483b
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:34:33 2014 +0100

    watchdog: xilinx: Move control_status_reg to functions
    
    control_status_reg is temp variables and should be
    used locally by specific function.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d14fd9645501444f06034339118de56686e25dfb
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Feb 12 14:34:32 2014 +0100

    watchdog: xilinx: Convert driver to the watchdog framework
    
    - Remove uneeded headers, fops functions
    - Use xilinx_wdt prefix in start/stop/keepalive functions
      and in new structures
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 70605d9bab216534a593f3ec8218ab8c015cb452
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Feb 15 13:23:25 2014 +0400

    watchdog: wdt285: Fix variable type
    
    Variable "new_margin" is checked in the function watchdog_ioctl()
    to be non-negative, so change its type to "int".
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1cf8a3487d385b3221d07ab6a7a003761e8806c1
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Feb 15 13:23:07 2014 +0400

    watchdog: shwdt: Remove unused variable
    
    Variable "wdt" is not used anywhere in the function sh_wdt_remove().
    This patch removes this variable.
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a9ba8376e9e6f7d3d6dd5c2c6816e9a9358d38e8
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Feb 15 13:22:49 2014 +0400

    watchdog: sc520_wdt: Remove unused variable
    
    Variable "dummy" is not used anywhere in the function wdt_config().
    This patch removes this variable.
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c303ca87653566db01fe5e49ac72a8b3dc1fb722
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Feb 15 13:22:18 2014 +0400

    watchdog: intel_scu_watchdog: Remove unused variable
    
    Variable "hw_pre_value" is not used anywhere in the
    function intel_scu_set_heartbeat().
    This patch removes this variable.
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0c29c2e8506ab9cfebd4836e758aa55dd5cf66fe
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Feb 15 13:21:51 2014 +0400

    watchdog: indydog: Simplify indydog_{start,stop}
    
    This patch simplify functions indydog_start() and indydog_stop()
    a bit and removes excess intermediate variable.
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7bce7c011e8f5d6e4e3da2309a614b6efb10466b
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Feb 15 13:21:03 2014 +0400

    watchdog: bcm63xx_wdt: Remove unused field from bcm63xx_wdt_device
    
    Field "default_ticks" is not used anywhere in the driver code.
    This patch removes this field.
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 9d11e4f8c3353088ace2f80bec85bb0e2f316382
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Feb 11 21:45:56 2014 +0900

    watchdog: sp805_wdt: Use devm_ioremap_resource()
    
    Use devm_ioremap_resource() in order to make the code simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6e272061391946fe28cadd5f9fbab1bab82b3748
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Feb 11 21:44:12 2014 +0900

    watchdog: omap_wdt: Use devm_ioremap_resource()
    
    Use devm_ioremap_resource() in order to make the code simpler,
    and remove 'struct resource *mem' from 'struct omap_wdt_dev'
    and omap_wdt_probe(), resplectively. because the 'mem' variables
    are not used anymore. Also the redundant return value check of
    platform_get_resource() is removed, because the value is checked
    by devm_ioremap_resource().
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4f6120b014c6a981a57a8951e01acfead1a57069
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Feb 11 21:41:54 2014 +0900

    watchdog: ep93xx_wdt: Use devm_ioremap_resource()
    
    Use devm_ioremap_resource() in order to make the code simpler,
    and remove redundant return value check of platform_get_resource()
    because the value is checked by devm_ioremap_resource().
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a17fb5cbee5dffcb93aeb4b71e2ef9e0eeec0bc2
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Feb 11 15:59:38 2014 +0900

    watchdog: ts72xx_wdt: make 'ts72xx_wdt_pdev' static
    
    Make 'ts72xx_wdt_pdev' static, because it is used only in this
    file. It also fixes the following sparse warning.
    
      warning: symbol 'ts72xx_wdt_pdev' was not declared. Should it be static?
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8deea830644c0a4bdd90dfda7249d0f40f0667fa
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Feb 11 15:46:43 2014 +0900

    watchdog: Remove unnecessary OOM messages
    
    The site-specific OOM messages are unnecessary, because they
    duplicate the MM subsystem generic OOM message. For example,
    k.alloc and v.alloc failures use dump_stack().
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Jean Delvare <jdelvare@suse.de> [for at32ap700x]
    Acked-by: Lubomir Rintel <lkundrak@v3.sk> [for bcm2835]
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org> [for sp805_wdt]
    Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com> [for ts72xx_wdt]
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8126334b20d79272a15b5c45053cb76b1e7320be
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Tue Jan 21 16:22:43 2014 -0500

    watchdog: delete non-required instances of include <linux/init.h>
    
    None of these files are actually using any __init type directives
    and hence don't need to include <linux/init.h>.  Most are just a
    left over from __devinit and __cpuinit removal, or simply due to
    code getting copied from one driver to the next.
    
    Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org

commit 4af897fa9992e5648d01fcff19d2c6d86a5143c9
Author: Christophe Leroy <christophe.leroy@c-s.fr>
Date:   Sat Nov 30 16:45:40 2013 +0100

    watchdog: mpc8xxx_wdt: MPC8xx is HW enabled
    
    MPC8xx watchdog is enabled at startup by HW.
    If the bootloader disables it, it cannot be reenabled.
    
    Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt b/Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt
new file mode 100644
index 0000000..6d63782
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt
@@ -0,0 +1,23 @@
+Xilinx AXI/PLB soft-core watchdog Device Tree Bindings
+---------------------------------------------------------
+
+Required properties:
+- compatible		: Should be "xlnx,xps-timebase-wdt-1.00.a" or
+			  "xlnx,xps-timebase-wdt-1.01.a".
+- reg			: Physical base address and size
+
+Optional properties:
+- clock-frequency	: Frequency of clock in Hz
+- xlnx,wdt-enable-once	: 0 - Watchdog can be restarted
+			  1 - Watchdog can be enabled just once
+- xlnx,wdt-interval	: Watchdog timeout interval in 2^<val> clock cycles,
+			  <val> is integer from 8 to 31.
+
+Example:
+axi-timebase-wdt@40100000 {
+	clock-frequency = <50000000>;
+	compatible = "xlnx,xps-timebase-wdt-1.00.a";
+	reg = <0x40100000 0x10000>;
+	xlnx,wdt-enable-once = <0x0>;
+	xlnx,wdt-interval = <0x1b>;
+} ;
diff --git a/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt b/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
index e39cb26..b8f75c5 100644
--- a/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/sunxi-wdt.txt
@@ -2,13 +2,13 @@ Allwinner SoCs Watchdog timer
 
 Required properties:
 
-- compatible : should be "allwinner,<soc-family>-wdt", the currently supported
-  SoC families being sun4i and sun6i
+- compatible : should be either "allwinner,sun4i-a10-wdt" or
+               "allwinner,sun6i-a31-wdt"
 - reg : Specifies base physical address and size of the registers.
 
 Example:
 
 wdt: watchdog@01c20c90 {
-	compatible = "allwinner,sun4i-wdt";
+	compatible = "allwinner,sun4i-a10-wdt";
 	reg = <0x01c20c90 0x10>;
 };
diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index f9492fe..692791c 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -150,6 +150,8 @@ nowayout: Disable watchdog shutdown on close
 -------------------------------------------------
 it87_wdt:
 nogameport: Forbid the activation of game port, default=0
+nocir: Forbid the use of CIR (workaround for some buggy setups); set to 1 if
+system resets despite watchdog daemon running, default=0
 exclusive: Watchdog exclusive device open, default=1
 timeout: Watchdog timeout in seconds, default=60
 testmode: Watchdog test mode (1 = no reboot), default=0
@@ -325,6 +327,11 @@ soft_noboot: Softdog action, set to 1 to ignore reboots, 0 to reboot
 stmp3xxx_wdt:
 heartbeat: Watchdog heartbeat period in seconds from 1 to 4194304, default 19
 -------------------------------------------------
+tegra_wdt:
+heartbeat: Watchdog heartbeats in seconds. (default = 120)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
 ts72xx_wdt:
 timeout: Watchdog timeout in seconds. (1 <= timeout <= 8, default=8)
 nowayout: Disable watchdog shutdown on close
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79d2589..0c6048d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -111,6 +111,15 @@ config WM8350_WATCHDOG
 	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
 	  the watchdog triggers the system will be reset.
 
+config XILINX_WATCHDOG
+	tristate "Xilinx Watchdog timer"
+	select WATCHDOG_CORE
+	help
+	  Watchdog driver for the xps_timebase_wdt ip core.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called of_xilinx_wdt.
+
 # ALPHA Architecture
 
 # ARM Architecture
@@ -292,7 +301,7 @@ config DAVINCI_WATCHDOG
 
 config ORION_WATCHDOG
 	tristate "Orion watchdog"
-	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE
+	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
 	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
@@ -421,6 +430,17 @@ config SIRFSOC_WATCHDOG
 	  Support for CSR SiRFprimaII and SiRFatlasVI watchdog. When
 	  the watchdog triggers the system will be reset.
 
+config TEGRA_WATCHDOG
+	tristate "Tegra watchdog"
+	depends on ARCH_TEGRA || COMPILE_TEST
+	select WATCHDOG_CORE
+	help
+	  Say Y here to include support for the watchdog timer
+	  embedded in NVIDIA Tegra SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tegra_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
@@ -533,7 +553,7 @@ config GEODE_WDT
 
 config SC520_WDT
 	tristate "AMD Elan SC520 processor Watchdog"
-	depends on X86
+	depends on MELAN
 	help
 	  This is the driver for the hardware watchdog built in to the
 	  AMD "Elan" SC520 microcomputer commonly used in embedded systems.
@@ -1023,18 +1043,6 @@ config M54xx_WATCHDOG
 
 # MicroBlaze Architecture
 
-config XILINX_WATCHDOG
-	tristate "Xilinx Watchdog timer"
-	depends on MICROBLAZE
-	---help---
-	  Watchdog driver for the xps_timebase_wdt ip core.
-
-	  IMPORTANT: The xps_timebase_wdt parent must have the property
-	  "clock-frequency" at device tree.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called of_xilinx_wdt.
-
 # MIPS Architecture
 
 config ATH79_WDT
@@ -1160,7 +1168,7 @@ config BCM2835_WDT
 
 config BCM_KONA_WDT
 	tristate "BCM Kona Watchdog"
-	depends on ARCH_BCM
+	depends on ARCH_BCM_MOBILE
 	select WATCHDOG_CORE
 	help
 	  Support for the watchdog timer on the following Broadcom BCM281xx
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 985a66c..1b5f3d5 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
 obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
 obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
+obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 5cf1621..5614416 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -239,7 +239,7 @@ static struct miscdevice acq_miscdev = {
  *	Init & exit routines
  */
 
-static int acq_probe(struct platform_device *dev)
+static int __init acq_probe(struct platform_device *dev)
 {
 	int ret;
 
@@ -291,7 +291,6 @@ static void acq_shutdown(struct platform_device *dev)
 }
 
 static struct platform_driver acquirewdt_driver = {
-	.probe		= acq_probe,
 	.remove		= acq_remove,
 	.shutdown	= acq_shutdown,
 	.driver		= {
@@ -306,20 +305,18 @@ static int __init acq_init(void)
 
 	pr_info("WDT driver for Acquire single board computer initialising\n");
 
-	err = platform_driver_register(&acquirewdt_driver);
-	if (err)
-		return err;
-
 	acq_platform_device = platform_device_register_simple(DRV_NAME,
 								-1, NULL, 0);
-	if (IS_ERR(acq_platform_device)) {
-		err = PTR_ERR(acq_platform_device);
-		goto unreg_platform_driver;
-	}
+	if (IS_ERR(acq_platform_device))
+		return PTR_ERR(acq_platform_device);
+
+	err = platform_driver_probe(&acquirewdt_driver, acq_probe);
+	if (err)
+		goto unreg_platform_device;
 	return 0;
 
-unreg_platform_driver:
-	platform_driver_unregister(&acquirewdt_driver);
+unreg_platform_device:
+	platform_device_unregister(acq_platform_device);
 	return err;
 }
 
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index a8961ad..7796db7 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -238,7 +238,7 @@ static struct miscdevice advwdt_miscdev = {
  *	Init & exit routines
  */
 
-static int advwdt_probe(struct platform_device *dev)
+static int __init advwdt_probe(struct platform_device *dev)
 {
 	int ret;
 
@@ -299,7 +299,6 @@ static void advwdt_shutdown(struct platform_device *dev)
 }
 
 static struct platform_driver advwdt_driver = {
-	.probe		= advwdt_probe,
 	.remove		= advwdt_remove,
 	.shutdown	= advwdt_shutdown,
 	.driver		= {
@@ -314,21 +313,19 @@ static int __init advwdt_init(void)
 
 	pr_info("WDT driver for Advantech single board computer initialising\n");
 
-	err = platform_driver_register(&advwdt_driver);
-	if (err)
-		return err;
-
 	advwdt_platform_device = platform_device_register_simple(DRV_NAME,
 								-1, NULL, 0);
-	if (IS_ERR(advwdt_platform_device)) {
-		err = PTR_ERR(advwdt_platform_device);
-		goto unreg_platform_driver;
-	}
+	if (IS_ERR(advwdt_platform_device))
+		return PTR_ERR(advwdt_platform_device);
+
+	err = platform_driver_probe(&advwdt_driver, advwdt_probe);
+	if (err)
+		goto unreg_platform_device;
 
 	return 0;
 
-unreg_platform_driver:
-	platform_driver_unregister(&advwdt_driver);
+unreg_platform_device:
+	platform_device_unregister(advwdt_platform_device);
 	return err;
 }
 
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 3a99657..ae6c287 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index afe7d17..25b5c67 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -323,10 +323,8 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 
 	wdt = devm_kzalloc(&pdev->dev, sizeof(struct wdt_at32ap700x),
 			GFP_KERNEL);
-	if (!wdt) {
-		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
+	if (!wdt)
 		return -ENOMEM;
-	}
 
 	wdt->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!wdt->regs) {
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 9fa1f69..399c3fd 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -22,7 +22,6 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
index cafa973..8df450c 100644
--- a/drivers/watchdog/bcm2835_wdt.c
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -114,10 +114,8 @@ static int bcm2835_wdt_probe(struct platform_device *pdev)
 	int err;
 
 	wdt = devm_kzalloc(dev, sizeof(struct bcm2835_wdt), GFP_KERNEL);
-	if (!wdt) {
-		dev_err(dev, "Failed to allocate memory for watchdog device");
+	if (!wdt)
 		return -ENOMEM;
-	}
 	platform_set_drvdata(pdev, wdt);
 
 	spin_lock_init(&wdt->lock);
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index b4021a2..b61fcc5 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/bcm47xx_wdt.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index 4eb188b..5a8e879 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
@@ -45,7 +44,6 @@
 static struct {
 	void __iomem *regs;
 	struct timer_list timer;
-	int default_ticks;
 	unsigned long inuse;
 	atomic_t ticks;
 } bcm63xx_wdt_device;
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index f7ae49e..6d03e8e 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -27,7 +27,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 213225e..e55ed70 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -21,7 +21,6 @@
 #include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/major.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index f09c54e..2e95896 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -185,7 +185,6 @@ static int da9052_wdt_probe(struct platform_device *pdev)
 	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
 				   GFP_KERNEL);
 	if (!driver_data) {
-		dev_err(da9052->dev, "Unable to alloacate watchdog device\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
index 575f37a..495089d 100644
--- a/drivers/watchdog/da9055_wdt.c
+++ b/drivers/watchdog/da9055_wdt.c
@@ -151,10 +151,8 @@ static int da9055_wdt_probe(struct platform_device *pdev)
 
 	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
 				   GFP_KERNEL);
-	if (!driver_data) {
-		dev_err(da9055->dev, "Failed to allocate watchdog device\n");
+	if (!driver_data)
 		return -ENOMEM;
-	}
 
 	driver_data->da9055 = da9055;
 
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index b1bae03..d09ad22 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/device.h>
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index d1d07f2..5f54e1e 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -118,16 +118,9 @@ static int ep93xx_wdt_probe(struct platform_device *pdev)
 	int err;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-
-	mmio_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!mmio_base)
-		return -ENXIO;
+	mmio_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mmio_base))
+		return PTR_ERR(mmio_base);
 
 	if (timeout < 1 || timeout > 3600) {
 		timeout = WDT_TIMEOUT;
@@ -172,9 +165,9 @@ static struct platform_driver ep93xx_wdt_driver = {
 
 module_platform_driver(ep93xx_wdt_driver);
 
-MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>,"
-		"Alessandro Zummo <a.zummo@towertech.it>,"
-		"H Hartley Sweeten <hsweeten@visionengravers.com>");
+MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>");
+MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
+MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");
 MODULE_DESCRIPTION("EP93xx Watchdog");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(WDT_VERSION);
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 4a6ae84..4c43e3f 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -215,7 +215,7 @@ static struct miscdevice geodewdt_miscdev = {
 	.fops = &geodewdt_fops,
 };
 
-static int geodewdt_probe(struct platform_device *dev)
+static int __init geodewdt_probe(struct platform_device *dev)
 {
 	int ret;
 
@@ -255,7 +255,6 @@ static void geodewdt_shutdown(struct platform_device *dev)
 }
 
 static struct platform_driver geodewdt_driver = {
-	.probe		= geodewdt_probe,
 	.remove		= geodewdt_remove,
 	.shutdown	= geodewdt_shutdown,
 	.driver		= {
@@ -268,20 +267,18 @@ static int __init geodewdt_init(void)
 {
 	int ret;
 
-	ret = platform_driver_register(&geodewdt_driver);
-	if (ret)
-		return ret;
-
 	geodewdt_platform_device = platform_device_register_simple(DRV_NAME,
 								-1, NULL, 0);
-	if (IS_ERR(geodewdt_platform_device)) {
-		ret = PTR_ERR(geodewdt_platform_device);
+	if (IS_ERR(geodewdt_platform_device))
+		return PTR_ERR(geodewdt_platform_device);
+
+	ret = platform_driver_probe(&geodewdt_driver, geodewdt_probe);
+	if (ret)
 		goto err;
-	}
 
 	return 0;
 err:
-	platform_driver_unregister(&geodewdt_driver);
+	platform_device_unregister(geodewdt_platform_device);
 	return ret;
 }
 
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 2b75e8b..75d2243 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -17,7 +17,6 @@
 
 #include <linux/device.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 25a2bfd..d7befd5 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -36,7 +36,6 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/uaccess.h>
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 04f8af6..0e6c033 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -347,15 +347,15 @@ static const struct watchdog_info ident = {
 static const struct watchdog_ops iTCO_wdt_ops = {
 	.owner =		THIS_MODULE,
 	.start =		iTCO_wdt_start,
-	.stop = 		iTCO_wdt_stop,
-	.ping = 		iTCO_wdt_ping,
+	.stop =			iTCO_wdt_stop,
+	.ping =			iTCO_wdt_ping,
 	.set_timeout =		iTCO_wdt_set_timeout,
 	.get_timeleft =		iTCO_wdt_get_timeleft,
 };
 
 static struct watchdog_device iTCO_wdt_watchdog_dev = {
 	.info =		&ident,
-	.ops = 		&iTCO_wdt_ops,
+	.ops =		&iTCO_wdt_ops,
 };
 
 /*
@@ -485,7 +485,7 @@ static int iTCO_wdt_probe(struct platform_device *dev)
 	iTCO_wdt_watchdog_dev.bootstatus = 0;
 	iTCO_wdt_watchdog_dev.timeout = WATCHDOG_TIMEOUT;
 	watchdog_set_nowayout(&iTCO_wdt_watchdog_dev, nowayout);
-	iTCO_wdt_watchdog_dev.parent = dev->dev.parent;
+	iTCO_wdt_watchdog_dev.parent = &dev->dev;
 
 	/* Make sure the watchdog is not running */
 	iTCO_wdt_stop(&iTCO_wdt_watchdog_dev);
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 7ae3669..4247c49 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -277,7 +277,7 @@ static struct miscdevice ibwdt_miscdev = {
  *	Init & exit routines
  */
 
-static int ibwdt_probe(struct platform_device *dev)
+static int __init ibwdt_probe(struct platform_device *dev)
 {
 	int res;
 
@@ -336,7 +336,6 @@ static void ibwdt_shutdown(struct platform_device *dev)
 }
 
 static struct platform_driver ibwdt_driver = {
-	.probe		= ibwdt_probe,
 	.remove		= ibwdt_remove,
 	.shutdown	= ibwdt_shutdown,
 	.driver		= {
@@ -351,21 +350,19 @@ static int __init ibwdt_init(void)
 
 	pr_info("WDT driver for IB700 single board computer initialising\n");
 
-	err = platform_driver_register(&ibwdt_driver);
-	if (err)
-		return err;
-
 	ibwdt_platform_device = platform_device_register_simple(DRV_NAME,
 								-1, NULL, 0);
-	if (IS_ERR(ibwdt_platform_device)) {
-		err = PTR_ERR(ibwdt_platform_device);
-		goto unreg_platform_driver;
-	}
+	if (IS_ERR(ibwdt_platform_device))
+		return PTR_ERR(ibwdt_platform_device);
+
+	err = platform_driver_probe(&ibwdt_driver, ibwdt_probe);
+	if (err)
+		goto unreg_platform_device;
 
 	return 0;
 
-unreg_platform_driver:
-	platform_driver_unregister(&ibwdt_driver);
+unreg_platform_device:
+	platform_device_unregister(ibwdt_platform_device);
 	return err;
 }
 
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index db0a344..366b047 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -360,7 +360,7 @@ struct ibmasr_id {
 	int type;
 };
 
-static struct ibmasr_id __initdata ibmasr_id_table[] = {
+static struct ibmasr_id ibmasr_id_table[] __initdata = {
 	{ "IBM Automatic Server Restart - eserver xSeries 220", ASMTYPE_TOPAZ },
 	{ "IBM Automatic Server Restart - Machine Type 8673", ASMTYPE_PEARL },
 	{ "IBM Automatic Server Restart - Machine Type 8480", ASMTYPE_JASPER },
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 1b5c25a..5d20cdd 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -41,24 +41,15 @@ MODULE_PARM_DESC(nowayout,
 
 static void indydog_start(void)
 {
-	u32 mc_ctrl0;
-
 	spin_lock(&indydog_lock);
-	mc_ctrl0 = sgimc->cpuctrl0;
-	mc_ctrl0 = sgimc->cpuctrl0 | SGIMC_CCTRL0_WDOG;
-	sgimc->cpuctrl0 = mc_ctrl0;
+	sgimc->cpuctrl0 |= SGIMC_CCTRL0_WDOG;
 	spin_unlock(&indydog_lock);
 }
 
 static void indydog_stop(void)
 {
-	u32 mc_ctrl0;
-
 	spin_lock(&indydog_lock);
-
-	mc_ctrl0 = sgimc->cpuctrl0;
-	mc_ctrl0 &= ~SGIMC_CCTRL0_WDOG;
-	sgimc->cpuctrl0 = mc_ctrl0;
+	sgimc->cpuctrl0 &= ~SGIMC_CCTRL0_WDOG;
 	spin_unlock(&indydog_lock);
 
 	pr_info("Stopped watchdog timer\n");
diff --git a/drivers/watchdog/intel_scu_watchdog.c b/drivers/watchdog/intel_scu_watchdog.c
index e13e65e..0caab62 100644
--- a/drivers/watchdog/intel_scu_watchdog.c
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -211,7 +211,6 @@ static int intel_scu_set_heartbeat(u32 t)
 	int			 ipc_ret;
 	int			 retry_count;
 	u32			 soft_value;
-	u32			 hw_pre_value;
 	u32			 hw_value;
 
 	watchdog_device.timer_set = t;
@@ -273,8 +272,7 @@ static int intel_scu_set_heartbeat(u32 t)
 			watchdog_device.timer_load_count_addr);
 
 		/* read count value before starting timer */
-		hw_pre_value = ioread32(watchdog_device.timer_load_count_addr);
-		hw_pre_value = hw_pre_value & 0xFFFF0000;
+		ioread32(watchdog_device.timer_load_count_addr);
 
 		/* Start the timer */
 		iowrite32(0x00000003, watchdog_device.timer_control_addr);
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index e2bba68..0b93739 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -54,6 +54,7 @@
 
 /* Defaults for Module Parameter */
 #define DEFAULT_NOGAMEPORT	0
+#define DEFAULT_NOCIR		0
 #define DEFAULT_EXCLUSIVE	1
 #define DEFAULT_TIMEOUT		60
 #define DEFAULT_TESTMODE	0
@@ -136,11 +137,13 @@
 #define WDTS_LOCKED	3
 #define WDTS_USE_GP	4
 #define WDTS_EXPECTED	5
+#define WDTS_USE_CIR	6
 
 static	unsigned int base, gpact, ciract, max_units, chip_type;
 static	unsigned long wdt_status;
 
 static	int nogameport = DEFAULT_NOGAMEPORT;
+static int nocir      = DEFAULT_NOCIR;
 static	int exclusive  = DEFAULT_EXCLUSIVE;
 static	int timeout    = DEFAULT_TIMEOUT;
 static	int testmode   = DEFAULT_TESTMODE;
@@ -149,6 +152,9 @@ static	bool nowayout   = DEFAULT_NOWAYOUT;
 module_param(nogameport, int, 0);
 MODULE_PARM_DESC(nogameport, "Forbid the activation of game port, default="
 		__MODULE_STRING(DEFAULT_NOGAMEPORT));
+module_param(nocir, int, 0);
+MODULE_PARM_DESC(nocir, "Forbid the use of Consumer IR interrupts to reset timer, default="
+		__MODULE_STRING(DEFAULT_NOCIR));
 module_param(exclusive, int, 0);
 MODULE_PARM_DESC(exclusive, "Watchdog exclusive device open, default="
 		__MODULE_STRING(DEFAULT_EXCLUSIVE));
@@ -258,9 +264,17 @@ static void wdt_keepalive(void)
 {
 	if (test_bit(WDTS_USE_GP, &wdt_status))
 		inb(base);
-	else
+	else if (test_bit(WDTS_USE_CIR, &wdt_status))
 		/* The timer reloads with around 5 msec delay */
 		outb(0x55, CIR_DR(base));
+	else {
+		if (superio_enter())
+			return;
+
+		superio_select(GPIO);
+		wdt_update_timeout();
+		superio_exit();
+	}
 	set_bit(WDTS_KEEPALIVE, &wdt_status);
 }
 
@@ -273,7 +287,7 @@ static int wdt_start(void)
 	superio_select(GPIO);
 	if (test_bit(WDTS_USE_GP, &wdt_status))
 		superio_outb(WDT_GAMEPORT, WDTCTRL);
-	else
+	else if (test_bit(WDTS_USE_CIR, &wdt_status))
 		superio_outb(WDT_CIRINT, WDTCTRL);
 	wdt_update_timeout();
 
@@ -660,7 +674,7 @@ static int __init it87_wdt_init(void)
 	}
 
 	/* If we haven't Gameport support, try to get CIR support */
-	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
+	if (!nocir && !test_bit(WDTS_USE_GP, &wdt_status)) {
 		if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
 			if (gp_rreq_fail)
 				pr_err("I/O Address 0x%04x and 0x%04x already in use\n",
@@ -682,6 +696,7 @@ static int __init it87_wdt_init(void)
 			superio_select(GAMEPORT);
 			superio_outb(gpact, ACTREG);
 		}
+		set_bit(WDTS_USE_CIR, &wdt_status);
 	}
 
 	if (timeout < 1 || timeout > max_units * 60) {
@@ -707,7 +722,7 @@ static int __init it87_wdt_init(void)
 	}
 
 	/* Initialize CIR to use it as keepalive source */
-	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
+	if (test_bit(WDTS_USE_CIR, &wdt_status)) {
 		outb(0x00, CIR_RCR(base));
 		outb(0xc0, CIR_TCR1(base));
 		outb(0x5c, CIR_TCR2(base));
@@ -717,9 +732,9 @@ static int __init it87_wdt_init(void)
 		outb(0x09, CIR_IER(base));
 	}
 
-	pr_info("Chip IT%04x revision %d initialized. timeout=%d sec (nowayout=%d testmode=%d exclusive=%d nogameport=%d)\n",
+	pr_info("Chip IT%04x revision %d initialized. timeout=%d sec (nowayout=%d testmode=%d exclusive=%d nogameport=%d nocir=%d)\n",
 		chip_type, chip_rev, timeout,
-		nowayout, testmode, exclusive, nogameport);
+		nowayout, testmode, exclusive, nogameport, nocir);
 
 	superio_exit();
 	return 0;
@@ -727,8 +742,10 @@ static int __init it87_wdt_init(void)
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region:
-	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
-	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
+	if (test_bit(WDTS_USE_GP, &wdt_status))
+		release_region(base, 1);
+	else if (test_bit(WDTS_USE_CIR, &wdt_status)) {
+		release_region(base, 8);
 		superio_select(CIR);
 		superio_outb(ciract, ACTREG);
 	}
@@ -754,7 +771,7 @@ static void __exit it87_wdt_exit(void)
 		if (test_bit(WDTS_USE_GP, &wdt_status)) {
 			superio_select(GAMEPORT);
 			superio_outb(gpact, ACTREG);
-		} else {
+		} else if (test_bit(WDTS_USE_CIR, &wdt_status)) {
 			superio_select(CIR);
 			superio_outb(ciract, ACTREG);
 		}
@@ -763,7 +780,11 @@ static void __exit it87_wdt_exit(void)
 
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
+
+	if (test_bit(WDTS_USE_GP, &wdt_status))
+		release_region(base, 1);
+	else if (test_bit(WDTS_USE_CIR, &wdt_status))
+		release_region(base, 8);
 }
 
 module_init(it87_wdt_init);
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index 3aa50cf..91e45ca 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -18,7 +18,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/device.h>
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index bdb3f4a..0e9cc6f 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -20,7 +20,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index c1f65b4..7831955 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -237,6 +237,7 @@ static const struct of_device_id mpc8xxx_wdt_match[] = {
 		.compatible = "fsl,mpc823-wdt",
 		.data = &(struct mpc8xxx_wdt_type) {
 			.prescaler = 0x800,
+			.hw_enabled = true,
 		},
 	},
 	{},
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index edb31ff..ff27c4a 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -40,7 +40,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index a0d893b..7135803 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -12,7 +12,6 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/kernel.h>
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index fb57103..57ccae8 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -1,6 +1,7 @@
 /*
  * Watchdog Device Driver for Xilinx axi/xps_timebase_wdt
  *
+ * (C) Copyright 2013 - 2014 Xilinx, Inc.
  * (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
  *
  * This program is free software; you can redistribute it and/or
@@ -9,18 +10,13 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/watchdog.h>
 #include <linux/io.h>
-#include <linux/uaccess.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
@@ -43,102 +39,103 @@
 #define XWT_TIMER_FAILED            0xFFFFFFFF
 
 #define WATCHDOG_NAME     "Xilinx Watchdog"
-#define PFX WATCHDOG_NAME ": "
 
 struct xwdt_device {
-	struct resource  res;
 	void __iomem *base;
-	u32 nowayout;
 	u32 wdt_interval;
-	u32 boot_status;
+	spinlock_t spinlock;
+	struct watchdog_device xilinx_wdt_wdd;
 };
 
-static struct xwdt_device xdev;
-
-static  u32 timeout;
-static  u32 control_status_reg;
-static  u8  expect_close;
-static  u8  no_timeout;
-static unsigned long driver_open;
-
-static  DEFINE_SPINLOCK(spinlock);
-
-static void xwdt_start(void)
+static int xilinx_wdt_start(struct watchdog_device *wdd)
 {
-	spin_lock(&spinlock);
+	u32 control_status_reg;
+	struct xwdt_device *xdev = watchdog_get_drvdata(wdd);
+
+	spin_lock(&xdev->spinlock);
 
 	/* Clean previous status and enable the watchdog timer */
-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	control_status_reg = ioread32(xdev->base + XWT_TWCSR0_OFFSET);
 	control_status_reg |= (XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK);
 
 	iowrite32((control_status_reg | XWT_CSR0_EWDT1_MASK),
-				xdev.base + XWT_TWCSR0_OFFSET);
+		  xdev->base + XWT_TWCSR0_OFFSET);
+
+	iowrite32(XWT_CSRX_EWDT2_MASK, xdev->base + XWT_TWCSR1_OFFSET);
 
-	iowrite32(XWT_CSRX_EWDT2_MASK, xdev.base + XWT_TWCSR1_OFFSET);
+	spin_unlock(&xdev->spinlock);
 
-	spin_unlock(&spinlock);
+	return 0;
 }
 
-static void xwdt_stop(void)
+static int xilinx_wdt_stop(struct watchdog_device *wdd)
 {
-	spin_lock(&spinlock);
+	u32 control_status_reg;
+	struct xwdt_device *xdev = watchdog_get_drvdata(wdd);
+
+	spin_lock(&xdev->spinlock);
 
-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	control_status_reg = ioread32(xdev->base + XWT_TWCSR0_OFFSET);
 
 	iowrite32((control_status_reg & ~XWT_CSR0_EWDT1_MASK),
-				xdev.base + XWT_TWCSR0_OFFSET);
+		  xdev->base + XWT_TWCSR0_OFFSET);
 
-	iowrite32(0, xdev.base + XWT_TWCSR1_OFFSET);
+	iowrite32(0, xdev->base + XWT_TWCSR1_OFFSET);
 
-	spin_unlock(&spinlock);
+	spin_unlock(&xdev->spinlock);
 	pr_info("Stopped!\n");
+
+	return 0;
 }
 
-static void xwdt_keepalive(void)
+static int xilinx_wdt_keepalive(struct watchdog_device *wdd)
 {
-	spin_lock(&spinlock);
+	u32 control_status_reg;
+	struct xwdt_device *xdev = watchdog_get_drvdata(wdd);
 
-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
-	control_status_reg |= (XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK);
-	iowrite32(control_status_reg, xdev.base + XWT_TWCSR0_OFFSET);
+	spin_lock(&xdev->spinlock);
 
-	spin_unlock(&spinlock);
-}
+	control_status_reg = ioread32(xdev->base + XWT_TWCSR0_OFFSET);
+	control_status_reg |= (XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK);
+	iowrite32(control_status_reg, xdev->base + XWT_TWCSR0_OFFSET);
 
-static void xwdt_get_status(int *status)
-{
-	int new_status;
+	spin_unlock(&xdev->spinlock);
 
-	spin_lock(&spinlock);
+	return 0;
+}
 
-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
-	new_status = ((control_status_reg &
-			(XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK)) != 0);
-	spin_unlock(&spinlock);
+static const struct watchdog_info xilinx_wdt_ident = {
+	.options =  WDIOF_MAGICCLOSE |
+		    WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =	WATCHDOG_NAME,
+};
 
-	*status = 0;
-	if (new_status & 1)
-		*status |= WDIOF_CARDRESET;
-}
+static const struct watchdog_ops xilinx_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = xilinx_wdt_start,
+	.stop = xilinx_wdt_stop,
+	.ping = xilinx_wdt_keepalive,
+};
 
-static u32 xwdt_selftest(void)
+static u32 xwdt_selftest(struct xwdt_device *xdev)
 {
 	int i;
 	u32 timer_value1;
 	u32 timer_value2;
 
-	spin_lock(&spinlock);
+	spin_lock(&xdev->spinlock);
 
-	timer_value1 = ioread32(xdev.base + XWT_TBR_OFFSET);
-	timer_value2 = ioread32(xdev.base + XWT_TBR_OFFSET);
+	timer_value1 = ioread32(xdev->base + XWT_TBR_OFFSET);
+	timer_value2 = ioread32(xdev->base + XWT_TBR_OFFSET);
 
 	for (i = 0;
 		((i <= XWT_MAX_SELFTEST_LOOP_COUNT) &&
 			(timer_value2 == timer_value1)); i++) {
-		timer_value2 = ioread32(xdev.base + XWT_TBR_OFFSET);
+		timer_value2 = ioread32(xdev->base + XWT_TBR_OFFSET);
 	}
 
-	spin_unlock(&spinlock);
+	spin_unlock(&xdev->spinlock);
 
 	if (timer_value2 != timer_value1)
 		return ~XWT_TIMER_FAILED;
@@ -146,238 +143,83 @@ static u32 xwdt_selftest(void)
 		return XWT_TIMER_FAILED;
 }
 
-static int xwdt_open(struct inode *inode, struct file *file)
-{
-	/* Only one process can handle the wdt at a time */
-	if (test_and_set_bit(0, &driver_open))
-		return -EBUSY;
-
-	/* Make sure that the module are always loaded...*/
-	if (xdev.nowayout)
-		__module_get(THIS_MODULE);
-
-	xwdt_start();
-	pr_info("Started...\n");
-
-	return nonseekable_open(inode, file);
-}
-
-static int xwdt_release(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42) {
-		xwdt_stop();
-	} else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		xwdt_keepalive();
-	}
-
-	clear_bit(0, &driver_open);
-	expect_close = 0;
-	return 0;
-}
-
-/*
- *      xwdt_write:
- *      @file: file handle to the watchdog
- *      @buf: buffer to write (unused as data does not matter here
- *      @count: count of bytes
- *      @ppos: pointer to the position to write. No seeks allowed
- *
- *      A write to a watchdog device is defined as a keepalive signal. Any
- *      write of data will do, as we don't define content meaning.
- */
-static ssize_t xwdt_write(struct file *file, const char __user *buf,
-						size_t len, loff_t *ppos)
-{
-	if (len) {
-		if (!xdev.nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, buf + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		xwdt_keepalive();
-	}
-	return len;
-}
-
-static const struct watchdog_info ident = {
-	.options =  WDIOF_MAGICCLOSE |
-		    WDIOF_KEEPALIVEPING,
-	.firmware_version =	1,
-	.identity =	WATCHDOG_NAME,
-};
-
-/*
- *      xwdt_ioctl:
- *      @file: file handle to the device
- *      @cmd: watchdog command
- *      @arg: argument pointer
- *
- *      The watchdog API defines a common set of functions for all watchdogs
- *      according to their available features.
- */
-static long xwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	int status;
-
-	union {
-		struct watchdog_info __user *ident;
-		int __user *i;
-	} uarg;
-
-	uarg.i = (int __user *)arg;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(uarg.ident, &ident,
-					sizeof(ident)) ? -EFAULT : 0;
-
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(xdev.boot_status, uarg.i);
-
-	case WDIOC_GETSTATUS:
-		xwdt_get_status(&status);
-		return put_user(status, uarg.i);
-
-	case WDIOC_KEEPALIVE:
-		xwdt_keepalive();
-		return 0;
-
-	case WDIOC_GETTIMEOUT:
-		if (no_timeout)
-			return -ENOTTY;
-		else
-			return put_user(timeout, uarg.i);
-
-	default:
-		return -ENOTTY;
-	}
-}
-
-static const struct file_operations xwdt_fops = {
-	.owner      = THIS_MODULE,
-	.llseek     = no_llseek,
-	.write      = xwdt_write,
-	.open       = xwdt_open,
-	.release    = xwdt_release,
-	.unlocked_ioctl = xwdt_ioctl,
-};
-
-static struct miscdevice xwdt_miscdev = {
-	.minor      = WATCHDOG_MINOR,
-	.name       = "watchdog",
-	.fops       = &xwdt_fops,
-};
-
 static int xwdt_probe(struct platform_device *pdev)
 {
 	int rc;
-	u32 *tmptr;
-	u32 *pfreq;
-
-	no_timeout = 0;
-
-	pfreq = (u32 *)of_get_property(pdev->dev.of_node,
-					"clock-frequency", NULL);
-
-	if (pfreq == NULL) {
-		pr_warn("The watchdog clock frequency cannot be obtained!\n");
-		no_timeout = 1;
-	}
-
-	rc = of_address_to_resource(pdev->dev.of_node, 0, &xdev.res);
-	if (rc) {
-		pr_warn("invalid address!\n");
-		return rc;
-	}
-
-	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
-					"xlnx,wdt-interval", NULL);
-	if (tmptr == NULL) {
-		pr_warn("Parameter \"xlnx,wdt-interval\" not found in device tree!\n");
-		no_timeout = 1;
-	} else {
-		xdev.wdt_interval = *tmptr;
-	}
-
-	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
-					"xlnx,wdt-enable-once", NULL);
-	if (tmptr == NULL) {
-		pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in device tree!\n");
-		xdev.nowayout = WATCHDOG_NOWAYOUT;
-	}
-
-/*
- *  Twice of the 2^wdt_interval / freq  because the first wdt overflow is
- *  ignored (interrupt), reset is only generated at second wdt overflow
- */
-	if (!no_timeout)
-		timeout = 2 * ((1<<xdev.wdt_interval) / *pfreq);
-
-	if (!request_mem_region(xdev.res.start,
-			xdev.res.end - xdev.res.start + 1, WATCHDOG_NAME)) {
-		rc = -ENXIO;
-		pr_err("memory request failure!\n");
-		goto err_out;
-	}
-
-	xdev.base = ioremap(xdev.res.start, xdev.res.end - xdev.res.start + 1);
-	if (xdev.base == NULL) {
-		rc = -ENOMEM;
-		pr_err("ioremap failure!\n");
-		goto release_mem;
-	}
-
-	rc = xwdt_selftest();
+	u32 pfreq = 0, enable_once = 0;
+	struct resource *res;
+	struct xwdt_device *xdev;
+	struct watchdog_device *xilinx_wdt_wdd;
+
+	xdev = devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
+	if (!xdev)
+		return -ENOMEM;
+
+	xilinx_wdt_wdd = &xdev->xilinx_wdt_wdd;
+	xilinx_wdt_wdd->info = &xilinx_wdt_ident;
+	xilinx_wdt_wdd->ops = &xilinx_wdt_ops;
+	xilinx_wdt_wdd->parent = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	xdev->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(xdev->base))
+		return PTR_ERR(xdev->base);
+
+	rc = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &pfreq);
+	if (rc)
+		dev_warn(&pdev->dev,
+			 "The watchdog clock frequency cannot be obtained\n");
+
+	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-interval",
+				  &xdev->wdt_interval);
+	if (rc)
+		dev_warn(&pdev->dev,
+			 "Parameter \"xlnx,wdt-interval\" not found\n");
+
+	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-enable-once",
+				  &enable_once);
+	if (rc)
+		dev_warn(&pdev->dev,
+			 "Parameter \"xlnx,wdt-enable-once\" not found\n");
+
+	watchdog_set_nowayout(xilinx_wdt_wdd, enable_once);
+
+	/*
+	 * Twice of the 2^wdt_interval / freq  because the first wdt overflow is
+	 * ignored (interrupt), reset is only generated at second wdt overflow
+	 */
+	if (pfreq && xdev->wdt_interval)
+		xilinx_wdt_wdd->timeout = 2 * ((1 << xdev->wdt_interval) /
+					  pfreq);
+
+	spin_lock_init(&xdev->spinlock);
+	watchdog_set_drvdata(xilinx_wdt_wdd, xdev);
+
+	rc = xwdt_selftest(xdev);
 	if (rc == XWT_TIMER_FAILED) {
-		pr_err("SelfTest routine error!\n");
-		goto unmap_io;
+		dev_err(&pdev->dev, "SelfTest routine error\n");
+		return rc;
 	}
 
-	xwdt_get_status(&xdev.boot_status);
-
-	rc = misc_register(&xwdt_miscdev);
+	rc = watchdog_register_device(xilinx_wdt_wdd);
 	if (rc) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-		       xwdt_miscdev.minor, rc);
-		goto unmap_io;
+		dev_err(&pdev->dev, "Cannot register watchdog (err=%d)\n", rc);
+		return rc;
 	}
 
-	if (no_timeout)
-		pr_info("driver loaded (timeout=? sec, nowayout=%d)\n",
-			xdev.nowayout);
-	else
-		pr_info("driver loaded (timeout=%d sec, nowayout=%d)\n",
-			timeout, xdev.nowayout);
+	dev_info(&pdev->dev, "Xilinx Watchdog Timer at %p with timeout %ds\n",
+		 xdev->base, xilinx_wdt_wdd->timeout);
 
-	expect_close = 0;
-	clear_bit(0, &driver_open);
+	platform_set_drvdata(pdev, xdev);
 
 	return 0;
-
-unmap_io:
-	iounmap(xdev.base);
-release_mem:
-	release_mem_region(xdev.res.start, resource_size(&xdev.res));
-err_out:
-	return rc;
 }
 
-static int xwdt_remove(struct platform_device *dev)
+static int xwdt_remove(struct platform_device *pdev)
 {
-	misc_deregister(&xwdt_miscdev);
-	iounmap(xdev.base);
-	release_mem_region(xdev.res.start, resource_size(&xdev.res));
+	struct xwdt_device *xdev = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&xdev->xilinx_wdt_wdd);
 
 	return 0;
 }
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 09cf013..3691b15 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -34,7 +34,6 @@
 #include <linux/mm.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
@@ -58,7 +57,6 @@ struct omap_wdt_dev {
 	void __iomem    *base;          /* physical */
 	struct device   *dev;
 	bool		omap_wdt_users;
-	struct resource *mem;
 	int		wdt_trgr_pattern;
 	struct mutex	lock;		/* to avoid races with PM */
 };
@@ -207,7 +205,7 @@ static int omap_wdt_probe(struct platform_device *pdev)
 {
 	struct omap_wd_timer_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct watchdog_device *omap_wdt;
-	struct resource *res, *mem;
+	struct resource *res;
 	struct omap_wdt_dev *wdev;
 	u32 rs;
 	int ret;
@@ -216,29 +214,20 @@ static int omap_wdt_probe(struct platform_device *pdev)
 	if (!omap_wdt)
 		return -ENOMEM;
 
-	/* reserve static register mappings */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
-	mem = devm_request_mem_region(&pdev->dev, res->start,
-				      resource_size(res), pdev->name);
-	if (!mem)
-		return -EBUSY;
-
 	wdev = devm_kzalloc(&pdev->dev, sizeof(*wdev), GFP_KERNEL);
 	if (!wdev)
 		return -ENOMEM;
 
 	wdev->omap_wdt_users	= false;
-	wdev->mem		= mem;
 	wdev->dev		= &pdev->dev;
 	wdev->wdt_trgr_pattern	= 0x1234;
 	mutex_init(&wdev->lock);
 
-	wdev->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!wdev->base)
-		return -ENOMEM;
+	/* reserve static register mappings */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdev->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(wdev->base))
+		return PTR_ERR(wdev->base);
 
 	omap_wdt->info	      = &omap_wdt_info;
 	omap_wdt->ops	      = &omap_wdt_ops;
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index f7722a4..4981634 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 5211d56..9f15dd9 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -512,9 +512,8 @@ static int __init pc87413_init(void)
 		return -EBUSY;
 
 	ret = register_reboot_notifier(&pc87413_notifier);
-	if (ret != 0) {
+	if (ret != 0)
 		pr_err("cannot register reboot notifier (err=%d)\n", ret);
-	}
 
 	ret = misc_register(&pc87413_miscdev);
 	if (ret != 0) {
@@ -575,8 +574,8 @@ static void __exit pc87413_exit(void)
 module_init(pc87413_init);
 module_exit(pc87413_exit);
 
-MODULE_AUTHOR("Sven Anders <anders@anduras.de>, "
-		"Marcus Junker <junker@anduras.de>,");
+MODULE_AUTHOR("Sven Anders <anders@anduras.de>");
+MODULE_AUTHOR("Marcus Junker <junker@anduras.de>");
 MODULE_DESCRIPTION("PC87413 WDT driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index e562e04..1a11aed 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -645,10 +645,8 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	/* allocate memory for our device and initialize it */
 	usb_pcwd = kzalloc(sizeof(struct usb_pcwd_private), GFP_KERNEL);
-	if (usb_pcwd == NULL) {
-		pr_err("Out of memory\n");
+	if (usb_pcwd == NULL)
 		goto error;
-	}
 
 	usb_pcwd_device = usb_pcwd;
 
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 5bec20f..15fb316 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -24,7 +24,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/spinlock.h>
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 082d062..29cf4dc 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -27,7 +27,6 @@
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff --git a/drivers/watchdog/retu_wdt.c b/drivers/watchdog/retu_wdt.c
index f53615d..a7a0695 100644
--- a/drivers/watchdog/retu_wdt.c
+++ b/drivers/watchdog/retu_wdt.c
@@ -16,7 +16,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/device.h>
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 3dd8ed2..cfed0fe 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/of.h>
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index aec946d..7c6ccd0 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/watchdog.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
@@ -526,7 +525,11 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	clk_prepare_enable(wdt->clock);
+	ret = clk_prepare_enable(wdt->clock);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable clock\n");
+		return ret;
+	}
 
 	ret = s3c2410wdt_cpufreq_register(wdt);
 	if (ret < 0) {
@@ -608,7 +611,6 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
  err_clk:
 	clk_disable_unprepare(wdt->clock);
-	wdt->clock = NULL;
 
  err:
 	return ret;
@@ -628,7 +630,6 @@ static int s3c2410wdt_remove(struct platform_device *dev)
 	s3c2410wdt_cpufreq_deregister(wdt);
 
 	clk_disable_unprepare(wdt->clock);
-	wdt->clock = NULL;
 
 	return 0;
 }
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index f353e18..1cfd3f6 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -158,12 +158,11 @@ static void wdt_timer_ping(unsigned long data)
 
 static void wdt_config(int writeval)
 {
-	__u16 dummy;
 	unsigned long flags;
 
 	/* buy some time (ping) */
 	spin_lock_irqsave(&wdt_spinlock, flags);
-	dummy = readw(wdtmrctl);	/* ensure write synchronization */
+	readw(wdtmrctl);	/* ensure write synchronization */
 	writew(0xAAAA, wdtmrctl);
 	writew(0x5555, wdtmrctl);
 	/* unlock WDT = make WDT configuration register writable one time */
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index af3528f..d04d02b 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -293,8 +293,6 @@ static int sh_wdt_probe(struct platform_device *pdev)
 
 static int sh_wdt_remove(struct platform_device *pdev)
 {
-	struct sh_wdt *wdt = platform_get_drvdata(pdev);
-
 	watchdog_unregister_device(&sh_wdt_dev);
 
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index c04a1aa..0dc5e32 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static int soft_noboot = 0;
+static int soft_noboot;
 module_param(soft_noboot, int, 0);
 MODULE_PARM_DESC(soft_noboot,
 	"Softdog action, set to 1 to ignore reboots, 0 to reboot (default=0)");
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 3f786ce..47629d2 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/amba/bus.h>
 #include <linux/bitops.h>
 #include <linux/clk.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
@@ -209,27 +208,15 @@ sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 	struct sp805_wdt *wdt;
 	int ret = 0;
 
-	if (!devm_request_mem_region(&adev->dev, adev->res.start,
-				resource_size(&adev->res), "sp805_wdt")) {
-		dev_warn(&adev->dev, "Failed to get memory region resource\n");
-		ret = -ENOENT;
-		goto err;
-	}
-
 	wdt = devm_kzalloc(&adev->dev, sizeof(*wdt), GFP_KERNEL);
 	if (!wdt) {
-		dev_warn(&adev->dev, "Kzalloc failed\n");
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	wdt->base = devm_ioremap(&adev->dev, adev->res.start,
-			resource_size(&adev->res));
-	if (!wdt->base) {
-		ret = -ENOMEM;
-		dev_warn(&adev->dev, "ioremap fail\n");
-		goto err;
-	}
+	wdt->base = devm_ioremap_resource(&adev->dev, &adev->res);
+	if (IS_ERR(wdt->base))
+		return PTR_ERR(wdt->base);
 
 	wdt->clk = devm_clk_get(&adev->dev, NULL);
 	if (IS_ERR(wdt->clk)) {
diff --git a/drivers/watchdog/stmp3xxx_rtc_wdt.c b/drivers/watchdog/stmp3xxx_rtc_wdt.c
index bb64ae3..3804d5e 100644
--- a/drivers/watchdog/stmp3xxx_rtc_wdt.c
+++ b/drivers/watchdog/stmp3xxx_rtc_wdt.c
@@ -9,7 +9,6 @@
  * under the terms of the GNU General Public License version 2 as published by
  * the Free Software Foundation.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/watchdog.h>
diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 76332d8..cd00a78 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -205,7 +205,7 @@ static void sunxi_wdt_shutdown(struct platform_device *pdev)
 }
 
 static const struct of_device_id sunxi_wdt_dt_ids[] = {
-	{ .compatible = "allwinner,sun4i-wdt" },
+	{ .compatible = "allwinner,sun4i-a10-wdt" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, sunxi_wdt_dt_ids);
diff --git a/drivers/watchdog/tegra_wdt.c b/drivers/watchdog/tegra_wdt.c
new file mode 100644
index 0000000..750e2a2
--- /dev/null
+++ b/drivers/watchdog/tegra_wdt.c
@@ -0,0 +1,302 @@
+/*
+ * Copyright (c) 2014, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+/* minimum and maximum watchdog trigger timeout, in seconds */
+#define MIN_WDT_TIMEOUT			1
+#define MAX_WDT_TIMEOUT			255
+
+/*
+ * Base of the WDT registers, from the timer base address.  There are
+ * actually 5 watchdogs that can be configured (by pairing with an available
+ * timer), at bases 0x100 + (WDT ID) * 0x20, where WDT ID is 0 through 4.
+ * This driver only configures the first watchdog (WDT ID 0).
+ */
+#define WDT_BASE			0x100
+#define WDT_ID				0
+
+/*
+ * Register base of the timer that's selected for pairing with the watchdog.
+ * This driver arbitrarily uses timer 5, which is currently unused by
+ * other drivers (in particular, the Tegra clocksource driver).  If this
+ * needs to change, take care that the new timer is not used by the
+ * clocksource driver.
+ */
+#define WDT_TIMER_BASE			0x60
+#define WDT_TIMER_ID			5
+
+/* WDT registers */
+#define WDT_CFG				0x0
+#define WDT_CFG_PERIOD_SHIFT		4
+#define WDT_CFG_PERIOD_MASK		0xff
+#define WDT_CFG_INT_EN			(1 << 12)
+#define WDT_CFG_PMC2CAR_RST_EN		(1 << 15)
+#define WDT_STS				0x4
+#define WDT_STS_COUNT_SHIFT		4
+#define WDT_STS_COUNT_MASK		0xff
+#define WDT_STS_EXP_SHIFT		12
+#define WDT_STS_EXP_MASK		0x3
+#define WDT_CMD				0x8
+#define WDT_CMD_START_COUNTER		(1 << 0)
+#define WDT_CMD_DISABLE_COUNTER		(1 << 1)
+#define WDT_UNLOCK			(0xc)
+#define WDT_UNLOCK_PATTERN		(0xc45a << 0)
+
+/* Timer registers */
+#define TIMER_PTV			0x0
+#define TIMER_EN			(1 << 31)
+#define TIMER_PERIODIC			(1 << 30)
+
+struct tegra_wdt {
+	struct watchdog_device	wdd;
+	void __iomem		*wdt_regs;
+	void __iomem		*tmr_regs;
+};
+
+#define WDT_HEARTBEAT 120
+static int heartbeat = WDT_HEARTBEAT;
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat,
+	"Watchdog heartbeats in seconds. (default = "
+	__MODULE_STRING(WDT_HEARTBEAT) ")");
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int tegra_wdt_start(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+	u32 val;
+
+	/*
+	 * This thing has a fixed 1MHz clock.  Normally, we would set the
+	 * period to 1 second by writing 1000000ul, but the watchdog system
+	 * reset actually occurs on the 4th expiration of this counter,
+	 * so we set the period to 1/4 of this amount.
+	 */
+	val = 1000000ul / 4;
+	val |= (TIMER_EN | TIMER_PERIODIC);
+	writel(val, wdt->tmr_regs + TIMER_PTV);
+
+	/*
+	 * Set number of periods and start counter.
+	 *
+	 * Interrupt handler is not required for user space
+	 * WDT accesses, since the caller is responsible to ping the
+	 * WDT to reset the counter before expiration, through ioctls.
+	 */
+	val = WDT_TIMER_ID |
+	      (wdd->timeout << WDT_CFG_PERIOD_SHIFT) |
+	      WDT_CFG_PMC2CAR_RST_EN;
+	writel(val, wdt->wdt_regs + WDT_CFG);
+
+	writel(WDT_CMD_START_COUNTER, wdt->wdt_regs + WDT_CMD);
+
+	return 0;
+}
+
+static int tegra_wdt_stop(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	writel(WDT_UNLOCK_PATTERN, wdt->wdt_regs + WDT_UNLOCK);
+	writel(WDT_CMD_DISABLE_COUNTER, wdt->wdt_regs + WDT_CMD);
+	writel(0, wdt->tmr_regs + TIMER_PTV);
+
+	return 0;
+}
+
+static int tegra_wdt_ping(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	writel(WDT_CMD_START_COUNTER, wdt->wdt_regs + WDT_CMD);
+
+	return 0;
+}
+
+static int tegra_wdt_set_timeout(struct watchdog_device *wdd,
+				 unsigned int timeout)
+{
+	wdd->timeout = timeout;
+
+	if (watchdog_active(wdd))
+		return tegra_wdt_start(wdd);
+
+	return 0;
+}
+
+static unsigned int tegra_wdt_get_timeleft(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+	u32 val;
+	int count;
+	int exp;
+
+	val = readl(wdt->wdt_regs + WDT_STS);
+
+	/* Current countdown (from timeout) */
+	count = (val >> WDT_STS_COUNT_SHIFT) & WDT_STS_COUNT_MASK;
+
+	/* Number of expirations (we are waiting for the 4th expiration) */
+	exp = (val >> WDT_STS_EXP_SHIFT) & WDT_STS_EXP_MASK;
+
+	/*
+	 * The entire thing is divided by 4 because we are ticking down 4 times
+	 * faster due to needing to wait for the 4th expiration.
+	 */
+	return (((3 - exp) * wdd->timeout) + count) / 4;
+}
+
+static const struct watchdog_info tegra_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT |
+			  WDIOF_MAGICCLOSE |
+			  WDIOF_KEEPALIVEPING,
+	.firmware_version = 0,
+	.identity	= "Tegra Watchdog",
+};
+
+static struct watchdog_ops tegra_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = tegra_wdt_start,
+	.stop = tegra_wdt_stop,
+	.ping = tegra_wdt_ping,
+	.set_timeout = tegra_wdt_set_timeout,
+	.get_timeleft = tegra_wdt_get_timeleft,
+};
+
+static int tegra_wdt_probe(struct platform_device *pdev)
+{
+	struct watchdog_device *wdd;
+	struct tegra_wdt *wdt;
+	struct resource *res;
+	void __iomem *regs;
+	int ret;
+
+	/* This is the timer base. */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	/*
+	 * Allocate our watchdog driver data, which has the
+	 * struct watchdog_device nested within it.
+	 */
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	/* Initialize struct tegra_wdt. */
+	wdt->wdt_regs = regs + WDT_BASE;
+	wdt->tmr_regs = regs + WDT_TIMER_BASE;
+
+	/* Initialize struct watchdog_device. */
+	wdd = &wdt->wdd;
+	wdd->timeout = heartbeat;
+	wdd->info = &tegra_wdt_info;
+	wdd->ops = &tegra_wdt_ops;
+	wdd->min_timeout = MIN_WDT_TIMEOUT;
+	wdd->max_timeout = MAX_WDT_TIMEOUT;
+
+	watchdog_set_drvdata(wdd, wdt);
+
+	watchdog_set_nowayout(wdd, nowayout);
+
+	ret = watchdog_register_device(wdd);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to register watchdog device\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, wdt);
+
+	dev_info(&pdev->dev,
+		 "initialized (heartbeat = %d sec, nowayout = %d)\n",
+		 heartbeat, nowayout);
+
+	return 0;
+}
+
+static int tegra_wdt_remove(struct platform_device *pdev)
+{
+	struct tegra_wdt *wdt = platform_get_drvdata(pdev);
+
+	tegra_wdt_stop(&wdt->wdd);
+
+	watchdog_unregister_device(&wdt->wdd);
+
+	dev_info(&pdev->dev, "removed wdt\n");
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int tegra_wdt_runtime_suspend(struct device *dev)
+{
+	struct tegra_wdt *wdt = dev_get_drvdata(dev);
+
+	if (watchdog_active(&wdt->wdd))
+		tegra_wdt_stop(&wdt->wdd);
+
+	return 0;
+}
+
+static int tegra_wdt_runtime_resume(struct device *dev)
+{
+	struct tegra_wdt *wdt = dev_get_drvdata(dev);
+
+	if (watchdog_active(&wdt->wdd))
+		tegra_wdt_start(&wdt->wdd);
+
+	return 0;
+}
+#endif
+
+static const struct of_device_id tegra_wdt_of_match[] = {
+	{ .compatible = "nvidia,tegra30-timer", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_wdt_of_match);
+
+static const struct dev_pm_ops tegra_wdt_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(tegra_wdt_runtime_suspend,
+				tegra_wdt_runtime_resume)
+};
+
+static struct platform_driver tegra_wdt_driver = {
+	.probe		= tegra_wdt_probe,
+	.remove		= tegra_wdt_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "tegra-wdt",
+		.pm	= &tegra_wdt_pm_ops,
+		.of_match_table = tegra_wdt_of_match,
+	},
+};
+module_platform_driver(tegra_wdt_driver);
+
+MODULE_AUTHOR("NVIDIA Corporation");
+MODULE_DESCRIPTION("Tegra Watchdog Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 09d4831..afa9d6e 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -61,7 +61,7 @@ struct ts72xx_wdt {
 	struct platform_device *pdev;
 };
 
-struct platform_device *ts72xx_wdt_pdev;
+static struct platform_device *ts72xx_wdt_pdev;
 
 /*
  * TS-72xx Watchdog supports following timeouts (value written
@@ -394,10 +394,8 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	int error = 0;
 
 	wdt = devm_kzalloc(&pdev->dev, sizeof(struct ts72xx_wdt), GFP_KERNEL);
-	if (!wdt) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!wdt)
 		return -ENOMEM;
-	}
 
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 68b45fc..e9ea856 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -455,6 +455,6 @@ module_init(wdt_init);
 module_exit(wdt_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marcus Junker <junker@anduras.de>, "
-		"Samuel Tardieu <sam@rfc1149.net>");
+MODULE_AUTHOR("Marcus Junker <junker@anduras.de>");
+MODULE_AUTHOR("Samuel Tardieu <sam@rfc1149.net>");
 MODULE_DESCRIPTION("w83697hf/hg WDT driver");
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index 7355ddd..ebbb183 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -139,9 +139,8 @@ static const struct watchdog_info ident = {
 static long watchdog_ioctl(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
-	unsigned int new_margin;
 	int __user *int_arg = (int __user *)arg;
-	int ret = -ENOTTY;
+	int new_margin, ret = -ENOTTY;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 3dc578e..48b2c05 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -49,7 +49,6 @@
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/pci.h>
 #include <linux/io.h>
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index e243bd0..2fa17e7 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -204,7 +204,6 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
 				   GFP_KERNEL);
 	if (!driver_data) {
-		dev_err(wm831x->dev, "Unable to alloacate watchdog device\n");
 		ret = -ENOMEM;
 		goto err;
 	}
