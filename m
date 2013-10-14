Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3JNPLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:11:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24272 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3JNPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:11:31 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-d6-525c09a1ff2a
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
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>
Subject: [PATCH v2 0/4] Exynos 5410 Dual cluster support
Date: Mon, 14 Oct 2013 19:08:21 +0400
Message-id: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xa7oLOWOCDJ6s17OYtO4Ak8W8z7IW
	84+cY7X4/+g1q8W5VysZLXoXXGWz2PT4GqvFwrYlLBaXd81hs5hxfh+Txe3LvBZLr19ksng6
	4SKbxYTpa1ksDq8AmrHu5XQWiy0/OxgtXh1sY7FY//wUo8XmTVOZLabO+MHuIOqxZt4aRo+W
	5h42jwWfr7B7/F31gtlj5fIvbB6vVs9k9bhzbQ+bx7tz59g9Ni+p93h1jcWjb8sqRo/t1+Yx
	e3zeJOexcW5oAF8Ul01Kak5mWWqRvl0CV8aFp/eZC5bJVty+YtzA2CHexcjJISFgInG/fQYT
	hC0mceHeerYuRi4OIYGljBLrpu1kh3B6mCQ+rNzPAlLFJqAn0ffqBpgtIqAgsbn3GStIEbPA
	L1aJTzNPMIMkhAUsJGY9nguU4OBgEVCVmLa3ACTMK+AscfzJPhaIbQoSR9vesk9g5F7AyLCK
	UTS1NLmgOCk910ivODG3uDQvXS85P3cTIyQCvu5gXHrM6hCjAAejEg+vgFN0kBBrYllxZe4h
	RgkOZiUR3ty3QCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mc0T7ZTs6flW5RdZMFhJf9jEg9qCm
	fOatqc9C3r2eFsHFsKOu/xTn3KD/nNHp97YvfKD99+DZyruTJ3B18XW+PFjeumZr99H9Ek0H
	HoccXCrtL7PxmoyUWIilQLqR+NG928Q+vc4TCzFYEFyYER0+98ny7+Zvcgy5PIRE/1d0NXSK
	pv3z3xytxFKckWioxVxUnAgABpksRV4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC
    
The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture.
Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
    
Patches add new platform description, support of clock controller,
dual cluster support and device tree for Exynos 5410 
   
Has been build on v3.12-rc5.
Has been tested on Exynos 5410 reference board (exynos_defconfig).
    
Thanks,
	Vyacheslav.


Changelog:

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

Tarek Dakhran (4):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: EXYNOS: add Exynos Dual Cluster Support
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |  37 +++
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |  65 +++++
 arch/arm/boot/dts/exynos5410.dtsi                  | 209 ++++++++++++++++
 arch/arm/mach-exynos/Kconfig                       |  12 +
 arch/arm/mach-exynos/Makefile                      |   2 +
 arch/arm/mach-exynos/common.c                      |  18 ++
 arch/arm/mach-exynos/edcs.c                        | 270 +++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h            |   1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   1 +
 arch/arm/plat-samsung/include/plat/cpu.h           |   8 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos5410.c               | 251 +++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             | 175 +++++++++++++
 14 files changed, 1051 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 arch/arm/mach-exynos/edcs.c
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.8.1.5

