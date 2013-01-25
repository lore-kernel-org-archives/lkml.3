Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3AYWrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:47:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3AYWqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:46:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 10/19] watchdog: at91sam9: at91_wdt_dt_ids cannot be __init
Date: Fri, 25 Jan 2013 22:44:09 +0000
Message-Id: <1359153858-31992-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UBqHe9c17Dnk+lQpnCgjiFfkP03lmph9LswtTmqjKMS
 lQihKw47tahldS4h2BoDSedPL+YJ6ymKXvaT+JrxmYaLjzAM69
 pfTLGNkQQIWMyO64gUnSMYv+CKCDyc/8MtGS6txjMdhRXASEPq
 XAgfnDmy8w5IDJZb1WmwDZ5xs4KesHPvJ3tA/uAaNU+rFIy6i1
 SNIG13TOdnVr5yBndKXCCw99M2YdIPN07j9lrc7WkjkXue/0S6
 7EkzxLjDV4RVCWFO1L+Mtv2B4JUJugIO0NIM2T7vyYa3Gu7TM5
 1/hfTdEWvELndCDftoOyHxxj6IgQ+/rRnMMbHBVsM/go3KRVEK
 OxMndHFqd6VMXDH6Edb9kcYCe+AyazTSu0/0FaaLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device IDs are referenced by the driver and potentially
used beyond the init time, as kbuild correctly warns
about. Remove the __initconst annotation.

Without this patch, building at91_dt_defconfig results in:

WARNING: drivers/watchdog/built-in.o(.data+0x28): Section mismatch in reference from the variable at91wdt_driver to the (unknown reference) .init.rodata:(unknown)
The variable at91wdt_driver references
the (unknown reference) __initconst (unknown)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
---
 drivers/watchdog/at91sam9_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index dc42e44..6dad954 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -304,7 +304,7 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
 }
 
 #if defined(CONFIG_OF)
-static const struct of_device_id at91_wdt_dt_ids[] __initconst = {
+static const struct of_device_id at91_wdt_dt_ids[] = {
 	{ .compatible = "atmel,at91sam9260-wdt" },
 	{ /* sentinel */ }
 };
-- 
1.8.0

