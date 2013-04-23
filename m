Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3DWQcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3DWQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, Afzal Mohammed <afzal@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 21/21] mtd: omap2: allow bulding as a module
Date: Tue, 23 Apr 2013 18:30:53 +0200
Message-Id: <1366734653-488286-22-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jSw43+b2wBQopcqhCAgpICIfzknybLWIAtb4xhsVVF6
 6JaGL8peoUStjISuMGKT2xqTyAabV+iSmqJ6bmtEfmmqqKJ9Mz
 6j5GGa3zdQSdQkhxx9s3gYLM/w7ypjUqCzD1GN/Y7Q/AZ3xXPV
 1tkM0FTIYUF4tNXg55ZCQGW19znGY8PVURXowTGj1UxQv1FGXK
 uPocPj1qkFIW0QHo31fw3zCuKWSQDSSf4ZrzwUYrfxJe7Hi7sH
 kWIQKRi7BDVisBcFw0NSyLsFrypRtjWycfTsMgMVipl0pROdRp
 1D7ndiIXlfNgsYSkOibJovbpkNeL6Byej7OhtyyFB0LrrVzsjV
 tR9nPB5LtMVupJzHVlr46io2GaKvqP26nrQPbGgeC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap2 nand device driver calls into the the elm code, which can
be a loadable module, and in that case it cannot be built-in itself.
I can see no reason why the omap2 driver cannot also be a module,
so let's make the option "tristate" in Kconfig to fix this allmodconfig
build error:

ERROR: "elm_config" [drivers/mtd/nand/omap2.ko] undefined!
ERROR: "elm_decode_bch_error_page" [drivers/mtd/nand/omap2.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Afzal Mohammed <afzal@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 81bf5e5..106b55e 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -109,7 +109,7 @@ config MTD_NAND_OMAP2
 
 config MTD_NAND_OMAP_BCH
 	depends on MTD_NAND && MTD_NAND_OMAP2 && ARCH_OMAP3
-	bool "Enable support for hardware BCH error correction"
+	tristate "Enable support for hardware BCH error correction"
 	default n
 	select BCH
 	select BCH_CONST_PARAMS
-- 
1.8.1.2

