Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3FAJSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:18:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61012 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3FAJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:18:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sourav Poddar <sourav.poddar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] serial: omap: repair building without PM_SLEEP
Date: Sat, 01 Jun 2013 11:18:13 +0200
Message-ID: <1844339.mxci2DdvBF@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DYTE8GGr0mH6wHpQ2Nwqhiwpy8hXsjeyJ1xN+4xp3Fs
 gCCZlc5QAAQKVTJW3HFCGFQizfduMBecV41hH3XCXdj5t2+SSN
 UnZh0akGi7iQNne59CJpQjc3+p/tTaImDBxX8bV3Ka3ULozDQ8
 Y8nxGHRDl6vUMwORW8/W7aV3a+O13CaVxWy3Cv3MhJ6IjzSLQ+
 wTyAeCKve65gQl2ccHEcTS9D7tGH9icPef7A7DakUE16ji1NOI
 IqW2xANl+yFI0+nqsFTG/w2H1WyIJ6VGGJ19h5b2KbQZGGZNrS
 d8VWrvYRPMMCaktStMI0q25xcUOqz3L9pJutDfGzLbDj27QKo0
 zDaasUprkymJvaRTdXsM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent bug fix in 3.10, ddd85e225c "serial: omap: prevent runtime PM for
"no_console_suspend"", introduced a regression from an obvious typo:

drivers/tty/serial/omap-serial.c:1677:14: error: 'serial_omap_complete' 
	undeclared here (not in a function)

This changes the incorrectly added macro to the one that we need instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Please apply for 3.10-rc

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 393a8eb..1aaeca8 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1326,7 +1326,7 @@ static int serial_omap_resume(struct device *dev)
 }
 #else
 #define serial_omap_prepare NULL
-#define serial_omap_prepare NULL
+#define serial_omap_complete NULL
 #endif /* CONFIG_PM_SLEEP */
 
 static void omap_serial_fill_features_erratas(struct uart_omap_port *up)

