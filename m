Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaLFCMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:12:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58392 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751216AbaLFCMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:12:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH] tty / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Sat, 06 Dec 2014 03:33:47 +0100
Message-ID: <1863568.HuOkEcjIrB@vostro.rjw.lan>
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
drivers/tty/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/tty/serial/8250/8250_dw.c  |    2 +-
 drivers/tty/serial/8250/8250_mtk.c |    2 +-
 drivers/tty/serial/mfd.c           |    7 ++-----
 drivers/tty/serial/msm_serial_hs.c |    2 +-
 drivers/tty/serial/omap-serial.c   |    2 +-
 5 files changed, 6 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/tty/serial/8250/8250_dw.c
===================================================================
--- linux-pm.orig/drivers/tty/serial/8250/8250_dw.c
+++ linux-pm/drivers/tty/serial/8250/8250_dw.c
@@ -489,7 +489,7 @@ static int dw8250_resume(struct device *
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int dw8250_runtime_suspend(struct device *dev)
 {
 	struct dw8250_data *data = dev_get_drvdata(dev);
Index: linux-pm/drivers/tty/serial/8250/8250_mtk.c
===================================================================
--- linux-pm.orig/drivers/tty/serial/8250/8250_mtk.c
+++ linux-pm/drivers/tty/serial/8250/8250_mtk.c
@@ -244,7 +244,7 @@ static int mtk8250_resume(struct device
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int mtk8250_runtime_suspend(struct device *dev)
 {
 	struct mtk8250_data *data = dev_get_drvdata(dev);
Index: linux-pm/drivers/tty/serial/msm_serial_hs.c
===================================================================
--- linux-pm.orig/drivers/tty/serial/msm_serial_hs.c
+++ linux-pm/drivers/tty/serial/msm_serial_hs.c
@@ -1792,7 +1792,7 @@ static void __exit msm_serial_hs_exit(vo
 }
 module_exit(msm_serial_hs_exit);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int msm_hs_runtime_idle(struct device *dev)
 {
 	/*
Index: linux-pm/drivers/tty/serial/mfd.c
===================================================================
--- linux-pm.orig/drivers/tty/serial/mfd.c
+++ linux-pm/drivers/tty/serial/mfd.c
@@ -1252,12 +1252,7 @@ static int serial_hsu_resume(struct pci_
 	}
 	return 0;
 }
-#else
-#define serial_hsu_suspend	NULL
-#define serial_hsu_resume	NULL
-#endif
 
-#ifdef CONFIG_PM_RUNTIME
 static int serial_hsu_runtime_idle(struct device *dev)
 {
 	pm_schedule_suspend(dev, 500);
@@ -1274,6 +1269,8 @@ static int serial_hsu_runtime_resume(str
 	return 0;
 }
 #else
+#define serial_hsu_suspend		NULL
+#define serial_hsu_resume		NULL
 #define serial_hsu_runtime_idle		NULL
 #define serial_hsu_runtime_suspend	NULL
 #define serial_hsu_runtime_resume	NULL
Index: linux-pm/drivers/tty/serial/omap-serial.c
===================================================================
--- linux-pm.orig/drivers/tty/serial/omap-serial.c
+++ linux-pm/drivers/tty/serial/omap-serial.c
@@ -1799,7 +1799,7 @@ static void serial_omap_mdr1_errataset(s
 	}
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static void serial_omap_restore_context(struct uart_omap_port *up)
 {
 	if (up->errata & UART_ERRATA_i202_MDR1_ACCESS)

