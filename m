Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3LKW3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:29:55 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39658 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3LKW3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:29:52 -0500
Message-ID: <52A8E755.4080600@samsung.com>
Date: Thu, 12 Dec 2013 07:29:41 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
CC: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-doc@vger.kernel.org,
        tomasz.figa@gmail.com, Naour Romain <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, Dave.Martin@arm.com,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-samsung-soc@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v5 0/3] Exynos 5410 support
References: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
In-Reply-To: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 23:26, Vyacheslav Tyrtov wrote:
> The series of patches represent support of Exynos 5410 SoC
>
> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
>
> Patches add new platform description, support of clock controller and device
> tree for Exynos 5410.
>
> Dual cluster support for Exynos 5410 (EDCS) has been removed from this series
> This patches is activating only the big cluster (all A15 cores)
>
> EDCS patch, which allows all 8 CPU cores (4 x A7 and 4 x A15)
> to run at the same time, will be released separately
>
> Has been build on v3.13-rc3
> Has been tested on Exynos 5410 reference board (exynos_defconfig)
>
> Thanks for all your comments to Tomasz Figa, Dave Martin and Nicolas Pitre.
> I hope, this is enough clean and hasn't any dependencies to go through
> Samsung tree. Kukjin, what do you think about it?
>

OK, looks good and I've applied.

Thanks,
Kukjin


> Vyacheslav.
>
>
> Changelog:
>
> v5:
> 	EDCS removed to separate patch.
>
> 	In arch/arm/mach-exynos/Kconfig
> 1. Removed select ARM_CCI and MCPM.
> 	In arch/arm/mach-exynos/platsmp.c
> 1. Added correct boot_reg for exynos5410.
> 	In arch/arm/boot/dts/exynos5410.dtsi
> 1. Removed cortex-a7 cpu nodes and cci node.
>
> v4:
> 	In arch/arm/mach-exynos/edcs.c
> 1. Renamed all exynos_ prefixes to edcs_.
> 2. Reworked edcs_core_power_up/down functions.
> 3. Removed exynos_core_power_control function.
> 4. Added this_core_to_pcpu function.
> 5. Added core_power_state function which detects if cpu is being reset.
> 6. Replaced cache flush sequences with v7_exit_coherency_flush().
> 7. exynos_core_power_down moved to lock protected area.
> 8. edcs_power_down_finish implemented.
> 	In Documentation/devicetree/bindings/clock/exynos5410-clock.txt
> 1. External clocks documented.
> 	In arch/arm/boot/dts/exynos5410-smdk5410.dts
> 1. oscclk node corrected according to ePAPR recommendation.
> 	In arch/arm/boot/dts/exynos5410.dtsi
> 1. mct@101C0000 node renamed to timer@101C0000.
> 2. "interrupt-controller" line removed from mct node.
> 3. mct_map renamed to interrupt_map.
> 	In arch/arm/mach-exynos/Kconfig
> 1. some cosmetic corrections.
> 	In include/dt-bindings/clock/exynos5410.h
> 1. Unnecessary defines removed.
>
> v3:
> 	In drivers/clk/samsung/clk-exynos5410.c
> 1. Fixed rate clock "samsung,clock-oscclk" removed.
> 	In arch/arm/boot/dts/exynos5410.dtsi
> 1. In mct node clock CLK_FIN_PLL replaced with generic fixed rate oscclk.
> 	In arch/arm/boot/dts/exynos5410-smdk5410.dts
> 1. Fixed rate oscclk clock added.
> 	In arch/arm/mach-exynos/edcs.c
> 1. Added write memory barrier in exynos_core_power_control function.
> 2. __raw_readl/__raw_writel replaced with readl_relaxed/writel_relaxed.
> 3. #define added for some magic constants.
> 4. Disabled the GIC CPU interface in exynos_power_down function.
>
> v2:
> 	In drivers/clk/samsung/clk-exynos5410.c
> 1. Clock driver converted to use preprocessor macros instead of enums.
>     Clock IDs now defined in include/dt-bindings/clock/exynos5410.h.
> 2. Unused spinlock removed.
> 3. Function exynos5410_clk_init defined as static.
>     Struct exynos5410_fixed_rate_ext_clks defined as static.
>     Struct exynos5410_mux_clks defined as static.
>     Struct exynos5410_div_clks defined as static.
>     Struct exynos5410_gate_clks defined as static.
> 4. Removed aliases.
> 5. Pll's magic register offsets defined as preprocessor macros.
> 6. Redundant check of device_node pointer removed.
> 	
> 	In arch/arm/boot/dts/exynos5410.dtsi
> 1. dwmmcX nodes renamed to mmc.
>     dwmmc_X renamed to mmc_X.
>     dwmmc status="disabled" field added.
>     fifo-depth field moved from arch/arm/boot/dts/exynos5410-smdk5410.dts
> 2. Blank lines added where necessary.
> 3. cpu@ suffixes corrected.
> 4. edcs node removed.
> 5. Hexadecimal characters case corrected.
> 6. Clock IDs replaced with preprocessor macros.
> 	
> 	In arch/arm/boot/dts/exynos5410-smdk5410.dts
> 1. status = "okay" field added to mmc nodes.
> 	
> 	In arch/arm/mach-exynos/edcs.c
> 1. "kfs_" prefix replaced with "edcs_"
> 2. EDCS_CPUS_PER_CLUSTER and EDCS_CLUSTERS defined instead of MCPM's values.
> 3. Cache handling sequence borrowed from arch/arm/mach-vexpress/tc2_pm.c
> 4. mcpm_sync_init() call added.
> 5. power management functions reworked.
> 	
> 	Other
> 1. Documentation/devicetree/bindings/clock/exynos5410-clock.txt corrected.
> 2. Removed smdk5410_defconfig. Instead SOC_EXYNOS5410 now selects MCPM and
>     ARM_CCI in arch/arm/mach-exynos/Kconfig.
> 3. edcs_status driver removed.
>
> Tarek Dakhran (3):
>    ARM: EXYNOS: Add support for EXYNOS5410 SoC
>    clk: exynos5410: register clocks using common clock framework
>    ARM: dts: Add initial device tree support for EXYNOS5410
>
>   .../devicetree/bindings/clock/exynos5410-clock.txt |  54 +++++
>   arch/arm/boot/dts/Makefile                         |   1 +
>   arch/arm/boot/dts/exynos5410-smdk5410.dts          |  72 +++++++
>   arch/arm/boot/dts/exynos5410.dtsi                  | 145 +++++++++++++
>   arch/arm/mach-exynos/Kconfig                       |  10 +
>   arch/arm/mach-exynos/common.c                      |  18 ++
>   arch/arm/mach-exynos/include/mach/map.h            |   1 +
>   arch/arm/mach-exynos/mach-exynos5-dt.c             |   1 +
>   arch/arm/mach-exynos/platsmp.c                     |   2 +
>   arch/arm/plat-samsung/include/plat/cpu.h           |   8 +
>   arch/arm/plat-samsung/include/plat/map-s5p.h       |   3 +
>   drivers/clk/samsung/Makefile                       |   1 +
>   drivers/clk/samsung/clk-exynos5410.c               | 239 +++++++++++++++++++++
>   include/dt-bindings/clock/exynos5410.h             |  32 +++
>   14 files changed, 587 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>   create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>   create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>   create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>   create mode 100644 include/dt-bindings/clock/exynos5410.h
>
