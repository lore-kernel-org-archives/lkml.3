Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaJTTxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:53:41 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:53153 "EHLO
	spo001.leaseweb.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbaJTTxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:53:38 -0400
Date: Mon, 20 Oct 2014 21:53:20 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Carlo Caione <carlo@caione.org>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>, Jisheng Zhang <jszhang@marvell.com>,
        Janusz Uzycki <j.uzycki@elproma.com.pl>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Harini Katakam <harinik@xilinx.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Xiubo Li <Li.Xiubo@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [GIT PULL REQUEST] watchdog - v3.18 Merge window
Message-ID: <20141020195319.GA27879@spo001.leaseweb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for being late. I reckoned you would go for a 2.5 week schedule,
but didn't expect a 2 week schedule and since I had to check wether or
not the code that the tree is dependent on was allready in, I am now
normally to late. So I hope you can still do this pull request.

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It contains following changes:
* Add Cadence WDT Driver
* Add Ricoh RN5T618 watchdog
* Add DA9063 PMIC watchdog driver
* Add Meson WDT driver
* add Restart handling code
* fixes and improvements

This will update the following files:

 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt |   24 
 Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt |    3 
 Documentation/devicetree/bindings/watchdog/meson6-wdt.txt  |   13 
 Documentation/devicetree/bindings/watchdog/qcom-wdt.txt    |   24 
 Documentation/devicetree/bindings/watchdog/samsung-wdt.txt |    1 
 arch/arm/configs/multi_v7_defconfig                        |    1 
 drivers/watchdog/Kconfig                                   |   54 +
 drivers/watchdog/Makefile                                  |    5 
 drivers/watchdog/booke_wdt.c                               |   28 
 drivers/watchdog/cadence_wdt.c                             |  516 +++++++++++++
 drivers/watchdog/da9063_wdt.c                              |  191 ++++
 drivers/watchdog/dw_wdt.c                                  |   36 
 drivers/watchdog/imx2_wdt.c                                |   43 -
 drivers/watchdog/meson_wdt.c                               |  236 +++++
 drivers/watchdog/of_xilinx_wdt.c                           |    1 
 drivers/watchdog/qcom-wdt.c                                |  224 +++++
 drivers/watchdog/rn5t618_wdt.c                             |  198 ++++
 drivers/watchdog/s3c2410_wdt.c                             |   47 +
 drivers/watchdog/stmp3xxx_rtc_wdt.c                        |   24 
 drivers/watchdog/sunxi_wdt.c                               |  111 ++
 drivers/watchdog/ts72xx_wdt.c                              |    6 
 include/linux/watchdog.h                                   |    9 
 22 files changed, 1725 insertions(+), 70 deletions(-)

with these Changes:

commit 06980b24cf9bfcc753a07ee362976169bb869869
Author: Carlo Caione <carlo@caione.org>
Date:   Thu Oct 9 21:59:16 2014 +0200

    watchdog: meson: remove magic value for reboot
    
    This patch removes the magic value used for rebooting the board. This
    value is useless and leads to a static checker warning as reported by
    Dan Carpenter.
    
    Signed-off-by: Carlo Caione <carlo@caione.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 71fd380a6b87f384002feceda39fd670ede7ea5f
Author: Chen Gang <gang.chen.5i5j@gmail.com>
Date:   Sun Oct 5 09:28:33 2014 +0800

    watchdog: Let XILINX_WATCHDOG and TEGRA_WATCHDOG depend on HAS_IOMEM
    
    They need HAS_IOMEM, so let them depend on it, the related error (with
    allmodconfig under um):
    
        MODPOST 1205 modules
      ERROR: "devm_ioremap_resource" [drivers/watchdog/tegra_wdt.ko] undefined!
      ERROR: "devm_ioremap_resource" [drivers/watchdog/of_xilinx_wdt.ko] undefined!
    
    Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c5ec618fbf83045b9d51679d809ddd45f990fe0a
Author: Chen-Yu Tsai <wens@csie.org>
Date:   Mon Sep 22 00:05:19 2014 +0800

    watchdog: sunxi: Add A31 watchdog support
    
    This patch adds support for the watchdog hardware found in A31 and
    newer SoCs. This new hardware has registers at different offsets, and
    the system reset control has been split out of the "mode" register
    into a new "configuration" register.
    
    Differences not supported by this driver include separate interrupt
    lines for each watchdog, instead of sharing an interrupt line and
    registers with the timer block.
    
    Signed-off-by: Chen-Yu Tsai <wens@csie.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f2147de334703c7c44372f013d7d466d756e6943
Author: Chen-Yu Tsai <wens@csie.org>
Date:   Mon Sep 22 00:05:18 2014 +0800

    watchdog: sunxi: support parameterized compatible strings
    
    This patch adds support for hardware parameters tied to compatible
    strings, so similar hardware can reuse the driver.
    
    This will be used to support the newer watchdog found in A31 and
    later SoCs. Differences in the new hardware include separate
    interrupt lines for each watchdog, and corresponding interrupt
    control/status registers. Watchdog control registers were also
    slightly rearranged.
    
    Also replace ioread32()/iowrite32() with readl()/writel() in various
    places changed.
    
    Signed-off-by: Chen-Yu Tsai <wens@csie.org>
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Heiko Stuebner <heiko@sntech.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

commit 334a9d8131254e06685b2af0c0f3cc7b3ec5bd04
Author: Jingchang Lu <jingchang.lu@freescale.com>
Date:   Fri Sep 12 15:24:36 2014 +0800

    watchdog: imx2_wdt: add restart handler support
    
      Register the watchdog as the system restart function
    to the new introducing kernel restart call chain in the
    driver instead of providing the restart in machine desc.
      This restart handler function is from the mxc_restart()
    in arch/arm/mach-imx/system.c
    
    Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 05e487d905ab29b5756d6d1e47e27eefa6693fb3
Author: Josh Cartwright <joshc@codeaurora.org>
Date:   Thu Sep 25 17:51:04 2014 -0500

    watchdog: qcom: register a restart notifier
    
    The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
    resort mechanism for triggering chip reset.  Usually, other restart
    methods (such as PS_HOLD) are preferrable for issuing a more complete
    reset of the chip.  As such, keep the priority of the watchdog notifier
    low.
    
    Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f286e1335f579dfd970c7fc3f62b248773a47a5c
Author: Heiko Stuebner <heiko@sntech.de>
Date:   Tue Aug 19 17:45:36 2014 -0700

    watchdog: s3c2410: add restart handler
    
    On a lot of Samsung systems the watchdog is responsible for restarting the
    system and until now this code was contained in plat-samsung/watchdog-reset.c.
    
    With the introduction of the restart handlers, this code can now move into
    driver itself, removing the need for arch-specific code.
    
    Tested on a S3C2442 based GTA02
    
    Signed-off-by: Heiko Stuebner <heiko@sntech.de>
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

commit 31228f43ab528628c9b5f1351604361aa1d78533
Author: Jisheng Zhang <jszhang@marvell.com>
Date:   Tue Sep 23 15:42:12 2014 +0800

    watchdog: dw_wdt: add restart handler support
    
    The kernel core now provides an API to trigger a system restart.
    Register with it to support restarting the system via. watchdog.
    
    Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 69a160a0543fd569661048a8692c10afcdb1914b
Author: Carlo Caione <carlo@caione.org>
Date:   Sat Sep 20 19:06:52 2014 +0200

    ARM: defconfig: update multi_v7_defconfig
    
    Update the multi_v7_defconfig enabling the watchdog driver for Meson
    SoCs.
    
    Signed-off-by: Carlo Caione <carlo@caione.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 22e1b8f60f913cf71e688af9b64317b515303f4c
Author: Carlo Caione <carlo@caione.org>
Date:   Sat Sep 20 19:06:50 2014 +0200

    ARM: meson: add watchdog driver
    
    This patch adds the watchdog driver for the Amlogic Meson SoCs used also
    to reboot the device.
    
    Signed-off-by: Carlo Caione <carlo@caione.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0c5691f00879cacf98a31b873c02d71c66d72855
Author: Carlo Caione <carlo@caione.org>
Date:   Sat Sep 20 19:06:49 2014 +0200

    ARM: docs: add documentation binding for meson watchdog
    
    Signed-off-by: Carlo Caione <carlo@caione.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3281b85c8697938e344d67144ca8ba520fa54d2b
Author: Janusz Uzycki <j.uzycki@elproma.com.pl>
Date:   Mon Sep 22 22:55:47 2014 +0200

    stmp3xxx_rtc_wdt: Add suspend/resume PM support
    
    There is no conflict with rtc/rtc-stmp3xxx.c parent
    because modified registers in PM functions of stmp3xxx_rtc_wdt
    are different.
    
    Signed-off-by: Janusz Uzycki <j.uzycki@elproma.com.pl>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5e9c16e3760893b3721f599f180795ca7160afef
Author: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date:   Sun Sep 28 19:05:45 2014 +0200

    watchdog: Add DA9063 PMIC watchdog driver.
    
    This driver supports the watchdog device inside the DA9063 PMIC.
    
    Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
    Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
    Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
    Acked-by: Steve Twiss <stwiss.opensource@diasemi.com>
    Tested-by: Steve Twiss <stwiss.opensource@diasemi.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 22b1c841e31510c3124c88a13b8a7ada14e2e2d1
Author: Beniamino Galvani <b.galvani@gmail.com>
Date:   Mon Sep 29 00:39:47 2014 +0200

    watchdog: add driver for Ricoh RN5T618 watchdog
    
    This adds a driver for the watchdog timer available in Ricoh RN5T618
    PMIC. The device supports a programmable expiration time of 1, 8, 32
    or 128 seconds.
    
    Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2b9366b669679f1388457ec5a62f9dd1d0a78b08
Author: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Date:   Wed Aug 27 15:17:11 2014 +0530

    watchdog: s3c2410_wdt: Add support for Watchdog device on Exynos7
    
    Exynos7 SoC has a Watchdog for Atlas (A57) cores
    This patch adds support for the Atlas watchdog.
    
    Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7c92c3d58429c38557ffd7e6a69dc97522335454
Author: Josh Cartwright <joshc@codeaurora.org>
Date:   Thu Sep 25 17:51:03 2014 -0500

    watchdog: qcom: document device tree bindings
    
    The Qualcomm Krait Processor Sub-system (KPSS) contains one or more
    instances of the WDT.  Provide documentation on how to describe these in
    the device tree.
    
    Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1094ebe9d1e1dde0754ff8cede16159fb20b2f3b
Author: Josh Cartwright <joshc@codeaurora.org>
Date:   Thu Sep 25 17:51:02 2014 -0500

    watchdog: qcom: add support for KPSS WDT
    
    Add a driver for the watchdog timer block found in the Krait Processor
    Subsystem (KPSS) on the MSM8960, APQ8064, and IPQ8064.
    
    Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit dfa07141e7a792aecf98a8a99dd40df0bf91bce2
Author: Jisheng Zhang <jszhang@marvell.com>
Date:   Tue Sep 23 15:42:11 2014 +0800

    watchdog: dw_wdt: initialise TOP_INIT in dw_wdt_set_top()
    
    The TOP_INIT, ie bit 4-7 of the WDOG_TIMEOUT_RANGE_REG_OFFSET register
    may be zero, so the timeout period may be very short after initialization
    is done, thus the system may be reset soon after enabling. We fix this
    problem by also initialising the TOP_INIT when setting TOP in function
    dw_wdt_set_top().
    
    Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 191891c0378f44aec8e06e889a08d0b76fe6c5cb
Author: Harini Katakam <harinik@xilinx.com>
Date:   Fri Aug 22 14:58:02 2014 +0530

    devicetree: Add Cadence WDT devicetree bindings documentation
    
    Add cadence-wdt bindings documentation.
    
    Signed-off-by: Harini Katakam <harinik@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 58bf016426594e5370e7e7059698a278294db997
Author: Harini Katakam <harinik@xilinx.com>
Date:   Fri Aug 22 14:58:01 2014 +0530

    watchdog: Add Cadence WDT driver
    
    Add Cadence WDT driver. This is used by Xilinx Zynq.
    
    Signed-off-by: Harini Katakam <harinik@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4846e3784585173f48e267b76f968bcb4a12d3b2
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Tue Sep 9 22:18:31 2014 +0200

    watchdog: simplify definitions of WATCHDOG_NOWAYOUT(_INIT_STATUS)?
    
    Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0461aea7ec379b00f4acb5d612bfb2f7a497eb92
Author: Xiubo Li <Li.Xiubo@freescale.com>
Date:   Mon Aug 18 16:12:50 2014 +0800

    watchdog: imx2_wdt: Convert to use regmap framework's endianness method.
    
    Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1f897a81915222310374cac1a85c0c7104f16249
Author: Mika Westerberg <mika.westerberg@linux.intel.com>
Date:   Tue Aug 19 14:57:12 2014 +0300

    watchdog: ts72xx_wdt: Kill superfluous variable in remove
    
    There is no need to store the return value of misc_deregister() in a
    variable. Instead we can just return the value directly.
    
    Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 62ce25439a7ea01eba5c2a6a8284e4aa23890042
Author: Pranith Kumar <bobby.prani@gmail.com>
Date:   Wed Aug 20 15:26:46 2014 -0400

    powerpc: booke_wdt: Fix build error as a module
    
    Building booke_wdt fails when trying to build as a module as there is no
    early_param() in module. Fix by using module_param() instead of early_param().
    
    Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fca8c0481bc8d751479ca13f454e89a7fdfece03
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Wed Aug 13 13:51:28 2014 +0200

    watchdog: xilinx: Remove .owner field for driver
    
    There is no need to init .owner field.
    
    Based on the patch from Peter Griffin <peter.griffin@linaro.org>
    "mmc: remove .owner field for drivers using module_platform_driver"
    
    This patch removes the superflous .owner field for drivers which
    use the module_platform_driver API, as this is overriden in
    platform_driver_register anyway."
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
new file mode 100644
index 0000000..c3a36ee
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
@@ -0,0 +1,24 @@
+Zynq Watchdog Device Tree Bindings
+-------------------------------------------
+
+Required properties:
+- compatible		: Should be "cdns,wdt-r1p2".
+- clocks		: This is pclk (APB clock).
+- interrupts		: This is wd_irq - watchdog timeout interrupt.
+- interrupt-parent	: Must be core interrupt controller.
+
+Optional properties
+- reset-on-timeout	: If this property exists, then a reset is done
+			  when watchdog times out.
+- timeout-sec		: Watchdog timeout value (in seconds).
+
+Example:
+	watchdog@f8005000 {
+		compatible = "cdns,wdt-r1p2";
+		clocks = <&clkc 45>;
+		interrupt-parent = <&intc>;
+		interrupts = <0 9 1>;
+		reg = <0xf8005000 0x1000>;
+		reset-on-timeout;
+		timeout-sec = <10>;
+	};
diff --git a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
index e52ba2d..8dab6fd 100644
--- a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
@@ -7,7 +7,8 @@ Required properties:
 
 Optional property:
 - big-endian: If present the watchdog device's registers are implemented
-  in big endian mode, otherwise in little mode.
+  in big endian mode, otherwise in native mode(same with CPU), for more
+  detail please see: Documentation/devicetree/bindings/regmap/regmap.txt.
 
 Examples:
 
diff --git a/Documentation/devicetree/bindings/watchdog/meson6-wdt.txt b/Documentation/devicetree/bindings/watchdog/meson6-wdt.txt
new file mode 100644
index 0000000..9200fc2
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/meson6-wdt.txt
@@ -0,0 +1,13 @@
+Meson SoCs Watchdog timer
+
+Required properties:
+
+- compatible : should be "amlogic,meson6-wdt"
+- reg : Specifies base physical address and size of the registers.
+
+Example:
+
+wdt: watchdog@c1109900 {
+	compatible = "amlogic,meson6-wdt";
+	reg = <0xc1109900 0x8>;
+};
diff --git a/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
new file mode 100644
index 0000000..4726924
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
@@ -0,0 +1,24 @@
+Qualcomm Krait Processor Sub-system (KPSS) Watchdog
+---------------------------------------------------
+
+Required properties :
+- compatible : shall contain only one of the following:
+
+			"qcom,kpss-wdt-msm8960"
+			"qcom,kpss-wdt-apq8064"
+			"qcom,kpss-wdt-ipq8064"
+
+- reg : shall contain base register location and length
+- clocks : shall contain the input clock
+
+Optional properties :
+- timeout-sec : shall contain the default watchdog timeout in seconds,
+                if unset, the default timeout is 30 seconds
+
+Example:
+	watchdog@208a038 {
+		compatible = "qcom,kpss-wdt-ipq8064";
+		reg = <0x0208a038 0x40>;
+		clocks = <&sleep_clk>;
+		timeout-sec = <10>;
+	};
diff --git a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
index cfff375..8f3d96a 100644
--- a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
@@ -9,6 +9,7 @@ Required properties:
 	(a) "samsung,s3c2410-wdt" for Exynos4 and previous SoCs
 	(b) "samsung,exynos5250-wdt" for Exynos5250
 	(c) "samsung,exynos5420-wdt" for Exynos5420
+	(c) "samsung,exynos7-wdt" for Exynos7
 
 - reg : base physical address of the controller and length of memory mapped
 	region.
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 491b7d5..9702b14 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -261,6 +261,7 @@ CONFIG_WATCHDOG=y
 CONFIG_XILINX_WATCHDOG=y
 CONFIG_ORION_WATCHDOG=y
 CONFIG_SUNXI_WATCHDOG=y
+CONFIG_MESON_WATCHDOG=y
 CONFIG_MFD_AS3722=y
 CONFIG_MFD_BCM590XX=y
 CONFIG_MFD_CROS_EC=y
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index e3d5bf0..d0107d4 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -87,6 +87,15 @@ config DA9055_WATCHDOG
 	  This driver can also be built as a module.  If so, the module
 	  will be called da9055_wdt.
 
+config DA9063_WATCHDOG
+	tristate "Dialog DA9063 Watchdog"
+	depends on MFD_DA9063
+	select WATCHDOG_CORE
+	help
+	  Support for the watchdog in the DA9063 PMIC.
+
+	  This driver can be built as a module. The module name is da9063_wdt.
+
 config GPIO_WATCHDOG
 	tristate "Watchdog device controlled through GPIO-line"
 	depends on OF_GPIO
@@ -123,6 +132,7 @@ config WM8350_WATCHDOG
 
 config XILINX_WATCHDOG
 	tristate "Xilinx Watchdog timer"
+	depends on HAS_IOMEM
 	select WATCHDOG_CORE
 	help
 	  Watchdog driver for the xps_timebase_wdt ip core.
@@ -157,6 +167,14 @@ config AT91SAM9X_WATCHDOG
 	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
 	  reboot your system when the timeout is reached.
 
+config CADENCE_WATCHDOG
+	tristate "Cadence Watchdog Timer"
+	depends on ARM
+	select WATCHDOG_CORE
+	help
+	  Say Y here if you want to include support for the watchdog
+	  timer in the Xilinx Zynq.
+
 config 21285_WATCHDOG
 	tristate "DC21285 watchdog"
 	depends on FOOTBRIDGE
@@ -319,6 +337,17 @@ config ORION_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called orion_wdt.
 
+config RN5T618_WATCHDOG
+	tristate "Ricoh RN5T618 watchdog"
+	depends on MFD_RN5T618
+	select WATCHDOG_CORE
+	help
+	  If you say yes here you get support for watchdog on the Ricoh
+	  RN5T618 PMIC.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called rn5t618_wdt.
+
 config SUNXI_WATCHDOG
 	tristate "Allwinner SoCs watchdog support"
 	depends on ARCH_SUNXI
@@ -444,7 +473,7 @@ config SIRFSOC_WATCHDOG
 
 config TEGRA_WATCHDOG
 	tristate "Tegra watchdog"
-	depends on ARCH_TEGRA || COMPILE_TEST
+	depends on (ARCH_TEGRA || COMPILE_TEST) && HAS_IOMEM
 	select WATCHDOG_CORE
 	help
 	  Say Y here to include support for the watchdog timer
@@ -453,6 +482,29 @@ config TEGRA_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called tegra_wdt.
 
+config QCOM_WDT
+	tristate "QCOM watchdog"
+	depends on HAS_IOMEM
+	depends on ARCH_QCOM
+	select WATCHDOG_CORE
+	help
+	  Say Y here to include Watchdog timer support for the watchdog found
+	  on QCOM chipsets.  Currently supported targets are the MSM8960,
+	  APQ8064, and IPQ8064.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qcom_wdt.
+
+config MESON_WATCHDOG
+	tristate "Amlogic Meson SoCs watchdog support"
+	depends on ARCH_MESON
+	select WATCHDOG_CORE
+	help
+	  Say Y here to include support for the watchdog timer
+	  in Amlogic Meson SoCs.
+	  To compile this driver as a module, choose M here: the
+	  module will be called meson_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index de17014..c569ec8 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_USBPCWATCHDOG) += pcwd_usb.o
 obj-$(CONFIG_ARM_SP805_WATCHDOG) += sp805_wdt.o
 obj-$(CONFIG_AT91RM9200_WATCHDOG) += at91rm9200_wdt.o
 obj-$(CONFIG_AT91SAM9X_WATCHDOG) += at91sam9_wdt.o
+obj-$(CONFIG_CADENCE_WATCHDOG) += cadence_wdt.o
 obj-$(CONFIG_OMAP_WATCHDOG) += omap_wdt.o
 obj-$(CONFIG_TWL4030_WATCHDOG) += twl4030_wdt.o
 obj-$(CONFIG_21285_WATCHDOG) += wdt285.o
@@ -47,6 +48,7 @@ obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
 obj-$(CONFIG_SUNXI_WATCHDOG) += sunxi_wdt.o
+obj-$(CONFIG_RN5T618_WATCHDOG) += rn5t618_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_RTC_WATCHDOG) += stmp3xxx_rtc_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
@@ -57,8 +59,10 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
 obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
+obj-$(CONFIG_QCOM_WDT) += qcom-wdt.o
 obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
 obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
+obj-$(CONFIG_MESON_WATCHDOG) += meson_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
@@ -173,6 +177,7 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 # Architecture Independent
 obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_DA9055_WATCHDOG) += da9055_wdt.o
+obj-$(CONFIG_DA9063_WATCHDOG) += da9063_wdt.o
 obj-$(CONFIG_GPIO_WATCHDOG)	+= gpio_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 08a7853..e96b09b 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -30,8 +30,6 @@
  * occur, and the final time the board will reset.
  */
 
-u32 booke_wdt_enabled;
-u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 
 #ifdef	CONFIG_PPC_FSL_BOOK3E
 #define WDTP(x)		((((x)&0x3)<<30)|(((x)&0x3c)<<15))
@@ -41,27 +39,10 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 #define WDTP_MASK	(TCR_WP_MASK)
 #endif
 
-/* Checks wdt=x and wdt_period=xx command-line option */
-notrace int __init early_parse_wdt(char *p)
-{
-	if (p && strncmp(p, "0", 1) != 0)
-		booke_wdt_enabled = 1;
-
-	return 0;
-}
-early_param("wdt", early_parse_wdt);
-
-int __init early_parse_wdt_period(char *p)
-{
-	unsigned long ret;
-	if (p) {
-		if (!kstrtol(p, 0, &ret))
-			booke_wdt_period = ret;
-	}
-
-	return 0;
-}
-early_param("wdt_period", early_parse_wdt_period);
+static bool booke_wdt_enabled;
+module_param(booke_wdt_enabled, bool, 0);
+static int  booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
+module_param(booke_wdt_period, int, 0);
 
 #ifdef CONFIG_PPC_FSL_BOOK3E
 
@@ -259,5 +240,6 @@ static int __init booke_wdt_init(void)
 module_init(booke_wdt_init);
 module_exit(booke_wdt_exit);
 
+MODULE_ALIAS("booke_wdt");
 MODULE_DESCRIPTION("PowerPC Book-E watchdog driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/cadence_wdt.c b/drivers/watchdog/cadence_wdt.c
new file mode 100644
index 0000000..5927c0a
--- /dev/null
+++ b/drivers/watchdog/cadence_wdt.c
@@ -0,0 +1,516 @@
+/*
+ * Cadence WDT driver - Used by Xilinx Zynq
+ *
+ * Copyright (C) 2010 - 2014 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
+
+#define CDNS_WDT_DEFAULT_TIMEOUT	10
+/* Supports 1 - 516 sec */
+#define CDNS_WDT_MIN_TIMEOUT	1
+#define CDNS_WDT_MAX_TIMEOUT	516
+
+/* Restart key */
+#define CDNS_WDT_RESTART_KEY 0x00001999
+
+/* Counter register access key */
+#define CDNS_WDT_REGISTER_ACCESS_KEY 0x00920000
+
+/* Counter value divisor */
+#define CDNS_WDT_COUNTER_VALUE_DIVISOR 0x1000
+
+/* Clock prescaler value and selection */
+#define CDNS_WDT_PRESCALE_64	64
+#define CDNS_WDT_PRESCALE_512	512
+#define CDNS_WDT_PRESCALE_4096	4096
+#define CDNS_WDT_PRESCALE_SELECT_64	1
+#define CDNS_WDT_PRESCALE_SELECT_512	2
+#define CDNS_WDT_PRESCALE_SELECT_4096	3
+
+/* Input clock frequency */
+#define CDNS_WDT_CLK_10MHZ	10000000
+#define CDNS_WDT_CLK_75MHZ	75000000
+
+/* Counter maximum value */
+#define CDNS_WDT_COUNTER_MAX 0xFFF
+
+static int wdt_timeout = CDNS_WDT_DEFAULT_TIMEOUT;
+static int nowayout = WATCHDOG_NOWAYOUT;
+
+module_param(wdt_timeout, int, 0);
+MODULE_PARM_DESC(wdt_timeout,
+		 "Watchdog time in seconds. (default="
+		 __MODULE_STRING(CDNS_WDT_DEFAULT_TIMEOUT) ")");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/**
+ * struct cdns_wdt - Watchdog device structure
+ * @regs: baseaddress of device
+ * @rst: reset flag
+ * @clk: struct clk * of a clock source
+ * @prescaler: for saving prescaler value
+ * @ctrl_clksel: counter clock prescaler selection
+ * @io_lock: spinlock for IO register access
+ * @cdns_wdt_device: watchdog device structure
+ * @cdns_wdt_notifier: notifier structure
+ *
+ * Structure containing parameters specific to cadence watchdog.
+ */
+struct cdns_wdt {
+	void __iomem		*regs;
+	bool			rst;
+	struct clk		*clk;
+	u32			prescaler;
+	u32			ctrl_clksel;
+	spinlock_t		io_lock;
+	struct watchdog_device	cdns_wdt_device;
+	struct notifier_block	cdns_wdt_notifier;
+};
+
+/* Write access to Registers */
+static inline void cdns_wdt_writereg(struct cdns_wdt *wdt, u32 offset, u32 val)
+{
+	writel_relaxed(val, wdt->regs + offset);
+}
+
+/*************************Register Map**************************************/
+
+/* Register Offsets for the WDT */
+#define CDNS_WDT_ZMR_OFFSET	0x0	/* Zero Mode Register */
+#define CDNS_WDT_CCR_OFFSET	0x4	/* Counter Control Register */
+#define CDNS_WDT_RESTART_OFFSET	0x8	/* Restart Register */
+#define CDNS_WDT_SR_OFFSET	0xC	/* Status Register */
+
+/*
+ * Zero Mode Register - This register controls how the time out is indicated
+ * and also contains the access code to allow writes to the register (0xABC).
+ */
+#define CDNS_WDT_ZMR_WDEN_MASK	0x00000001 /* Enable the WDT */
+#define CDNS_WDT_ZMR_RSTEN_MASK	0x00000002 /* Enable the reset output */
+#define CDNS_WDT_ZMR_IRQEN_MASK	0x00000004 /* Enable IRQ output */
+#define CDNS_WDT_ZMR_RSTLEN_16	0x00000030 /* Reset pulse of 16 pclk cycles */
+#define CDNS_WDT_ZMR_ZKEY_VAL	0x00ABC000 /* Access key, 0xABC << 12 */
+/*
+ * Counter Control register - This register controls how fast the timer runs
+ * and the reset value and also contains the access code to allow writes to
+ * the register.
+ */
+#define CDNS_WDT_CCR_CRV_MASK	0x00003FFC /* Counter reset value */
+
+/**
+ * cdns_wdt_stop - Stop the watchdog.
+ *
+ * @wdd: watchdog device
+ *
+ * Read the contents of the ZMR register, clear the WDEN bit
+ * in the register and set the access key for successful write.
+ *
+ * Return: always 0
+ */
+static int cdns_wdt_stop(struct watchdog_device *wdd)
+{
+	struct cdns_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	spin_lock(&wdt->io_lock);
+	cdns_wdt_writereg(wdt, CDNS_WDT_ZMR_OFFSET,
+			  CDNS_WDT_ZMR_ZKEY_VAL & (~CDNS_WDT_ZMR_WDEN_MASK));
+	spin_unlock(&wdt->io_lock);
+
+	return 0;
+}
+
+/**
+ * cdns_wdt_reload - Reload the watchdog timer (i.e. pat the watchdog).
+ *
+ * @wdd: watchdog device
+ *
+ * Write the restart key value (0x00001999) to the restart register.
+ *
+ * Return: always 0
+ */
+static int cdns_wdt_reload(struct watchdog_device *wdd)
+{
+	struct cdns_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	spin_lock(&wdt->io_lock);
+	cdns_wdt_writereg(wdt, CDNS_WDT_RESTART_OFFSET,
+			  CDNS_WDT_RESTART_KEY);
+	spin_unlock(&wdt->io_lock);
+
+	return 0;
+}
+
+/**
+ * cdns_wdt_start - Enable and start the watchdog.
+ *
+ * @wdd: watchdog device
+ *
+ * The counter value is calculated according to the formula:
+ *		calculated count = (timeout * clock) / prescaler + 1.
+ * The calculated count is divided by 0x1000 to obtain the field value
+ * to write to counter control register.
+ * Clears the contents of prescaler and counter reset value. Sets the
+ * prescaler to 4096 and the calculated count and access key
+ * to write to CCR Register.
+ * Sets the WDT (WDEN bit) and either the Reset signal(RSTEN bit)
+ * or Interrupt signal(IRQEN) with a specified cycles and the access
+ * key to write to ZMR Register.
+ *
+ * Return: always 0
+ */
+static int cdns_wdt_start(struct watchdog_device *wdd)
+{
+	struct cdns_wdt *wdt = watchdog_get_drvdata(wdd);
+	unsigned int data = 0;
+	unsigned short count;
+	unsigned long clock_f = clk_get_rate(wdt->clk);
+
+	/*
+	 * Counter value divisor to obtain the value of
+	 * counter reset to be written to control register.
+	 */
+	count = (wdd->timeout * (clock_f / wdt->prescaler)) /
+		 CDNS_WDT_COUNTER_VALUE_DIVISOR + 1;
+
+	if (count > CDNS_WDT_COUNTER_MAX)
+		count = CDNS_WDT_COUNTER_MAX;
+
+	spin_lock(&wdt->io_lock);
+	cdns_wdt_writereg(wdt, CDNS_WDT_ZMR_OFFSET,
+			  CDNS_WDT_ZMR_ZKEY_VAL);
+
+	count = (count << 2) & CDNS_WDT_CCR_CRV_MASK;
+
+	/* Write counter access key first to be able write to register */
+	data = count | CDNS_WDT_REGISTER_ACCESS_KEY | wdt->ctrl_clksel;
+	cdns_wdt_writereg(wdt, CDNS_WDT_CCR_OFFSET, data);
+	data = CDNS_WDT_ZMR_WDEN_MASK | CDNS_WDT_ZMR_RSTLEN_16 |
+	       CDNS_WDT_ZMR_ZKEY_VAL;
+
+	/* Reset on timeout if specified in device tree. */
+	if (wdt->rst) {
+		data |= CDNS_WDT_ZMR_RSTEN_MASK;
+		data &= ~CDNS_WDT_ZMR_IRQEN_MASK;
+	} else {
+		data &= ~CDNS_WDT_ZMR_RSTEN_MASK;
+		data |= CDNS_WDT_ZMR_IRQEN_MASK;
+	}
+	cdns_wdt_writereg(wdt, CDNS_WDT_ZMR_OFFSET, data);
+	cdns_wdt_writereg(wdt, CDNS_WDT_RESTART_OFFSET,
+			  CDNS_WDT_RESTART_KEY);
+	spin_unlock(&wdt->io_lock);
+
+	return 0;
+}
+
+/**
+ * cdns_wdt_settimeout - Set a new timeout value for the watchdog device.
+ *
+ * @wdd: watchdog device
+ * @new_time: new timeout value that needs to be set
+ * Return: 0 on success
+ *
+ * Update the watchdog_device timeout with new value which is used when
+ * cdns_wdt_start is called.
+ */
+static int cdns_wdt_settimeout(struct watchdog_device *wdd,
+			       unsigned int new_time)
+{
+	wdd->timeout = new_time;
+
+	return cdns_wdt_start(wdd);
+}
+
+/**
+ * cdns_wdt_irq_handler - Notifies of watchdog timeout.
+ *
+ * @irq: interrupt number
+ * @dev_id: pointer to a platform device structure
+ * Return: IRQ_HANDLED
+ *
+ * The handler is invoked when the watchdog times out and a
+ * reset on timeout has not been enabled.
+ */
+static irqreturn_t cdns_wdt_irq_handler(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+
+	dev_info(&pdev->dev,
+		 "Watchdog timed out. Internal reset not enabled\n");
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Info structure used to indicate the features supported by the device
+ * to the upper layers. This is defined in watchdog.h header file.
+ */
+static struct watchdog_info cdns_wdt_info = {
+	.identity	= "cdns_wdt watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+			  WDIOF_MAGICCLOSE,
+};
+
+/* Watchdog Core Ops */
+static struct watchdog_ops cdns_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = cdns_wdt_start,
+	.stop = cdns_wdt_stop,
+	.ping = cdns_wdt_reload,
+	.set_timeout = cdns_wdt_settimeout,
+};
+
+/**
+ * cdns_wdt_notify_sys - Notifier for reboot or shutdown.
+ *
+ * @this: handle to notifier block
+ * @code: turn off indicator
+ * @unused: unused
+ * Return: NOTIFY_DONE
+ *
+ * This notifier is invoked whenever the system reboot or shutdown occur
+ * because we need to disable the WDT before system goes down as WDT might
+ * reset on the next boot.
+ */
+static int cdns_wdt_notify_sys(struct notifier_block *this, unsigned long code,
+			       void *unused)
+{
+	struct cdns_wdt *wdt = container_of(this, struct cdns_wdt,
+					    cdns_wdt_notifier);
+	if (code == SYS_DOWN || code == SYS_HALT)
+		cdns_wdt_stop(&wdt->cdns_wdt_device);
+
+	return NOTIFY_DONE;
+}
+
+/************************Platform Operations*****************************/
+/**
+ * cdns_wdt_probe - Probe call for the device.
+ *
+ * @pdev: handle to the platform device structure.
+ * Return: 0 on success, negative error otherwise.
+ *
+ * It does all the memory allocation and registration for the device.
+ */
+static int cdns_wdt_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret, irq;
+	unsigned long clock_f;
+	struct cdns_wdt *wdt;
+	struct watchdog_device *cdns_wdt_device;
+
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	cdns_wdt_device = &wdt->cdns_wdt_device;
+	cdns_wdt_device->info = &cdns_wdt_info;
+	cdns_wdt_device->ops = &cdns_wdt_ops;
+	cdns_wdt_device->timeout = CDNS_WDT_DEFAULT_TIMEOUT;
+	cdns_wdt_device->min_timeout = CDNS_WDT_MIN_TIMEOUT;
+	cdns_wdt_device->max_timeout = CDNS_WDT_MAX_TIMEOUT;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdt->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(wdt->regs))
+		return PTR_ERR(wdt->regs);
+
+	/* Register the interrupt */
+	wdt->rst = of_property_read_bool(pdev->dev.of_node, "reset-on-timeout");
+	irq = platform_get_irq(pdev, 0);
+	if (!wdt->rst && irq >= 0) {
+		ret = devm_request_irq(&pdev->dev, irq, cdns_wdt_irq_handler, 0,
+				       pdev->name, pdev);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"cannot register interrupt handler err=%d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	/* Initialize the members of cdns_wdt structure */
+	cdns_wdt_device->parent = &pdev->dev;
+
+	ret = watchdog_init_timeout(cdns_wdt_device, wdt_timeout, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to set timeout value\n");
+		return ret;
+	}
+
+	watchdog_set_nowayout(cdns_wdt_device, nowayout);
+	watchdog_set_drvdata(cdns_wdt_device, wdt);
+
+	wdt->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(wdt->clk)) {
+		dev_err(&pdev->dev, "input clock not found\n");
+		ret = PTR_ERR(wdt->clk);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(wdt->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to enable clock\n");
+		return ret;
+	}
+
+	clock_f = clk_get_rate(wdt->clk);
+	if (clock_f <= CDNS_WDT_CLK_75MHZ) {
+		wdt->prescaler = CDNS_WDT_PRESCALE_512;
+		wdt->ctrl_clksel = CDNS_WDT_PRESCALE_SELECT_512;
+	} else {
+		wdt->prescaler = CDNS_WDT_PRESCALE_4096;
+		wdt->ctrl_clksel = CDNS_WDT_PRESCALE_SELECT_4096;
+	}
+
+	spin_lock_init(&wdt->io_lock);
+
+	wdt->cdns_wdt_notifier.notifier_call = &cdns_wdt_notify_sys;
+	ret = register_reboot_notifier(&wdt->cdns_wdt_notifier);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "cannot register reboot notifier err=%d)\n",
+			ret);
+		goto err_clk_disable;
+	}
+
+	ret = watchdog_register_device(cdns_wdt_device);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register wdt device\n");
+		goto err_clk_disable;
+	}
+	platform_set_drvdata(pdev, wdt);
+
+	dev_dbg(&pdev->dev, "Xilinx Watchdog Timer at %p with timeout %ds%s\n",
+		 wdt->regs, cdns_wdt_device->timeout,
+		 nowayout ? ", nowayout" : "");
+
+	return 0;
+
+err_clk_disable:
+	clk_disable_unprepare(wdt->clk);
+
+	return ret;
+}
+
+/**
+ * cdns_wdt_remove - Probe call for the device.
+ *
+ * @pdev: handle to the platform device structure.
+ * Return: 0 on success, otherwise negative error.
+ *
+ * Unregister the device after releasing the resources.
+ */
+static int cdns_wdt_remove(struct platform_device *pdev)
+{
+	struct cdns_wdt *wdt = platform_get_drvdata(pdev);
+
+	cdns_wdt_stop(&wdt->cdns_wdt_device);
+	watchdog_unregister_device(&wdt->cdns_wdt_device);
+	unregister_reboot_notifier(&wdt->cdns_wdt_notifier);
+	clk_disable_unprepare(wdt->clk);
+
+	return 0;
+}
+
+/**
+ * cdns_wdt_shutdown - Stop the device.
+ *
+ * @pdev: handle to the platform structure.
+ *
+ */
+static void cdns_wdt_shutdown(struct platform_device *pdev)
+{
+	struct cdns_wdt *wdt = platform_get_drvdata(pdev);
+
+	cdns_wdt_stop(&wdt->cdns_wdt_device);
+	clk_disable_unprepare(wdt->clk);
+}
+
+/**
+ * cdns_wdt_suspend - Stop the device.
+ *
+ * @dev: handle to the device structure.
+ * Return: 0 always.
+ */
+static int __maybe_unused cdns_wdt_suspend(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
+	struct cdns_wdt *wdt = platform_get_drvdata(pdev);
+
+	cdns_wdt_stop(&wdt->cdns_wdt_device);
+	clk_disable_unprepare(wdt->clk);
+
+	return 0;
+}
+
+/**
+ * cdns_wdt_resume - Resume the device.
+ *
+ * @dev: handle to the device structure.
+ * Return: 0 on success, errno otherwise.
+ */
+static int __maybe_unused cdns_wdt_resume(struct device *dev)
+{
+	int ret;
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
+	struct cdns_wdt *wdt = platform_get_drvdata(pdev);
+
+	ret = clk_prepare_enable(wdt->clk);
+	if (ret) {
+		dev_err(dev, "unable to enable clock\n");
+		return ret;
+	}
+	cdns_wdt_start(&wdt->cdns_wdt_device);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(cdns_wdt_pm_ops, cdns_wdt_suspend, cdns_wdt_resume);
+
+static struct of_device_id cdns_wdt_of_match[] = {
+	{ .compatible = "cdns,wdt-r1p2", },
+	{ /* end of table */ }
+};
+MODULE_DEVICE_TABLE(of, cdns_wdt_of_match);
+
+/* Driver Structure */
+static struct platform_driver cdns_wdt_driver = {
+	.probe		= cdns_wdt_probe,
+	.remove		= cdns_wdt_remove,
+	.shutdown	= cdns_wdt_shutdown,
+	.driver		= {
+		.name	= "cdns-wdt",
+		.owner	= THIS_MODULE,
+		.of_match_table = cdns_wdt_of_match,
+		.pm	= &cdns_wdt_pm_ops,
+	},
+};
+
+module_platform_driver(cdns_wdt_driver);
+
+MODULE_AUTHOR("Xilinx, Inc.");
+MODULE_DESCRIPTION("Watchdog driver for Cadence WDT");
+MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/da9063_wdt.c b/drivers/watchdog/da9063_wdt.c
new file mode 100644
index 0000000..2cd6b2c
--- /dev/null
+++ b/drivers/watchdog/da9063_wdt.c
@@ -0,0 +1,191 @@
+/*
+ * Watchdog driver for DA9063 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: Mariusz Wojtasik <mariusz.wojtasik@diasemi.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/mfd/da9063/registers.h>
+#include <linux/mfd/da9063/core.h>
+#include <linux/regmap.h>
+
+/*
+ * Watchdog selector to timeout in seconds.
+ *   0: WDT disabled;
+ *   others: timeout = 2048 ms * 2^(TWDSCALE-1).
+ */
+static const unsigned int wdt_timeout[] = { 0, 2, 4, 8, 16, 32, 65, 131 };
+#define DA9063_TWDSCALE_DISABLE		0
+#define DA9063_TWDSCALE_MIN		1
+#define DA9063_TWDSCALE_MAX		(ARRAY_SIZE(wdt_timeout) - 1)
+#define DA9063_WDT_MIN_TIMEOUT		wdt_timeout[DA9063_TWDSCALE_MIN]
+#define DA9063_WDT_MAX_TIMEOUT		wdt_timeout[DA9063_TWDSCALE_MAX]
+#define DA9063_WDG_TIMEOUT		wdt_timeout[3]
+
+struct da9063_watchdog {
+	struct da9063 *da9063;
+	struct watchdog_device wdtdev;
+};
+
+static unsigned int da9063_wdt_timeout_to_sel(unsigned int secs)
+{
+	unsigned int i;
+
+	for (i = DA9063_TWDSCALE_MIN; i <= DA9063_TWDSCALE_MAX; i++) {
+		if (wdt_timeout[i] >= secs)
+			return i;
+	}
+
+	return DA9063_TWDSCALE_MAX;
+}
+
+static int _da9063_wdt_set_timeout(struct da9063 *da9063, unsigned int regval)
+{
+	return regmap_update_bits(da9063->regmap, DA9063_REG_CONTROL_D,
+				  DA9063_TWDSCALE_MASK, regval);
+}
+
+static int da9063_wdt_start(struct watchdog_device *wdd)
+{
+	struct da9063_watchdog *wdt = watchdog_get_drvdata(wdd);
+	unsigned int selector;
+	int ret;
+
+	selector = da9063_wdt_timeout_to_sel(wdt->wdtdev.timeout);
+	ret = _da9063_wdt_set_timeout(wdt->da9063, selector);
+	if (ret)
+		dev_err(wdt->da9063->dev, "Watchdog failed to start (err = %d)\n",
+			ret);
+
+	return ret;
+}
+
+static int da9063_wdt_stop(struct watchdog_device *wdd)
+{
+	struct da9063_watchdog *wdt = watchdog_get_drvdata(wdd);
+	int ret;
+
+	ret = regmap_update_bits(wdt->da9063->regmap, DA9063_REG_CONTROL_D,
+				 DA9063_TWDSCALE_MASK, DA9063_TWDSCALE_DISABLE);
+	if (ret)
+		dev_alert(wdt->da9063->dev, "Watchdog failed to stop (err = %d)\n",
+			  ret);
+
+	return ret;
+}
+
+static int da9063_wdt_ping(struct watchdog_device *wdd)
+{
+	struct da9063_watchdog *wdt = watchdog_get_drvdata(wdd);
+	int ret;
+
+	ret = regmap_write(wdt->da9063->regmap, DA9063_REG_CONTROL_F,
+			   DA9063_WATCHDOG);
+	if (ret)
+		dev_alert(wdt->da9063->dev, "Failed to ping the watchdog (err = %d)\n",
+			  ret);
+
+	return ret;
+}
+
+static int da9063_wdt_set_timeout(struct watchdog_device *wdd,
+				  unsigned int timeout)
+{
+	struct da9063_watchdog *wdt = watchdog_get_drvdata(wdd);
+	unsigned int selector;
+	int ret;
+
+	selector = da9063_wdt_timeout_to_sel(timeout);
+	ret = _da9063_wdt_set_timeout(wdt->da9063, selector);
+	if (ret)
+		dev_err(wdt->da9063->dev, "Failed to set watchdog timeout (err = %d)\n",
+			ret);
+	else
+		wdd->timeout = wdt_timeout[selector];
+
+	return ret;
+}
+
+static const struct watchdog_info da9063_watchdog_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "DA9063 Watchdog",
+};
+
+static const struct watchdog_ops da9063_watchdog_ops = {
+	.owner = THIS_MODULE,
+	.start = da9063_wdt_start,
+	.stop = da9063_wdt_stop,
+	.ping = da9063_wdt_ping,
+	.set_timeout = da9063_wdt_set_timeout,
+};
+
+static int da9063_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct da9063 *da9063;
+	struct da9063_watchdog *wdt;
+
+	if (!pdev->dev.parent)
+		return -EINVAL;
+
+	da9063 = dev_get_drvdata(pdev->dev.parent);
+	if (!da9063)
+		return -EINVAL;
+
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	wdt->da9063 = da9063;
+
+	wdt->wdtdev.info = &da9063_watchdog_info;
+	wdt->wdtdev.ops = &da9063_watchdog_ops;
+	wdt->wdtdev.min_timeout = DA9063_WDT_MIN_TIMEOUT;
+	wdt->wdtdev.max_timeout = DA9063_WDT_MAX_TIMEOUT;
+	wdt->wdtdev.timeout = DA9063_WDG_TIMEOUT;
+
+	wdt->wdtdev.status = WATCHDOG_NOWAYOUT_INIT_STATUS;
+
+	watchdog_set_drvdata(&wdt->wdtdev, wdt);
+	dev_set_drvdata(&pdev->dev, wdt);
+
+	ret = watchdog_register_device(&wdt->wdtdev);
+
+	return ret;
+}
+
+static int da9063_wdt_remove(struct platform_device *pdev)
+{
+	struct da9063_watchdog *wdt = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&wdt->wdtdev);
+
+	return 0;
+}
+
+static struct platform_driver da9063_wdt_driver = {
+	.probe = da9063_wdt_probe,
+	.remove = da9063_wdt_remove,
+	.driver = {
+		.name = DA9063_DRVNAME_WATCHDOG,
+	},
+};
+module_platform_driver(da9063_wdt_driver);
+
+MODULE_AUTHOR("Mariusz Wojtasik <mariusz.wojtasik@diasemi.com>");
+MODULE_DESCRIPTION("Watchdog driver for Dialog DA9063");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DA9063_DRVNAME_WATCHDOG);
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 9f21029..9e577a6 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -21,6 +21,7 @@
 
 #include <linux/bitops.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/fs.h>
@@ -29,9 +30,11 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/uaccess.h>
@@ -40,6 +43,7 @@
 #define WDOG_CONTROL_REG_OFFSET		    0x00
 #define WDOG_CONTROL_REG_WDT_EN_MASK	    0x01
 #define WDOG_TIMEOUT_RANGE_REG_OFFSET	    0x04
+#define WDOG_TIMEOUT_RANGE_TOPINIT_SHIFT    4
 #define WDOG_CURRENT_COUNT_REG_OFFSET	    0x08
 #define WDOG_COUNTER_RESTART_REG_OFFSET     0x0c
 #define WDOG_COUNTER_RESTART_KICK_VALUE	    0x76
@@ -62,6 +66,7 @@ static struct {
 	unsigned long		next_heartbeat;
 	struct timer_list	timer;
 	int			expect_close;
+	struct notifier_block	restart_handler;
 } dw_wdt;
 
 static inline int dw_wdt_is_enabled(void)
@@ -106,7 +111,8 @@ static int dw_wdt_set_top(unsigned top_s)
 		}
 
 	/* Set the new value in the watchdog. */
-	writel(top_val, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
+	writel(top_val | top_val << WDOG_TIMEOUT_RANGE_TOPINIT_SHIFT,
+		dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
 
 	dw_wdt_set_next_heartbeat();
 
@@ -119,6 +125,26 @@ static void dw_wdt_keepalive(void)
 	       WDOG_COUNTER_RESTART_REG_OFFSET);
 }
 
+static int dw_wdt_restart_handle(struct notifier_block *this,
+				unsigned long mode, void *cmd)
+{
+	u32 val;
+
+	writel(0, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
+	val = readl(dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
+	if (val & WDOG_CONTROL_REG_WDT_EN_MASK)
+		writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
+			WDOG_COUNTER_RESTART_REG_OFFSET);
+	else
+		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
+		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
+
+	/* wait for reset to assert... */
+	mdelay(500);
+
+	return NOTIFY_DONE;
+}
+
 static void dw_wdt_ping(unsigned long data)
 {
 	if (time_before(jiffies, dw_wdt.next_heartbeat) ||
@@ -314,6 +340,12 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_disable_clk;
 
+	dw_wdt.restart_handler.notifier_call = dw_wdt_restart_handle;
+	dw_wdt.restart_handler.priority = 128;
+	ret = register_restart_handler(&dw_wdt.restart_handler);
+	if (ret)
+		pr_warn("cannot register restart handler\n");
+
 	dw_wdt_set_next_heartbeat();
 	setup_timer(&dw_wdt.timer, dw_wdt_ping, 0);
 	mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
@@ -328,6 +360,8 @@ out_disable_clk:
 
 static int dw_wdt_drv_remove(struct platform_device *pdev)
 {
+	unregister_restart_handler(&dw_wdt.restart_handler);
+
 	misc_deregister(&dw_wdt_miscdev);
 
 	clk_disable_unprepare(dw_wdt.clk);
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 68c3d37..7e12f88 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -22,14 +22,17 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
 #include <linux/watchdog.h>
@@ -59,6 +62,7 @@ struct imx2_wdt_device {
 	struct regmap *regmap;
 	struct timer_list timer;	/* Pings the watchdog when closed */
 	struct watchdog_device wdog;
+	struct notifier_block restart_handler;
 };
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
@@ -77,6 +81,31 @@ static const struct watchdog_info imx2_wdt_info = {
 	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
 };
 
+static int imx2_restart_handler(struct notifier_block *this, unsigned long mode,
+				void *cmd)
+{
+	unsigned int wcr_enable = IMX2_WDT_WCR_WDE;
+	struct imx2_wdt_device *wdev = container_of(this,
+						    struct imx2_wdt_device,
+						    restart_handler);
+	/* Assert SRS signal */
+	regmap_write(wdev->regmap, 0, wcr_enable);
+	/*
+	 * Due to imx6q errata ERR004346 (WDOG: WDOG SRS bit requires to be
+	 * written twice), we add another two writes to ensure there must be at
+	 * least two writes happen in the same one 32kHz clock period.  We save
+	 * the target check here, since the writes shouldn't be a huge burden
+	 * for other platforms.
+	 */
+	regmap_write(wdev->regmap, 0, wcr_enable);
+	regmap_write(wdev->regmap, 0, wcr_enable);
+
+	/* wait for reset to assert... */
+	mdelay(500);
+
+	return NOTIFY_DONE;
+}
+
 static inline void imx2_wdt_setup(struct watchdog_device *wdog)
 {
 	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
@@ -191,12 +220,10 @@ static struct regmap_config imx2_wdt_regmap_config = {
 
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct imx2_wdt_device *wdev;
 	struct watchdog_device *wdog;
 	struct resource *res;
 	void __iomem *base;
-	bool big_endian;
 	int ret;
 	u32 val;
 
@@ -204,10 +231,6 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 	if (!wdev)
 		return -ENOMEM;
 
-	big_endian = of_property_read_bool(np, "big-endian");
-	if (big_endian)
-		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
@@ -257,6 +280,12 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	wdev->restart_handler.notifier_call = imx2_restart_handler;
+	wdev->restart_handler.priority = 128;
+	ret = register_restart_handler(&wdev->restart_handler);
+	if (ret)
+		dev_err(&pdev->dev, "cannot register restart handler\n");
+
 	dev_info(&pdev->dev, "timeout %d sec (nowayout=%d)\n",
 		 wdog->timeout, nowayout);
 
@@ -268,6 +297,8 @@ static int __exit imx2_wdt_remove(struct platform_device *pdev)
 	struct watchdog_device *wdog = platform_get_drvdata(pdev);
 	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
 
+	unregister_restart_handler(&wdev->restart_handler);
+
 	watchdog_unregister_device(wdog);
 
 	if (imx2_wdt_is_running(wdev)) {
diff --git a/drivers/watchdog/meson_wdt.c b/drivers/watchdog/meson_wdt.c
new file mode 100644
index 0000000..ef6a298
--- /dev/null
+++ b/drivers/watchdog/meson_wdt.c
@@ -0,0 +1,236 @@
+/*
+ *      Meson Watchdog Driver
+ *
+ *      Copyright (c) 2014 Carlo Caione
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+
+#define DRV_NAME		"meson_wdt"
+
+#define MESON_WDT_TC		0x00
+#define MESON_WDT_TC_EN		BIT(22)
+#define MESON_WDT_TC_TM_MASK	0x3fffff
+#define MESON_WDT_DC_RESET	(3 << 24)
+
+#define MESON_WDT_RESET		0x04
+
+#define MESON_WDT_TIMEOUT	30
+#define MESON_WDT_MIN_TIMEOUT	1
+#define MESON_WDT_MAX_TIMEOUT	(MESON_WDT_TC_TM_MASK / 100000)
+
+#define MESON_SEC_TO_TC(s)	((s) * 100000)
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int timeout = MESON_WDT_TIMEOUT;
+
+struct meson_wdt_dev {
+	struct watchdog_device wdt_dev;
+	void __iomem *wdt_base;
+	struct notifier_block restart_handler;
+};
+
+static int meson_restart_handle(struct notifier_block *this, unsigned long mode,
+				void *cmd)
+{
+	u32 tc_reboot = MESON_WDT_DC_RESET | MESON_WDT_TC_EN;
+	struct meson_wdt_dev *meson_wdt = container_of(this,
+						       struct meson_wdt_dev,
+						       restart_handler);
+
+	while (1) {
+		writel(tc_reboot, meson_wdt->wdt_base + MESON_WDT_TC);
+		mdelay(5);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int meson_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct meson_wdt_dev *meson_wdt = watchdog_get_drvdata(wdt_dev);
+
+	writel(0, meson_wdt->wdt_base + MESON_WDT_RESET);
+
+	return 0;
+}
+
+static void meson_wdt_change_timeout(struct watchdog_device *wdt_dev,
+				     unsigned int timeout)
+{
+	struct meson_wdt_dev *meson_wdt = watchdog_get_drvdata(wdt_dev);
+	u32 reg;
+
+	reg = readl(meson_wdt->wdt_base + MESON_WDT_TC);
+	reg &= ~MESON_WDT_TC_TM_MASK;
+	reg |= MESON_SEC_TO_TC(timeout);
+	writel(reg, meson_wdt->wdt_base + MESON_WDT_TC);
+}
+
+static int meson_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				 unsigned int timeout)
+{
+	wdt_dev->timeout = timeout;
+
+	meson_wdt_change_timeout(wdt_dev, timeout);
+	meson_wdt_ping(wdt_dev);
+
+	return 0;
+}
+
+static int meson_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	struct meson_wdt_dev *meson_wdt = watchdog_get_drvdata(wdt_dev);
+	u32 reg;
+
+	reg = readl(meson_wdt->wdt_base + MESON_WDT_TC);
+	reg &= ~MESON_WDT_TC_EN;
+	writel(reg, meson_wdt->wdt_base + MESON_WDT_TC);
+
+	return 0;
+}
+
+static int meson_wdt_start(struct watchdog_device *wdt_dev)
+{
+	struct meson_wdt_dev *meson_wdt = watchdog_get_drvdata(wdt_dev);
+	u32 reg;
+
+	meson_wdt_change_timeout(wdt_dev, meson_wdt->wdt_dev.timeout);
+	meson_wdt_ping(wdt_dev);
+
+	reg = readl(meson_wdt->wdt_base + MESON_WDT_TC);
+	reg |= MESON_WDT_TC_EN;
+	writel(reg, meson_wdt->wdt_base + MESON_WDT_TC);
+
+	return 0;
+}
+
+static const struct watchdog_info meson_wdt_info = {
+	.identity	= DRV_NAME,
+	.options	= WDIOF_SETTIMEOUT |
+			  WDIOF_KEEPALIVEPING |
+			  WDIOF_MAGICCLOSE,
+};
+
+static const struct watchdog_ops meson_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= meson_wdt_start,
+	.stop		= meson_wdt_stop,
+	.ping		= meson_wdt_ping,
+	.set_timeout	= meson_wdt_set_timeout,
+};
+
+static int meson_wdt_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct meson_wdt_dev *meson_wdt;
+	int err;
+
+	meson_wdt = devm_kzalloc(&pdev->dev, sizeof(*meson_wdt), GFP_KERNEL);
+	if (!meson_wdt)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	meson_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(meson_wdt->wdt_base))
+		return PTR_ERR(meson_wdt->wdt_base);
+
+	meson_wdt->wdt_dev.parent = &pdev->dev;
+	meson_wdt->wdt_dev.info = &meson_wdt_info;
+	meson_wdt->wdt_dev.ops = &meson_wdt_ops;
+	meson_wdt->wdt_dev.timeout = MESON_WDT_TIMEOUT;
+	meson_wdt->wdt_dev.max_timeout = MESON_WDT_MAX_TIMEOUT;
+	meson_wdt->wdt_dev.min_timeout = MESON_WDT_MIN_TIMEOUT;
+
+	watchdog_set_drvdata(&meson_wdt->wdt_dev, meson_wdt);
+
+	watchdog_init_timeout(&meson_wdt->wdt_dev, timeout, &pdev->dev);
+	watchdog_set_nowayout(&meson_wdt->wdt_dev, nowayout);
+
+	meson_wdt_stop(&meson_wdt->wdt_dev);
+
+	err = watchdog_register_device(&meson_wdt->wdt_dev);
+	if (err)
+		return err;
+
+	platform_set_drvdata(pdev, meson_wdt);
+
+	meson_wdt->restart_handler.notifier_call = meson_restart_handle;
+	meson_wdt->restart_handler.priority = 128;
+	err = register_restart_handler(&meson_wdt->restart_handler);
+	if (err)
+		dev_err(&pdev->dev,
+			"cannot register restart handler (err=%d)\n", err);
+
+	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
+		 meson_wdt->wdt_dev.timeout, nowayout);
+
+	return 0;
+}
+
+static int meson_wdt_remove(struct platform_device *pdev)
+{
+	struct meson_wdt_dev *meson_wdt = platform_get_drvdata(pdev);
+
+	unregister_restart_handler(&meson_wdt->restart_handler);
+
+	watchdog_unregister_device(&meson_wdt->wdt_dev);
+
+	return 0;
+}
+
+static void meson_wdt_shutdown(struct platform_device *pdev)
+{
+	struct meson_wdt_dev *meson_wdt = platform_get_drvdata(pdev);
+
+	meson_wdt_stop(&meson_wdt->wdt_dev);
+}
+
+static const struct of_device_id meson_wdt_dt_ids[] = {
+	{ .compatible = "amlogic,meson6-wdt" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, meson_wdt_dt_ids);
+
+static struct platform_driver meson_wdt_driver = {
+	.probe		= meson_wdt_probe,
+	.remove		= meson_wdt_remove,
+	.shutdown	= meson_wdt_shutdown,
+	.driver		= {
+		.owner		= THIS_MODULE,
+		.name		= DRV_NAME,
+		.of_match_table	= meson_wdt_dt_ids,
+	},
+};
+
+module_platform_driver(meson_wdt_driver);
+
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout, "Watchdog heartbeat in seconds");
+
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Carlo Caione <carlo@caione.org>");
+MODULE_DESCRIPTION("Meson Watchdog Timer Driver");
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 1e6e28d..b2e1b4c 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -236,7 +236,6 @@ static struct platform_driver xwdt_driver = {
 	.probe       = xwdt_probe,
 	.remove      = xwdt_remove,
 	.driver = {
-		.owner = THIS_MODULE,
 		.name  = WATCHDOG_NAME,
 		.of_match_table = xwdt_of_match,
 	},
diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
new file mode 100644
index 0000000..aa85618
--- /dev/null
+++ b/drivers/watchdog/qcom-wdt.c
@@ -0,0 +1,224 @@
+/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
+
+#define WDT_RST		0x0
+#define WDT_EN		0x8
+#define WDT_BITE_TIME	0x24
+
+struct qcom_wdt {
+	struct watchdog_device	wdd;
+	struct clk		*clk;
+	unsigned long		rate;
+	struct notifier_block	restart_nb;
+	void __iomem		*base;
+};
+
+static inline
+struct qcom_wdt *to_qcom_wdt(struct watchdog_device *wdd)
+{
+	return container_of(wdd, struct qcom_wdt, wdd);
+}
+
+static int qcom_wdt_start(struct watchdog_device *wdd)
+{
+	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
+
+	writel(0, wdt->base + WDT_EN);
+	writel(1, wdt->base + WDT_RST);
+	writel(wdd->timeout * wdt->rate, wdt->base + WDT_BITE_TIME);
+	writel(1, wdt->base + WDT_EN);
+	return 0;
+}
+
+static int qcom_wdt_stop(struct watchdog_device *wdd)
+{
+	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
+
+	writel(0, wdt->base + WDT_EN);
+	return 0;
+}
+
+static int qcom_wdt_ping(struct watchdog_device *wdd)
+{
+	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
+
+	writel(1, wdt->base + WDT_RST);
+	return 0;
+}
+
+static int qcom_wdt_set_timeout(struct watchdog_device *wdd,
+				unsigned int timeout)
+{
+	wdd->timeout = timeout;
+	return qcom_wdt_start(wdd);
+}
+
+static const struct watchdog_ops qcom_wdt_ops = {
+	.start		= qcom_wdt_start,
+	.stop		= qcom_wdt_stop,
+	.ping		= qcom_wdt_ping,
+	.set_timeout	= qcom_wdt_set_timeout,
+	.owner		= THIS_MODULE,
+};
+
+static const struct watchdog_info qcom_wdt_info = {
+	.options	= WDIOF_KEEPALIVEPING
+			| WDIOF_MAGICCLOSE
+			| WDIOF_SETTIMEOUT,
+	.identity	= KBUILD_MODNAME,
+};
+
+static int qcom_wdt_restart(struct notifier_block *nb, unsigned long action,
+			    void *data)
+{
+	struct qcom_wdt *wdt = container_of(nb, struct qcom_wdt, restart_nb);
+	u32 timeout;
+
+	/*
+	 * Trigger watchdog bite:
+	 *    Setup BITE_TIME to be 128ms, and enable WDT.
+	 */
+	timeout = 128 * wdt->rate / 1000;
+
+	writel(0, wdt->base + WDT_EN);
+	writel(1, wdt->base + WDT_RST);
+	writel(timeout, wdt->base + WDT_BITE_TIME);
+	writel(1, wdt->base + WDT_EN);
+
+	/*
+	 * Actually make sure the above sequence hits hardware before sleeping.
+	 */
+	wmb();
+
+	msleep(150);
+	return NOTIFY_DONE;
+}
+
+static int qcom_wdt_probe(struct platform_device *pdev)
+{
+	struct qcom_wdt *wdt;
+	struct resource *res;
+	int ret;
+
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdt->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(wdt->base))
+		return PTR_ERR(wdt->base);
+
+	wdt->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(wdt->clk)) {
+		dev_err(&pdev->dev, "failed to get input clock\n");
+		return PTR_ERR(wdt->clk);
+	}
+
+	ret = clk_prepare_enable(wdt->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to setup clock\n");
+		return ret;
+	}
+
+	/*
+	 * We use the clock rate to calculate the max timeout, so ensure it's
+	 * not zero to avoid a divide-by-zero exception.
+	 *
+	 * WATCHDOG_CORE assumes units of seconds, if the WDT is clocked such
+	 * that it would bite before a second elapses it's usefulness is
+	 * limited.  Bail if this is the case.
+	 */
+	wdt->rate = clk_get_rate(wdt->clk);
+	if (wdt->rate == 0 ||
+	    wdt->rate > 0x10000000U) {
+		dev_err(&pdev->dev, "invalid clock rate\n");
+		ret = -EINVAL;
+		goto err_clk_unprepare;
+	}
+
+	wdt->wdd.dev = &pdev->dev;
+	wdt->wdd.info = &qcom_wdt_info;
+	wdt->wdd.ops = &qcom_wdt_ops;
+	wdt->wdd.min_timeout = 1;
+	wdt->wdd.max_timeout = 0x10000000U / wdt->rate;
+
+	/*
+	 * If 'timeout-sec' unspecified in devicetree, assume a 30 second
+	 * default, unless the max timeout is less than 30 seconds, then use
+	 * the max instead.
+	 */
+	wdt->wdd.timeout = min(wdt->wdd.max_timeout, 30U);
+	watchdog_init_timeout(&wdt->wdd, 0, &pdev->dev);
+
+	ret = watchdog_register_device(&wdt->wdd);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register watchdog\n");
+		goto err_clk_unprepare;
+	}
+
+	/*
+	 * WDT restart notifier has priority 0 (use as a last resort)
+	 */
+	wdt->restart_nb.notifier_call = qcom_wdt_restart;
+	ret = register_restart_handler(&wdt->restart_nb);
+	if (ret)
+		dev_err(&pdev->dev, "failed to setup restart handler\n");
+
+	platform_set_drvdata(pdev, wdt);
+	return 0;
+
+err_clk_unprepare:
+	clk_disable_unprepare(wdt->clk);
+	return ret;
+}
+
+static int qcom_wdt_remove(struct platform_device *pdev)
+{
+	struct qcom_wdt *wdt = platform_get_drvdata(pdev);
+
+	unregister_restart_handler(&wdt->restart_nb);
+	watchdog_unregister_device(&wdt->wdd);
+	clk_disable_unprepare(wdt->clk);
+	return 0;
+}
+
+static const struct of_device_id qcom_wdt_of_table[] = {
+	{ .compatible = "qcom,kpss-wdt-msm8960", },
+	{ .compatible = "qcom,kpss-wdt-apq8064", },
+	{ .compatible = "qcom,kpss-wdt-ipq8064", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, qcom_wdt_of_table);
+
+static struct platform_driver qcom_watchdog_driver = {
+	.probe	= qcom_wdt_probe,
+	.remove	= qcom_wdt_remove,
+	.driver	= {
+		.name		= KBUILD_MODNAME,
+		.of_match_table	= qcom_wdt_of_table,
+	},
+};
+module_platform_driver(qcom_watchdog_driver);
+
+MODULE_DESCRIPTION("QCOM KPSS Watchdog Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/watchdog/rn5t618_wdt.c b/drivers/watchdog/rn5t618_wdt.c
new file mode 100644
index 0000000..d1c1227
--- /dev/null
+++ b/drivers/watchdog/rn5t618_wdt.c
@@ -0,0 +1,198 @@
+/*
+ * Watchdog driver for Ricoh RN5T618 PMIC
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/rn5t618.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#define DRIVER_NAME "rn5t618-wdt"
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int timeout;
+
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout, "Initial watchdog timeout in seconds");
+
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+struct rn5t618_wdt {
+	struct watchdog_device wdt_dev;
+	struct rn5t618 *rn5t618;
+};
+
+/*
+ * This array encodes the values of WDOGTIM field for the supported
+ * watchdog expiration times. If the watchdog is not accessed before
+ * the timer expiration, the PMU generates an interrupt and if the CPU
+ * doesn't clear it within one second the system is restarted.
+ */
+static const struct {
+	u8 reg_val;
+	unsigned int time;
+} rn5t618_wdt_map[] = {
+	{ 0, 1 },
+	{ 1, 8 },
+	{ 2, 32 },
+	{ 3, 128 },
+};
+
+static int rn5t618_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				   unsigned int t)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(rn5t618_wdt_map); i++) {
+		if (rn5t618_wdt_map[i].time + 1 >= t)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(rn5t618_wdt_map))
+		return -EINVAL;
+
+	ret = regmap_update_bits(wdt->rn5t618->regmap, RN5T618_WATCHDOG,
+				 RN5T618_WATCHDOG_WDOGTIM_M,
+				 rn5t618_wdt_map[i].reg_val);
+	if (!ret)
+		wdt_dev->timeout = rn5t618_wdt_map[i].time;
+
+	return ret;
+}
+
+static int rn5t618_wdt_start(struct watchdog_device *wdt_dev)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+	int ret;
+
+	ret = rn5t618_wdt_set_timeout(wdt_dev, wdt_dev->timeout);
+	if (ret)
+		return ret;
+
+	/* enable repower-on */
+	ret = regmap_update_bits(wdt->rn5t618->regmap, RN5T618_REPCNT,
+				 RN5T618_REPCNT_REPWRON,
+				 RN5T618_REPCNT_REPWRON);
+	if (ret)
+		return ret;
+
+	/* enable watchdog */
+	ret = regmap_update_bits(wdt->rn5t618->regmap, RN5T618_WATCHDOG,
+				 RN5T618_WATCHDOG_WDOGEN,
+				 RN5T618_WATCHDOG_WDOGEN);
+	if (ret)
+		return ret;
+
+	/* enable watchdog interrupt */
+	return regmap_update_bits(wdt->rn5t618->regmap, RN5T618_PWRIREN,
+				  RN5T618_PWRIRQ_IR_WDOG,
+				  RN5T618_PWRIRQ_IR_WDOG);
+}
+
+static int rn5t618_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+
+	return regmap_update_bits(wdt->rn5t618->regmap, RN5T618_WATCHDOG,
+				  RN5T618_WATCHDOG_WDOGEN, 0);
+}
+
+static int rn5t618_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+	unsigned int val;
+	int ret;
+
+	/* The counter is restarted after a R/W access to watchdog register */
+	ret = regmap_read(wdt->rn5t618->regmap, RN5T618_WATCHDOG, &val);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(wdt->rn5t618->regmap, RN5T618_WATCHDOG, val);
+	if (ret)
+		return ret;
+
+	/* Clear pending watchdog interrupt */
+	return regmap_update_bits(wdt->rn5t618->regmap, RN5T618_PWRIRQ,
+				  RN5T618_PWRIRQ_IR_WDOG, 0);
+}
+
+static struct watchdog_info rn5t618_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+			  WDIOF_KEEPALIVEPING,
+	.identity	= DRIVER_NAME,
+};
+
+static struct watchdog_ops rn5t618_wdt_ops = {
+	.owner          = THIS_MODULE,
+	.start          = rn5t618_wdt_start,
+	.stop           = rn5t618_wdt_stop,
+	.ping           = rn5t618_wdt_ping,
+	.set_timeout    = rn5t618_wdt_set_timeout,
+};
+
+static int rn5t618_wdt_probe(struct platform_device *pdev)
+{
+	struct rn5t618 *rn5t618 = dev_get_drvdata(pdev->dev.parent);
+	struct rn5t618_wdt *wdt;
+	int min_timeout, max_timeout;
+
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct rn5t618_wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	min_timeout = rn5t618_wdt_map[0].time;
+	max_timeout = rn5t618_wdt_map[ARRAY_SIZE(rn5t618_wdt_map) - 1].time;
+
+	wdt->rn5t618 = rn5t618;
+	wdt->wdt_dev.info = &rn5t618_wdt_info;
+	wdt->wdt_dev.ops = &rn5t618_wdt_ops;
+	wdt->wdt_dev.min_timeout = min_timeout;
+	wdt->wdt_dev.max_timeout = max_timeout;
+	wdt->wdt_dev.timeout = max_timeout;
+	wdt->wdt_dev.parent = &pdev->dev;
+
+	watchdog_set_drvdata(&wdt->wdt_dev, wdt);
+	watchdog_init_timeout(&wdt->wdt_dev, timeout, &pdev->dev);
+	watchdog_set_nowayout(&wdt->wdt_dev, nowayout);
+
+	platform_set_drvdata(pdev, wdt);
+
+	return watchdog_register_device(&wdt->wdt_dev);
+}
+
+static int rn5t618_wdt_remove(struct platform_device *pdev)
+{
+	struct rn5t618_wdt *wdt = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&wdt->wdt_dev);
+
+	return 0;
+}
+
+static struct platform_driver rn5t618_wdt_driver = {
+	.probe = rn5t618_wdt_probe,
+	.remove = rn5t618_wdt_remove,
+	.driver = {
+		.name	= DRIVER_NAME,
+	},
+};
+
+module_platform_driver(rn5t618_wdt_driver);
+
+MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
+MODULE_DESCRIPTION("RN5T618 watchdog driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 7c6ccd0..8532c3e 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -41,6 +41,8 @@
 #include <linux/of.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/reboot.h>
+#include <linux/delay.h>
 
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -128,6 +130,7 @@ struct s3c2410_wdt {
 	unsigned long		wtdat_save;
 	struct watchdog_device	wdt_device;
 	struct notifier_block	freq_transition;
+	struct notifier_block	restart_handler;
 	struct s3c2410_wdt_variant *drv_data;
 	struct regmap *pmureg;
 };
@@ -155,6 +158,15 @@ static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
 	.quirks = QUIRK_HAS_PMU_CONFIG | QUIRK_HAS_RST_STAT,
 };
 
+static const struct s3c2410_wdt_variant drv_data_exynos7 = {
+	.disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
+	.mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
+	.mask_bit = 0,
+	.rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
+	.rst_stat_bit = 23,	/* A57 WDTRESET */
+	.quirks = QUIRK_HAS_PMU_CONFIG | QUIRK_HAS_RST_STAT,
+};
+
 static const struct of_device_id s3c2410_wdt_match[] = {
 	{ .compatible = "samsung,s3c2410-wdt",
 	  .data = &drv_data_s3c2410 },
@@ -162,6 +174,8 @@ static const struct of_device_id s3c2410_wdt_match[] = {
 	  .data = &drv_data_exynos5250 },
 	{ .compatible = "samsung,exynos5420-wdt",
 	  .data = &drv_data_exynos5420 },
+	{ .compatible = "samsung,exynos7-wdt",
+	  .data = &drv_data_exynos7 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c2410_wdt_match);
@@ -438,6 +452,31 @@ static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
 }
 #endif
 
+static int s3c2410wdt_restart(struct notifier_block *this,
+			      unsigned long mode, void *cmd)
+{
+	struct s3c2410_wdt *wdt = container_of(this, struct s3c2410_wdt,
+					       restart_handler);
+	void __iomem *wdt_base = wdt->reg_base;
+
+	/* disable watchdog, to be safe  */
+	writel(0, wdt_base + S3C2410_WTCON);
+
+	/* put initial values into count and data */
+	writel(0x80, wdt_base + S3C2410_WTCNT);
+	writel(0x80, wdt_base + S3C2410_WTDAT);
+
+	/* set the watchdog to go and reset... */
+	writel(S3C2410_WTCON_ENABLE | S3C2410_WTCON_DIV16 |
+		S3C2410_WTCON_RSTEN | S3C2410_WTCON_PRESCALE(0x20),
+		wdt_base + S3C2410_WTCON);
+
+	/* wait for reset to assert... */
+	mdelay(500);
+
+	return NOTIFY_DONE;
+}
+
 static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wdt *wdt)
 {
 	unsigned int rst_stat;
@@ -592,6 +631,12 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, wdt);
 
+	wdt->restart_handler.notifier_call = s3c2410wdt_restart;
+	wdt->restart_handler.priority = 128;
+	ret = register_restart_handler(&wdt->restart_handler);
+	if (ret)
+		pr_err("cannot register restart handler, %d\n", ret);
+
 	/* print out a statement of readiness */
 
 	wtcon = readl(wdt->reg_base + S3C2410_WTCON);
@@ -621,6 +666,8 @@ static int s3c2410wdt_remove(struct platform_device *dev)
 	int ret;
 	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
 
+	unregister_restart_handler(&wdt->restart_handler);
+
 	ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/watchdog/stmp3xxx_rtc_wdt.c b/drivers/watchdog/stmp3xxx_rtc_wdt.c
index 3804d5e..a62b1b6 100644
--- a/drivers/watchdog/stmp3xxx_rtc_wdt.c
+++ b/drivers/watchdog/stmp3xxx_rtc_wdt.c
@@ -94,9 +94,33 @@ static int stmp3xxx_wdt_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int __maybe_unused stmp3xxx_wdt_suspend(struct device *dev)
+{
+	struct watchdog_device *wdd = &stmp3xxx_wdd;
+
+	if (watchdog_active(wdd))
+		return wdt_stop(wdd);
+
+	return 0;
+}
+
+static int __maybe_unused stmp3xxx_wdt_resume(struct device *dev)
+{
+	struct watchdog_device *wdd = &stmp3xxx_wdd;
+
+	if (watchdog_active(wdd))
+		return wdt_start(wdd);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(stmp3xxx_wdt_pm_ops,
+			 stmp3xxx_wdt_suspend, stmp3xxx_wdt_resume);
+
 static struct platform_driver stmp3xxx_wdt_driver = {
 	.driver = {
 		.name = "stmp3xxx_rtc_wdt",
+		.pm = &stmp3xxx_wdt_pm_ops,
 	},
 	.probe = stmp3xxx_wdt_probe,
 	.remove = stmp3xxx_wdt_remove,
diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 480bb55..b62301e 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -23,6 +23,7 @@
 #include <linux/moduleparam.h>
 #include <linux/notifier.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
 #include <linux/types.h>
@@ -30,15 +31,11 @@
 
 #define WDT_MAX_TIMEOUT         16
 #define WDT_MIN_TIMEOUT         1
-#define WDT_MODE_TIMEOUT(n)     ((n) << 3)
-#define WDT_TIMEOUT_MASK        WDT_MODE_TIMEOUT(0x0F)
+#define WDT_TIMEOUT_MASK        0x0F
 
-#define WDT_CTRL                0x00
 #define WDT_CTRL_RELOAD         ((1 << 0) | (0x0a57 << 1))
 
-#define WDT_MODE                0x04
 #define WDT_MODE_EN             (1 << 0)
-#define WDT_MODE_RST_EN         (1 << 1)
 
 #define DRV_NAME		"sunxi-wdt"
 #define DRV_VERSION		"1.0"
@@ -46,15 +43,29 @@
 static bool nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int timeout = WDT_MAX_TIMEOUT;
 
+/*
+ * This structure stores the register offsets for different variants
+ * of Allwinner's watchdog hardware.
+ */
+struct sunxi_wdt_reg {
+	u8 wdt_ctrl;
+	u8 wdt_cfg;
+	u8 wdt_mode;
+	u8 wdt_timeout_shift;
+	u8 wdt_reset_mask;
+	u8 wdt_reset_val;
+};
+
 struct sunxi_wdt_dev {
 	struct watchdog_device wdt_dev;
 	void __iomem *wdt_base;
+	const struct sunxi_wdt_reg *wdt_regs;
 	struct notifier_block restart_handler;
 };
 
 /*
  * wdt_timeout_map maps the watchdog timer interval value in seconds to
- * the value of the register WDT_MODE bit 3:6
+ * the value of the register WDT_MODE at bits .wdt_timeout_shift ~ +3
  *
  * [timeout seconds] = register value
  *
@@ -82,19 +93,32 @@ static int sunxi_restart_handle(struct notifier_block *this, unsigned long mode,
 						       struct sunxi_wdt_dev,
 						       restart_handler);
 	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+	const struct sunxi_wdt_reg *regs = sunxi_wdt->wdt_regs;
+	u32 val;
+
+	/* Set system reset function */
+	val = readl(wdt_base + regs->wdt_cfg);
+	val &= ~(regs->wdt_reset_mask);
+	val |= regs->wdt_reset_val;
+	writel(val, wdt_base + regs->wdt_cfg);
 
-	/* Enable timer and set reset bit in the watchdog */
-	writel(WDT_MODE_EN | WDT_MODE_RST_EN, wdt_base + WDT_MODE);
+	/* Set lowest timeout and enable watchdog */
+	val = readl(wdt_base + regs->wdt_mode);
+	val &= ~(WDT_TIMEOUT_MASK << regs->wdt_timeout_shift);
+	val |= WDT_MODE_EN;
+	writel(val, wdt_base + regs->wdt_mode);
 
 	/*
 	 * Restart the watchdog. The default (and lowest) interval
 	 * value for the watchdog is 0.5s.
 	 */
-	writel(WDT_CTRL_RELOAD, wdt_base + WDT_CTRL);
+	writel(WDT_CTRL_RELOAD, wdt_base + regs->wdt_ctrl);
 
 	while (1) {
 		mdelay(5);
-		writel(WDT_MODE_EN | WDT_MODE_RST_EN, wdt_base + WDT_MODE);
+		val = readl(wdt_base + regs->wdt_mode);
+		val |= WDT_MODE_EN;
+		writel(val, wdt_base + regs->wdt_mode);
 	}
 	return NOTIFY_DONE;
 }
@@ -103,8 +127,9 @@ static int sunxi_wdt_ping(struct watchdog_device *wdt_dev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
 	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+	const struct sunxi_wdt_reg *regs = sunxi_wdt->wdt_regs;
 
-	iowrite32(WDT_CTRL_RELOAD, wdt_base + WDT_CTRL);
+	writel(WDT_CTRL_RELOAD, wdt_base + regs->wdt_ctrl);
 
 	return 0;
 }
@@ -114,6 +139,7 @@ static int sunxi_wdt_set_timeout(struct watchdog_device *wdt_dev,
 {
 	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
 	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+	const struct sunxi_wdt_reg *regs = sunxi_wdt->wdt_regs;
 	u32 reg;
 
 	if (wdt_timeout_map[timeout] == 0)
@@ -121,10 +147,10 @@ static int sunxi_wdt_set_timeout(struct watchdog_device *wdt_dev,
 
 	sunxi_wdt->wdt_dev.timeout = timeout;
 
-	reg = ioread32(wdt_base + WDT_MODE);
-	reg &= ~WDT_TIMEOUT_MASK;
-	reg |= WDT_MODE_TIMEOUT(wdt_timeout_map[timeout]);
-	iowrite32(reg, wdt_base + WDT_MODE);
+	reg = readl(wdt_base + regs->wdt_mode);
+	reg &= ~(WDT_TIMEOUT_MASK << regs->wdt_timeout_shift);
+	reg |= wdt_timeout_map[timeout] << regs->wdt_timeout_shift;
+	writel(reg, wdt_base + regs->wdt_mode);
 
 	sunxi_wdt_ping(wdt_dev);
 
@@ -135,8 +161,9 @@ static int sunxi_wdt_stop(struct watchdog_device *wdt_dev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
 	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+	const struct sunxi_wdt_reg *regs = sunxi_wdt->wdt_regs;
 
-	iowrite32(0, wdt_base + WDT_MODE);
+	writel(0, wdt_base + regs->wdt_mode);
 
 	return 0;
 }
@@ -146,6 +173,7 @@ static int sunxi_wdt_start(struct watchdog_device *wdt_dev)
 	u32 reg;
 	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
 	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+	const struct sunxi_wdt_reg *regs = sunxi_wdt->wdt_regs;
 	int ret;
 
 	ret = sunxi_wdt_set_timeout(&sunxi_wdt->wdt_dev,
@@ -153,9 +181,16 @@ static int sunxi_wdt_start(struct watchdog_device *wdt_dev)
 	if (ret < 0)
 		return ret;
 
-	reg = ioread32(wdt_base + WDT_MODE);
-	reg |= (WDT_MODE_RST_EN | WDT_MODE_EN);
-	iowrite32(reg, wdt_base + WDT_MODE);
+	/* Set system reset function */
+	reg = readl(wdt_base + regs->wdt_cfg);
+	reg &= ~(regs->wdt_reset_mask);
+	reg |= ~(regs->wdt_reset_val);
+	writel(reg, wdt_base + regs->wdt_cfg);
+
+	/* Enable watchdog */
+	reg = readl(wdt_base + regs->wdt_mode);
+	reg |= WDT_MODE_EN;
+	writel(reg, wdt_base + regs->wdt_mode);
 
 	return 0;
 }
@@ -175,9 +210,35 @@ static const struct watchdog_ops sunxi_wdt_ops = {
 	.set_timeout	= sunxi_wdt_set_timeout,
 };
 
+static const struct sunxi_wdt_reg sun4i_wdt_reg = {
+	.wdt_ctrl = 0x00,
+	.wdt_cfg = 0x04,
+	.wdt_mode = 0x04,
+	.wdt_timeout_shift = 3,
+	.wdt_reset_mask = 0x02,
+	.wdt_reset_val = 0x02,
+};
+
+static const struct sunxi_wdt_reg sun6i_wdt_reg = {
+	.wdt_ctrl = 0x10,
+	.wdt_cfg = 0x14,
+	.wdt_mode = 0x18,
+	.wdt_timeout_shift = 4,
+	.wdt_reset_mask = 0x03,
+	.wdt_reset_val = 0x01,
+};
+
+static const struct of_device_id sunxi_wdt_dt_ids[] = {
+	{ .compatible = "allwinner,sun4i-a10-wdt", .data = &sun4i_wdt_reg },
+	{ .compatible = "allwinner,sun6i-a31-wdt", .data = &sun6i_wdt_reg },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, sunxi_wdt_dt_ids);
+
 static int sunxi_wdt_probe(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt;
+	const struct of_device_id *device;
 	struct resource *res;
 	int err;
 
@@ -187,6 +248,12 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sunxi_wdt);
 
+	device = of_match_device(sunxi_wdt_dt_ids, &pdev->dev);
+	if (!device)
+		return -ENODEV;
+
+	sunxi_wdt->wdt_regs = device->data;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	sunxi_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(sunxi_wdt->wdt_base))
@@ -242,12 +309,6 @@ static void sunxi_wdt_shutdown(struct platform_device *pdev)
 	sunxi_wdt_stop(&sunxi_wdt->wdt_dev);
 }
 
-static const struct of_device_id sunxi_wdt_dt_ids[] = {
-	{ .compatible = "allwinner,sun4i-a10-wdt" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, sunxi_wdt_dt_ids);
-
 static struct platform_driver sunxi_wdt_driver = {
 	.probe		= sunxi_wdt_probe,
 	.remove		= sunxi_wdt_remove,
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index afa9d6e..dee9c6c 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -428,11 +428,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 
 static int ts72xx_wdt_remove(struct platform_device *pdev)
 {
-	int error;
-
-	error = misc_deregister(&ts72xx_wdt_miscdev);
-
-	return error;
+	return misc_deregister(&ts72xx_wdt_miscdev);
 }
 
 static struct platform_driver ts72xx_wdt_driver = {
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 2a3038e..395b70e 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -97,13 +97,8 @@ struct watchdog_device {
 #define WDOG_UNREGISTERED	4	/* Has the device been unregistered */
 };
 
-#ifdef CONFIG_WATCHDOG_NOWAYOUT
-#define WATCHDOG_NOWAYOUT		1
-#define WATCHDOG_NOWAYOUT_INIT_STATUS	(1 << WDOG_NO_WAY_OUT)
-#else
-#define WATCHDOG_NOWAYOUT		0
-#define WATCHDOG_NOWAYOUT_INIT_STATUS	0
-#endif
+#define WATCHDOG_NOWAYOUT		IS_BUILTIN(CONFIG_WATCHDOG_NOWAYOUT)
+#define WATCHDOG_NOWAYOUT_INIT_STATUS	(WATCHDOG_NOWAYOUT << WDOG_NO_WAY_OUT)
 
 /* Use the following function to check whether or not the watchdog is active */
 static inline bool watchdog_active(struct watchdog_device *wdd)
