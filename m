Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaKZWCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:02:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:53319 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaKZWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:02:04 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Sekhar Nori <nsekhar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] tty: serial: serial-omap: depend on !8250_omap
Date: Wed, 26 Nov 2014 23:01:46 +0100
Message-Id: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technically speaking this is not required. If both are enabled then the
Maikefile order says that 8250 one wins, the second is never probed.

If we choose to enable 8250_omap via defconfig then one might get supprised
that his console isn't working anymore since nothing says use ttySx
instead ttyOx.
This patch _tries_ to bring this to the users' attention by not showing
the serial-omap driver once the 8250 one is enabled. So the user might
choose to use the help text which says that this driver (8250_omap)
uses ttySx instead ttyOx.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
This is my attempt to warn the defconfig user of the defconfig change
(which did not yet happen). Any suggestions?

 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index e71a28b4b94e..1b1bdf946fee 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1125,7 +1125,7 @@ config SERIAL_OF_PLATFORM
 
 config SERIAL_OMAP
 	tristate "OMAP serial port support"
-	depends on ARCH_OMAP2PLUS
+	depends on ARCH_OMAP2PLUS && !SERIAL_8250_OMAP
 	select SERIAL_CORE
 	help
 	  If you have a machine based on an Texas Instruments OMAP CPU you
-- 
2.1.3

