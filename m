Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3LJOaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:30:23 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12034 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3LJOaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:30:19 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-28-52a72578d451
From: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org, tomasz.figa@gmail.com
Subject: [PATCH v5 0/3] Exynos 5410 support
Date: Tue, 10 Dec 2013 18:26:36 +0400
Message-id: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xa7oVqsuDDL7vsbGYtO4Ak8W8z7IW
	TXP3MFrMP3KO1eL/o9esFuderWS06F1wlc1i0+NrrBYL25awWFzeNYfNYsb5fUwWty/zWiy9
	fpHJ4umEi2wWn579Y7eYMH0ti8XhFUDT1r2czmKx5WcHo8Wrg20sFuufn2K02LxpKrPFql1/
	GC2mzvjB7iDhsWbeGkaPluYeNo8Fn6+we/xd9YLZY+esu+weK5d/YfN4tXomq8eda3vYPN6d
	O8fusXlJvceraywefVtWMXpsvzaP2ePzJjmPjXNDA/ijuGxSUnMyy1KL9O0SuDJav05hLtiu
	W3FmcytbA+NflS5GTg4JAROJt11PmSFsMYkL99azdTFycQgJLGWU2P9xMyuE08MksfnYcUaQ
	KjYBPYm+VzdYQGwRAQWJzb3PwIqYBQ6xSby+fxdoFAeHsIC2xI9zdSA1LAKqEi9nv2MDsXkF
	XCRuNTYyQWxTkDja9pZ9AiP3AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghsfJlB+Pi
	Y1aHGAU4GJV4eAsYlgUJsSaWFVfmHmKU4GBWEuHd9gIoxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gVFozc1bidJ2lZF9xyzzj+YaKN22vWlRXcdxZ+mqA2K5G88zrZuT0uHc+vxOhvGbR2ohIpJn
	m4zN/vMxnp245F15XNjy2R6WkhsXCrOfCVq+JOCGsE7eivucM/L8u6NqX581srJyfeu0LDVd
	mfPOSq3niptU9qc4nbDrFJ2jeWGN/Q9tufkO0UosxRmJhlrMRcWJAOThk7JzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC

The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture

Patches add new platform description, support of clock controller and device 
tree for Exynos 5410.

Dual cluster support for Exynos 5410 (EDCS) has been removed from this series 
This patches is activating only the big cluster (all A15 cores)

EDCS patch, which allows all 8 CPU cores (4 x A7 and 4 x A15) 
to run at the same time, will be released separately

Has been build on v3.13-rc3
Has been tested on Exynos 5410 reference board (exynos_defconfig)

Thanks for all your comments to Tomasz Figa, Dave Martin and Nicolas Pitre.
I hope, this is enough clean and hasn't any dependencies to go through 
Samsung tree. Kukjin, what do you think about it?

Vyacheslav.


Changelog:

v5:
	EDCS removed to separate patch.

	In arch/arm/mach-exynos/Kconfig
1. Removed select ARM_CCI and MCPM.
	In arch/arm/mach-exynos/platsmp.c
1. Added correct boot_reg for exynos5410.
	In arch/arm/boot/dts/exynos5410.dtsi
1. Removed cortex-a7 cpu nodes and cci node.

v4:
	In arch/arm/mach-exynos/edcs.c
1. Renamed all exynos_ prefixes to edcs_.
2. Reworked edcs_core_power_up/down functions.
3. Removed exynos_core_power_control function.
4. Added this_core_to_pcpu function.
5. Added core_power_state function which detects if cpu is being reset.
6. Replaced cache flush sequences with v7_exit_coherency_flush().
7. exynos_core_power_down moved to lock protected area.
8. edcs_power_down_finish implemented.
	In Documentation/devicetree/bindings/clock/exynos5410-clock.txt
1. External clocks documented.
	In arch/arm/boot/dts/exynos5410-smdk5410.dts
1. oscclk node corrected according to ePAPR recommendation.
	In arch/arm/boot/dts/exynos5410.dtsi
1. mct@101C0000 node renamed to timer@101C0000.
2. "interrupt-controller" line removed from mct node.
3. mct_map renamed to interrupt_map.
	In arch/arm/mach-exynos/Kconfig
1. some cosmetic corrections.
	In include/dt-bindings/clock/exynos5410.h
1. Unnecessary defines removed.

v3:
	In drivers/clk/samsung/clk-exynos5410.c
1. Fixed rate clock "samsung,clock-oscclk" removed.
	In arch/arm/boot/dts/exynos5410.dtsi
1. In mct node clock CLK_FIN_PLL replaced with generic fixed rate oscclk.
	In arch/arm/boot/dts/exynos5410-smdk5410.dts
1. Fixed rate oscclk clock added.
	In arch/arm/mach-exynos/edcs.c
1. Added write memory barrier in exynos_core_power_control function.
2. __raw_readl/__raw_writel replaced with readl_relaxed/writel_relaxed.
3. #define added for some magic constants.
4. Disabled the GIC CPU interface in exynos_power_down function.

v2:
	In drivers/clk/samsung/clk-exynos5410.c
1. Clock driver converted to use preprocessor macros instead of enums.
   Clock IDs now defined in include/dt-bindings/clock/exynos5410.h.
2. Unused spinlock removed.
3. Function exynos5410_clk_init defined as static.
   Struct exynos5410_fixed_rate_ext_clks defined as static.
   Struct exynos5410_mux_clks defined as static.
   Struct exynos5410_div_clks defined as static.
   Struct exynos5410_gate_clks defined as static.
4. Removed aliases.
5. Pll's magic register offsets defined as preprocessor macros.
6. Redundant check of device_node pointer removed.
	
	In arch/arm/boot/dts/exynos5410.dtsi
1. dwmmcX nodes renamed to mmc.
   dwmmc_X renamed to mmc_X.
   dwmmc status="disabled" field added.
   fifo-depth field moved from arch/arm/boot/dts/exynos5410-smdk5410.dts
2. Blank lines added where necessary.
3. cpu@ suffixes corrected.
4. edcs node removed.
5. Hexadecimal characters case corrected.
6. Clock IDs replaced with preprocessor macros.
	
	In arch/arm/boot/dts/exynos5410-smdk5410.dts
1. status = "okay" field added to mmc nodes.
	
	In arch/arm/mach-exynos/edcs.c
1. "kfs_" prefix replaced with "edcs_"
2. EDCS_CPUS_PER_CLUSTER and EDCS_CLUSTERS defined instead of MCPM's values.
3. Cache handling sequence borrowed from arch/arm/mach-vexpress/tc2_pm.c
4. mcpm_sync_init() call added.
5. power management functions reworked.
	
	Other
1. Documentation/devicetree/bindings/clock/exynos5410-clock.txt corrected.
2. Removed smdk5410_defconfig. Instead SOC_EXYNOS5410 now selects MCPM and
   ARM_CCI in arch/arm/mach-exynos/Kconfig.
3. edcs_status driver removed.

Tarek Dakhran (3):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |  54 +++++
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |  72 +++++++
 arch/arm/boot/dts/exynos5410.dtsi                  | 145 +++++++++++++
 arch/arm/mach-exynos/Kconfig                       |  10 +
 arch/arm/mach-exynos/common.c                      |  18 ++
 arch/arm/mach-exynos/include/mach/map.h            |   1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   1 +
 arch/arm/mach-exynos/platsmp.c                     |   2 +
 arch/arm/plat-samsung/include/plat/cpu.h           |   8 +
 arch/arm/plat-samsung/include/plat/map-s5p.h       |   3 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos5410.c               | 239 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |  32 +++
 14 files changed, 587 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.8.1.5

