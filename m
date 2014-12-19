Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaLSBmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:42:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52563 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751695AbaLSBmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:42:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>, Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH 1/4] spi: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Fri, 19 Dec 2014 02:49:26 +0100
Message-ID: <6486956.sOFTSHEqBe@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <472992175.g1ArEYGFPo@vostro.rjw.lan>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

A couple of new CONFIG_PM_RUNTIME users have been added recently
in the SPI subsystem.

However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so
#ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
depend on CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
drivers/spi/ (again).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Please let me know if there are any objections against pushing this through
the linux-pm tree.

---
 drivers/spi/spi-img-spfi.c    |    4 ++--
 drivers/spi/spi-meson-spifc.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/spi/spi-meson-spifc.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-meson-spifc.c
+++ linux-pm/drivers/spi/spi-meson-spifc.c
@@ -413,7 +413,7 @@ static int meson_spifc_resume(struct dev
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int meson_spifc_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
@@ -431,7 +431,7 @@ static int meson_spifc_runtime_resume(st
 
 	return clk_prepare_enable(spifc->clk);
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops meson_spifc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(meson_spifc_suspend, meson_spifc_resume)
Index: linux-pm/drivers/spi/spi-img-spfi.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-img-spfi.c
+++ linux-pm/drivers/spi/spi-img-spfi.c
@@ -663,7 +663,7 @@ static int img_spfi_remove(struct platfo
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int img_spfi_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
@@ -692,7 +692,7 @@ static int img_spfi_runtime_resume(struc
 
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
 static int img_spfi_suspend(struct device *dev)

