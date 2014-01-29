Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaA2TyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:54:22 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:55299 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbaA2TyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:54:17 -0500
Date: Wed, 29 Jan 2014 20:54:10 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        Anson Huang <b20788@freescale.com>, Baruch Siach <baruch@tkos.co.il>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Doug Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Markus Mayer <markus.mayer@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: [GIT PULL REQUEST] watchdog - v3.14-rc1 merge window
Message-ID: <20140129195410.GA29278@spo001.leaseweb.com>
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

This series contains:
 * new driver for bcm281xx watchdog device
 * new driver for gpio based watchdog devices
 * remove DEFINE_PCI_DEVICE_TABLE macro for watchdog device drivers
 * conversion of davinci_wdt and mpc8xxx_wdt to watchdog core
 * improvements on davinci_wdt, at91/dt, at91sam9_wdt and s3c2410_wdt
 * Auto-detect IO address and expand supported chips on w836* super-I/O chipsets
 * core: Make dt "timeout-sec" property work on drivers w/out min/max
 * fix Kconfig dependencies
 * sirf: Remove redundant of_match_ptr helper
 * mach-moxart: add restart handler
 * hpwdt patch to display better panic information
 * imx2_wdt: disable watchdog timer during low power mode

This will update the following files:

 Documentation/devicetree/bindings/watchdog/atmel-wdt.txt   |   30 -
 Documentation/devicetree/bindings/watchdog/davinci-wdt.txt |   15 
 Documentation/devicetree/bindings/watchdog/gpio-wdt.txt    |   23 
 Documentation/devicetree/bindings/watchdog/samsung-wdt.txt |   20 
 arch/arm/boot/dts/at91sam9260.dtsi                         |    5 
 arch/arm/boot/dts/at91sam9263.dtsi                         |    5 
 arch/arm/boot/dts/at91sam9g45.dtsi                         |    5 
 arch/arm/boot/dts/at91sam9n12.dtsi                         |    5 
 arch/arm/boot/dts/at91sam9x5.dtsi                          |    5 
 arch/arm/boot/dts/kizbox.dts                               |    6 
 arch/arm/boot/dts/sama5d3.dtsi                             |    5 
 arch/arm/configs/bcm_defconfig                             |    3 
 drivers/watchdog/Kconfig                                   |   59 +-
 drivers/watchdog/Makefile                                  |    2 
 drivers/watchdog/alim1535_wdt.c                            |    2 
 drivers/watchdog/alim7101_wdt.c                            |    2 
 drivers/watchdog/at91sam9_wdt.c                            |  320 ++++++++---
 drivers/watchdog/bcm_kona_wdt.c                            |  368 +++++++++++++
 drivers/watchdog/davinci_wdt.c                             |  221 +++----
 drivers/watchdog/dw_wdt.c                                  |    2 
 drivers/watchdog/gpio_wdt.c                                |  254 ++++++++
 drivers/watchdog/hpwdt.c                                   |   13 
 drivers/watchdog/i6300esb.c                                |    2 
 drivers/watchdog/imx2_wdt.c                                |    4 
 drivers/watchdog/moxart_wdt.c                              |   15 
 drivers/watchdog/mpc8xxx_wdt.c                             |  110 +--
 drivers/watchdog/nv_tco.c                                  |    2 
 drivers/watchdog/pcwd_pci.c                                |    2 
 drivers/watchdog/s3c2410_wdt.c                             |  203 ++++++-
 drivers/watchdog/sirfsoc_wdt.c                             |    2 
 drivers/watchdog/sp5100_tco.c                              |    2 
 drivers/watchdog/via_wdt.c                                 |    2 
 drivers/watchdog/w83627hf_wdt.c                            |  234 +++++++-
 drivers/watchdog/watchdog_core.c                           |    4 
 drivers/watchdog/wdt_pci.c                                 |    2 
 35 files changed, 1598 insertions(+), 356 deletions(-)

with these Changes:

commit ea3d4011a871e1802e201086195c61e6dbeaf6d5
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Aug 17 13:58:46 2013 -0700

    watchdog: w83627hf_wdt: Reset watchdog trigger during initialization
    
    If the watchdog has already triggered for whatever reason, it won't restart
    unless the trigger is reset.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7b6d0b6ad49e55f8b82dbf233ece4e091417a738
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Aug 17 13:58:44 2013 -0700

    watchdog: w83627hf: Add support for W83697HF and W83697UG
    
    Major difference is that the watchdog control and counter registers
    are different on both chips.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 962c04f54e4a3c322d19b47256f9aec0b9c8124e
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Aug 17 13:58:43 2013 -0700

    watchdog: w83627hf: Auto-detect IO address and supported chips
    
    Instead of requiring the user to provide an IO address per module
    parameter, auto-detect it as well as supported chips.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f72fa00f8ab216ee484d61de17ddc84712456c3a
Author: Boris BREZILLON <b.brezillon@overkiz.com>
Date:   Sun Nov 3 18:52:44 2013 +0100

    watchdog: at91sam9_wdt: increase security margin on watchdog counter reset
    
    Try to reset the watchdog counter 4 or 2 times more often than actually
    requested, to avoid spurious watchdog reset.
    If this is not possible because of the min_heartbeat value, reset it at
    the min_heartbeat period.
    
    Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a04c3f01d33f4661424deeff67913699a0910c53
Author: Boris BREZILLON <b.brezillon@overkiz.com>
Date:   Sun Nov 3 18:52:43 2013 +0100

    watchdog: at91sam9_wdt: avoid spurious watchdog reset during init
    
    Use the min_heartbeat value instead of the calculated heartbeat value for
    the first watchdog reset to avoid spurious watchdog reset.
    
    Resetting the watchdog counter during init might lead to a watchdog fault
    reset because the watchdog counter has to be running for at least
    min_heartbeat.
    
    Resetting the watchdog counter after heartbeat might lead to a watchdog
    timeout reset because the watchdog counter is running for more than
    max_heartbeat time.
    
    Using min_heartbeat instead of heartbeat does not guarantee that the
    watchdog won't trigger a reset, but at least it reduces the chances to be
    in such a case.
    
    Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1444797fc178b58e91cf29a438efd05dd890d43a
Author: Boris BREZILLON <b.brezillon@overkiz.com>
Date:   Sun Nov 3 18:52:42 2013 +0100

    watchdog: at91sam9_wdt: fix secs_to_ticks
    
    Fix the secs_to_ticks macro in case 0 is passed as an argument.
    
    Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 705b675db92bbbda47507205a37784d2d0ab8c0d
Author: Boris BREZILLON <b.brezillon@overkiz.com>
Date:   Fri Oct 4 09:24:15 2013 +0200

    ARM: at91/dt: add watchdog properties to kizbox board
    
    Add watchdog specific config for kizbox board.
    
    Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fe46aa679f12c6e43039a2a3255ea47e47dcef52
Author: Boris BREZILLON <b.brezillon@overkiz.com>
Date:   Fri Oct 4 09:24:14 2013 +0200

    ARM: at91/dt: add sam9 watchdog default options to SoCs
    
    Set default watchdog options in every SoC compatible with the sam9 watchdog.
    
    Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6914c5873c227f0eb03e3860a1cf95a930a06f31
Author: Boris BREZILLON <b.brezillon@overkiz.com>
Date:   Fri Oct 4 09:24:13 2013 +0200

    watchdog: at91sam9_wdt: update device tree doc
    
    Add new at91sam9 watchdog properties to the documentation.
    
    Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5161b31dc39a6d6dadc95f298de48a725b73ada8
Author: Boris BREZILLON <b.brezillon@overkiz.com>
Date:   Fri Oct 4 09:24:12 2013 +0200

    watchdog: at91sam9_wdt: better watchdog support
    
    The at91sam9 watchdog timer can only be configured once, and the current
    implementation tries to configure it in a static way:
    - 2 seconds timeout
    - wdt restart every 500ms
    
    If the timer has already been configured with different values, it returns an
    error and do not create any watchdog device.
    
    This is not critical if the watchdog is disabled, but if it has been enabled with
    different timeout values it will lead to a SoC reset.
    
    This patch series tries to address this issue by adapting the heartbeat value
    according the WDT timer config:
    - it first tries to configure the timer as requested.
    - if it fails it fallbacks to the current config, adapting its heartbeat timer
    to the needs
    
    This patch series also move to a dynamically allocated at91wdt device instead
    of the static instance.
    
    It adds a new at91 wdt type: software. This new type make use of the at91 wdt
    interrupt to trigger a software reboot.
    
    Finally it adds several properties to the device tree bindings.
    
    Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e30722e49783ed5ea56b5737a2821d022c4e915e
Author: Naresh Bhat <naresh.bhat@linaro.org>
Date:   Wed Jan 22 18:14:03 2014 +0530

    watchdog: sp805_wdt depends also on ARM64
    
    Add sp805_wdt depends on ARM64.
    
    Signed-off-by: Naresh Bhat <naresh.bhat@linaro.org>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8773926d7135bb2d4e933272cd4c0c3aa5c4a088
Author: Jonas Jensen <jonas.jensen@gmail.com>
Date:   Wed Dec 18 16:18:03 2013 +0100

    watchdog: mach-moxart: add restart handler
    
    mach-moxart lacks a separate register for reset; as a workaround,
    add a function that can be hooked to arm_pm_restart.
    
    Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d5cfaf0a8554ad6b0e74955c7217ed24b2cadc9b
Author: Christophe Leroy <christophe.leroy@c-s.fr>
Date:   Wed Dec 4 07:32:14 2013 +0100

    watchdog: mpc8xxx_wdt convert to watchdog core
    
    Convert mpc8xxx_wdt.c to the new watchdog API.
    
    Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 15edd9eedd61ac7be53d63ffa6a7208d4479cece
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Sat Dec 21 14:01:13 2013 +0530

    watchdog: sirf: Remove redundant of_match_ptr helper
    
    'sirfsoc_wdt_of_match' is always compiled in. Hence the
    helper macro is not needed.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7bb5be947e5a32f3b4c1c5cad3bf47e9b5a26db0
Author: Thomas Mingarelli <thomas.mingarelli@hp.com>
Date:   Tue Jan 28 21:26:10 2014 +0100

    watchdog: hpwdt patch to display informative string
    
    This patch is being submitted to output a general string when the panic comes
    in that informs the user of the possible places to look for the source of the
    NMI. Because various systems log the message in different places this would
    give a single display of where to go look instead of code that acts on all
    these different server names or IDs.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 58a251f2c25a5305b6b18be7e576b75f6f9ce187
Author: Baruch Siach <baruch@tkos.co.il>
Date:   Mon Dec 30 14:25:54 2013 +0200

    watchdog: dw_wdt: remove build dependencies
    
    There is nothing ARM specific in this driver, and we intend to use it on the
    Xtensa architecture. Also, clk.h now includes stubs for !CONFIG_HAVE_CLK, so
    the driver should build anyway.
    
    Signed-off-by: Baruch Siach <baruch@tkos.co.il>
    Acked-by: Jamie Iles <jamie@jamieiles.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1a9c5efa576eccadd2836a1e53dcea21f999c180
Author: Anson Huang <b20788@freescale.com>
Date:   Mon Jan 13 19:58:34 2014 +0800

    watchdog: imx2_wdt: disable watchdog timer during low power mode
    
    We should set watchdog timer to be disabled in low power mode,
    as there is no service running in background, otherwise, system
    will reset unexpected.
    
    Signed-off-by: Anson Huang <b20788@freescale.com>
    Acked-by: Shawn Guo <shawn.guo@linaro.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit cffc9a60ebac3b560a370553abd885fa43d8b286
Author: Doug Anderson <dianders@chromium.org>
Date:   Fri Dec 6 13:08:07 2013 -0800

    watchdog: s3c2410_wdt: Report when the watchdog reset the system
    
    A good watchdog driver is supposed to report when it was responsible
    for resetting the system.  Implement this for the s3c2410, at least on
    exynos5250 and exynos5420 where we already have a pointer to the PMU
    registers to read the information.
    
    Note that exynos4 SoCs also provide the reset status, but providing
    that is left as an exercise for future changes and is not plumbed up
    in this patch series.  Also note the exynos4 SoCs don't appear to need
    any PMU config, which is why this patch separates the concepts of
    having PMU Registers vs. needing PMU Config.
    
    Signed-off-by: Doug Anderson <dianders@chromium.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4f1f653a68d67ca5732fdd7ee4deb290a3ea5149
Author: Leela Krishna Amudala <l.krishna@samsung.com>
Date:   Fri Dec 6 11:17:47 2013 +0530

    watchdog: s3c2410_wdt: use syscon regmap interface to configure pmu register
    
    Add device tree support for exynos5250 and 5420 SoCs and use syscon regmap interface
    to configure AUTOMATIC_WDT_RESET_DISABLE and MASK_WDT_RESET_REQUEST registers of PMU
    to mask/unmask enable/disable of watchdog in probe and s2r scenarios.
    
    Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
    Signed-off-by: Doug Anderson <dianders@chromium.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 178624403c04a4af315583eaf75ebb8545474544
Author: Doug Anderson <dianders@chromium.org>
Date:   Tue Nov 26 16:57:19 2013 -0800

    watchdog: s3c2410_wdt: Handle rounding a little better for timeout
    
    The existing watchdog timeout worked OK but didn't deal with
    rounding in an ideal way when dividing out all of its clocks.
    
    Specifically if you had a timeout of 32 seconds and an input clock of
    66666666, you'd end up setting a timeout of 31.9998 seconds and
    reporting a timeout of 31 seconds.
    
    Specifically DBG printouts showed:
      s3c2410wdt_set_heartbeat: count=16666656, timeout=32, freq=520833
      s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666656 (0000ff4f)
    and the final timeout reported to the user was:
      ((count / divisor) * divisor) / freq
      (0xff4f * 255) / 520833 = 31 (truncated from 31.9998)
    the technically "correct" value is:
      (0xff4f * 255) / (66666666.0 / 128) = 31.9998
    
    By using "DIV_ROUND_UP" we can be a little more correct.
      s3c2410wdt_set_heartbeat: count=16666688, timeout=32, freq=520834
      s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666688 (0000ff50)
    and the final timeout reported to the user:
      (0xff50 * 255) / 520834 = 32
    the technically "correct" value is:
      (0xff50 * 255) / (66666666.0 / 128) = 32.0003
    
    We'll use a DIV_ROUND_UP to solve this, generally erroring on the side
    of reporting shorter values to the user and setting the watchdog to
    slightly longer than requested:
    * Round input frequency up to assume watchdog is counting faster.
    * Round divisions by divisor up to give us extra time.
    
    At the same time we can avoid a for loop by just doing the right math.
    
    Signed-off-by: Doug Anderson <dianders@chromium.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0f1dd98d896efb956d474754b5d2f0c420d40192
Author: Doug Anderson <dianders@chromium.org>
Date:   Mon Nov 25 15:36:43 2013 -0800

    watchdog: s3c2410_wdt: Only register for cpufreq on ARM_S3C24XX_CPUFREQ
    
    On modern SoCs the watchdog timer is parented on a clock that doesn't
    change every time we have a cpufreq change.  That means we don't need
    to constantly adjust the watchdog timer, so avoid registering for and
    dealing with cpufreq transitions unless we've actually got
    CONFIG_ARM_S3C24XX_CPUFREQ defined.
    
    Note that this is more than just an optimization.  The s3c2410
    watchdog driver actually pats the watchdog on every CPU frequency
    change.  On modern systems these happen many times per second (even in
    a system where "nothing" is happening).  That effectively makes any
    userspace watchdog program useless (the watchdog is constantly patted
    by the kernel).  If we need ARM_S3C24XX_CPUFREQ defined on a
    multiplatform kernel we'll need to make sure that kernel supports
    common clock and change this to user common clock framework.
    
    Signed-off-by: Doug Anderson <dianders@chromium.org>
    Reviewed-by: Tomasz Figa <t.figa@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 25134eafb05eef6dd4b6caee3a711b63ee0c3737
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Nov 30 11:54:32 2013 +0400

    watchdog: GPIO-controlled watchdog
    
    This patch adds a watchdog driver for devices controlled through GPIO,
    (Analog Devices ADM706, Maxim MAX823, National NE555 etc).
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8832b20093434514fda5e8a0c885270eda4fbf40
Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Date:   Wed Dec 4 21:39:30 2013 +0200

    watchdog: davinci: reuse driver for keystone arch
    
    The keystone arch uses the same IP watchdog, so add "ti,keystone-wdt"
    compatible and correct identity.
    
    The Keystone arch is using clocks in DT and source clock for watchdog
    has to be specified, so add this to binding.
    
    Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4fa5daa9c618e3411a351c326c34916b65ee7ae6
Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Date:   Wed Dec 4 21:39:29 2013 +0200

    watchdog: davinci: add "timeout-sec" property
    
    Since Davinci WDT has been switched to use WDT core, it became able
    to support timeout-sec property, so add it to it's binding description.
    
    Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a771994901bde73779c94ec558b95c75bc2c7518
Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Date:   Wed Dec 4 21:39:28 2013 +0200

    watchdog: davinci: add GET_TIMELEFT option support
    
    Currently, the davinci watchdog can be read while counting,
    so we can add ability to report the remaining time before
    the system will reboot.
    
    Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6d9a6cf5c63fe4f08b05fc53f7a17048df86d3ac
Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Date:   Wed Dec 4 21:39:27 2013 +0200

    watchdog: davinci: use davinci_wdt_device structure to hold device data
    
    Some SoCs, like Keystone 2, can support more than one WDT and each
    watchdog device has to use it's own base address, clock source,
    watchdog device, so add new davinci_wdt_device structure to hold
    device data.
    
    Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Reviewed-by: Guenter roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f48f3ceabf2ce4fb5b8aa0672166e1e9001946b9
Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Date:   Thu Dec 5 13:26:24 2013 +0200

    watchdog: davinci: change driver to use WDT core
    
    To reduce code duplicate and increase code readability use WDT core
    code to handle WDT interface.
    
    Remove io_lock as the WDT core uses mutex to lock each wdt device.
    Remove wdt_state as the WDT core tracks state with its own variable.
    
    The watchdog_init_timeout() can read timeout value from timeout-sec
    property if the passed value is out of bounds. The heartbeat is
    initialized in next way. If heartbeat is not set thought module
    parameter, try to read it's value from WDT node timeout-sec property.
    If node has no one, use default value.
    
    The heartbeat is hold in wdd->timeout by WDT core, so use it in
    order to set timeout period.
    
    Davinci WDT can't be stopped and once it's expired - it can be
    rearmed only after hardware reset, that's why nowayout feature
    is enforced.
    
    Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6e2ac20e9c47cf26a1dd5a0f05b93ef0afd3c1c5
Author: Markus Mayer <markus.mayer@linaro.org>
Date:   Mon Jan 6 13:56:10 2014 -0800

    watchdog: bcm281xx: Debugfs support
    
    This change introduces debugfs support for the BCM281xx watchdog driver.
    
    Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6adb730dc2085c16c52a2f991cc1661e4a7fd6d5
Author: Markus Mayer <markus.mayer@linaro.org>
Date:   Fri Nov 22 14:56:03 2013 -0800

    watchdog: bcm281xx: Watchdog Driver
    
    This commit adds support for the watchdog timer used on the BCM281xx
    family of SoCs.
    
    Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
    Reviewed-by: Matt Porter <matt.porter@linaro.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2c34d59916bd82efe6544f39ec162e8c9236009d
Author: Doug Anderson <dianders@chromium.org>
Date:   Tue Nov 26 10:22:52 2013 -0800

    watchdog: core: Make dt "timeout-sec" property work on drivers w/out min/max
    
    It is valid for a watchdog driver to have 0 for a "min" and "max"
    timeout if the driver doesn't need the core to enforce the concepts of
    min and max.  The s3c2410_wdt driver is one such driver.  Specifically
    it can be hard for that driver to come up with a static "max" on all
    platforms without a lot more information since the input clock on
    S3C2410 and S3C2440 can change with DVFS.
    
    As written, watchdog_init_timeout() will not ever read "timeout-sec"
    on these drivers since watchdog_timeout_invalid() will _never_ return
    true.  Change to not consider a timeout_parm of 0 as valid even if
    min/max aren't specified by the driver.  Also handle the case when
    there is no min/max and no "timeout-sec" property.
    
    Signed-off-by: Doug Anderson <dianders@chromium.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit bc17f9dcb11dfe7a5f02103da51f580d62a6df2c
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Dec 3 08:30:22 2013 +0900

    watchdog: remove DEFINE_PCI_DEVICE_TABLE macro
    
    Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
    is not preferred.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
index fcdd48f..f90e294 100644
--- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
@@ -9,11 +9,37 @@ Required properties:
 
 Optional properties:
 - timeout-sec: contains the watchdog timeout in seconds.
+- interrupts : Should contain WDT interrupt.
+- atmel,max-heartbeat-sec : Should contain the maximum heartbeat value in
+	seconds. This value should be less or equal to 16. It is used to
+	compute the WDV field.
+- atmel,min-heartbeat-sec : Should contain the minimum heartbeat value in
+	seconds. This value must be smaller than the max-heartbeat-sec value.
+	It is used to compute the WDD field.
+- atmel,watchdog-type : Should be "hardware" or "software". Hardware watchdog
+	use the at91 watchdog reset. Software watchdog use the watchdog
+	interrupt to trigger a software reset.
+- atmel,reset-type : Should be "proc" or "all".
+	"all" : assert peripherals and processor reset signals
+	"proc" : assert the processor reset signal
+	This is valid only when using "hardware" watchdog.
+- atmel,disable : Should be present if you want to disable the watchdog.
+- atmel,idle-halt : Should be present if you want to stop the watchdog when
+	entering idle state.
+- atmel,dbg-halt : Should be present if you want to stop the watchdog when
+	entering debug state.
 
 Example:
-
 	watchdog@fffffd40 {
 		compatible = "atmel,at91sam9260-wdt";
 		reg = <0xfffffd40 0x10>;
-		timeout-sec = <10>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		timeout-sec = <15>;
+		atmel,watchdog-type = "hardware";
+		atmel,reset-type = "all";
+		atmel,dbg-halt;
+		atmel,idle-halt;
+		atmel,max-heartbeat-sec = <16>;
+		atmel,min-heartbeat-sec = <0>;
+		status = "okay";
 	};
diff --git a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
index 75558cc..e60b9a1 100644
--- a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
@@ -1,12 +1,24 @@
-DaVinci Watchdog Timer (WDT) Controller
+Texas Instruments DaVinci/Keystone Watchdog Timer (WDT) Controller
 
 Required properties:
-- compatible : Should be "ti,davinci-wdt"
+- compatible : Should be "ti,davinci-wdt", "ti,keystone-wdt"
 - reg : Should contain WDT registers location and length
 
+Optional properties:
+- timeout-sec : Contains the watchdog timeout in seconds
+- clocks : the clock feeding the watchdog timer.
+	   Needed if platform uses clocks.
+	   See clock-bindings.txt
+
+Documentation:
+Davinci DM646x - http://www.ti.com/lit/ug/spruer5b/spruer5b.pdf
+Keystone - http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf
+
 Examples:
 
 wdt: wdt@2320000 {
 	compatible = "ti,davinci-wdt";
 	reg = <0x02320000 0x80>;
+	timeout-sec = <30>;
+	clocks = <&clkwdtimer0>;
 };
diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
new file mode 100644
index 0000000..37afec1
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
@@ -0,0 +1,23 @@
+* GPIO-controlled Watchdog
+
+Required Properties:
+- compatible: Should contain "linux,wdt-gpio".
+- gpios: From common gpio binding; gpio connection to WDT reset pin.
+- hw_algo: The algorithm used by the driver. Should be one of the
+  following values:
+  - toggle: Either a high-to-low or a low-to-high transition clears
+    the WDT counter. The watchdog timer is disabled when GPIO is
+    left floating or connected to a three-state buffer.
+  - level: Low or high level starts counting WDT timeout,
+    the opposite level disables the WDT. Active level is determined
+    by the GPIO flags.
+- hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
+
+Example:
+	watchdog: watchdog {
+		/* ADM706 */
+		compatible = "linux,wdt-gpio";
+		gpios = <&gpio3 9 GPIO_ACTIVE_LOW>;
+		hw_algo = "toggle";
+		hw_margin_ms = <1600>;
+	};
diff --git a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
index 2aa486c..cfff375 100644
--- a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
@@ -5,10 +5,29 @@ after a preset amount of time during which the WDT reset event has not
 occurred.
 
 Required properties:
-- compatible : should be "samsung,s3c2410-wdt"
+- compatible : should be one among the following
+	(a) "samsung,s3c2410-wdt" for Exynos4 and previous SoCs
+	(b) "samsung,exynos5250-wdt" for Exynos5250
+	(c) "samsung,exynos5420-wdt" for Exynos5420
+
 - reg : base physical address of the controller and length of memory mapped
 	region.
 - interrupts : interrupt number to the cpu.
+- samsung,syscon-phandle : reference to syscon node (This property required only
+	in case of compatible being "samsung,exynos5250-wdt" or "samsung,exynos5420-wdt".
+	In case of Exynos5250 and 5420 this property points to syscon node holding the PMU
+	base address)
 
 Optional properties:
 - timeout-sec : contains the watchdog timeout in seconds.
+
+Example:
+
+watchdog@101D0000 {
+	compatible = "samsung,exynos5250-wdt";
+	reg = <0x101D0000 0x100>;
+	interrupts = <0 42 0>;
+	clocks = <&clock 336>;
+	clock-names = "watchdog";
+	samsung,syscon-phandle = <&pmu_syscon>;
+};
diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 56ee828..997901f 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -648,6 +648,11 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				atmel,watchdog-type = "hardware";
+				atmel,reset-type = "all";
+				atmel,dbg-halt;
+				atmel,idle-halt;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index c8fa9b9..0042f73 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -552,6 +552,11 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				atmel,watchdog-type = "hardware";
+				atmel,reset-type = "all";
+				atmel,dbg-halt;
+				atmel,idle-halt;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index ef0857c..cbcc058 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -706,6 +706,11 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				atmel,watchdog-type = "hardware";
+				atmel,reset-type = "all";
+				atmel,dbg-halt;
+				atmel,idle-halt;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 7248270..394e6ce 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -541,6 +541,11 @@
 			watchdog@fffffe40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffe40 0x10>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				atmel,watchdog-type = "hardware";
+				atmel,reset-type = "all";
+				atmel,dbg-halt;
+				atmel,idle-halt;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 6e5e9cf..174219d 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -754,6 +754,11 @@
 			watchdog@fffffe40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffe40 0x10>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				atmel,watchdog-type = "hardware";
+				atmel,reset-type = "all";
+				atmel,dbg-halt;
+				atmel,idle-halt;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/kizbox.dts b/arch/arm/boot/dts/kizbox.dts
index 02df191..928f6ee 100644
--- a/arch/arm/boot/dts/kizbox.dts
+++ b/arch/arm/boot/dts/kizbox.dts
@@ -53,6 +53,12 @@
 				status = "okay";
 			};
 
+			watchdog@fffffd40 {
+				timeout-sec = <15>;
+				atmel,max-heartbeat-sec = <16>;
+				atmel,min-heartbeat-sec = <0>;
+				status = "okay";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 1105558..52447c1 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1092,6 +1092,11 @@
 			watchdog@fffffe40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffe40 0x10>;
+				interrupts = <4 IRQ_TYPE_LEVEL_HIGH 7>;
+				atmel,watchdog-type = "hardware";
+				atmel,reset-type = "all";
+				atmel,dbg-halt;
+				atmel,idle-halt;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 2c38fdf..2519d6d 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -126,3 +126,6 @@ CONFIG_CRC7=y
 CONFIG_XZ_DEC=y
 CONFIG_AVERAGE=y
 CONFIG_PINCTRL_CAPRI=y
+CONFIG_WATCHDOG=y
+CONFIG_BCM_KONA_WDT=y
+CONFIG_BCM_KONA_WDT_DEBUG=y
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 5be6e91..4c4c566 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -87,6 +87,14 @@ config DA9055_WATCHDOG
 	  This driver can also be built as a module.  If so, the module
 	  will be called da9055_wdt.
 
+config GPIO_WATCHDOG
+	tristate "Watchdog device controlled through GPIO-line"
+	depends on OF_GPIO
+	select WATCHDOG_CORE
+	help
+	  If you say yes here you get support for watchdog device
+	  controlled through GPIO-line.
+
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
@@ -109,7 +117,7 @@ config WM8350_WATCHDOG
 
 config ARM_SP805_WATCHDOG
 	tristate "ARM SP805 Watchdog"
-	depends on ARM && ARM_AMBA
+	depends on (ARM || ARM64) && ARM_AMBA
 	select WATCHDOG_CORE
 	help
 	  ARM Primecell SP805 Watchdog timer. This will reboot your system when
@@ -188,6 +196,7 @@ config S3C2410_WATCHDOG
 	tristate "S3C2410 Watchdog"
 	depends on HAVE_S3C2410_WATCHDOG
 	select WATCHDOG_CORE
+	select MFD_SYSCON if ARCH_EXYNOS5
 	help
 	  Watchdog timer block in the Samsung SoCs. This will reboot
 	  the system when the timer expires with the watchdog enabled.
@@ -214,10 +223,9 @@ config SA1100_WATCHDOG
 
 config DW_WATCHDOG
 	tristate "Synopsys DesignWare watchdog"
-	depends on ARM && HAVE_CLK
 	help
 	  Say Y here if to include support for the Synopsys DesignWare
-	  watchdog timer found in many ARM chips.
+	  watchdog timer found in many chips.
 	  To compile this driver as a module, choose M here: the
 	  module will be called dw_wdt.
 
@@ -270,10 +278,11 @@ config IOP_WATCHDOG
 
 config DAVINCI_WATCHDOG
 	tristate "DaVinci watchdog"
-	depends on ARCH_DAVINCI
+	depends on ARCH_DAVINCI || ARCH_KEYSTONE
+	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
-	  in the DaVinci DM644x/DM646x processors.
+	  in the DaVinci DM644x/DM646x or Keystone processors.
 	  To compile this driver as a module, choose M here: the
 	  module will be called davinci_wdt.
 
@@ -883,13 +892,22 @@ config VIA_WDT
 	Most people will say N.
 
 config W83627HF_WDT
-	tristate "W83627HF/W83627DHG Watchdog Timer"
+	tristate "Watchdog timer for W83627HF/W83627DHG and compatibles"
 	depends on X86
 	select WATCHDOG_CORE
 	---help---
-	  This is the driver for the hardware watchdog on the W83627HF chipset
-	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
-	  (and likely others). The driver also supports the W83627DHG chip.
+	  This is the driver for the hardware watchdog on the following
+	  Super I/O chips.
+		W83627DHG/DHG-P/EHF/EHG/F/G/HF/S/SF/THF/UHG/UG
+		W83637HF
+		W83667HG/HG-B
+		W83687THF
+		W83697HF
+		W83697UG
+		NCT6775
+		NCT6776
+		NCT6779
+
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
 	  amount of time.
@@ -1139,6 +1157,28 @@ config BCM2835_WDT
 	  To compile this driver as a loadable module, choose M here.
 	  The module will be called bcm2835_wdt.
 
+config BCM_KONA_WDT
+	tristate "BCM Kona Watchdog"
+	depends on ARCH_BCM
+	select WATCHDOG_CORE
+	help
+	  Support for the watchdog timer on the following Broadcom BCM281xx
+	  family, which includes BCM11130, BCM11140, BCM11351, BCM28145 and
+	  BCM28155 variants.
+
+	  Say 'Y' or 'M' here to enable the driver. The module will be called
+	  bcm_kona_wdt.
+
+config BCM_KONA_WDT_DEBUG
+	bool "DEBUGFS support for BCM Kona Watchdog"
+	depends on BCM_KONA_WDT
+	help
+	  If enabled, adds /sys/kernel/debug/bcm_kona_wdt/info which provides
+	  access to the driver's internal data structures as well as watchdog
+	  timer hardware registres.
+
+	  If in doubt, say 'N'.
+
 config LANTIQ_WDT
 	tristate "Lantiq SoC watchdog"
 	depends on LANTIQ
@@ -1171,6 +1211,7 @@ config MPC5200_WDT
 config 8xxx_WDT
 	tristate "MPC8xxx Platform Watchdog Timer"
 	depends on PPC_8xx || PPC_83xx || PPC_86xx
+	select WATCHDOG_CORE
 	help
 	  This driver is for a SoC level watchdog that exists on some
 	  Freescale PowerPC processors. So far this driver supports:
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 91bd95a..985a66c 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
 obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
+obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
@@ -171,6 +172,7 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 # Architecture Independent
 obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_DA9055_WATCHDOG) += da9055_wdt.o
+obj-$(CONFIG_GPIO_WATCHDOG)	+= gpio_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index fbb7b94..3a17fbd 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -301,7 +301,7 @@ static int ali_notify_sys(struct notifier_block *this,
  *	want to register another driver on the same PCI id.
  */
 
-static DEFINE_PCI_DEVICE_TABLE(ali_pci_tbl) __used = {
+static const struct pci_device_id ali_pci_tbl[] __used = {
 	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 12f0b76..996b2f7 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -414,7 +414,7 @@ err_out:
 module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
-static DEFINE_PCI_DEVICE_TABLE(alim7101_pci_tbl) __used = {
+static const struct pci_device_id alim7101_pci_tbl[] __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index be37dde..489729b 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -19,11 +19,13 @@
 
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 #include <linux/jiffies.h>
@@ -31,22 +33,33 @@
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 
 #include "at91sam9_wdt.h"
 
 #define DRV_NAME "AT91SAM9 Watchdog"
 
-#define wdt_read(field) \
-	__raw_readl(at91wdt_private.base + field)
-#define wdt_write(field, val) \
-	__raw_writel((val), at91wdt_private.base + field)
+#define wdt_read(wdt, field) \
+	__raw_readl((wdt)->base + (field))
+#define wdt_write(wtd, field, val) \
+	__raw_writel((val), (wdt)->base + (field))
 
 /* AT91SAM9 watchdog runs a 12bit counter @ 256Hz,
  * use this to convert a watchdog
  * value from/to milliseconds.
  */
-#define ms_to_ticks(t)	(((t << 8) / 1000) - 1)
-#define ticks_to_ms(t)	(((t + 1) * 1000) >> 8)
+#define ticks_to_hz_rounddown(t)	((((t) + 1) * HZ) >> 8)
+#define ticks_to_hz_roundup(t)		(((((t) + 1) * HZ) + 255) >> 8)
+#define ticks_to_secs(t)		(((t) + 1) >> 8)
+#define secs_to_ticks(s)		((s) ? (((s) << 8) - 1) : 0)
+
+#define WDT_MR_RESET	0x3FFF2FFF
+
+/* Watchdog max counter value in ticks */
+#define WDT_COUNTER_MAX_TICKS	0xFFF
+
+/* Watchdog max delta/value in secs */
+#define WDT_COUNTER_MAX_SECS	ticks_to_secs(WDT_COUNTER_MAX_TICKS)
 
 /* Hardware timeout in seconds */
 #define WDT_HW_TIMEOUT 2
@@ -66,23 +79,40 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static struct watchdog_device at91_wdt_dev;
-static void at91_ping(unsigned long data);
-
-static struct {
+#define to_wdt(wdd) container_of(wdd, struct at91wdt, wdd)
+struct at91wdt {
+	struct watchdog_device wdd;
 	void __iomem *base;
 	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
 	struct timer_list timer;	/* The timer that pings the watchdog */
-} at91wdt_private;
+	u32 mr;
+	u32 mr_mask;
+	unsigned long heartbeat;	/* WDT heartbeat in jiffies */
+	bool nowayout;
+	unsigned int irq;
+};
 
 /* ......................................................................... */
 
+static irqreturn_t wdt_interrupt(int irq, void *dev_id)
+{
+	struct at91wdt *wdt = (struct at91wdt *)dev_id;
+
+	if (wdt_read(wdt, AT91_WDT_SR)) {
+		pr_crit("at91sam9 WDT software reset\n");
+		emergency_restart();
+		pr_crit("Reboot didn't ?????\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static inline void at91_wdt_reset(void)
+static inline void at91_wdt_reset(struct at91wdt *wdt)
 {
-	wdt_write(AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
+	wdt_write(wdt, AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
 }
 
 /*
@@ -90,26 +120,21 @@ static inline void at91_wdt_reset(void)
  */
 static void at91_ping(unsigned long data)
 {
-	if (time_before(jiffies, at91wdt_private.next_heartbeat) ||
-	    (!watchdog_active(&at91_wdt_dev))) {
-		at91_wdt_reset();
-		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
-	} else
+	struct at91wdt *wdt = (struct at91wdt *)data;
+	if (time_before(jiffies, wdt->next_heartbeat) ||
+	    !watchdog_active(&wdt->wdd)) {
+		at91_wdt_reset(wdt);
+		mod_timer(&wdt->timer, jiffies + wdt->heartbeat);
+	} else {
 		pr_crit("I will reset your machine !\n");
-}
-
-static int at91_wdt_ping(struct watchdog_device *wdd)
-{
-	/* calculate when the next userspace timeout will be */
-	at91wdt_private.next_heartbeat = jiffies + wdd->timeout * HZ;
-	return 0;
+	}
 }
 
 static int at91_wdt_start(struct watchdog_device *wdd)
 {
-	/* calculate the next userspace timeout and modify the timer */
-	at91_wdt_ping(wdd);
-	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
+	struct at91wdt *wdt = to_wdt(wdd);
+	/* calculate when the next userspace timeout will be */
+	wdt->next_heartbeat = jiffies + wdd->timeout * HZ;
 	return 0;
 }
 
@@ -122,39 +147,104 @@ static int at91_wdt_stop(struct watchdog_device *wdd)
 static int at91_wdt_set_timeout(struct watchdog_device *wdd, unsigned int new_timeout)
 {
 	wdd->timeout = new_timeout;
-	return 0;
+	return at91_wdt_start(wdd);
 }
 
-/*
- * Set the watchdog time interval in 1/256Hz (write-once)
- * Counter is 12 bit.
- */
-static int at91_wdt_settimeout(unsigned int timeout)
+static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 {
-	unsigned int reg;
-	unsigned int mr;
-
-	/* Check if disabled */
-	mr = wdt_read(AT91_WDT_MR);
-	if (mr & AT91_WDT_WDDIS) {
-		pr_err("sorry, watchdog is disabled\n");
-		return -EIO;
+	u32 tmp;
+	u32 delta;
+	u32 value;
+	int err;
+	u32 mask = wdt->mr_mask;
+	unsigned long min_heartbeat = 1;
+	unsigned long max_heartbeat;
+	struct device *dev = &pdev->dev;
+
+	tmp = wdt_read(wdt, AT91_WDT_MR);
+	if ((tmp & mask) != (wdt->mr & mask)) {
+		if (tmp == WDT_MR_RESET) {
+			wdt_write(wdt, AT91_WDT_MR, wdt->mr);
+			tmp = wdt_read(wdt, AT91_WDT_MR);
+		}
+	}
+
+	if (tmp & AT91_WDT_WDDIS) {
+		if (wdt->mr & AT91_WDT_WDDIS)
+			return 0;
+		dev_err(dev, "watchdog is disabled\n");
+		return -EINVAL;
+	}
+
+	value = tmp & AT91_WDT_WDV;
+	delta = (tmp & AT91_WDT_WDD) >> 16;
+
+	if (delta < value)
+		min_heartbeat = ticks_to_hz_roundup(value - delta);
+
+	max_heartbeat = ticks_to_hz_rounddown(value);
+	if (!max_heartbeat) {
+		dev_err(dev,
+			"heartbeat is too small for the system to handle it correctly\n");
+		return -EINVAL;
 	}
 
 	/*
-	 * All counting occurs at SLOW_CLOCK / 128 = 256 Hz
-	 *
-	 * Since WDV is a 12-bit counter, the maximum period is
-	 * 4096 / 256 = 16 seconds.
+	 * Try to reset the watchdog counter 4 or 2 times more often than
+	 * actually requested, to avoid spurious watchdog reset.
+	 * If this is not possible because of the min_heartbeat value, reset
+	 * it at the min_heartbeat period.
 	 */
-	reg = AT91_WDT_WDRSTEN	/* causes watchdog reset */
-		/* | AT91_WDT_WDRPROC	causes processor reset only */
-		| AT91_WDT_WDDBGHLT	/* disabled in debug mode */
-		| AT91_WDT_WDD		/* restart at any time */
-		| (timeout & AT91_WDT_WDV);  /* timer value */
-	wdt_write(AT91_WDT_MR, reg);
+	if ((max_heartbeat / 4) >= min_heartbeat)
+		wdt->heartbeat = max_heartbeat / 4;
+	else if ((max_heartbeat / 2) >= min_heartbeat)
+		wdt->heartbeat = max_heartbeat / 2;
+	else
+		wdt->heartbeat = min_heartbeat;
+
+	if (max_heartbeat < min_heartbeat + 4)
+		dev_warn(dev,
+			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
+
+	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
+		err = request_irq(wdt->irq, wdt_interrupt,
+				  IRQF_SHARED | IRQF_IRQPOLL,
+				  pdev->name, wdt);
+		if (err)
+			return err;
+	}
+
+	if ((tmp & wdt->mr_mask) != (wdt->mr & wdt->mr_mask))
+		dev_warn(dev,
+			 "watchdog already configured differently (mr = %x expecting %x)\n",
+			 tmp & wdt->mr_mask, wdt->mr & wdt->mr_mask);
+
+	setup_timer(&wdt->timer, at91_ping, (unsigned long)wdt);
+
+	/*
+	 * Use min_heartbeat the first time to avoid spurious watchdog reset:
+	 * we don't know for how long the watchdog counter is running, and
+	 *  - resetting it right now might trigger a watchdog fault reset
+	 *  - waiting for heartbeat time might lead to a watchdog timeout
+	 *    reset
+	 */
+	mod_timer(&wdt->timer, jiffies + min_heartbeat);
+
+	/* Try to set timeout from device tree first */
+	if (watchdog_init_timeout(&wdt->wdd, 0, dev))
+		watchdog_init_timeout(&wdt->wdd, heartbeat, dev);
+	watchdog_set_nowayout(&wdt->wdd, wdt->nowayout);
+	err = watchdog_register_device(&wdt->wdd);
+	if (err)
+		goto out_stop_timer;
+
+	wdt->next_heartbeat = jiffies + wdt->wdd.timeout * HZ;
 
 	return 0;
+
+out_stop_timer:
+	del_timer(&wdt->timer);
+	return err;
 }
 
 /* ......................................................................... */
@@ -169,61 +259,123 @@ static const struct watchdog_ops at91_wdt_ops = {
 	.owner =	THIS_MODULE,
 	.start =	at91_wdt_start,
 	.stop =		at91_wdt_stop,
-	.ping =		at91_wdt_ping,
 	.set_timeout =	at91_wdt_set_timeout,
 };
 
-static struct watchdog_device at91_wdt_dev = {
-	.info =		&at91_wdt_info,
-	.ops =		&at91_wdt_ops,
-	.timeout =	WDT_HEARTBEAT,
-	.min_timeout =	1,
-	.max_timeout =	0xFFFF,
-};
+#if defined(CONFIG_OF)
+static int of_at91wdt_init(struct device_node *np, struct at91wdt *wdt)
+{
+	u32 min = 0;
+	u32 max = WDT_COUNTER_MAX_SECS;
+	const char *tmp;
+
+	/* Get the interrupts property */
+	wdt->irq = irq_of_parse_and_map(np, 0);
+	if (!wdt->irq)
+		dev_warn(wdt->wdd.parent, "failed to get IRQ from DT\n");
+
+	if (!of_property_read_u32_index(np, "atmel,max-heartbeat-sec", 0,
+					&max)) {
+		if (!max || max > WDT_COUNTER_MAX_SECS)
+			max = WDT_COUNTER_MAX_SECS;
+
+		if (!of_property_read_u32_index(np, "atmel,min-heartbeat-sec",
+						0, &min)) {
+			if (min >= max)
+				min = max - 1;
+		}
+	}
+
+	min = secs_to_ticks(min);
+	max = secs_to_ticks(max);
+
+	wdt->mr_mask = 0x3FFFFFFF;
+	wdt->mr = 0;
+	if (!of_property_read_string(np, "atmel,watchdog-type", &tmp) &&
+	    !strcmp(tmp, "software")) {
+		wdt->mr |= AT91_WDT_WDFIEN;
+		wdt->mr_mask &= ~AT91_WDT_WDRPROC;
+	} else {
+		wdt->mr |= AT91_WDT_WDRSTEN;
+	}
+
+	if (!of_property_read_string(np, "atmel,reset-type", &tmp) &&
+	    !strcmp(tmp, "proc"))
+		wdt->mr |= AT91_WDT_WDRPROC;
+
+	if (of_property_read_bool(np, "atmel,disable")) {
+		wdt->mr |= AT91_WDT_WDDIS;
+		wdt->mr_mask &= AT91_WDT_WDDIS;
+	}
+
+	if (of_property_read_bool(np, "atmel,idle-halt"))
+		wdt->mr |= AT91_WDT_WDIDLEHLT;
+
+	if (of_property_read_bool(np, "atmel,dbg-halt"))
+		wdt->mr |= AT91_WDT_WDDBGHLT;
+
+	wdt->mr |= max | ((max - min) << 16);
+
+	return 0;
+}
+#else
+static inline int of_at91wdt_init(struct device_node *np, struct at91wdt *wdt)
+{
+	return 0;
+}
+#endif
 
 static int __init at91wdt_probe(struct platform_device *pdev)
 {
 	struct resource	*r;
-	int res;
+	int err;
+	struct at91wdt *wdt;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r)
-		return -ENODEV;
-	at91wdt_private.base = ioremap(r->start, resource_size(r));
-	if (!at91wdt_private.base) {
-		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
 		return -ENOMEM;
-	}
 
-	at91_wdt_dev.parent = &pdev->dev;
-	watchdog_init_timeout(&at91_wdt_dev, heartbeat, &pdev->dev);
-	watchdog_set_nowayout(&at91_wdt_dev, nowayout);
+	wdt->mr = (WDT_HW_TIMEOUT * 256) | AT91_WDT_WDRSTEN | AT91_WDT_WDD |
+		  AT91_WDT_WDDBGHLT | AT91_WDT_WDIDLEHLT;
+	wdt->mr_mask = 0x3FFFFFFF;
+	wdt->nowayout = nowayout;
+	wdt->wdd.parent = &pdev->dev;
+	wdt->wdd.info = &at91_wdt_info;
+	wdt->wdd.ops = &at91_wdt_ops;
+	wdt->wdd.timeout = WDT_HEARTBEAT;
+	wdt->wdd.min_timeout = 1;
+	wdt->wdd.max_timeout = 0xFFFF;
 
-	/* Set watchdog */
-	res = at91_wdt_settimeout(ms_to_ticks(WDT_HW_TIMEOUT * 1000));
-	if (res)
-		return res;
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdt->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(wdt->base))
+		return PTR_ERR(wdt->base);
+
+	if (pdev->dev.of_node) {
+		err = of_at91wdt_init(pdev->dev.of_node, wdt);
+		if (err)
+			return err;
+	}
 
-	res = watchdog_register_device(&at91_wdt_dev);
-	if (res)
-		return res;
+	err = at91_wdt_init(pdev, wdt);
+	if (err)
+		return err;
 
-	at91wdt_private.next_heartbeat = jiffies + at91_wdt_dev.timeout * HZ;
-	setup_timer(&at91wdt_private.timer, at91_ping, 0);
-	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
+	platform_set_drvdata(pdev, wdt);
 
 	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
-		at91_wdt_dev.timeout, nowayout);
+		wdt->wdd.timeout, wdt->nowayout);
 
 	return 0;
 }
 
 static int __exit at91wdt_remove(struct platform_device *pdev)
 {
-	watchdog_unregister_device(&at91_wdt_dev);
+	struct at91wdt *wdt = platform_get_drvdata(pdev);
+	watchdog_unregister_device(&wdt->wdd);
 
 	pr_warn("I quit now, hardware will probably reboot!\n");
-	del_timer(&at91wdt_private.timer);
+	del_timer(&wdt->timer);
 
 	return 0;
 }
diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
new file mode 100644
index 0000000..9c24809
--- /dev/null
+++ b/drivers/watchdog/bcm_kona_wdt.c
@@ -0,0 +1,368 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#define SECWDOG_CTRL_REG		0x00000000
+#define SECWDOG_COUNT_REG		0x00000004
+
+#define SECWDOG_RESERVED_MASK		0x1dffffff
+#define SECWDOG_WD_LOAD_FLAG		0x10000000
+#define SECWDOG_EN_MASK			0x08000000
+#define SECWDOG_SRSTEN_MASK		0x04000000
+#define SECWDOG_RES_MASK		0x00f00000
+#define SECWDOG_COUNT_MASK		0x000fffff
+
+#define SECWDOG_MAX_COUNT		SECWDOG_COUNT_MASK
+#define SECWDOG_CLKS_SHIFT		20
+#define SECWDOG_MAX_RES			15
+#define SECWDOG_DEFAULT_RESOLUTION	4
+#define SECWDOG_MAX_TRY			1000
+
+#define SECS_TO_TICKS(x, w)		((x) << (w)->resolution)
+#define TICKS_TO_SECS(x, w)		((x) >> (w)->resolution)
+
+#define BCM_KONA_WDT_NAME		"bcm_kona_wdt"
+
+struct bcm_kona_wdt {
+	void __iomem *base;
+	/*
+	 * One watchdog tick is 1/(2^resolution) seconds. Resolution can take
+	 * the values 0-15, meaning one tick can be 1s to 30.52us. Our default
+	 * resolution of 4 means one tick is 62.5ms.
+	 *
+	 * The watchdog counter is 20 bits. Depending on resolution, the maximum
+	 * counter value of 0xfffff expires after about 12 days (resolution 0)
+	 * down to only 32s (resolution 15). The default resolution of 4 gives
+	 * us a maximum of about 18 hours and 12 minutes before the watchdog
+	 * times out.
+	 */
+	int resolution;
+	spinlock_t lock;
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	unsigned long busy_count;
+	struct dentry *debugfs;
+#endif
+};
+
+static int secure_register_read(struct bcm_kona_wdt *wdt, uint32_t offset)
+{
+	uint32_t val;
+	unsigned count = 0;
+
+	/*
+	 * If the WD_LOAD_FLAG is set, the watchdog counter field is being
+	 * updated in hardware. Once the WD timer is updated in hardware, it
+	 * gets cleared.
+	 */
+	do {
+		if (unlikely(count > 1))
+			udelay(5);
+		val = readl_relaxed(wdt->base + offset);
+		count++;
+	} while ((val & SECWDOG_WD_LOAD_FLAG) && count < SECWDOG_MAX_TRY);
+
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+	/* Remember the maximum number iterations due to WD_LOAD_FLAG */
+	if (count > wdt->busy_count)
+		wdt->busy_count = count;
+#endif
+
+	/* This is the only place we return a negative value. */
+	if (val & SECWDOG_WD_LOAD_FLAG)
+		return -ETIMEDOUT;
+
+	/* We always mask out reserved bits. */
+	val &= SECWDOG_RESERVED_MASK;
+
+	return val;
+}
+
+#ifdef CONFIG_BCM_KONA_WDT_DEBUG
+
+static int bcm_kona_wdt_dbg_show(struct seq_file *s, void *data)
+{
+	int ctl_val, cur_val, ret;
+	unsigned long flags;
+	struct bcm_kona_wdt *wdt = s->private;
+
+	if (!wdt)
+		return seq_puts(s, "No device pointer\n");
+
+	spin_lock_irqsave(&wdt->lock, flags);
+	ctl_val = secure_register_read(wdt, SECWDOG_CTRL_REG);
+	cur_val = secure_register_read(wdt, SECWDOG_COUNT_REG);
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	if (ctl_val < 0 || cur_val < 0) {
+		ret = seq_puts(s, "Error accessing hardware\n");
+	} else {
+		int ctl, cur, ctl_sec, cur_sec, res;
+
+		ctl = ctl_val & SECWDOG_COUNT_MASK;
+		res = (ctl_val & SECWDOG_RES_MASK) >> SECWDOG_CLKS_SHIFT;
+		cur = cur_val & SECWDOG_COUNT_MASK;
+		ctl_sec = TICKS_TO_SECS(ctl, wdt);
+		cur_sec = TICKS_TO_SECS(cur, wdt);
+		ret = seq_printf(s, "Resolution: %d / %d\n"
+				"Control: %d s / %d (%#x) ticks\n"
+				"Current: %d s / %d (%#x) ticks\n"
+				"Busy count: %lu\n", res,
+				wdt->resolution, ctl_sec, ctl, ctl, cur_sec,
+				cur, cur, wdt->busy_count);
+	}
+
+	return ret;
+}
+
+static int bcm_kona_dbg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, bcm_kona_wdt_dbg_show, inode->i_private);
+}
+
+static const struct file_operations bcm_kona_dbg_operations = {
+	.open		= bcm_kona_dbg_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void bcm_kona_wdt_debug_init(struct platform_device *pdev)
+{
+	struct dentry *dir;
+	struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
+
+	if (!wdt)
+		return;
+
+	wdt->debugfs = NULL;
+
+	dir = debugfs_create_dir(BCM_KONA_WDT_NAME, NULL);
+	if (IS_ERR_OR_NULL(dir))
+		return;
+
+	if (debugfs_create_file("info", S_IFREG | S_IRUGO, dir, wdt,
+				&bcm_kona_dbg_operations))
+		wdt->debugfs = dir;
+	else
+		debugfs_remove_recursive(dir);
+}
+
+static void bcm_kona_wdt_debug_exit(struct platform_device *pdev)
+{
+	struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
+
+	if (wdt && wdt->debugfs) {
+		debugfs_remove_recursive(wdt->debugfs);
+		wdt->debugfs = NULL;
+	}
+}
+
+#else
+
+static void bcm_kona_wdt_debug_init(struct platform_device *pdev) {}
+static void bcm_kona_wdt_debug_exit(struct platform_device *pdev) {}
+
+#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
+
+static int bcm_kona_wdt_ctrl_reg_modify(struct bcm_kona_wdt *wdt,
+					unsigned mask, unsigned newval)
+{
+	int val;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+
+	val = secure_register_read(wdt, SECWDOG_CTRL_REG);
+	if (val < 0) {
+		ret = val;
+	} else {
+		val &= ~mask;
+		val |= newval;
+		writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
+	}
+
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	return ret;
+}
+
+static int bcm_kona_wdt_set_resolution_reg(struct bcm_kona_wdt *wdt)
+{
+	if (wdt->resolution > SECWDOG_MAX_RES)
+		return -EINVAL;
+
+	return bcm_kona_wdt_ctrl_reg_modify(wdt, SECWDOG_RES_MASK,
+					wdt->resolution << SECWDOG_CLKS_SHIFT);
+}
+
+static int bcm_kona_wdt_set_timeout_reg(struct watchdog_device *wdog,
+					unsigned watchdog_flags)
+{
+	struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
+
+	return bcm_kona_wdt_ctrl_reg_modify(wdt, SECWDOG_COUNT_MASK,
+					SECS_TO_TICKS(wdog->timeout, wdt) |
+					watchdog_flags);
+}
+
+static int bcm_kona_wdt_set_timeout(struct watchdog_device *wdog,
+	unsigned int t)
+{
+	wdog->timeout = t;
+	return 0;
+}
+
+static unsigned int bcm_kona_wdt_get_timeleft(struct watchdog_device *wdog)
+{
+	struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
+	int val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+	val = secure_register_read(wdt, SECWDOG_COUNT_REG);
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	if (val < 0)
+		return val;
+
+	return TICKS_TO_SECS(val & SECWDOG_COUNT_MASK, wdt);
+}
+
+static int bcm_kona_wdt_start(struct watchdog_device *wdog)
+{
+	return bcm_kona_wdt_set_timeout_reg(wdog,
+					SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK);
+}
+
+static int bcm_kona_wdt_stop(struct watchdog_device *wdog)
+{
+	struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
+
+	return bcm_kona_wdt_ctrl_reg_modify(wdt, SECWDOG_EN_MASK |
+					    SECWDOG_SRSTEN_MASK, 0);
+}
+
+static struct watchdog_ops bcm_kona_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	bcm_kona_wdt_start,
+	.stop =		bcm_kona_wdt_stop,
+	.set_timeout =	bcm_kona_wdt_set_timeout,
+	.get_timeleft =	bcm_kona_wdt_get_timeleft,
+};
+
+static struct watchdog_info bcm_kona_wdt_info = {
+	.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+	.identity =	"Broadcom Kona Watchdog Timer",
+};
+
+static struct watchdog_device bcm_kona_wdt_wdd = {
+	.info =		&bcm_kona_wdt_info,
+	.ops =		&bcm_kona_wdt_ops,
+	.min_timeout =	1,
+	.max_timeout =	SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
+	.timeout =	SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
+};
+
+static void bcm_kona_wdt_shutdown(struct platform_device *pdev)
+{
+	bcm_kona_wdt_stop(&bcm_kona_wdt_wdd);
+}
+
+static int bcm_kona_wdt_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct bcm_kona_wdt *wdt;
+	struct resource *res;
+	int ret;
+
+	wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdt->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(wdt->base))
+		return -ENODEV;
+
+	wdt->resolution = SECWDOG_DEFAULT_RESOLUTION;
+	ret = bcm_kona_wdt_set_resolution_reg(wdt);
+	if (ret) {
+		dev_err(dev, "Failed to set resolution (error: %d)", ret);
+		return ret;
+	}
+
+	spin_lock_init(&wdt->lock);
+	platform_set_drvdata(pdev, wdt);
+	watchdog_set_drvdata(&bcm_kona_wdt_wdd, wdt);
+
+	ret = bcm_kona_wdt_set_timeout_reg(&bcm_kona_wdt_wdd, 0);
+	if (ret) {
+		dev_err(dev, "Failed set watchdog timeout");
+		return ret;
+	}
+
+	ret = watchdog_register_device(&bcm_kona_wdt_wdd);
+	if (ret) {
+		dev_err(dev, "Failed to register watchdog device");
+		return ret;
+	}
+
+	bcm_kona_wdt_debug_init(pdev);
+	dev_dbg(dev, "Broadcom Kona Watchdog Timer");
+
+	return 0;
+}
+
+static int bcm_kona_wdt_remove(struct platform_device *pdev)
+{
+	bcm_kona_wdt_debug_exit(pdev);
+	bcm_kona_wdt_shutdown(pdev);
+	watchdog_unregister_device(&bcm_kona_wdt_wdd);
+	dev_dbg(&pdev->dev, "Watchdog driver disabled");
+
+	return 0;
+}
+
+static const struct of_device_id bcm_kona_wdt_of_match[] = {
+	{ .compatible = "brcm,kona-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm_kona_wdt_of_match);
+
+static struct platform_driver bcm_kona_wdt_driver = {
+	.driver = {
+			.name = BCM_KONA_WDT_NAME,
+			.owner = THIS_MODULE,
+			.of_match_table = bcm_kona_wdt_of_match,
+		  },
+	.probe = bcm_kona_wdt_probe,
+	.remove = bcm_kona_wdt_remove,
+	.shutdown = bcm_kona_wdt_shutdown,
+};
+
+module_platform_driver(bcm_kona_wdt_driver);
+
+MODULE_ALIAS("platform:" BCM_KONA_WDT_NAME);
+MODULE_AUTHOR("Markus Mayer <mmayer@broadcom.com>");
+MODULE_DESCRIPTION("Broadcom Kona Watchdog Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 12591f6..b1bae03 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -3,7 +3,7 @@
  *
  * Watchdog driver for DaVinci DM644x/DM646x processors
  *
- * Copyright (C) 2006 Texas Instruments.
+ * Copyright (C) 2006-2013 Texas Instruments.
  *
  * 2007 (c) MontaVista Software, Inc. This file is licensed under
  * the terms of the GNU General Public License version 2. This program
@@ -15,18 +15,12 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
-#include <linux/bitops.h>
 #include <linux/platform_device.h>
-#include <linux/spinlock.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/device.h>
 #include <linux/clk.h>
-#include <linux/slab.h>
 #include <linux/err.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
@@ -61,142 +55,103 @@
 #define WDKEY_SEQ0		(0xa5c6 << 16)
 #define WDKEY_SEQ1		(0xda7e << 16)
 
-static int heartbeat = DEFAULT_HEARTBEAT;
+static int heartbeat;
 
-static DEFINE_SPINLOCK(io_lock);
-static unsigned long wdt_status;
-#define WDT_IN_USE        0
-#define WDT_OK_TO_CLOSE   1
-#define WDT_REGION_INITED 2
-#define WDT_DEVICE_INITED 3
-
-static void __iomem	*wdt_base;
-struct clk		*wdt_clk;
-
-static void wdt_service(void)
-{
-	spin_lock(&io_lock);
-
-	/* put watchdog in service state */
-	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
-	/* put watchdog in active state */
-	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
-
-	spin_unlock(&io_lock);
-}
+/*
+ * struct to hold data for each WDT device
+ * @base - base io address of WD device
+ * @clk - source clock of WDT
+ * @wdd - hold watchdog device as is in WDT core
+ */
+struct davinci_wdt_device {
+	void __iomem		*base;
+	struct clk		*clk;
+	struct watchdog_device	wdd;
+};
 
-static void wdt_enable(void)
+static int davinci_wdt_start(struct watchdog_device *wdd)
 {
 	u32 tgcr;
 	u32 timer_margin;
 	unsigned long wdt_freq;
+	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
 
-	wdt_freq = clk_get_rate(wdt_clk);
-
-	spin_lock(&io_lock);
+	wdt_freq = clk_get_rate(davinci_wdt->clk);
 
 	/* disable, internal clock source */
-	iowrite32(0, wdt_base + TCR);
+	iowrite32(0, davinci_wdt->base + TCR);
 	/* reset timer, set mode to 64-bit watchdog, and unreset */
-	iowrite32(0, wdt_base + TGCR);
+	iowrite32(0, davinci_wdt->base + TGCR);
 	tgcr = TIMMODE_64BIT_WDOG | TIM12RS_UNRESET | TIM34RS_UNRESET;
-	iowrite32(tgcr, wdt_base + TGCR);
+	iowrite32(tgcr, davinci_wdt->base + TGCR);
 	/* clear counter regs */
-	iowrite32(0, wdt_base + TIM12);
-	iowrite32(0, wdt_base + TIM34);
+	iowrite32(0, davinci_wdt->base + TIM12);
+	iowrite32(0, davinci_wdt->base + TIM34);
 	/* set timeout period */
-	timer_margin = (((u64)heartbeat * wdt_freq) & 0xffffffff);
-	iowrite32(timer_margin, wdt_base + PRD12);
-	timer_margin = (((u64)heartbeat * wdt_freq) >> 32);
-	iowrite32(timer_margin, wdt_base + PRD34);
+	timer_margin = (((u64)wdd->timeout * wdt_freq) & 0xffffffff);
+	iowrite32(timer_margin, davinci_wdt->base + PRD12);
+	timer_margin = (((u64)wdd->timeout * wdt_freq) >> 32);
+	iowrite32(timer_margin, davinci_wdt->base + PRD34);
 	/* enable run continuously */
-	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
+	iowrite32(ENAMODE12_PERIODIC, davinci_wdt->base + TCR);
 	/* Once the WDT is in pre-active state write to
 	 * TIM12, TIM34, PRD12, PRD34, TCR, TGCR, WDTCR are
 	 * write protected (except for the WDKEY field)
 	 */
 	/* put watchdog in pre-active state */
-	iowrite32(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ0 | WDEN, davinci_wdt->base + WDTCR);
 	/* put watchdog in active state */
-	iowrite32(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
-
-	spin_unlock(&io_lock);
+	iowrite32(WDKEY_SEQ1 | WDEN, davinci_wdt->base + WDTCR);
+	return 0;
 }
 
-static int davinci_wdt_open(struct inode *inode, struct file *file)
+static int davinci_wdt_ping(struct watchdog_device *wdd)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	wdt_enable();
+	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
 
-	return nonseekable_open(inode, file);
+	/* put watchdog in service state */
+	iowrite32(WDKEY_SEQ0, davinci_wdt->base + WDTCR);
+	/* put watchdog in active state */
+	iowrite32(WDKEY_SEQ1, davinci_wdt->base + WDTCR);
+	return 0;
 }
 
-static ssize_t
-davinci_wdt_write(struct file *file, const char *data, size_t len,
-		  loff_t *ppos)
+static unsigned int davinci_wdt_get_timeleft(struct watchdog_device *wdd)
 {
-	if (len)
-		wdt_service();
+	u64 timer_counter;
+	unsigned long freq;
+	u32 val;
+	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
 
-	return len;
-}
+	/* if timeout has occured then return 0 */
+	val = ioread32(davinci_wdt->base + WDTCR);
+	if (val & WDFLAG)
+		return 0;
 
-static const struct watchdog_info ident = {
-	.options = WDIOF_KEEPALIVEPING,
-	.identity = "DaVinci Watchdog",
-};
+	freq = clk_get_rate(davinci_wdt->clk);
 
-static long davinci_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	int ret = -ENOTTY;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info *)arg, &ident,
-				   sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_service();
-		ret = 0;
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-	}
-	return ret;
-}
+	if (!freq)
+		return 0;
 
-static int davinci_wdt_release(struct inode *inode, struct file *file)
-{
-	wdt_service();
-	clear_bit(WDT_IN_USE, &wdt_status);
+	timer_counter = ioread32(davinci_wdt->base + TIM12);
+	timer_counter |= ((u64)ioread32(davinci_wdt->base + TIM34) << 32);
 
-	return 0;
+	do_div(timer_counter, freq);
+
+	return wdd->timeout - timer_counter;
 }
 
-static const struct file_operations davinci_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = davinci_wdt_write,
-	.unlocked_ioctl = davinci_wdt_ioctl,
-	.open = davinci_wdt_open,
-	.release = davinci_wdt_release,
+static const struct watchdog_info davinci_wdt_info = {
+	.options = WDIOF_KEEPALIVEPING,
+	.identity = "DaVinci/Keystone Watchdog",
 };
 
-static struct miscdevice davinci_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &davinci_wdt_fops,
+static const struct watchdog_ops davinci_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= davinci_wdt_start,
+	.stop		= davinci_wdt_ping,
+	.ping		= davinci_wdt_ping,
+	.get_timeleft	= davinci_wdt_get_timeleft,
 };
 
 static int davinci_wdt_probe(struct platform_device *pdev)
@@ -204,37 +159,53 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct device *dev = &pdev->dev;
 	struct resource  *wdt_mem;
+	struct watchdog_device *wdd;
+	struct davinci_wdt_device *davinci_wdt;
+
+	davinci_wdt = devm_kzalloc(dev, sizeof(*davinci_wdt), GFP_KERNEL);
+	if (!davinci_wdt)
+		return -ENOMEM;
 
-	wdt_clk = devm_clk_get(dev, NULL);
-	if (WARN_ON(IS_ERR(wdt_clk)))
-		return PTR_ERR(wdt_clk);
+	davinci_wdt->clk = devm_clk_get(dev, NULL);
+	if (WARN_ON(IS_ERR(davinci_wdt->clk)))
+		return PTR_ERR(davinci_wdt->clk);
 
-	clk_prepare_enable(wdt_clk);
+	clk_prepare_enable(davinci_wdt->clk);
 
-	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
-		heartbeat = DEFAULT_HEARTBEAT;
+	platform_set_drvdata(pdev, davinci_wdt);
 
-	dev_info(dev, "heartbeat %d sec\n", heartbeat);
+	wdd			= &davinci_wdt->wdd;
+	wdd->info		= &davinci_wdt_info;
+	wdd->ops		= &davinci_wdt_ops;
+	wdd->min_timeout	= 1;
+	wdd->max_timeout	= MAX_HEARTBEAT;
+	wdd->timeout		= DEFAULT_HEARTBEAT;
+
+	watchdog_init_timeout(wdd, heartbeat, dev);
+
+	dev_info(dev, "heartbeat %d sec\n", wdd->timeout);
+
+	watchdog_set_drvdata(wdd, davinci_wdt);
+	watchdog_set_nowayout(wdd, 1);
 
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	wdt_base = devm_ioremap_resource(dev, wdt_mem);
-	if (IS_ERR(wdt_base))
-		return PTR_ERR(wdt_base);
+	davinci_wdt->base = devm_ioremap_resource(dev, wdt_mem);
+	if (IS_ERR(davinci_wdt->base))
+		return PTR_ERR(davinci_wdt->base);
 
-	ret = misc_register(&davinci_wdt_miscdev);
-	if (ret < 0) {
-		dev_err(dev, "cannot register misc device\n");
-	} else {
-		set_bit(WDT_DEVICE_INITED, &wdt_status);
-	}
+	ret = watchdog_register_device(wdd);
+	if (ret < 0)
+		dev_err(dev, "cannot register watchdog device\n");
 
 	return ret;
 }
 
 static int davinci_wdt_remove(struct platform_device *pdev)
 {
-	misc_deregister(&davinci_wdt_miscdev);
-	clk_disable_unprepare(wdt_clk);
+	struct davinci_wdt_device *davinci_wdt = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&davinci_wdt->wdd);
+	clk_disable_unprepare(davinci_wdt->clk);
 
 	return 0;
 }
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index a46f5c7..ee4f86b 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -8,7 +8,7 @@
  * 2 of the License, or (at your option) any later version.
  *
  * This file implements a driver for the Synopsys DesignWare watchdog device
- * in the many ARM subsystems. The watchdog has 16 different timeout periods
+ * in the many subsystems. The watchdog has 16 different timeout periods
  * and these are a function of the input clock frequency.
  *
  * The DesignWare watchdog cannot be stopped once it has been started so we
diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
new file mode 100644
index 0000000..220a9e0
--- /dev/null
+++ b/drivers/watchdog/gpio_wdt.c
@@ -0,0 +1,254 @@
+/*
+ * Driver for watchdog device controlled through GPIO-line
+ *
+ * Author: 2013, Alexander Shiyan <shc_work@mail.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
+
+#define SOFT_TIMEOUT_MIN	1
+#define SOFT_TIMEOUT_DEF	60
+#define SOFT_TIMEOUT_MAX	0xffff
+
+enum {
+	HW_ALGO_TOGGLE,
+	HW_ALGO_LEVEL,
+};
+
+struct gpio_wdt_priv {
+	int			gpio;
+	bool			active_low;
+	bool			state;
+	unsigned int		hw_algo;
+	unsigned int		hw_margin;
+	unsigned long		last_jiffies;
+	struct notifier_block	notifier;
+	struct timer_list	timer;
+	struct watchdog_device	wdd;
+};
+
+static void gpio_wdt_disable(struct gpio_wdt_priv *priv)
+{
+	gpio_set_value_cansleep(priv->gpio, !priv->active_low);
+
+	/* Put GPIO back to tristate */
+	if (priv->hw_algo == HW_ALGO_TOGGLE)
+		gpio_direction_input(priv->gpio);
+}
+
+static int gpio_wdt_start(struct watchdog_device *wdd)
+{
+	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
+
+	priv->state = priv->active_low;
+	gpio_direction_output(priv->gpio, priv->state);
+	priv->last_jiffies = jiffies;
+	mod_timer(&priv->timer, priv->last_jiffies + priv->hw_margin);
+
+	return 0;
+}
+
+static int gpio_wdt_stop(struct watchdog_device *wdd)
+{
+	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
+
+	mod_timer(&priv->timer, 0);
+	gpio_wdt_disable(priv);
+
+	return 0;
+}
+
+static int gpio_wdt_ping(struct watchdog_device *wdd)
+{
+	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
+
+	priv->last_jiffies = jiffies;
+
+	return 0;
+}
+
+static int gpio_wdt_set_timeout(struct watchdog_device *wdd, unsigned int t)
+{
+	wdd->timeout = t;
+
+	return gpio_wdt_ping(wdd);
+}
+
+static void gpio_wdt_hwping(unsigned long data)
+{
+	struct watchdog_device *wdd = (struct watchdog_device *)data;
+	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
+
+	if (time_after(jiffies, priv->last_jiffies +
+		       msecs_to_jiffies(wdd->timeout * 1000))) {
+		dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
+		return;
+	}
+
+	/* Restart timer */
+	mod_timer(&priv->timer, jiffies + priv->hw_margin);
+
+	switch (priv->hw_algo) {
+	case HW_ALGO_TOGGLE:
+		/* Toggle output pin */
+		priv->state = !priv->state;
+		gpio_set_value_cansleep(priv->gpio, priv->state);
+		break;
+	case HW_ALGO_LEVEL:
+		/* Pulse */
+		gpio_set_value_cansleep(priv->gpio, !priv->active_low);
+		udelay(1);
+		gpio_set_value_cansleep(priv->gpio, priv->active_low);
+		break;
+	}
+}
+
+static int gpio_wdt_notify_sys(struct notifier_block *nb, unsigned long code,
+			       void *unused)
+{
+	struct gpio_wdt_priv *priv = container_of(nb, struct gpio_wdt_priv,
+						  notifier);
+
+	mod_timer(&priv->timer, 0);
+
+	switch (code) {
+	case SYS_HALT:
+	case SYS_POWER_OFF:
+		gpio_wdt_disable(priv);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static const struct watchdog_info gpio_wdt_ident = {
+	.options	= WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING |
+			  WDIOF_SETTIMEOUT,
+	.identity	= "GPIO Watchdog",
+};
+
+static const struct watchdog_ops gpio_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= gpio_wdt_start,
+	.stop		= gpio_wdt_stop,
+	.ping		= gpio_wdt_ping,
+	.set_timeout	= gpio_wdt_set_timeout,
+};
+
+static int gpio_wdt_probe(struct platform_device *pdev)
+{
+	struct gpio_wdt_priv *priv;
+	enum of_gpio_flags flags;
+	unsigned int hw_margin;
+	unsigned long f = 0;
+	const char *algo;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->gpio = of_get_gpio_flags(pdev->dev.of_node, 0, &flags);
+	if (!gpio_is_valid(priv->gpio))
+		return priv->gpio;
+
+	priv->active_low = flags & OF_GPIO_ACTIVE_LOW;
+
+	ret = of_property_read_string(pdev->dev.of_node, "hw_algo", &algo);
+	if (ret)
+		return ret;
+	if (!strncmp(algo, "toggle", 6)) {
+		priv->hw_algo = HW_ALGO_TOGGLE;
+		f = GPIOF_IN;
+	} else if (!strncmp(algo, "level", 5)) {
+		priv->hw_algo = HW_ALGO_LEVEL;
+		f = priv->active_low ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+	} else {
+		return -EINVAL;
+	}
+
+	ret = devm_gpio_request_one(&pdev->dev, priv->gpio, f,
+				    dev_name(&pdev->dev));
+	if (ret)
+		return ret;
+
+	ret = of_property_read_u32(pdev->dev.of_node,
+				   "hw_margin_ms", &hw_margin);
+	if (ret)
+		return ret;
+	/* Disallow values lower than 2 and higher than 65535 ms */
+	if (hw_margin < 2 || hw_margin > 65535)
+		return -EINVAL;
+
+	/* Use safe value (1/2 of real timeout) */
+	priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
+
+	watchdog_set_drvdata(&priv->wdd, priv);
+
+	priv->wdd.info		= &gpio_wdt_ident;
+	priv->wdd.ops		= &gpio_wdt_ops;
+	priv->wdd.min_timeout	= SOFT_TIMEOUT_MIN;
+	priv->wdd.max_timeout	= SOFT_TIMEOUT_MAX;
+
+	if (watchdog_init_timeout(&priv->wdd, 0, &pdev->dev) < 0)
+		priv->wdd.timeout = SOFT_TIMEOUT_DEF;
+
+	setup_timer(&priv->timer, gpio_wdt_hwping, (unsigned long)&priv->wdd);
+
+	ret = watchdog_register_device(&priv->wdd);
+	if (ret)
+		return ret;
+
+	priv->notifier.notifier_call = gpio_wdt_notify_sys;
+	ret = register_reboot_notifier(&priv->notifier);
+	if (ret)
+		watchdog_unregister_device(&priv->wdd);
+
+	return ret;
+}
+
+static int gpio_wdt_remove(struct platform_device *pdev)
+{
+	struct gpio_wdt_priv *priv = platform_get_drvdata(pdev);
+
+	del_timer_sync(&priv->timer);
+	unregister_reboot_notifier(&priv->notifier);
+	watchdog_unregister_device(&priv->wdd);
+
+	return 0;
+}
+
+static const struct of_device_id gpio_wdt_dt_ids[] = {
+	{ .compatible = "linux,wdt-gpio", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, gpio_wdt_dt_ids);
+
+static struct platform_driver gpio_wdt_driver = {
+	.driver	= {
+		.name		= "gpio-wdt",
+		.owner		= THIS_MODULE,
+		.of_match_table	= gpio_wdt_dt_ids,
+	},
+	.probe	= gpio_wdt_probe,
+	.remove	= gpio_wdt_remove,
+};
+module_platform_driver(gpio_wdt_driver);
+
+MODULE_AUTHOR("Alexander Shiyan <shc_work@mail.ru>");
+MODULE_DESCRIPTION("GPIO Watchdog");
+MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 45b979d..2b75e8b 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -39,7 +39,7 @@
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 #include <asm/nmi.h>
 
-#define HPWDT_VERSION			"1.3.2"
+#define HPWDT_VERSION			"1.3.3"
 #define SECS_TO_TICKS(secs)		((secs) * 1000 / 128)
 #define TICKS_TO_SECS(ticks)		((ticks) * 128 / 1000)
 #define HPWDT_MAX_TIMER			TICKS_TO_SECS(65535)
@@ -55,7 +55,7 @@ static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
 static unsigned long __iomem *hpwdt_timer_con;
 
-static DEFINE_PCI_DEVICE_TABLE(hpwdt_devices) = {
+static const struct pci_device_id hpwdt_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },	/* iLO2 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },	/* iLO3 */
 	{0},			/* terminate list */
@@ -501,8 +501,13 @@ static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 				"but unable to determine source.\n");
 		}
 	}
-	panic("An NMI occurred, please see the Integrated "
-		"Management Log for details.\n");
+	panic("An NMI occurred. Depending on your system the reason "
+		"for the NMI is logged in any one of the following "
+		"resources:\n"
+		"1. Integrated Management Log (IML)\n"
+		"2. OA Syslog\n"
+		"3. OA Forward Progress Log\n"
+		"4. iLO Event Log");
 
 out:
 	return NMI_DONE;
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index a72fe93..25a2bfd 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -334,7 +334,7 @@ static struct miscdevice esb_miscdev = {
 /*
  * Data for PCI driver interface
  */
-static DEFINE_PCI_DEVICE_TABLE(esb_pci_tbl) = {
+static const struct pci_device_id esb_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
 	{ 0, },                 /* End of list */
 };
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index b4786bc..dd51d95 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -2,6 +2,7 @@
  * Watchdog driver for IMX2 and later processors
  *
  *  Copyright (C) 2010 Wolfram Sang, Pengutronix e.K. <w.sang@pengutronix.de>
+ *  Copyright (C) 2014 Freescale Semiconductor, Inc.
  *
  * some parts adapted by similar drivers from Darius Augulis and Vladimir
  * Zapolskiy, additional improvements by Wim Van Sebroeck.
@@ -40,6 +41,7 @@
 #define IMX2_WDT_WCR_WT		(0xFF << 8)	/* -> Watchdog Timeout Field */
 #define IMX2_WDT_WCR_WRE	(1 << 3)	/* -> WDOG Reset Enable */
 #define IMX2_WDT_WCR_WDE	(1 << 2)	/* -> Watchdog Enable */
+#define IMX2_WDT_WCR_WDZST	(1 << 0)	/* -> Watchdog timer Suspend */
 
 #define IMX2_WDT_WSR		0x02		/* Service Register */
 #define IMX2_WDT_SEQ1		0x5555		/* -> service sequence 1 */
@@ -87,6 +89,8 @@ static inline void imx2_wdt_setup(void)
 {
 	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
 
+	/* Suspend timer in low power mode, write once-only */
+	val |= IMX2_WDT_WCR_WDZST;
 	/* Strip the old watchdog Time-Out value */
 	val &= ~IMX2_WDT_WCR_WT;
 	/* Generate reset if WDOG times out */
diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
index 4166e4d..4aa3a8a 100644
--- a/drivers/watchdog/moxart_wdt.c
+++ b/drivers/watchdog/moxart_wdt.c
@@ -19,6 +19,8 @@
 #include <linux/watchdog.h>
 #include <linux/moduleparam.h>
 
+#include <asm/system_misc.h>
+
 #define REG_COUNT			0x4
 #define REG_MODE			0x8
 #define REG_ENABLE			0xC
@@ -29,8 +31,17 @@ struct moxart_wdt_dev {
 	unsigned int clock_frequency;
 };
 
+static struct moxart_wdt_dev *moxart_restart_ctx;
+
 static int heartbeat;
 
+static void moxart_wdt_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	writel(1, moxart_restart_ctx->base + REG_COUNT);
+	writel(0x5ab9, moxart_restart_ctx->base + REG_MODE);
+	writel(0x03, moxart_restart_ctx->base + REG_ENABLE);
+}
+
 static int moxart_wdt_stop(struct watchdog_device *wdt_dev)
 {
 	struct moxart_wdt_dev *moxart_wdt = watchdog_get_drvdata(wdt_dev);
@@ -125,6 +136,9 @@ static int moxart_wdt_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	moxart_restart_ctx = moxart_wdt;
+	arm_pm_restart = moxart_wdt_restart;
+
 	dev_dbg(dev, "Watchdog enabled (heartbeat=%d sec, nowayout=%d)\n",
 		moxart_wdt->dev.timeout, nowayout);
 
@@ -135,6 +149,7 @@ static int moxart_wdt_remove(struct platform_device *pdev)
 {
 	struct moxart_wdt_dev *moxart_wdt = platform_get_drvdata(pdev);
 
+	arm_pm_restart = NULL;
 	moxart_wdt_stop(&moxart_wdt->dev);
 	watchdog_unregister_device(&moxart_wdt->dev);
 
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index d821520..c1f65b4 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -73,9 +73,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
  * to 0
  */
 static int prescale = 1;
-static unsigned int timeout_sec;
 
-static unsigned long wdt_is_open;
 static DEFINE_SPINLOCK(wdt_spinlock);
 
 static void mpc8xxx_wdt_keepalive(void)
@@ -87,39 +85,23 @@ static void mpc8xxx_wdt_keepalive(void)
 	spin_unlock(&wdt_spinlock);
 }
 
+static struct watchdog_device mpc8xxx_wdt_dev;
 static void mpc8xxx_wdt_timer_ping(unsigned long arg);
-static DEFINE_TIMER(wdt_timer, mpc8xxx_wdt_timer_ping, 0, 0);
+static DEFINE_TIMER(wdt_timer, mpc8xxx_wdt_timer_ping, 0,
+		(unsigned long)&mpc8xxx_wdt_dev);
 
 static void mpc8xxx_wdt_timer_ping(unsigned long arg)
 {
+	struct watchdog_device *w = (struct watchdog_device *)arg;
+
 	mpc8xxx_wdt_keepalive();
 	/* We're pinging it twice faster than needed, just to be sure. */
-	mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
-}
-
-static void mpc8xxx_wdt_pr_warn(const char *msg)
-{
-	pr_crit("%s, expect the %s soon!\n", msg,
-		reset ? "reset" : "machine check exception");
+	mod_timer(&wdt_timer, jiffies + HZ * w->timeout / 2);
 }
 
-static ssize_t mpc8xxx_wdt_write(struct file *file, const char __user *buf,
-				 size_t count, loff_t *ppos)
-{
-	if (count)
-		mpc8xxx_wdt_keepalive();
-	return count;
-}
-
-static int mpc8xxx_wdt_open(struct inode *inode, struct file *file)
+static int mpc8xxx_wdt_start(struct watchdog_device *w)
 {
 	u32 tmp = SWCRR_SWEN;
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-
-	/* Once we start the watchdog we can't stop it */
-	if (nowayout)
-		__module_get(THIS_MODULE);
 
 	/* Good, fire up the show */
 	if (prescale)
@@ -133,59 +115,37 @@ static int mpc8xxx_wdt_open(struct inode *inode, struct file *file)
 
 	del_timer_sync(&wdt_timer);
 
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
+static int mpc8xxx_wdt_ping(struct watchdog_device *w)
 {
-	if (!nowayout)
-		mpc8xxx_wdt_timer_ping(0);
-	else
-		mpc8xxx_wdt_pr_warn("watchdog closed");
-	clear_bit(0, &wdt_is_open);
+	mpc8xxx_wdt_keepalive();
 	return 0;
 }
 
-static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+static int mpc8xxx_wdt_stop(struct watchdog_device *w)
 {
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING,
-		.firmware_version = 1,
-		.identity = "MPC8xxx",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		mpc8xxx_wdt_keepalive();
-		return 0;
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout_sec, p);
-	default:
-		return -ENOTTY;
-	}
+	mod_timer(&wdt_timer, jiffies);
+	return 0;
 }
 
-static const struct file_operations mpc8xxx_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= mpc8xxx_wdt_write,
-	.unlocked_ioctl	= mpc8xxx_wdt_ioctl,
-	.open		= mpc8xxx_wdt_open,
-	.release	= mpc8xxx_wdt_release,
+static struct watchdog_info mpc8xxx_wdt_info = {
+	.options = WDIOF_KEEPALIVEPING,
+	.firmware_version = 1,
+	.identity = "MPC8xxx",
 };
 
-static struct miscdevice mpc8xxx_wdt_miscdev = {
-	.minor	= WATCHDOG_MINOR,
-	.name	= "watchdog",
-	.fops	= &mpc8xxx_wdt_fops,
+static struct watchdog_ops mpc8xxx_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = mpc8xxx_wdt_start,
+	.ping = mpc8xxx_wdt_ping,
+	.stop = mpc8xxx_wdt_stop,
+};
+
+static struct watchdog_device mpc8xxx_wdt_dev = {
+	.info = &mpc8xxx_wdt_info,
+	.ops = &mpc8xxx_wdt_ops,
 };
 
 static const struct of_device_id mpc8xxx_wdt_match[];
@@ -197,6 +157,7 @@ static int mpc8xxx_wdt_probe(struct platform_device *ofdev)
 	const struct mpc8xxx_wdt_type *wdt_type;
 	u32 freq = fsl_get_sys_freq();
 	bool enabled;
+	unsigned int timeout_sec;
 
 	match = of_match_device(mpc8xxx_wdt_match, &ofdev->dev);
 	if (!match)
@@ -223,6 +184,7 @@ static int mpc8xxx_wdt_probe(struct platform_device *ofdev)
 	else
 		timeout_sec = timeout / freq;
 
+	mpc8xxx_wdt_dev.timeout = timeout_sec;
 #ifdef MODULE
 	ret = mpc8xxx_wdt_init_late();
 	if (ret)
@@ -238,7 +200,7 @@ static int mpc8xxx_wdt_probe(struct platform_device *ofdev)
 	 * userspace handles it.
 	 */
 	if (enabled)
-		mpc8xxx_wdt_timer_ping(0);
+		mod_timer(&wdt_timer, jiffies);
 	return 0;
 err_unmap:
 	iounmap(wd_base);
@@ -248,9 +210,10 @@ err_unmap:
 
 static int mpc8xxx_wdt_remove(struct platform_device *ofdev)
 {
-	mpc8xxx_wdt_pr_warn("watchdog removed");
+	pr_crit("Watchdog removed, expect the %s soon!\n",
+		reset ? "reset" : "machine check exception");
 	del_timer_sync(&wdt_timer);
-	misc_deregister(&mpc8xxx_wdt_miscdev);
+	watchdog_unregister_device(&mpc8xxx_wdt_dev);
 	iounmap(wd_base);
 
 	return 0;
@@ -302,10 +265,11 @@ static int mpc8xxx_wdt_init_late(void)
 	if (!wd_base)
 		return -ENODEV;
 
-	ret = misc_register(&mpc8xxx_wdt_miscdev);
+	watchdog_set_nowayout(&mpc8xxx_wdt_dev, nowayout);
+
+	ret = watchdog_register_device(&mpc8xxx_wdt_dev);
 	if (ret) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
+		pr_err("cannot register watchdog device (err=%d)\n", ret);
 		return ret;
 	}
 	return 0;
diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
index 231e5b9..0b9ec61 100644
--- a/drivers/watchdog/nv_tco.c
+++ b/drivers/watchdog/nv_tco.c
@@ -289,7 +289,7 @@ static struct miscdevice nv_tco_miscdev = {
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static DEFINE_PCI_DEVICE_TABLE(tco_pci_tbl) = {
+static const struct pci_device_id tco_pci_tbl[] = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SMBUS,
 	  PCI_ANY_ID, PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS,
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index b4864f2..c0d07ee 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -801,7 +801,7 @@ static void pcipcwd_card_exit(struct pci_dev *pdev)
 	cards_found--;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pcipcwd_pci_tbl) = {
+static const struct pci_device_id pcipcwd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_QUICKLOGIC, PCI_DEVICE_ID_WATCHDOG_PCIPCWD,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 },			/* End of list */
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 7d8fd04..aec946d 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -40,6 +40,8 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -60,6 +62,16 @@
 #define CONFIG_S3C2410_WATCHDOG_ATBOOT		(0)
 #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
 
+#define EXYNOS5_RST_STAT_REG_OFFSET		0x0404
+#define EXYNOS5_WDT_DISABLE_REG_OFFSET		0x0408
+#define EXYNOS5_WDT_MASK_RESET_REG_OFFSET	0x040c
+#define QUIRK_HAS_PMU_CONFIG			(1 << 0)
+#define QUIRK_HAS_RST_STAT			(1 << 1)
+
+/* These quirks require that we have a PMU register map */
+#define QUIRKS_HAVE_PMUREG			(QUIRK_HAS_PMU_CONFIG | \
+						 QUIRK_HAS_RST_STAT)
+
 static bool nowayout	= WATCHDOG_NOWAYOUT;
 static int tmr_margin;
 static int tmr_atboot	= CONFIG_S3C2410_WATCHDOG_ATBOOT;
@@ -83,6 +95,30 @@ MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, "
 			"0 to reboot (default 0)");
 MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
 
+/**
+ * struct s3c2410_wdt_variant - Per-variant config data
+ *
+ * @disable_reg: Offset in pmureg for the register that disables the watchdog
+ * timer reset functionality.
+ * @mask_reset_reg: Offset in pmureg for the register that masks the watchdog
+ * timer reset functionality.
+ * @mask_bit: Bit number for the watchdog timer in the disable register and the
+ * mask reset register.
+ * @rst_stat_reg: Offset in pmureg for the register that has the reset status.
+ * @rst_stat_bit: Bit number in the rst_stat register indicating a watchdog
+ * reset.
+ * @quirks: A bitfield of quirks.
+ */
+
+struct s3c2410_wdt_variant {
+	int disable_reg;
+	int mask_reset_reg;
+	int mask_bit;
+	int rst_stat_reg;
+	int rst_stat_bit;
+	u32 quirks;
+};
+
 struct s3c2410_wdt {
 	struct device		*dev;
 	struct clk		*clock;
@@ -93,8 +129,54 @@ struct s3c2410_wdt {
 	unsigned long		wtdat_save;
 	struct watchdog_device	wdt_device;
 	struct notifier_block	freq_transition;
+	struct s3c2410_wdt_variant *drv_data;
+	struct regmap *pmureg;
 };
 
+static const struct s3c2410_wdt_variant drv_data_s3c2410 = {
+	.quirks = 0
+};
+
+#ifdef CONFIG_OF
+static const struct s3c2410_wdt_variant drv_data_exynos5250  = {
+	.disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
+	.mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
+	.mask_bit = 20,
+	.rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
+	.rst_stat_bit = 20,
+	.quirks = QUIRK_HAS_PMU_CONFIG | QUIRK_HAS_RST_STAT,
+};
+
+static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
+	.disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
+	.mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
+	.mask_bit = 0,
+	.rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
+	.rst_stat_bit = 9,
+	.quirks = QUIRK_HAS_PMU_CONFIG | QUIRK_HAS_RST_STAT,
+};
+
+static const struct of_device_id s3c2410_wdt_match[] = {
+	{ .compatible = "samsung,s3c2410-wdt",
+	  .data = &drv_data_s3c2410 },
+	{ .compatible = "samsung,exynos5250-wdt",
+	  .data = &drv_data_exynos5250 },
+	{ .compatible = "samsung,exynos5420-wdt",
+	  .data = &drv_data_exynos5420 },
+	{},
+};
+MODULE_DEVICE_TABLE(of, s3c2410_wdt_match);
+#endif
+
+static const struct platform_device_id s3c2410_wdt_ids[] = {
+	{
+		.name = "s3c2410-wdt",
+		.driver_data = (unsigned long)&drv_data_s3c2410,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(platform, s3c2410_wdt_ids);
+
 /* watchdog control routines */
 
 #define DBG(fmt, ...)					\
@@ -110,6 +192,35 @@ static inline struct s3c2410_wdt *freq_to_wdt(struct notifier_block *nb)
 	return container_of(nb, struct s3c2410_wdt, freq_transition);
 }
 
+static int s3c2410wdt_mask_and_disable_reset(struct s3c2410_wdt *wdt, bool mask)
+{
+	int ret;
+	u32 mask_val = 1 << wdt->drv_data->mask_bit;
+	u32 val = 0;
+
+	/* No need to do anything if no PMU CONFIG needed */
+	if (!(wdt->drv_data->quirks & QUIRK_HAS_PMU_CONFIG))
+		return 0;
+
+	if (mask)
+		val = mask_val;
+
+	ret = regmap_update_bits(wdt->pmureg,
+			wdt->drv_data->disable_reg,
+			mask_val, val);
+	if (ret < 0)
+		goto error;
+
+	ret = regmap_update_bits(wdt->pmureg,
+			wdt->drv_data->mask_reset_reg,
+			mask_val, val);
+ error:
+	if (ret < 0)
+		dev_err(wdt->dev, "failed to update reg(%d)\n", ret);
+
+	return ret;
+}
+
 static int s3c2410wdt_keepalive(struct watchdog_device *wdd)
 {
 	struct s3c2410_wdt *wdt = watchdog_get_drvdata(wdd);
@@ -188,7 +299,7 @@ static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeou
 	if (timeout < 1)
 		return -EINVAL;
 
-	freq /= 128;
+	freq = DIV_ROUND_UP(freq, 128);
 	count = timeout * freq;
 
 	DBG("%s: count=%d, timeout=%d, freq=%lu\n",
@@ -200,21 +311,18 @@ static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeou
 	*/
 
 	if (count >= 0x10000) {
-		for (divisor = 1; divisor <= 0x100; divisor++) {
-			if ((count / divisor) < 0x10000)
-				break;
-		}
+		divisor = DIV_ROUND_UP(count, 0xffff);
 
-		if ((count / divisor) >= 0x10000) {
+		if (divisor > 0x100) {
 			dev_err(wdt->dev, "timeout %d too big\n", timeout);
 			return -EINVAL;
 		}
 	}
 
 	DBG("%s: timeout=%d, divisor=%d, count=%d (%08x)\n",
-	    __func__, timeout, divisor, count, count/divisor);
+	    __func__, timeout, divisor, count, DIV_ROUND_UP(count, divisor));
 
-	count /= divisor;
+	count = DIV_ROUND_UP(count, divisor);
 	wdt->count = count;
 
 	/* update the pre-scaler */
@@ -264,7 +372,7 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_CPU_FREQ
+#ifdef CONFIG_ARM_S3C24XX_CPUFREQ
 
 static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
 					  unsigned long val, void *data)
@@ -331,6 +439,37 @@ static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
 }
 #endif
 
+static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wdt *wdt)
+{
+	unsigned int rst_stat;
+	int ret;
+
+	if (!(wdt->drv_data->quirks & QUIRK_HAS_RST_STAT))
+		return 0;
+
+	ret = regmap_read(wdt->pmureg, wdt->drv_data->rst_stat_reg, &rst_stat);
+	if (ret)
+		dev_warn(wdt->dev, "Couldn't get RST_STAT register\n");
+	else if (rst_stat & BIT(wdt->drv_data->rst_stat_bit))
+		return WDIOF_CARDRESET;
+
+	return 0;
+}
+
+/* s3c2410_get_wdt_driver_data */
+static inline struct s3c2410_wdt_variant *
+get_wdt_drv_data(struct platform_device *pdev)
+{
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(s3c2410_wdt_match, pdev->dev.of_node);
+		return (struct s3c2410_wdt_variant *)match->data;
+	} else {
+		return (struct s3c2410_wdt_variant *)
+			platform_get_device_id(pdev)->driver_data;
+	}
+}
+
 static int s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev;
@@ -353,6 +492,16 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	spin_lock_init(&wdt->lock);
 	wdt->wdt_device = s3c2410_wdd;
 
+	wdt->drv_data = get_wdt_drv_data(pdev);
+	if (wdt->drv_data->quirks & QUIRKS_HAVE_PMUREG) {
+		wdt->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
+						"samsung,syscon-phandle");
+		if (IS_ERR(wdt->pmureg)) {
+			dev_err(dev, "syscon regmap lookup failed.\n");
+			return PTR_ERR(wdt->pmureg);
+		}
+	}
+
 	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (wdt_irq == NULL) {
 		dev_err(dev, "no irq resource specified\n");
@@ -415,12 +564,18 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	watchdog_set_nowayout(&wdt->wdt_device, nowayout);
 
+	wdt->wdt_device.bootstatus = s3c2410wdt_get_bootstatus(wdt);
+
 	ret = watchdog_register_device(&wdt->wdt_device);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
 		goto err_cpufreq;
 	}
 
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, false);
+	if (ret < 0)
+		goto err_unregister;
+
 	if (tmr_atboot && started == 0) {
 		dev_info(dev, "starting watchdog timer\n");
 		s3c2410wdt_start(&wdt->wdt_device);
@@ -445,6 +600,9 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
+ err_unregister:
+	watchdog_unregister_device(&wdt->wdt_device);
+
  err_cpufreq:
 	s3c2410wdt_cpufreq_deregister(wdt);
 
@@ -458,8 +616,13 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 static int s3c2410wdt_remove(struct platform_device *dev)
 {
+	int ret;
 	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
 
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
+	if (ret < 0)
+		return ret;
+
 	watchdog_unregister_device(&wdt->wdt_device);
 
 	s3c2410wdt_cpufreq_deregister(wdt);
@@ -474,6 +637,8 @@ static void s3c2410wdt_shutdown(struct platform_device *dev)
 {
 	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
 
+	s3c2410wdt_mask_and_disable_reset(wdt, true);
+
 	s3c2410wdt_stop(&wdt->wdt_device);
 }
 
@@ -481,12 +646,17 @@ static void s3c2410wdt_shutdown(struct platform_device *dev)
 
 static int s3c2410wdt_suspend(struct device *dev)
 {
+	int ret;
 	struct s3c2410_wdt *wdt = dev_get_drvdata(dev);
 
 	/* Save watchdog state, and turn it off. */
 	wdt->wtcon_save = readl(wdt->reg_base + S3C2410_WTCON);
 	wdt->wtdat_save = readl(wdt->reg_base + S3C2410_WTDAT);
 
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
+	if (ret < 0)
+		return ret;
+
 	/* Note that WTCNT doesn't need to be saved. */
 	s3c2410wdt_stop(&wdt->wdt_device);
 
@@ -495,6 +665,7 @@ static int s3c2410wdt_suspend(struct device *dev)
 
 static int s3c2410wdt_resume(struct device *dev)
 {
+	int ret;
 	struct s3c2410_wdt *wdt = dev_get_drvdata(dev);
 
 	/* Restore watchdog state. */
@@ -502,6 +673,10 @@ static int s3c2410wdt_resume(struct device *dev)
 	writel(wdt->wtdat_save, wdt->reg_base + S3C2410_WTCNT);/* Reset count */
 	writel(wdt->wtcon_save, wdt->reg_base + S3C2410_WTCON);
 
+	ret = s3c2410wdt_mask_and_disable_reset(wdt, false);
+	if (ret < 0)
+		return ret;
+
 	dev_info(dev, "watchdog %sabled\n",
 		(wdt->wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
@@ -512,18 +687,11 @@ static int s3c2410wdt_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(s3c2410wdt_pm_ops, s3c2410wdt_suspend,
 			s3c2410wdt_resume);
 
-#ifdef CONFIG_OF
-static const struct of_device_id s3c2410_wdt_match[] = {
-	{ .compatible = "samsung,s3c2410-wdt" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, s3c2410_wdt_match);
-#endif
-
 static struct platform_driver s3c2410wdt_driver = {
 	.probe		= s3c2410wdt_probe,
 	.remove		= s3c2410wdt_remove,
 	.shutdown	= s3c2410wdt_shutdown,
+	.id_table	= s3c2410_wdt_ids,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "s3c2410-wdt",
@@ -538,4 +706,3 @@ MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>, "
 	      "Dimitry Andric <dimitry.andric@tomtom.com>");
 MODULE_DESCRIPTION("S3C2410 Watchdog Device Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:s3c2410-wdt");
diff --git a/drivers/watchdog/sirfsoc_wdt.c b/drivers/watchdog/sirfsoc_wdt.c
index ced3edc..702d078 100644
--- a/drivers/watchdog/sirfsoc_wdt.c
+++ b/drivers/watchdog/sirfsoc_wdt.c
@@ -212,7 +212,7 @@ static struct platform_driver sirfsoc_wdt_driver = {
 		.name = "sirfsoc-wdt",
 		.owner = THIS_MODULE,
 		.pm = &sirfsoc_wdt_pm_ops,
-		.of_match_table	= of_match_ptr(sirfsoc_wdt_of_match),
+		.of_match_table	= sirfsoc_wdt_of_match,
 	},
 	.probe = sirfsoc_wdt_probe,
 	.remove = sirfsoc_wdt_remove,
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index ce63a1b..5cca9cd 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -303,7 +303,7 @@ static struct miscdevice sp5100_tco_miscdev = {
  * register a pci_driver, because someone else might
  * want to register another driver on the same PCI id.
  */
-static DEFINE_PCI_DEVICE_TABLE(sp5100_tco_pci_tbl) = {
+static const struct pci_device_id sp5100_tco_pci_tbl[] = {
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS, PCI_ANY_ID,
 	  PCI_ANY_ID, },
 	{ 0, },			/* End of list */
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 1a68f76..d2cd9f0 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -239,7 +239,7 @@ static void wdt_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
+static const struct pci_device_id wdt_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX800) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index e24b210..b1da0c1 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -44,10 +44,13 @@
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
-/* You must set this - there is no sane way to probe for this board. */
-static int wdt_io = 0x2E;
-module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
+static int wdt_io;
+static int cr_wdt_timeout;	/* WDT timeout register */
+static int cr_wdt_control;	/* WDT control register */
+
+enum chips { w83627hf, w83627s, w83697hf, w83697ug, w83637hf, w83627thf,
+	     w83687thf, w83627ehf, w83627dhg, w83627uhg, w83667hg, w83627dhg_p,
+	     w83667hg_b, nct6775, nct6776, nct6779 };
 
 static int timeout;			/* in seconds */
 module_param(timeout, int, 0);
@@ -72,6 +75,29 @@ MODULE_PARM_DESC(nowayout,
 
 #define W83627HF_LD_WDT		0x08
 
+#define W83627HF_ID		0x52
+#define W83627S_ID		0x59
+#define W83697HF_ID		0x60
+#define W83697UG_ID		0x68
+#define W83637HF_ID		0x70
+#define W83627THF_ID		0x82
+#define W83687THF_ID		0x85
+#define W83627EHF_ID		0x88
+#define W83627DHG_ID		0xa0
+#define W83627UHG_ID		0xa2
+#define W83667HG_ID		0xa5
+#define W83627DHG_P_ID		0xb0
+#define W83667HG_B_ID		0xb3
+#define NCT6775_ID		0xb4
+#define NCT6776_ID		0xc3
+#define NCT6779_ID		0xc5
+
+#define W83627HF_WDT_TIMEOUT	0xf6
+#define W83697HF_WDT_TIMEOUT	0xf4
+
+#define W83627HF_WDT_CONTROL	0xf5
+#define W83697HF_WDT_CONTROL	0xf3
+
 static void superio_outb(int reg, int val)
 {
 	outb(reg, WDT_EFER);
@@ -106,10 +132,7 @@ static void superio_exit(void)
 	release_region(wdt_io, 2);
 }
 
-/* tyan motherboards seem to set F5 to 0x4C ?
- * So explicitly init to appropriate value. */
-
-static int w83627hf_init(struct watchdog_device *wdog)
+static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 {
 	int ret;
 	unsigned char t;
@@ -119,35 +142,83 @@ static int w83627hf_init(struct watchdog_device *wdog)
 		return ret;
 
 	superio_select(W83627HF_LD_WDT);
-	t = superio_inb(0x20);	/* check chip version	*/
-	if (t == 0x82) {	/* W83627THF		*/
-		t = (superio_inb(0x2b) & 0xf7);
-		superio_outb(0x2b, t | 0x04); /* set GPIO3 to WDT0 */
-	} else if (t == 0x88 || t == 0xa0) {	/* W83627EHF / W83627DHG */
-		t = superio_inb(0x2d);
-		superio_outb(0x2d, t & ~0x01);	/* set GPIO5 to WDT0 */
-	}
 
 	/* set CR30 bit 0 to activate GPIO2 */
 	t = superio_inb(0x30);
 	if (!(t & 0x01))
 		superio_outb(0x30, t | 0x01);
 
-	t = superio_inb(0xF6);
+	switch (chip) {
+	case w83627hf:
+	case w83627s:
+		t = superio_inb(0x2B) & ~0x10;
+		superio_outb(0x2B, t); /* set GPIO24 to WDT0 */
+		break;
+	case w83697hf:
+		/* Set pin 119 to WDTO# mode (= CR29, WDT0) */
+		t = superio_inb(0x29) & ~0x60;
+		t |= 0x20;
+		superio_outb(0x29, t);
+		break;
+	case w83697ug:
+		/* Set pin 118 to WDTO# mode */
+		t = superio_inb(0x2b) & ~0x04;
+		superio_outb(0x2b, t);
+		break;
+	case w83627thf:
+		t = (superio_inb(0x2B) & ~0x08) | 0x04;
+		superio_outb(0x2B, t); /* set GPIO3 to WDT0 */
+		break;
+	case w83627dhg:
+	case w83627dhg_p:
+		t = superio_inb(0x2D) & ~0x01; /* PIN77 -> WDT0# */
+		superio_outb(0x2D, t); /* set GPIO5 to WDT0 */
+		t = superio_inb(cr_wdt_control);
+		t |= 0x02;	/* enable the WDTO# output low pulse
+				 * to the KBRST# pin */
+		superio_outb(cr_wdt_control, t);
+		break;
+	case w83637hf:
+		break;
+	case w83687thf:
+		t = superio_inb(0x2C) & ~0x80; /* PIN47 -> WDT0# */
+		superio_outb(0x2C, t);
+		break;
+	case w83627ehf:
+	case w83627uhg:
+	case w83667hg:
+	case w83667hg_b:
+	case nct6775:
+	case nct6776:
+	case nct6779:
+		/*
+		 * These chips have a fixed WDTO# output pin (W83627UHG),
+		 * or support more than one WDTO# output pin.
+		 * Don't touch its configuration, and hope the BIOS
+		 * does the right thing.
+		 */
+		t = superio_inb(cr_wdt_control);
+		t |= 0x02;	/* enable the WDTO# output low pulse
+				 * to the KBRST# pin */
+		superio_outb(cr_wdt_control, t);
+		break;
+	default:
+		break;
+	}
+
+	t = superio_inb(cr_wdt_timeout);
 	if (t != 0) {
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
 			wdog->timeout);
-		superio_outb(0xF6, wdog->timeout);
+		superio_outb(cr_wdt_timeout, wdog->timeout);
 	}
 
 	/* set second mode & disable keyboard turning off watchdog */
-	t = superio_inb(0xF5) & ~0x0C;
-	/* enable the WDTO# output low pulse to the KBRST# pin */
-	t |= 0x02;
-	superio_outb(0xF5, t);
+	t = superio_inb(cr_wdt_control) & ~0x0C;
+	superio_outb(cr_wdt_control, t);
 
-	/* disable keyboard & mouse turning off watchdog */
-	t = superio_inb(0xF7) & ~0xC0;
+	/* reset trigger, disable keyboard & mouse turning off watchdog */
+	t = superio_inb(0xF7) & ~0xD0;
 	superio_outb(0xF7, t);
 
 	superio_exit();
@@ -164,7 +235,7 @@ static int wdt_set_time(unsigned int timeout)
 		return ret;
 
 	superio_select(W83627HF_LD_WDT);
-	superio_outb(0xF6, timeout);
+	superio_outb(cr_wdt_timeout, timeout);
 	superio_exit();
 
 	return 0;
@@ -197,7 +268,7 @@ static unsigned int wdt_get_time(struct watchdog_device *wdog)
 		return 0;
 
 	superio_select(W83627HF_LD_WDT);
-	timeleft = superio_inb(0xF6);
+	timeleft = superio_inb(cr_wdt_timeout);
 	superio_exit();
 
 	return timeleft;
@@ -249,16 +320,123 @@ static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
+static int wdt_find(int addr)
+{
+	u8 val;
+	int ret;
+
+	cr_wdt_timeout = W83627HF_WDT_TIMEOUT;
+	cr_wdt_control = W83627HF_WDT_CONTROL;
+
+	ret = superio_enter();
+	if (ret)
+		return ret;
+	superio_select(W83627HF_LD_WDT);
+	val = superio_inb(0x20);
+	switch (val) {
+	case W83627HF_ID:
+		ret = w83627hf;
+		break;
+	case W83627S_ID:
+		ret = w83627s;
+		break;
+	case W83697HF_ID:
+		ret = w83697hf;
+		cr_wdt_timeout = W83697HF_WDT_TIMEOUT;
+		cr_wdt_control = W83697HF_WDT_CONTROL;
+		break;
+	case W83697UG_ID:
+		ret = w83697ug;
+		cr_wdt_timeout = W83697HF_WDT_TIMEOUT;
+		cr_wdt_control = W83697HF_WDT_CONTROL;
+		break;
+	case W83637HF_ID:
+		ret = w83637hf;
+		break;
+	case W83627THF_ID:
+		ret = w83627thf;
+		break;
+	case W83687THF_ID:
+		ret = w83687thf;
+		break;
+	case W83627EHF_ID:
+		ret = w83627ehf;
+		break;
+	case W83627DHG_ID:
+		ret = w83627dhg;
+		break;
+	case W83627DHG_P_ID:
+		ret = w83627dhg_p;
+		break;
+	case W83627UHG_ID:
+		ret = w83627uhg;
+		break;
+	case W83667HG_ID:
+		ret = w83667hg;
+		break;
+	case W83667HG_B_ID:
+		ret = w83667hg_b;
+		break;
+	case NCT6775_ID:
+		ret = nct6775;
+		break;
+	case NCT6776_ID:
+		ret = nct6776;
+		break;
+	case NCT6779_ID:
+		ret = nct6779;
+		break;
+	case 0xff:
+		ret = -ENODEV;
+		break;
+	default:
+		ret = -ENODEV;
+		pr_err("Unsupported chip ID: 0x%02x\n", val);
+		break;
+	}
+	superio_exit();
+	return ret;
+}
+
 static int __init wdt_init(void)
 {
 	int ret;
+	int chip;
+	const char * const chip_name[] = {
+		"W83627HF",
+		"W83627S",
+		"W83697HF",
+		"W83697UG",
+		"W83637HF",
+		"W83627THF",
+		"W83687THF",
+		"W83627EHF",
+		"W83627DHG",
+		"W83627UHG",
+		"W83667HG",
+		"W83667DHG-P",
+		"W83667HG-B",
+		"NCT6775",
+		"NCT6776",
+		"NCT6779",
+	};
+
+	wdt_io = 0x2e;
+	chip = wdt_find(0x2e);
+	if (chip < 0) {
+		wdt_io = 0x4e;
+		chip = wdt_find(0x4e);
+		if (chip < 0)
+			return chip;
+	}
 
-	pr_info("WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising\n");
+	pr_info("WDT driver for %s Super I/O chip initialising\n",
+		chip_name[chip]);
 
 	watchdog_init_timeout(&wdt_dev, timeout, NULL);
 	watchdog_set_nowayout(&wdt_dev, nowayout);
 
-	ret = w83627hf_init(&wdt_dev);
+	ret = w83627hf_init(&wdt_dev, chip);
 	if (ret) {
 		pr_err("failed to initialize watchdog (err=%d)\n", ret);
 		return ret;
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 461336c..cec9b55 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -78,7 +78,7 @@ int watchdog_init_timeout(struct watchdog_device *wdd,
 	watchdog_check_min_max_timeout(wdd);
 
 	/* try to get the timeout module parameter first */
-	if (!watchdog_timeout_invalid(wdd, timeout_parm)) {
+	if (!watchdog_timeout_invalid(wdd, timeout_parm) && timeout_parm) {
 		wdd->timeout = timeout_parm;
 		return ret;
 	}
@@ -89,7 +89,7 @@ int watchdog_init_timeout(struct watchdog_device *wdd,
 	if (dev == NULL || dev->of_node == NULL)
 		return ret;
 	of_property_read_u32(dev->of_node, "timeout-sec", &t);
-	if (!watchdog_timeout_invalid(wdd, t))
+	if (!watchdog_timeout_invalid(wdd, t) && t)
 		wdd->timeout = t;
 	else
 		ret = -EINVAL;
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index ee89ba4..3dc578e 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -720,7 +720,7 @@ static void wdtpci_remove_one(struct pci_dev *pdev)
 }
 
 
-static DEFINE_PCI_DEVICE_TABLE(wdtpci_pci_tbl) = {
+static const struct pci_device_id wdtpci_pci_tbl[] = {
 	{
 		.vendor	   = PCI_VENDOR_ID_ACCESSIO,
 		.device	   = PCI_DEVICE_ID_ACCESSIO_WDG_CSM,
