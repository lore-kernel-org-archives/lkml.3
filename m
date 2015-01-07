Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbbAGFja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:39:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9597 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbAGFjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:39:22 -0500
X-AuditID: cbfee68d-f79296d000004278-db-54acc688506e
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene@kernel.org, linux@arm.linux.org.uk, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, arnd@arndb.de, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Andy Gross <agross@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 6/6] drivers: soc: Add support for Exynos PMU driver
Date: Wed, 07 Jan 2015 11:01:28 +0530
Message-id: <1420608688-10459-7-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
References: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkRrfj2JoQg8WPOSx2fuhmsmi4GmLx
	d9IxdouNM9azWvQ/fs1sMeXPciaLTY+vsVpc3jWHzWLG+X1MFrcv81os2vqF3eJ13xpmixvT
	W1gtOpYxOvB5tDT3sHn8/jWJ0eNyXy+Tx6ZVnWwed67tYfPYvKTeo7f5HZtH35ZVjB7Hb2xn
	8vi8SS6AK4rLJiU1J7MstUjfLoEr49efpcwFawwq5h+cydTAOEWji5GTQ0LARKJx5TV2CFtM
	4sK99WxdjFwcQgJLGSWenNnGAlPUcPM4I0RiOqPE+kVXmSGcCUwSh/79ZgapYhPQlXjyfi6Y
	LSKQLdF/ezULSBGzwE0mictHnwHN5eAQFnCXmHFIAMRkEVCVmN7EClLOK+Ahcf3BOVaIZXIS
	W249AruIU8BT4tnU/2BxIaCa3w0fGCFq3rJLvP8iCWKzCAhIfJt8iAVkpISArMSmA8wQJZIS
	B1fcYJnAKLyAkWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmBUnf73rHcH4+0D1ocYBTgY
	lXh4C/rWhAixJpYVV+YeYjQF2jCRWUo0OR8Yu3kl8YbGZkYWpiamxkbmlmZK4ryKUj+DhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTA6nPG7+cnFS+Xiz2d3ddayMMW8TDyTXtB99U3Y556L
	WnqJKumMsVMZiw+e2rXY5LJikttmp8Z0I3eDvxtFpqa8/unvf33PntBjZu+ub9zpo3Ll2gqD
	BSW7ZnD6MZqt5LjN4aXwR6a0JaOnpWyXB9PXU5/Vg79uf67WkuV2ekek9KpZFhOuLspVYinO
	SDTUYi4qTgQAwl0D56UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd2OY2tCDFbrW+z80M1k0XA1xOLv
	pGPsFhtnrGe16H/8mtliyp/lTBabHl9jtbi8aw6bxYzz+5gsbl/mtVi09Qu7xeu+NcwWN6a3
	sFp0LGN04PNoae5h8/j9axKjx+W+XiaPTas62TzuXNvD5rF5Sb1Hb/M7No++LasYPY7f2M7k
	8XmTXABXVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5b
	Zg7Q+UoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjF9/ljIXrDGomH9w
	JlMD4xSNLkZODgkBE4mGm8cZIWwxiQv31rN1MXJxCAlMZ5RYv+gqM4QzgUni0L/fzCBVbAK6
	Ek/ezwWzRQSyJfpvr2YBKWIWuMkkcfnoM6B2Dg5hAXeJGYcEQEwWAVWJ6U2sIOW8Ah4S1x+c
	Y4VYJiex5dYjdhCbU8BT4tnU/2BxIaCa3w0fGCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqX
	rpecn7uJERyzz6R3MK5qsDjEKMDBqMTDW9C3JkSINbGsuDL3EKMEB7OSCK9VJ1CINyWxsiq1
	KD++qDQntfgQoynQUROZpUST84HpJK8k3tDYxNzU2NTSxMLEzFJJnFfJvi1ESCA9sSQ1OzW1
	ILUIpo+Jg1OqgXFu+G7/vWEPNXoqVt0V6V02+eilzES5nu8r92TwrEk9pLeq2ikggX9baO5q
	Bf8g1tQr+TbvDlRN/j85fVKqB5PLmV7lGsOixTm7H5UyesVbMe6xNTnAY5T/7X9/J/vsbN7V
	Ww5PD+c58k7JrOD2ux8bF0XtM925We3CaT6ucI412WtMVjed9VBiKc5INNRiLipOBABGv0Wa
	7wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves Exynos PMU driver implementation from "arm/mach-exynos"
to "drivers/soc/samsung". This driver is mainly used for setting misc
bits of register from PMU IP of Exynos SoC which will be required to
configure before Suspend/Resume. Currently all these settings are done
in "arch/arm/mach-exynos/pmu.c" but moving ahead for ARM64 based SoC
support, there is a need of this PMU driver in driver/* folder.

This driver uses existing DT binding information and there should
be no functionality change in the supported platforms.

CC: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>
CC: Andy Gross <agross@codeaurora.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Kconfig                         |  1 +
 arch/arm/mach-exynos/Makefile                        |  4 +---
 drivers/soc/Kconfig                                  |  1 +
 drivers/soc/Makefile                                 |  1 +
 drivers/soc/samsung/Kconfig                          | 20 ++++++++++++++++++++
 drivers/soc/samsung/Makefile                         |  4 ++++
 .../pmu.c => drivers/soc/samsung/exynos-pmu.c        |  0
 .../mach-exynos => drivers/soc/samsung}/exynos-pmu.h |  0
 .../soc/samsung}/exynos3250-pmu.c                    |  0
 .../soc/samsung}/exynos4-pmu.c                       |  0
 .../soc/samsung}/exynos5250-pmu.c                    |  0
 .../soc/samsung}/exynos5420-pmu.c                    |  0
 12 files changed, 28 insertions(+), 3 deletions(-)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (100%)
 rename {arch/arm/mach-exynos => drivers/soc/samsung}/exynos-pmu.h (100%)
 rename {arch/arm/mach-exynos => drivers/soc/samsung}/exynos3250-pmu.c (100%)
 rename {arch/arm/mach-exynos => drivers/soc/samsung}/exynos4-pmu.c (100%)
 rename {arch/arm/mach-exynos => drivers/soc/samsung}/exynos5250-pmu.c (100%)
 rename {arch/arm/mach-exynos => drivers/soc/samsung}/exynos5420-pmu.c (100%)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 603820e..2e00b75 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -25,6 +25,7 @@ menuconfig ARCH_EXYNOS
 	select S5P_DEV_MFC
 	select SRAM
 	select MFD_SYSCON
+	select SOC_SAMSUNG
 	help
 	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
 
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 462df1b..b91b382 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -9,9 +9,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)
 
 # Core
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o \
-					exynos3250-pmu.o exynos4-pmu.o \
-					exynos5250-pmu.o exynos5420-pmu.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o exynos-smc.o firmware.o
 
 obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
 obj-$(CONFIG_PM_SLEEP)		+= suspend.o
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 76d6bd4..c3abfbe 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -1,6 +1,7 @@
 menu "SOC (System On Chip) specific Drivers"
 
 source "drivers/soc/qcom/Kconfig"
+source "drivers/soc/samsung/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
 
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 063113d..620366f 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
+obj-$(CONFIG_SOC_SAMSUNG)	+= samsung/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
 obj-$(CONFIG_PLAT_VERSATILE)	+= versatile/
diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
new file mode 100644
index 0000000..6855cc4
--- /dev/null
+++ b/drivers/soc/samsung/Kconfig
@@ -0,0 +1,20 @@
+#
+# SAMSUNG SOC drivers
+#
+menu "Samsung SOC drivers support"
+
+config SOC_SAMSUNG
+	bool
+
+config EXYNOS_PMU
+	bool "Support Exynos Power Management Unit"
+	depends on ARCH_EXYNOS
+	default y
+	help
+	  Exynos SoC have Power Management Unit (PMU) which controls power and
+	  operation state of various components in Exynos SoC. This driver
+	  provides implementation of PMU driver and provides various
+	  functionality like initialisation and transition to various low power
+	  states.
+
+endmenu
diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
new file mode 100644
index 0000000..d746a1d
--- /dev/null
+++ b/drivers/soc/samsung/Makefile
@@ -0,0 +1,4 @@
+ifdef CONFIG_ARM
+obj-$(CONFIG_EXYNOS_PMU)	+= exynos-pmu.o exynos3250-pmu.o exynos4-pmu.o \
+					exynos5250-pmu.o exynos5420-pmu.o
+endif
diff --git a/arch/arm/mach-exynos/pmu.c b/drivers/soc/samsung/exynos-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/pmu.c
rename to drivers/soc/samsung/exynos-pmu.c
diff --git a/arch/arm/mach-exynos/exynos-pmu.h b/drivers/soc/samsung/exynos-pmu.h
similarity index 100%
rename from arch/arm/mach-exynos/exynos-pmu.h
rename to drivers/soc/samsung/exynos-pmu.h
diff --git a/arch/arm/mach-exynos/exynos3250-pmu.c b/drivers/soc/samsung/exynos3250-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/exynos3250-pmu.c
rename to drivers/soc/samsung/exynos3250-pmu.c
diff --git a/arch/arm/mach-exynos/exynos4-pmu.c b/drivers/soc/samsung/exynos4-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/exynos4-pmu.c
rename to drivers/soc/samsung/exynos4-pmu.c
diff --git a/arch/arm/mach-exynos/exynos5250-pmu.c b/drivers/soc/samsung/exynos5250-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/exynos5250-pmu.c
rename to drivers/soc/samsung/exynos5250-pmu.c
diff --git a/arch/arm/mach-exynos/exynos5420-pmu.c b/drivers/soc/samsung/exynos5420-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/exynos5420-pmu.c
rename to drivers/soc/samsung/exynos5420-pmu.c
-- 
2.2.0

