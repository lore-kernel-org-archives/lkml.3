Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaLFCJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:09:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60762 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751061AbaLFCI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:08:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Heiko Stuebner <heiko@sntech.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-spi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] SPI / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Sat, 06 Dec 2014 03:30:23 +0100
Message-ID: <2091649.zj2SIBdzpD@vostro.rjw.lan>
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

Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
drivers/spi/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/spi/spi-coldfire-qspi.c |    2 +-
 drivers/spi/spi-orion.c         |    2 +-
 drivers/spi/spi-pxa2xx.c        |    2 +-
 drivers/spi/spi-qup.c           |    4 ++--
 drivers/spi/spi-rockchip.c      |    4 ++--
 drivers/spi/spi-s3c64xx.c       |    4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/spi/spi-s3c64xx.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-s3c64xx.c
+++ linux-pm/drivers/spi/spi-s3c64xx.c
@@ -1266,7 +1266,7 @@ static int s3c64xx_spi_resume(struct dev
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int s3c64xx_spi_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
@@ -1296,7 +1296,7 @@ static int s3c64xx_spi_runtime_resume(st
 
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops s3c64xx_spi_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(s3c64xx_spi_suspend, s3c64xx_spi_resume)
Index: linux-pm/drivers/spi/spi-coldfire-qspi.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-coldfire-qspi.c
+++ linux-pm/drivers/spi/spi-coldfire-qspi.c
@@ -491,7 +491,7 @@ static int mcfqspi_resume(struct device
 }
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int mcfqspi_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
Index: linux-pm/drivers/spi/spi-qup.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-qup.c
+++ linux-pm/drivers/spi/spi-qup.c
@@ -646,7 +646,7 @@ error:
 	return ret;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int spi_qup_pm_suspend_runtime(struct device *device)
 {
 	struct spi_master *master = dev_get_drvdata(device);
@@ -672,7 +672,7 @@ static int spi_qup_pm_resume_runtime(str
 	writel_relaxed(config, controller->base + QUP_CONFIG);
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
 static int spi_qup_suspend(struct device *device)
Index: linux-pm/drivers/spi/spi-orion.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-orion.c
+++ linux-pm/drivers/spi/spi-orion.c
@@ -523,7 +523,7 @@ static int orion_spi_remove(struct platf
 
 MODULE_ALIAS("platform:" DRIVER_NAME);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int orion_spi_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
Index: linux-pm/drivers/spi/spi-rockchip.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-rockchip.c
+++ linux-pm/drivers/spi/spi-rockchip.c
@@ -801,7 +801,7 @@ static int rockchip_spi_resume(struct de
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int rockchip_spi_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
@@ -829,7 +829,7 @@ static int rockchip_spi_runtime_resume(s
 
 	return ret;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops rockchip_spi_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(rockchip_spi_suspend, rockchip_spi_resume)
Index: linux-pm/drivers/spi/spi-pxa2xx.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-pxa2xx.c
+++ linux-pm/drivers/spi/spi-pxa2xx.c
@@ -1307,7 +1307,7 @@ static int pxa2xx_spi_resume(struct devi
 }
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int pxa2xx_spi_runtime_suspend(struct device *dev)
 {
 	struct driver_data *drv_data = dev_get_drvdata(dev);

