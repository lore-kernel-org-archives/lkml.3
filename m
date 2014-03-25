Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaCYTzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:55:52 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:48657 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaCYTzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:55:50 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, stable@vger.kernel.org
Subject: [PATCH] MIPS: OCTEON: fix EARLY_PRINTK_8250 build failure
Date: Tue, 25 Mar 2014 21:58:45 +0200
Message-Id: <1395777525-28910-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling EARLY_PRINTK_8250 breaks OCTEON builds because of multiple
prom_putchar() implementations. OCTEON provides its own prom_putchar()
(also used by the watchdog driver), so we should prevent user from
selecting EARLY_PRINTK_8250 on OCTEON.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: stable@vger.kernel.org
---
 arch/mips/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index b147e70..b27e65886 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -22,7 +22,7 @@ config EARLY_PRINTK
 
 config EARLY_PRINTK_8250
 	bool "8250/16550 and compatible serial early printk driver"
-	depends on EARLY_PRINTK
+	depends on EARLY_PRINTK && !CAVIUM_OCTEON_SOC
 	default n
 	help
 	  If you say Y here, it will be possible to use a 8250/16550 serial
-- 
1.9.0

