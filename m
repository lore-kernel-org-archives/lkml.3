Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaLSBmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:42:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55835 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751602AbaLSBmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:42:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org
Subject: [PATCH 3/4] tty: 8250_omap: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Fri, 19 Dec 2014 02:55 +0100
Message-ID: <1897135.rk4lcWQyIt@vostro.rjw.lan>
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

The 8250_omap serial driver is a new user of CONFIG_PM_RUNTIME.

However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so
#ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
depend on CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM in 8250_omap.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Please let me know if there are any objections against pushing this through
the linux-pm tree.

---
 drivers/tty/serial/8250/8250_omap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/tty/serial/8250/8250_omap.c
===================================================================
--- linux-pm.orig/drivers/tty/serial/8250/8250_omap.c
+++ linux-pm/drivers/tty/serial/8250/8250_omap.c
@@ -561,7 +561,7 @@ static int omap_8250_startup(struct uart
 	if (ret)
 		goto err;
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	up->capabilities |= UART_CAP_RPM;
 #endif
 
@@ -997,12 +997,12 @@ static int omap8250_probe(struct platfor
 	up.port.fifosize = 64;
 	up.tx_loadsz = 64;
 	up.capabilities = UART_CAP_FIFO;
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	/*
-	 * PM_RUNTIME is mostly transparent. However to do it right we need to a
+	 * Runtime PM is mostly transparent. However to do it right we need to a
 	 * TX empty interrupt before we can put the device to auto idle. So if
-	 * PM_RUNTIME is not enabled we don't add that flag and can spare that
-	 * one extra interrupt in the TX path.
+	 * PM is not enabled we don't add that flag and can spare that one extra
+	 * interrupt in the TX path.
 	 */
 	up.capabilities |= UART_CAP_RPM;
 #endif
@@ -1105,7 +1105,7 @@ static int omap8250_remove(struct platfo
 	return 0;
 }
 
-#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
+#ifdef CONFIG_PM
 
 static inline void omap8250_enable_wakeirq(struct omap8250_priv *priv,
 					   bool enable)
@@ -1179,7 +1179,7 @@ static int omap8250_resume(struct device
 #define omap8250_complete NULL
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int omap8250_lost_context(struct uart_8250_port *up)
 {
 	u32 val;

