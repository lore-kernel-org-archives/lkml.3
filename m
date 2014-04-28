Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbaD1MDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:03:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62169 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbaD1MCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:02:19 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-d2-535e434a4e92
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, b.zolnierkie@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [RESUBMIT RFC PATCH v2 3/3] drivers: mfd: Add support for Exynos PMU
 driver
Date: Mon, 28 Apr 2014 21:20:07 +0900
Message-id: <1398687607-4554-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t8zA10v57hgg57XahYbZ6xntVg26S6b
	Re+Cq2wW978eZbTY9Pgaq8XlXXPYLGac38dkcfsyr8WirV/YLU53s1pcXPGFyWL9jNcsFjef
	bWey2NGymsWBz6OluYfN4861PWwe804GemxeUu/Rt2UVo8fnTXIBbFFcNimpOZllqUX6dglc
	GZvP3WIruCxVcXbmbKYGxnOiXYycHBICJhIzJu5hhLDFJC7cW8/WxcjFISSwjFHiftNaVpii
	I/c7mCES0xklPj98xwLhtDFJTNxyFKydTUBX4sn7ucwgtohAtsSVxvtgHcwCR5kkjrZ/BCsS
	FgiT2LxqDthYFgFViTnfH4PFeQXcJY58fMDexcgBtE5BYs4kG5Awp4CHxOqLT9hAbCGgko4F
	18BmSghcY5d4ufUrM8QcAYlvkw+xQPTKSmw6wAxxtaTEwRU3WCYwCi9gZFjFKJpakFxQnJRe
	ZKhXnJhbXJqXrpecn7uJERIxvTsYbx+wPsSYDDRuIrOUaHI+MOLySuINjc2MLExNTI2NzC3N
	SBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHx0v72NW+qDaYZJ4d83h9p0nJ4
	j6qzrrD5rrLebedsbpQ5F3JL+VXJvfZfa6OcKlkbc2WR0IK3N51TJt6YJxjH+1V/ScXpmmdr
	ShIXvyx5NeHoxmzxg3v8sx/y7126aQZHhudvjjV3ohX59nBz5fbdvMhz7eL7BPELDJo61bkx
	+/htDKco3JZQYinOSDTUYi4qTgQAYhF4564CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV0v57hgg6e3FC02zljParFs0l02
	i94FV9ks7n89ymix6fE1VovLu+awWcw4v4/J4vZlXotFW7+wW5zuZrW4uOILk8X6Ga9ZLG4+
	285ksaNlNYsDn0dLcw+bx51re9g85p0M9Ni8pN6jb8sqRo/Pm+QC2KIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5VUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWZsPneLreCyVMXZmbOZGhjPiXYxcnJICJhIHLnfwQxh
	i0lcuLeerYuRi0NIYDqjxOeH71ggnDYmiYlbjjKCVLEJ6Eo8eT8XrENEIFviSuN9ZpAiZoGj
	TBJH2z+CFQkLhElsXjWHFcRmEVCVmPP9MVicV8Bd4sjHB+xdjBxA6xQk5kyyAQlzCnhIrL74
	hA3EFgIq6VhwjXkCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHx+ExqB+PKBotD
	jAIcjEo8vBFzYoOFWBPLiitzDzFKcDArifB6OsUFC/GmJFZWpRblxxeV5qQWH2JMBjpqIrOU
	aHI+MFXklcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANj45vL
	P0+fiesLvOz3LHOVzhvJ1k7Bj6HX79YorFDJniS9PfftHXmdFdNWPu6bb3LcNMuv5UZnqv59
	5ZOS3osEZ+isPWbtcSJ/u4LpLKk4meyTYQ9n/vAoYf/XXZf4fcGxuhin/9v3/Ra7rnvsvhif
	4tz/+pt6117aHii58+TJibd+asXIivzaoMRSnJFoqMVcVJwIAFOh0ncLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves Exynos PMU driver implementation from
"arm/mach-exynos" to "drivers/mfd".
This driver is mainly used for setting misc bits of register from PMU IP
of Exynos SoC which will be required to configure before Suspend/Resume.
Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
moving ahead for ARM64 based SoC support, there is a need of DT based
implementation of PMU driver.
This driver uses already existing DT binding information.

CC: Sangbeom Kim <sbkim73@samsung.com>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Kconfig                           |    2 ++
 arch/arm/mach-exynos/Makefile                          |    2 --
 drivers/mfd/Kconfig                                    |    9 +++++++++
 drivers/mfd/Makefile                                   |    1 +
 arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c |    0
 5 files changed, 12 insertions(+), 2 deletions(-)
 rename arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c (100%)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 2f60c90..79559b4 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -27,6 +27,7 @@ config ARCH_EXYNOS4
 	select PM_GENERIC_DOMAINS if PM_RUNTIME
 	select S5P_DEV_MFC
 	select MFD_SYSCON
+	select MFD_EXYNOS_PMU
 	help
 	  Samsung EXYNOS4 SoCs based systems
 
@@ -38,6 +39,7 @@ config ARCH_EXYNOS5
 	select HAVE_SMP
 	select PINCTRL
 	select MFD_SYSCON
+	select MFD_EXYNOS_PMU
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
 
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index a656dbe..19fdf17 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -18,8 +18,6 @@ obj-$(CONFIG_PM_SLEEP)		+= pm.o sleep.o
 obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= pmu.o
-
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3383412..fd48870 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1203,6 +1203,15 @@ config MFD_STW481X
 	  in various ST Microelectronics and ST-Ericsson embedded
 	  Nomadik series.
 
+config MFD_EXYNOS_PMU
+	tristate "Support Exynos Power Managment Unit"
+	depends on ARM || ARM64
+	help
+	Exynos SoC have Power Management Unit (PMU) which controls power and
+	operation state of Exynos SoC in two different ways. This driver
+	provides impmentation of PMU driver and provides basic functionality
+	required during these operation state.
+
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 2851275..7c43d07 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -166,3 +166,4 @@ obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
+obj-$(CONFIG_MFD_EXYNOS_PMU)	+= exynos-pmu.o
diff --git a/arch/arm/mach-exynos/pmu.c b/drivers/mfd/exynos-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/pmu.c
rename to drivers/mfd/exynos-pmu.c
-- 
1.7.10.4

