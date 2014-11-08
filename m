Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaKHNWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:22:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41176 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaKHNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:22:43 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f2-545e1920f8db
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, lee.jones@linaro.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 2/6] drivers: soc: Add support for Exynos PMU driver
Date: Sat, 08 Nov 2014 18:46:37 +0530
Message-id: <1415452601-13078-3-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkWldRMi7E4NAfRouGqyEWvQuuslnc
	/3qU0WLT42usFpd3zWGzmHF+H5PFoq1f2C0Ov2lndeDwuHNtD5vH5iX1Hn1bVjF6fN4kF8AS
	xWWTkpqTWZZapG+XwJVx+uEDpoK5MhXHOk+yNjBOFe9i5OSQEDCRmHD9CguELSZx4d56ti5G
	Lg4hgaWMEu0X57DDFB2beRgqMZ1R4sDRRiYIZwKTxMPZN9hAqtgEjCV+7twP1MHBISLgLbH8
	miJIDbPAYUaJSUceM4PUCAu4S0y7vIcJxGYRUJW49aEfLM4LFL+yrhesV0JAQWLOJBuQMKeA
	h8SCvd1g1wkBlWx6+I8RZKaEwGR2iUe7P7NAzBGQ+Db5EAtEr6zEpgPMEEdLShxccYNlAqPw
	AkaGVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxiBIX7637MJOxjvHbA+xCjAwajEw3ujJTZE
	iDWxrLgy9xCjKdCGicxSosn5wEjKK4k3NDYzsjA1MTU2Mrc0UxLnfS31M1hIID2xJDU7NbUg
	tSi+qDQntfgQIxMHp1QDo8U+nzNCLd1nJFmScj6H5crHpaft70iTLF+l+yRkdcmBpCuzPgrN
	6GB4e8dfot19QtuUu2zh/IanfC8+ev9cNeZC0z//NPVH1m+KdPxzEk9ueZlkvzlr2fcZXtf4
	T65XufHqzOfKR89zd+tIPHsdUyPw0SqsLKEvQetLaswhuaxt9qyVbgdLlFiKMxINtZiLihMB
	pjwy0mwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQV0FybgQg/dTTC0aroZY9C64ymZx
	/+tRRotNj6+xWlzeNYfNYsb5fUwWi7Z+Ybc4/Kad1YHD4861PWwem5fUe/RtWcXo8XmTXABL
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjNMPHzAVzJWpONZ5krWBcap4
	FyMnh4SAicSxmYfZIGwxiQv31gPZXBxCAtMZJQ4cbWSCcCYwSTycfQOsik3AWOLnzv3sXYwc
	HCIC3hLLrymC1DALHGaUmHTkMTNIjbCAu8S0y3uYQGwWAVWJWx/6weK8QPEr63rBeiUEFCTm
	TLIBCXMKeEgs2NvNAmILAZVseviPcQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsY
	wRH0THoH46oGi0OMAhyMSjy8N1piQ4RYE8uKK3MPMUpwMCuJ8PaeBwrxpiRWVqUW5ccXleak
	Fh9iNAU6aiKzlGhyPjC680riDY1NzE2NTS1NLEzMLJXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFx
	cEo1MNaHLAiLDpiu94fx1MIHB0Le57x87SV06Q/H04vNm6o+uYqpXbd4m2BXslGsYJ4jy67b
	vtc0Vp6aZRKwIcDXN3tN7dRP5Z+FOy6fPV8gOdN4jqdG8Gu2CXNZp/3iYJurXd0atMnvVSZf
	26xtLDqswdHf1pTk9gdG8wbO01lZ+Tl1w5z3THG105VYijMSDbWYi4oTAbpcqmq2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves Exynos PMU driver implementation from "arm/mach-exynos"
to "drivers/soc/samsung". This driver is mainly used for setting misc bits of
register from PMU IP of Exynos SoC which will be required to configure
before Suspend/Resume. Currently all these settings are done in
"arch/arm/mach-exynos/pmu.c" but moving ahead for ARM64 based SoC
support,there is a need of DT based implementation of PMU driver.

This driver uses already existing DT binding information.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/Makefile                      |    2 +-
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   19 +++++++++++++++++++
 drivers/soc/samsung/Makefile                       |    1 +
 .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |    0
 6 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (100%)

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index bcefb54..b91b382 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -9,7 +9,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)
 
 # Core
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o exynos-smc.o firmware.o
 
 obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
 obj-$(CONFIG_PM_SLEEP)		+= suspend.o
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 76d6bd4..90f33b9 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -3,5 +3,6 @@ menu "SOC (System On Chip) specific Drivers"
 source "drivers/soc/qcom/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
+source "drivers/soc/samsung/Kconfig"
 
 endmenu
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 063113d..44d220d 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
 obj-$(CONFIG_PLAT_VERSATILE)	+= versatile/
+obj-$(CONFIG_ARCH_EXYNOS)	+= samsung/
diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
new file mode 100644
index 0000000..beb6dfc
--- /dev/null
+++ b/drivers/soc/samsung/Kconfig
@@ -0,0 +1,19 @@
+#
+# SAMSUNG SOC drivers
+#
+menuconfig SOC_SAMSUNG
+	bool "Samsung SOC drivers support"
+
+if SOC_SAMSUNG
+
+config MFD_EXYNOS_PMU
+	tristate "Support Exynos Power Management Unit"
+	depends on ARM || ARM64
+	default y
+	help
+	  Exynos SoC have Power Management Unit (PMU) which controls power and
+	  operation state of Exynos SoC in two different ways. This driver
+	  provides implementation of PMU driver and provides basic functionality
+	  required during these operation state.
+
+endif #SOC_SAMSUNG
diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
new file mode 100644
index 0000000..9d30f61
--- /dev/null
+++ b/drivers/soc/samsung/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MFD_EXYNOS_PMU)	+= exynos-pmu.o
diff --git a/arch/arm/mach-exynos/pmu.c b/drivers/soc/samsung/exynos-pmu.c
similarity index 100%
rename from arch/arm/mach-exynos/pmu.c
rename to drivers/soc/samsung/exynos-pmu.c
-- 
1.7.9.5

