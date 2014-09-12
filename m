Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaILIih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:38:37 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50589 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbaILIif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:38:35 -0400
Message-ID: <1410511111.31130.4.camel@x220>
Subject: [PATCH] PM / OPP: Remove ARCH_HAS_OPP completely
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Nishanth Menon <nm@ti.com>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 10:38:31 +0200
In-Reply-To: <1406551632.5397.17.camel@x220>
References: <1406551632.5397.17.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2014 08:38:31.0900 (UTC) FILETIME=[EF0271C0:01CFCE64]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
removed the only dependency that used it. Setting it had no effect
anymore.

So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
some reason that commit did not remove all select statements for that
symbol. These statements are useless. Remove them too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Done on top of next-20140912. Tested with git grep only!

 arch/arm/mach-omap2/Kconfig    | 5 -----
 arch/arm/mach-shmobile/Kconfig | 1 -
 drivers/devfreq/Kconfig        | 1 -
 3 files changed, 7 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 5b103099626d..f138bd33a463 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -22,7 +22,6 @@ config ARCH_OMAP4
 	bool "TI OMAP4"
 	depends on ARCH_MULTI_V7
 	select ARCH_OMAP2PLUS
-	select ARCH_HAS_OPP
 	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
 	select ARM_CPU_SUSPEND if PM
 	select ARM_ERRATA_720789
@@ -41,7 +40,6 @@ config SOC_OMAP5
 	bool "TI OMAP5"
 	depends on ARCH_MULTI_V7
 	select ARCH_OMAP2PLUS
-	select ARCH_HAS_OPP
 	select ARM_CPU_SUSPEND if PM
 	select ARM_GIC
 	select HAVE_ARM_SCU if SMP
@@ -53,14 +51,12 @@ config SOC_AM33XX
 	bool "TI AM33XX"
 	depends on ARCH_MULTI_V7
 	select ARCH_OMAP2PLUS
-	select ARCH_HAS_OPP
 	select ARM_CPU_SUSPEND if PM
 
 config SOC_AM43XX
 	bool "TI AM43x"
 	depends on ARCH_MULTI_V7
 	select ARCH_OMAP2PLUS
-	select ARCH_HAS_OPP
 	select ARM_GIC
 	select MACH_OMAP_GENERIC
 	select MIGHT_HAVE_CACHE_L2X0
@@ -69,7 +65,6 @@ config SOC_DRA7XX
 	bool "TI DRA7XX"
 	depends on ARCH_MULTI_V7
 	select ARCH_OMAP2PLUS
-	select ARCH_HAS_OPP
 	select ARM_CPU_SUSPEND if PM
 	select ARM_GIC
 	select HAVE_ARM_ARCH_TIMER
diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 21f457b56c01..f59019dd986e 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -36,7 +36,6 @@ menuconfig ARCH_SHMOBILE_MULTI
 	select NO_IOPORT_MAP
 	select PINCTRL
 	select ARCH_REQUIRE_GPIOLIB
-	select ARCH_HAS_OPP
 
 if ARCH_SHMOBILE_MULTI
 
diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 3dced0a9eae3..2227e9bf3884 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -80,7 +80,6 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 config ARM_EXYNOS5_BUS_DEVFREQ
 	bool "ARM Exynos5250 Bus DEVFREQ Driver"
 	depends on SOC_EXYNOS5250
-	select ARCH_HAS_OPP
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select PM_OPP
 	help
-- 
1.9.3


