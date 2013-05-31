Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3EaWXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:23:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab3EaWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Dom Cobley <popcornmix@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Stephen Warren <swarren@wwwdotorg.org>, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 05/15] hwrng: bcm2835: fix MODULE_LICENSE tag
Date: Sat,  1 Jun 2013 00:22:42 +0200
Message-Id: <1370038972-2318779-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:7/pU8daD/QexAl/ATCX3TTei/ggtOuNYkKVejNK2Hz4
 8zC9pxxO/kZ/UA1txb5gq5GFYwnEccQe3sDkonTo8WSTPo1ChJ
 /nzHExPM48mhL76h761wkmMX9Z51SwxspMJpeaGsQRNMUiRttX
 VJk3n9aRmTGA0nNZ4KHyaEOqI3zWHsd6aMqnW80EOJn/XLLj5Q
 RhExcMrDs1rQDB/hRAby6GYVYb5Mx/FbVjSdHCXuC6lnTkseBN
 hNpAKdULgeUbAvZKuz0sR9eyXvrYgRN1b8UjrCxBDQ5mkDuEit
 jVi0GzZ14hxg5f0oGgMdDY/9XXfpmIqB0LvxoA1jqQciymWloC
 FGwjaQ7mQ3h66EynjmFFcs+fTJvWzL+Tzx9VMjN8o
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

