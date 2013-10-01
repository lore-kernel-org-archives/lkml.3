Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3JAQUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:20:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9412 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3JAQUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:20:34 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-7c-524af6509bc7
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
Subject: [PATCH 0/6] Exynos 5410 Dual cluster support
Date: Tue, 01 Oct 2013 20:17:01 +0400
Message-id: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7oB37yCDM7NVrGYtO4Ak8W8z7IW
	84+cY7X4/+g1q8W5VysZLXoXXGWz2PT4GqvFwrYlLBaXd81hs5hxfh+Txe3LvBZLr19ksng6
	4SKbxYTpa1ksDq8AmrHu5XQWiy0/OxgtXh1sY7FY//wUo8XmTVOZLabO+MHuIOqxZt4aRo+W
	5h42jwWfr7B7/F31gtlj5fIvbB6vVs9k9bhzbQ+bx7tz59g9Ni+p93h1jcWjb8sqRo/t1+Yx
	e3zeJOexcW5oAF8Ul01Kak5mWWqRvl0CV8bVxs0sBf2iFV/enmRuYFzA38XIySEhYCIxedY9
	FghbTOLCvfVsILaQwFJGiUNLk7sYuYDsHiaJ3rYTTCAJNgE9ib5XN8AaRAQUJDb3PmMFKWIW
	+MUq8WnmCeYuRg4OYQFTiTsTVUFqWARUJfasuckKYvMKuEicazvHCrFMQeJo21v2CYzcCxgZ
	VjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKERMDXHYxLj1kdYhTgYFTi4ZV46BUkxJpYVlyZ
	e4hRgoNZSYTX/ixQiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NEYWDsdp2zJ/fu7p3/6/3JDwEv
	ypNkJj0OndP76kdBpkD0J9VH7wJPz7861a1vm1OHNOPp/SKXMs8p/1+ydN0lruqHzcW8XWKq
	3q+uHtj1MmeRyoIQvTMRnhHLNece4GNcsOC9wbZjJtvK1xk3Lb0juqIo/kHCv1tXe/ZUm2eb
	/tNtClqyR/S+EktxRqKhFnNRcSIAUn0eeV4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC
    
The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture.
Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
    
Patches add new platform description, support of clock controller,
dual cluster support, device tree for Exynos 5410 and minor fixes (CCI, MCT)
   
Has been builded on v3.12-rc3.
Has been tested on Exynos 5410 reference board (smdk5410_defconfig).
    
Thanks,
	Vyacheslav.

Tarek Dakhran (6):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: EXYNOS: add Exynos Dual Cluster Support
  ARM: dts: Add initial device tree support for EXYNOS5410
  ARM: EXYNOS: Minor fixes to enable EXYNOS5410 support
  ARM: smdk5410_defconfig: add defconfig for smdk5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |  72 ++++++
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |  67 +++++
 arch/arm/boot/dts/exynos5410.dtsi                  | 189 ++++++++++++++
 arch/arm/configs/smdk5410_defconfig                | 134 ++++++++++
 arch/arm/mach-exynos/Kconfig                       |  10 +
 arch/arm/mach-exynos/Makefile                      |   2 +
 arch/arm/mach-exynos/common.c                      |  18 ++
 arch/arm/mach-exynos/edcs.c                        | 217 ++++++++++++++++
 arch/arm/mach-exynos/edcs.h                        |  41 +++
 arch/arm/mach-exynos/edcs_status.c                 | 110 +++++++++
 arch/arm/mach-exynos/include/mach/map.h            |   1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   1 +
 arch/arm/plat-samsung/include/plat/cpu.h           |   8 +
 drivers/bus/arm-cci.c                              |   7 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos5410.c               | 274 +++++++++++++++++++++
 drivers/clocksource/exynos_mct.c                   |   8 +-
 drivers/irqchip/exynos-combiner.c                  |  12 +-
 20 files changed, 1172 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 arch/arm/configs/smdk5410_defconfig
 create mode 100644 arch/arm/mach-exynos/edcs.c
 create mode 100644 arch/arm/mach-exynos/edcs.h
 create mode 100644 arch/arm/mach-exynos/edcs_status.c
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c

-- 
1.8.1.5

