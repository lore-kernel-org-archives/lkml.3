Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbaK0Vo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:44:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56600 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750756AbaK0Vo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:44:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [Replacement][PATCH 1/4] PM: Merge the SET*_RUNTIME_PM_OPS() macros
Date: Thu, 27 Nov 2014 23:05:41 +0100
Message-ID: <1740704.VN27cDdEAu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3484329.phAPviVnbd@vostro.rjw.lan>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan> <3484329.phAPviVnbd@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The SET_PM_RUNTIME_PM_OPS() and SET_RUNTIME_PM_OPS() macros are
identical except that one of them is not empty for CONFIG_PM set,
while the other one is not empty for CONFIG_PM_RUNTIME set,
respectively.

However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so one
of these macros is now redundant.

For this reason, replace SET_PM_RUNTIME_PM_OPS() with
SET_RUNTIME_PM_OPS() everywhere and redefine the SET_PM_RUNTIME_PM_OPS
symbol as SET_RUNTIME_PM_OPS in case new code is starting to use the
macro being removed here.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

It turns out that some new drivers are starting to use SET_PM_RUNTIME_PM_OPS,
so add a #define mapping it onto SET_RUNTIME_PM_OPS for them (we'll fix that
up when things settle).

---
 drivers/amba/bus.c                |    2 +-
 drivers/dma/ste_dma40.c           |    2 +-
 drivers/gpio/gpio-zynq.c          |    2 +-
 drivers/i2c/busses/i2c-hix5hd2.c  |    2 +-
 drivers/i2c/busses/i2c-nomadik.c  |    2 +-
 drivers/mmc/host/mmci.c           |    2 +-
 drivers/mmc/host/sh_mobile_sdhi.c |    2 +-
 drivers/mmc/host/tmio_mmc.c       |    2 +-
 drivers/spi/spi-pl022.c           |    2 +-
 include/linux/pm.h                |   11 ++---------
 10 files changed, 11 insertions(+), 18 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Index: linux-pm/drivers/amba/bus.c
===================================================================
--- linux-pm.orig/drivers/amba/bus.c
+++ linux-pm/drivers/amba/bus.c
@@ -124,7 +124,7 @@ static const struct dev_pm_ops amba_pm =
 	.thaw		= pm_generic_thaw,
 	.poweroff	= pm_generic_poweroff,
 	.restore	= pm_generic_restore,
-	SET_PM_RUNTIME_PM_OPS(
+	SET_RUNTIME_PM_OPS(
 		amba_pm_runtime_suspend,
 		amba_pm_runtime_resume,
 		NULL
Index: linux-pm/drivers/dma/ste_dma40.c
===================================================================
--- linux-pm.orig/drivers/dma/ste_dma40.c
+++ linux-pm/drivers/dma/ste_dma40.c
@@ -3051,7 +3051,7 @@ static int dma40_runtime_resume(struct d
 
 static const struct dev_pm_ops dma40_pm_ops = {
 	SET_LATE_SYSTEM_SLEEP_PM_OPS(dma40_suspend, dma40_resume)
-	SET_PM_RUNTIME_PM_OPS(dma40_runtime_suspend,
+	SET_RUNTIME_PM_OPS(dma40_runtime_suspend,
 				dma40_runtime_resume,
 				NULL)
 };
Index: linux-pm/drivers/gpio/gpio-zynq.c
===================================================================
--- linux-pm.orig/drivers/gpio/gpio-zynq.c
+++ linux-pm/drivers/gpio/gpio-zynq.c
@@ -578,7 +578,7 @@ static void zynq_gpio_free(struct gpio_c
 
 static const struct dev_pm_ops zynq_gpio_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(zynq_gpio_suspend, zynq_gpio_resume)
-	SET_PM_RUNTIME_PM_OPS(zynq_gpio_runtime_suspend,
+	SET_RUNTIME_PM_OPS(zynq_gpio_runtime_suspend,
 			zynq_gpio_runtime_resume, NULL)
 };
 
Index: linux-pm/drivers/i2c/busses/i2c-hix5hd2.c
===================================================================
--- linux-pm.orig/drivers/i2c/busses/i2c-hix5hd2.c
+++ linux-pm/drivers/i2c/busses/i2c-hix5hd2.c
@@ -528,7 +528,7 @@ static int hix5hd2_i2c_runtime_resume(st
 #endif
 
 static const struct dev_pm_ops hix5hd2_i2c_pm_ops = {
-	SET_PM_RUNTIME_PM_OPS(hix5hd2_i2c_runtime_suspend,
+	SET_RUNTIME_PM_OPS(hix5hd2_i2c_runtime_suspend,
 			      hix5hd2_i2c_runtime_resume,
 			      NULL)
 };
Index: linux-pm/drivers/i2c/busses/i2c-nomadik.c
===================================================================
--- linux-pm.orig/drivers/i2c/busses/i2c-nomadik.c
+++ linux-pm/drivers/i2c/busses/i2c-nomadik.c
@@ -932,7 +932,7 @@ static int nmk_i2c_runtime_resume(struct
 
 static const struct dev_pm_ops nmk_i2c_pm = {
 	SET_LATE_SYSTEM_SLEEP_PM_OPS(nmk_i2c_suspend_late, nmk_i2c_resume_early)
-	SET_PM_RUNTIME_PM_OPS(nmk_i2c_runtime_suspend,
+	SET_RUNTIME_PM_OPS(nmk_i2c_runtime_suspend,
 			nmk_i2c_runtime_resume,
 			NULL)
 };
Index: linux-pm/drivers/mmc/host/mmci.c
===================================================================
--- linux-pm.orig/drivers/mmc/host/mmci.c
+++ linux-pm/drivers/mmc/host/mmci.c
@@ -1843,7 +1843,7 @@ static int mmci_runtime_resume(struct de
 static const struct dev_pm_ops mmci_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
 				pm_runtime_force_resume)
-	SET_PM_RUNTIME_PM_OPS(mmci_runtime_suspend, mmci_runtime_resume, NULL)
+	SET_RUNTIME_PM_OPS(mmci_runtime_suspend, mmci_runtime_resume, NULL)
 };
 
 static struct amba_id mmci_ids[] = {
Index: linux-pm/drivers/mmc/host/sh_mobile_sdhi.c
===================================================================
--- linux-pm.orig/drivers/mmc/host/sh_mobile_sdhi.c
+++ linux-pm/drivers/mmc/host/sh_mobile_sdhi.c
@@ -375,7 +375,7 @@ static int sh_mobile_sdhi_remove(struct
 static const struct dev_pm_ops tmio_mmc_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
 			pm_runtime_force_resume)
-	SET_PM_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
+	SET_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
 			tmio_mmc_host_runtime_resume,
 			NULL)
 };
Index: linux-pm/drivers/mmc/host/tmio_mmc.c
===================================================================
--- linux-pm.orig/drivers/mmc/host/tmio_mmc.c
+++ linux-pm/drivers/mmc/host/tmio_mmc.c
@@ -135,7 +135,7 @@ static int tmio_mmc_remove(struct platfo
 
 static const struct dev_pm_ops tmio_mmc_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(tmio_mmc_suspend, tmio_mmc_resume)
-	SET_PM_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
+	SET_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
 			tmio_mmc_host_runtime_resume,
 			NULL)
 };
Index: linux-pm/drivers/spi/spi-pl022.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-pl022.c
+++ linux-pm/drivers/spi/spi-pl022.c
@@ -2377,7 +2377,7 @@ static int pl022_runtime_resume(struct d
 
 static const struct dev_pm_ops pl022_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pl022_suspend, pl022_resume)
-	SET_PM_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
+	SET_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
 };
 
 static struct vendor_data vendor_arm = {
Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -342,7 +342,7 @@ struct dev_pm_ops {
 #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
 	.runtime_suspend = suspend_fn, \
 	.runtime_resume = resume_fn, \
@@ -351,14 +351,7 @@ struct dev_pm_ops {
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #endif
 
-#ifdef CONFIG_PM
-#define SET_PM_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
-	.runtime_suspend = suspend_fn, \
-	.runtime_resume = resume_fn, \
-	.runtime_idle = idle_fn,
-#else
-#define SET_PM_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
-#endif
+#define SET_PM_RUNTIME_PM_OPS	SET_RUNTIME_PM_OPS
 
 /*
  * Use this if you want to use the same suspend and resume callbacks for suspend

