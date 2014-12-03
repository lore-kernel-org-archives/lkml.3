Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaLCB3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:29:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54591 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750730AbaLCB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:29:06 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] gpio / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 02:50:30 +0100
Message-ID: <1655942.O63mJN07or@vostro.rjw.lan>
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

Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/gpio/gpio-omap.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/gpio/gpio-omap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/gpio/gpio-omap.c
===================================================================
--- linux-pm.orig/drivers/gpio/gpio-omap.c
+++ linux-pm/drivers/gpio/gpio-omap.c
@@ -1259,7 +1259,7 @@ static int omap_gpio_probe(struct platfo
 
 #ifdef CONFIG_ARCH_OMAP2PLUS
 
-#if defined(CONFIG_PM_RUNTIME)
+#if defined(CONFIG_PM)
 static void omap_gpio_restore_context(struct gpio_bank *bank);
 
 static int omap_gpio_runtime_suspend(struct device *dev)
@@ -1440,7 +1440,7 @@ static int omap_gpio_runtime_resume(stru
 
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 void omap2_gpio_prepare_for_idle(int pwr_mode)
 {
@@ -1468,7 +1468,7 @@ void omap2_gpio_resume_after_idle(void)
 	}
 }
 
-#if defined(CONFIG_PM_RUNTIME)
+#if defined(CONFIG_PM)
 static void omap_gpio_init_context(struct gpio_bank *p)
 {
 	struct omap_gpio_reg_offs *regs = p->regs;
@@ -1525,7 +1525,7 @@ static void omap_gpio_restore_context(st
 	writel_relaxed(bank->context.irqenable2,
 				bank->base + bank->regs->irqenable2);
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 #else
 #define omap_gpio_runtime_suspend NULL
 #define omap_gpio_runtime_resume NULL

