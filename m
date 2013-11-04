Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3KDBQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:16:19 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:60984 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KDBQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:16:18 -0500
MIME-Version: 1.0
In-Reply-To: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
From: caglar sayin <caglar@hotmail.com.tr>
Date: Mon, 4 Nov 2013 02:15:57 +0100
X-Google-Sender-Auth: M1IKJCniLO-miXaDbMLjomQdWkw
Message-ID: <CABG2-1qnG8Vxy7RTE522Rq56kBfsHeAtMFbDPW2D-8yt3U+VVg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Exynos 5410 Dual cluster support
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, I checked 3.12 but I could not find this patch. Is it dead or
under development? If it is under development, any external link?

Thanks
with sincerely respects...

On Mon, Oct 14, 2013 at 5:08 PM, Vyacheslav Tyrtov <v.tyrtov@samsung.com> wrote:
> The series of patches represent support of Exynos 5410 SoC
>
> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture.
> Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
>
> Patches add new platform description, support of clock controller,
> dual cluster support and device tree for Exynos 5410
>
> Has been build on v3.12-rc5.
> Has been tested on Exynos 5410 reference board (exynos_defconfig).
>
> Thanks,
>         Vyacheslav.
>
>
> Changelog:
>
> v2:
>         In drivers/clk/samsung/clk-exynos5410.c
> 1. Clock driver converted to use preprocessor macros instead of enums.
>    Clock IDs now defined in include/dt-bindings/clock/exynos5410.h.
> 2. Unused spinlock removed.
> 3. Function exynos5410_clk_init defined as static.
>    Struct exynos5410_fixed_rate_ext_clks defined as static.
>    Struct exynos5410_mux_clks defined as static.
>    Struct exynos5410_div_clks defined as static.
>    Struct exynos5410_gate_clks defined as static.
> 4. Removed aliases.
> 5. Pll's magic register offsets defined as preprocessor macros.
> 6. Redundant check of device_node pointer removed.
>
>         In arch/arm/boot/dts/exynos5410.dtsi
> 1. dwmmcX nodes renamed to mmc.
>    dwmmc_X renamed to mmc_X.
>    dwmmc status="disabled" field added.
>    fifo-depth field moved from arch/arm/boot/dts/exynos5410-smdk5410.dts
> 2. Blank lines added where necessary.
> 3. cpu@ suffixes corrected.
> 4. edcs node removed.
> 5. Hexadecimal characters case corrected.
> 6. Clock IDs replaced with preprocessor macros.
>
>         In arch/arm/boot/dts/exynos5410-smdk5410.dts
> 1. status = "okay" field added to mmc nodes.
>
>         In arch/arm/mach-exynos/edcs.c
> 1. "kfs_" prefix replaced with "edcs_"
> 2. EDCS_CPUS_PER_CLUSTER and EDCS_CLUSTERS defined instead of MCPM's values.
> 3. Cache handling sequence borrowed from arch/arm/mach-vexpress/tc2_pm.c
> 4. mcpm_sync_init() call added.
> 5. power management functions reworked.
>
>         Other
> 1. Documentation/devicetree/bindings/clock/exynos5410-clock.txt corrected.
> 2. Removed smdk5410_defconfig. Instead SOC_EXYNOS5410 now selects MCPM and
>    ARM_CCI in arch/arm/mach-exynos/Kconfig.
> 3. edcs_status driver removed.
>
> Tarek Dakhran (4):
>   ARM: EXYNOS: Add support for EXYNOS5410 SoC
>   clk: exynos5410: register clocks using common clock framework
>   ARM: EXYNOS: add Exynos Dual Cluster Support
>   ARM: dts: Add initial device tree support for EXYNOS5410
>
>  .../devicetree/bindings/clock/exynos5410-clock.txt |  37 +++
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/exynos5410-smdk5410.dts          |  65 +++++
>  arch/arm/boot/dts/exynos5410.dtsi                  | 209 ++++++++++++++++
>  arch/arm/mach-exynos/Kconfig                       |  12 +
>  arch/arm/mach-exynos/Makefile                      |   2 +
>  arch/arm/mach-exynos/common.c                      |  18 ++
>  arch/arm/mach-exynos/edcs.c                        | 270 +++++++++++++++++++++
>  arch/arm/mach-exynos/include/mach/map.h            |   1 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c             |   1 +
>  arch/arm/plat-samsung/include/plat/cpu.h           |   8 +
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos5410.c               | 251 +++++++++++++++++++
>  include/dt-bindings/clock/exynos5410.h             | 175 +++++++++++++
>  14 files changed, 1051 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>  create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>  create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>  create mode 100644 arch/arm/mach-exynos/edcs.c
>  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>  create mode 100644 include/dt-bindings/clock/exynos5410.h
>
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
