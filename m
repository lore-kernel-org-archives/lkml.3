Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaLDAdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:33:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52287 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751106AbaLDAdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:33:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] MFD / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Thu, 04 Dec 2014 01:54:41 +0100
Message-ID: <2857906.7ft1XTNUKe@vostro.rjw.lan>
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
drivers/mfd/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/mfd/ab8500-gpadc.c |    2 +-
 drivers/mfd/arizona-core.c |    4 ++--
 drivers/mfd/wm8994-core.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/mfd/ab8500-gpadc.c
===================================================================
--- linux-pm.orig/drivers/mfd/ab8500-gpadc.c
+++ linux-pm/drivers/mfd/ab8500-gpadc.c
@@ -867,7 +867,7 @@ static void ab8500_gpadc_read_calibratio
 		gpadc->cal_data[ADC_INPUT_VBAT].offset);
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int ab8500_gpadc_runtime_suspend(struct device *dev)
 {
 	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
Index: linux-pm/drivers/mfd/wm8994-core.c
===================================================================
--- linux-pm.orig/drivers/mfd/wm8994-core.c
+++ linux-pm/drivers/mfd/wm8994-core.c
@@ -116,7 +116,7 @@ static const char *wm8958_main_supplies[
 	"SPKVDD2",
 };
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int wm8994_suspend(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
Index: linux-pm/drivers/mfd/arizona-core.c
===================================================================
--- linux-pm.orig/drivers/mfd/arizona-core.c
+++ linux-pm/drivers/mfd/arizona-core.c
@@ -330,7 +330,7 @@ err_fll:
 		return err;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int arizona_runtime_resume(struct device *dev)
 {
 	struct arizona *arizona = dev_get_drvdata(dev);
@@ -1024,7 +1024,7 @@ int arizona_dev_init(struct arizona *ari
 		goto err_irq;
 	}
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	regulator_disable(arizona->dcvdd);
 #endif
 

