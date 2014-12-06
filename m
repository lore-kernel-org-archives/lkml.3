Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaLFCRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:17:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62842 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751051AbaLFCRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:17:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@kernel.org>
Subject: [PATCH] phy / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Sat, 06 Dec 2014 03:39:05 +0100
Message-ID: <2122955.8tCSpWHocD@vostro.rjw.lan>
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
drivers/phy/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/phy/phy-omap-usb2.c |    2 +-
 drivers/phy/phy-ti-pipe3.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/phy/phy-omap-usb2.c
===================================================================
--- linux-pm.orig/drivers/phy/phy-omap-usb2.c
+++ linux-pm/drivers/phy/phy-omap-usb2.c
@@ -322,7 +322,7 @@ static int omap_usb2_remove(struct platf
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 
 static int omap_usb2_runtime_suspend(struct device *dev)
 {
Index: linux-pm/drivers/phy/phy-ti-pipe3.c
===================================================================
--- linux-pm.orig/drivers/phy/phy-ti-pipe3.c
+++ linux-pm/drivers/phy/phy-ti-pipe3.c
@@ -423,7 +423,7 @@ static int ti_pipe3_remove(struct platfo
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 
 static int ti_pipe3_runtime_suspend(struct device *dev)
 {

