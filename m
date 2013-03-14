Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3CNNO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:14:59 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51695 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab3CNNLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:11:51 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 03/10] drivers: char: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 14:11:24 +0100
Message-Id: <1363266691-15757-5-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/char/hw_random/mxc-rnga.c   | 13 +------------
 drivers/char/hw_random/tx4939-rng.c | 13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index f05d857..895d0b8 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -228,18 +228,7 @@ static struct platform_driver mxc_rnga_driver = {
 	.remove = __exit_p(mxc_rnga_remove),
 };
 
-static int __init mod_init(void)
-{
-	return platform_driver_probe(&mxc_rnga_driver, mxc_rnga_probe);
-}
-
-static void __exit mod_exit(void)
-{
-	platform_driver_unregister(&mxc_rnga_driver);
-}
-
-module_init(mod_init);
-module_exit(mod_exit);
+module_platform_driver_probe(mxc_rnga_driver, mxc_rnga_probe);
 
 MODULE_AUTHOR("Freescale Semiconductor, Inc.");
 MODULE_DESCRIPTION("H/W RNGA driver for i.MX");
diff --git a/drivers/char/hw_random/tx4939-rng.c b/drivers/char/hw_random/tx4939-rng.c
index 3099198..d34a24a 100644
--- a/drivers/char/hw_random/tx4939-rng.c
+++ b/drivers/char/hw_random/tx4939-rng.c
@@ -166,18 +166,7 @@ static struct platform_driver tx4939_rng_driver = {
 	.remove = tx4939_rng_remove,
 };
 
-static int __init tx4939rng_init(void)
-{
-	return platform_driver_probe(&tx4939_rng_driver, tx4939_rng_probe);
-}
-
-static void __exit tx4939rng_exit(void)
-{
-	platform_driver_unregister(&tx4939_rng_driver);
-}
-
-module_init(tx4939rng_init);
-module_exit(tx4939rng_exit);
+module_platform_driver_probe(tx4939_rng_driver, tx4939_rng_probe);
 
 MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver for TX4939");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

