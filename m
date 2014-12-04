Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaLDAxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:53:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58732 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751429AbaLDAxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:53:41 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: e1000-devel@lists.sourceforge.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        Linux NICS <linux.nics@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] e1000e / igb / PM: Eliminate CONFIG_PM_RUNTIME
Date: Thu, 04 Dec 2014 02:15:06 +0100
Message-ID: <2389302.4ImTL0YnUc@vostro.rjw.lan>
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
depending on CONFIG_PM_RUNTIME within #ifdef blocks depending on
CONFIG_PM may be dropped now.

Do that in the e1000e and igb network drivers.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/net/ethernet/intel/e1000e/netdev.c |    2 --
 drivers/net/ethernet/intel/igb/igb_main.c  |    6 +-----
 2 files changed, 1 insertion(+), 7 deletions(-)

Index: linux-pm/drivers/net/ethernet/intel/e1000e/netdev.c
===================================================================
--- linux-pm.orig/drivers/net/ethernet/intel/e1000e/netdev.c
+++ linux-pm/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6372,7 +6372,6 @@ static int e1000e_pm_resume(struct devic
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
 static int e1000e_pm_runtime_idle(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -6432,7 +6431,6 @@ static int e1000e_pm_runtime_suspend(str
 
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
 #endif /* CONFIG_PM */
 
 static void e1000_shutdown(struct pci_dev *pdev)
Index: linux-pm/drivers/net/ethernet/intel/igb/igb_main.c
===================================================================
--- linux-pm.orig/drivers/net/ethernet/intel/igb/igb_main.c
+++ linux-pm/drivers/net/ethernet/intel/igb/igb_main.c
@@ -186,11 +186,9 @@ static int igb_pci_enable_sriov(struct p
 static int igb_suspend(struct device *);
 #endif
 static int igb_resume(struct device *);
-#ifdef CONFIG_PM_RUNTIME
 static int igb_runtime_suspend(struct device *dev);
 static int igb_runtime_resume(struct device *dev);
 static int igb_runtime_idle(struct device *dev);
-#endif
 static const struct dev_pm_ops igb_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(igb_suspend, igb_resume)
 	SET_RUNTIME_PM_OPS(igb_runtime_suspend, igb_runtime_resume,
@@ -7441,7 +7439,6 @@ static int igb_resume(struct device *dev
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
 static int igb_runtime_idle(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -7478,8 +7475,7 @@ static int igb_runtime_resume(struct dev
 {
 	return igb_resume(dev);
 }
-#endif /* CONFIG_PM_RUNTIME */
-#endif
+#endif /* CONFIG_PM */
 
 static void igb_shutdown(struct pci_dev *pdev)
 {

