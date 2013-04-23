Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3DWPyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:54:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab3DWPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:54:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dom Cobley <popcornmix@gmail.com>, Lubomir Rintel <lkundrak@v3.sk>,
        Stephen Warren <swarren@wwwdotorg.org>, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH] hwrng: bcm2835: fix MODULE_LICENSE tag
Date: Tue, 23 Apr 2013 17:54:34 +0200
Message-Id: <1366732475-479886-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366732475-479886-1-git-send-email-arnd@arndb.de>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0Ys2baY0SUUrip6DtwfYWweVnIpRHUh7ypfuvB7d0fA
 c9gyrfRUfmCCdt+5Wky+V2CWwh5RhnT1s98lKWr47tM85R4CQ0
 2pM7bn+6NGld5MvXypkpveq4Q9RA5Xcxrh/8sl0Iym4gWHf5NT
 JdIU4kkKlDNeqEvCJlO1FA04DosRIwxJcP5VHwpTWC5j/h+eJH
 xHPdnjb39R5vBR8CBOi2gd8aAMVct5pVylm/xtYrwCuGMJyFoh
 QjMmn+GtoulcaXQhX/g7/k7xd65T5nl/He15Bek0MgAG2XXyok
 UbMcMK33KPLiV5F7IWqUQRq/nWXum5ur+pcILBQZh5lPsBZIR+
 T/txYU+vRz3GAvf9pmexf/TFNIs6ELazWpokVGmMh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MODULE_LICENSE macro invocation must use either "GPL" or "GPL v2",
but not "GPLv2" in order to be detected by the module loader.

This fixes the allmodconfig build error:

FATAL: modpost: GPL-incompatible module bcm2835-rng.ko uses GPL-only symbol 'platform_driver_unregister'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dom Cobley <popcornmix@gmail.com>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: linux-rpi-kernel@lists.infradead.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/bcm2835-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index eb7f147..43577ca 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -110,4 +110,4 @@ module_platform_driver(bcm2835_rng_driver);
 
 MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
 MODULE_DESCRIPTION("BCM2835 Random Number Generator (RNG) driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.2

