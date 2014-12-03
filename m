Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaLCBWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:22:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53351 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750896AbaLCBWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:22:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] DMA / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 02:44:08 +0100
Message-ID: <2237445.kkHAuggnGG@vostro.rjw.lan>
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

Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/dma/nbpfaxi.c
and drivers/dma/tegra20-apb-dma.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/dma/nbpfaxi.c         |    2 +-
 drivers/dma/tegra20-apb-dma.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/dma/nbpfaxi.c
===================================================================
--- linux-pm.orig/drivers/dma/nbpfaxi.c
+++ linux-pm/drivers/dma/nbpfaxi.c
@@ -1479,7 +1479,7 @@ static struct platform_device_id nbpf_id
 };
 MODULE_DEVICE_TABLE(platform, nbpf_ids);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int nbpf_runtime_suspend(struct device *dev)
 {
 	struct nbpf_device *nbpf = platform_get_drvdata(to_platform_device(dev));
Index: linux-pm/drivers/dma/tegra20-apb-dma.c
===================================================================
--- linux-pm.orig/drivers/dma/tegra20-apb-dma.c
+++ linux-pm/drivers/dma/tegra20-apb-dma.c
@@ -1587,7 +1587,7 @@ static int tegra_dma_pm_resume(struct de
 #endif
 
 static const struct dev_pm_ops tegra_dma_dev_pm_ops = {
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	.runtime_suspend = tegra_dma_runtime_suspend,
 	.runtime_resume = tegra_dma_runtime_resume,
 #endif

