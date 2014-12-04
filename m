Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaLDBC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:02:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50283 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752054AbaLDBC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:02:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: sh / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Thu, 04 Dec 2014 02:24:22 +0100
Message-ID: <3463511.sXIeyHdjYI@vostro.rjw.lan>
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

Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/sh/pm_runtime.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/sh/pm_runtime.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/sh/pm_runtime.c
===================================================================
--- linux-pm.orig/drivers/sh/pm_runtime.c
+++ linux-pm/drivers/sh/pm_runtime.c
@@ -20,7 +20,7 @@
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int sh_pm_runtime_suspend(struct device *dev)
 {
 	int ret;
@@ -68,7 +68,7 @@ static struct dev_pm_domain default_pm_d
 
 #define DEFAULT_PM_DOMAIN_PTR	NULL
 
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static struct pm_clk_notifier_block platform_bus_notifier = {
 	.pm_domain = DEFAULT_PM_DOMAIN_PTR,

