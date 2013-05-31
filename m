Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab3EaW0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:26:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab3EaWXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Afzal Mohammed <afzal@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 02/15] mtd: omap2: allow bulding as a module
Date: Sat,  1 Jun 2013 00:22:39 +0200
Message-Id: <1370038972-2318779-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:omNpzOYNZemm/kAyH171xaWXumPVxbytGvEAIt8wzeZ
 L47DLywV/AK0cghBeiCfzYCTbPgEanUhkap4L5TiNwxzY+c1CF
 uB9HxsyjN6YX5e0LQz+h61UYEVsXcMuy8fw4FePcGAFL0DvRZb
 WiN0DpCejGRVgqw5aZB0V0goEW6DuxlrNO0yYQkA6JO+WD8I/t
 ak+mfOIRRxVgFOOxawRq7cLLZHvm/qjPC0XJyBR6dxwaWC0dnf
 7tShmnGsKVfoFhjF+LFIEbMLKsgpE+NSc35CmTD+aTZ/mCX0Z3
 JKn9958x8XcdIqd28FMHhVHbqqRqDeKBLaD6JY0EVWaQW2GLGw
 cR6B128BGJzneeJqZc9ATb1WuB6b2LrfezWy/ZUjH
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
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Afzal Mohammed <afzal@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 3ae9105..5ef8f5e 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -95,7 +95,7 @@ config MTD_NAND_OMAP2
 
 config MTD_NAND_OMAP_BCH
 	depends on MTD_NAND && MTD_NAND_OMAP2 && ARCH_OMAP3
-	bool "Enable support for hardware BCH error correction"
+	tristate "Enable support for hardware BCH error correction"
 	default n
 	select BCH
 	select BCH_CONST_PARAMS
-- 
1.8.1.2

