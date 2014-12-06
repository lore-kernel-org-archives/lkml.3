Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaLFC2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:28:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65071 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751167AbaLFC2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:28:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] ARM / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Sat, 06 Dec 2014 03:50:03 +0100
Message-ID: <2407638.dfZGaT4vm1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
depending on CONFIG_PM_RUNTIME may now be changed to depend on
CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere in the code under
arch/arm/ (the defconfig files will be modified later).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 arch/arm/kernel/perf_event.c       |    2 +-
 arch/arm/mach-davinci/pm_domain.c  |    2 +-
 arch/arm/mach-keystone/pm_domain.c |    2 +-
 arch/arm/mach-omap1/pm_bus.c       |    4 ++--
 arch/arm/mach-omap2/io.c           |    2 +-
 arch/arm/mach-omap2/omap_device.c  |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-pm/arch/arm/kernel/perf_event.c
===================================================================
--- linux-pm.orig/arch/arm/kernel/perf_event.c
+++ linux-pm/arch/arm/kernel/perf_event.c
@@ -481,7 +481,7 @@ static void armpmu_disable(struct pmu *p
 	armpmu->stop(armpmu);
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int armpmu_runtime_resume(struct device *dev)
 {
 	struct arm_pmu_platdata *plat = dev_get_platdata(dev);
Index: linux-pm/arch/arm/mach-davinci/pm_domain.c
===================================================================
--- linux-pm.orig/arch/arm/mach-davinci/pm_domain.c
+++ linux-pm/arch/arm/mach-davinci/pm_domain.c
@@ -14,7 +14,7 @@
 #include <linux/pm_clock.h>
 #include <linux/platform_device.h>
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int davinci_pm_runtime_suspend(struct device *dev)
 {
 	int ret;
Index: linux-pm/arch/arm/mach-keystone/pm_domain.c
===================================================================
--- linux-pm.orig/arch/arm/mach-keystone/pm_domain.c
+++ linux-pm/arch/arm/mach-keystone/pm_domain.c
@@ -19,7 +19,7 @@
 #include <linux/clk-provider.h>
 #include <linux/of.h>
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int keystone_pm_runtime_suspend(struct device *dev)
 {
 	int ret;
Index: linux-pm/arch/arm/mach-omap1/pm_bus.c
===================================================================
--- linux-pm.orig/arch/arm/mach-omap1/pm_bus.c
+++ linux-pm/arch/arm/mach-omap1/pm_bus.c
@@ -21,7 +21,7 @@
 
 #include "soc.h"
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int omap1_pm_runtime_suspend(struct device *dev)
 {
 	int ret;
@@ -59,7 +59,7 @@ static struct dev_pm_domain default_pm_d
 #define OMAP1_PM_DOMAIN (&default_pm_domain)
 #else
 #define OMAP1_PM_DOMAIN NULL
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static struct pm_clk_notifier_block platform_bus_notifier = {
 	.pm_domain = OMAP1_PM_DOMAIN,
Index: linux-pm/arch/arm/mach-omap2/io.c
===================================================================
--- linux-pm.orig/arch/arm/mach-omap2/io.c
+++ linux-pm/arch/arm/mach-omap2/io.c
@@ -359,7 +359,7 @@ static void __init omap_hwmod_init_posts
 	u8 postsetup_state;
 
 	/* Set the default postsetup state for all hwmods */
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	postsetup_state = _HWMOD_STATE_IDLE;
 #else
 	postsetup_state = _HWMOD_STATE_ENABLED;
Index: linux-pm/arch/arm/mach-omap2/omap_device.c
===================================================================
--- linux-pm.orig/arch/arm/mach-omap2/omap_device.c
+++ linux-pm/arch/arm/mach-omap2/omap_device.c
@@ -588,7 +588,7 @@ odbs_exit:
 	return ERR_PTR(ret);
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int _od_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);

