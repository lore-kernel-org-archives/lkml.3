Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3IKE7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3IKE5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:04 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=SJmK94jYO1sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iRcHoNZiLCgA:10 a=2KMo9-giAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=sozttTNsAAAA:8 a=drOt6m5kAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=JTMqrY5UvyEA:10 a=-ydLB92TkmgA:10 a=3Rfx1nUSh_UA:10 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042923.608513957@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Afzal Mohammed <afzal@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        <linux-mtd@lists.infradead.org>
Subject: [189/251] mtd: omap2: allow bulding as a module
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0189-mtd-omap2-allow-bulding-as-a-module.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 930d800bded771b26d9944c47810829130ff7c8c ]

The omap2 nand device driver calls into the the elm code, which can
be a loadable module, and in that case it cannot be built-in itself.
I can see no reason why the omap2 driver cannot also be a module,
so let's make the option "tristate" in Kconfig to fix this allmodconfig
build error:

ERROR: "elm_config" [drivers/mtd/nand/omap2.ko] undefined!
ERROR: "elm_decode_bch_error_page" [drivers/mtd/nand/omap2.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Afzal Mohammed <afzal@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/mtd/nand/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 8ca4176..bd773e2 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -117,7 +117,7 @@ config MTD_NAND_OMAP2
 
 config MTD_NAND_OMAP_BCH
 	depends on MTD_NAND && MTD_NAND_OMAP2 && ARCH_OMAP3
-	bool "Enable support for hardware BCH error correction"
+	tristate "Enable support for hardware BCH error correction"
 	default n
 	select BCH
 	select BCH_CONST_PARAMS
-- 
1.7.10.4


