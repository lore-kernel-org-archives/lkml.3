Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaLDAfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:35:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50028 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751322AbaLDAfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:35:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Piel <eric.piel@tremplin-utc.net>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] misc / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Thu, 04 Dec 2014 01:57:13 +0100
Message-ID: <2262178.AG1kTbXfTd@vostro.rjw.lan>
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
drivers/misc/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/misc/apds990x.c                |    4 ++--
 drivers/misc/bh1770glc.c               |    2 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    4 ++--
 drivers/misc/mei/mei_dev.h             |    4 ++--
 drivers/misc/mei/pci-me.c              |    8 ++++----
 drivers/misc/mei/pci-txe.c             |    8 +++-----
 6 files changed, 14 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
===================================================================
--- linux-pm.orig/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ linux-pm/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -235,7 +235,7 @@ static int lis3lv02d_i2c_resume(struct d
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int lis3_i2c_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
@@ -253,7 +253,7 @@ static int lis3_i2c_runtime_resume(struc
 	lis3lv02d_poweron(lis3);
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static const struct i2c_device_id lis3lv02d_id[] = {
 	{"lis3lv02d", LIS3LV02D},
Index: linux-pm/drivers/misc/mei/mei_dev.h
===================================================================
--- linux-pm.orig/drivers/misc/mei/mei_dev.h
+++ linux-pm/drivers/misc/mei/mei_dev.h
@@ -530,9 +530,9 @@ struct mei_device {
 	 * Power Gating support
 	 */
 	enum mei_pg_event pg_event;
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	struct dev_pm_domain pg_domain;
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];
 	u32 rd_msg_hdr;
Index: linux-pm/drivers/misc/mei/pci-me.c
===================================================================
--- linux-pm.orig/drivers/misc/mei/pci-me.c
+++ linux-pm/drivers/misc/mei/pci-me.c
@@ -89,13 +89,13 @@ static const struct pci_device_id mei_me
 
 MODULE_DEVICE_TABLE(pci, mei_me_pci_tbl);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static inline void mei_me_set_pm_domain(struct mei_device *dev);
 static inline void mei_me_unset_pm_domain(struct mei_device *dev);
 #else
 static inline void mei_me_set_pm_domain(struct mei_device *dev) {}
 static inline void mei_me_unset_pm_domain(struct mei_device *dev) {}
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 /**
  * mei_me_quirk_probe - probe for devices that doesn't valid ME interface
@@ -357,7 +357,7 @@ static int mei_me_pci_resume(struct devi
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int mei_me_pm_runtime_idle(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
@@ -453,7 +453,7 @@ static inline void mei_me_unset_pm_domai
 	/* stop using pm callbacks if any */
 	dev->dev->pm_domain = NULL;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM
 static const struct dev_pm_ops mei_me_pm_ops = {
Index: linux-pm/drivers/misc/mei/pci-txe.c
===================================================================
--- linux-pm.orig/drivers/misc/mei/pci-txe.c
+++ linux-pm/drivers/misc/mei/pci-txe.c
@@ -42,13 +42,13 @@ static const struct pci_device_id mei_tx
 };
 MODULE_DEVICE_TABLE(pci, mei_txe_pci_tbl);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static inline void mei_txe_set_pm_domain(struct mei_device *dev);
 static inline void mei_txe_unset_pm_domain(struct mei_device *dev);
 #else
 static inline void mei_txe_set_pm_domain(struct mei_device *dev) {}
 static inline void mei_txe_unset_pm_domain(struct mei_device *dev) {}
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static void mei_txe_pci_iounmap(struct pci_dev *pdev, struct mei_txe_hw *hw)
 {
@@ -295,7 +295,7 @@ static int mei_txe_pci_resume(struct dev
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int mei_txe_pm_runtime_idle(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
@@ -401,9 +401,7 @@ static inline void mei_txe_unset_pm_doma
 	/* stop using pm callbacks if any */
 	dev->dev->pm_domain = NULL;
 }
-#endif /* CONFIG_PM_RUNTIME */
 
-#ifdef CONFIG_PM
 static const struct dev_pm_ops mei_txe_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(mei_txe_pci_suspend,
 				mei_txe_pci_resume)
Index: linux-pm/drivers/misc/apds990x.c
===================================================================
--- linux-pm.orig/drivers/misc/apds990x.c
+++ linux-pm/drivers/misc/apds990x.c
@@ -609,7 +609,7 @@ static int apds990x_detect(struct apds99
 	return ret;
 }
 
-#if defined(CONFIG_PM) || defined(CONFIG_PM_RUNTIME)
+#ifdef CONFIG_PM
 static int apds990x_chip_on(struct apds990x_chip *chip)
 {
 	int err	 = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
@@ -1237,7 +1237,7 @@ static int apds990x_resume(struct device
 }
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int apds990x_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
Index: linux-pm/drivers/misc/bh1770glc.c
===================================================================
--- linux-pm.orig/drivers/misc/bh1770glc.c
+++ linux-pm/drivers/misc/bh1770glc.c
@@ -1358,7 +1358,7 @@ static int bh1770_resume(struct device *
 }
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int bh1770_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);

