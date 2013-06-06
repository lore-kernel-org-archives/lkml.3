Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab3FFI0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:26:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:57359 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3FFI0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:26:48 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-pcmcia@lists.infradead.org>, <linux@dominikbrodowski.net>,
        <manabian@gmail.com>, <fabio.porcedda@gmail.com>,
        <laurent.navet@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 6/7] pcmcia: at91_cf: use module_platform_driver_probe()
Date: Thu, 6 Jun 2013 10:24:19 +0200
Message-ID: <83a19de2ec83a4210b11b3ac49e3652d90e00a04.1370506678.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1370506678.git.nicolas.ferre@atmel.com>
References: <cover.1370506678.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Porcedda <fabio.porcedda@gmail.com>

Use module_platform_driver_probe() macro which makes the code smaller
and simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/pcmcia/at91_cf.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 149b95c..8ddc57c 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -411,17 +411,7 @@ static struct platform_driver at91_cf_driver = {
 
 /*--------------------------------------------------------------------------*/
 
-static int __init at91_cf_init(void)
-{
-	return platform_driver_probe(&at91_cf_driver, at91_cf_probe);
-}
-module_init(at91_cf_init);
-
-static void __exit at91_cf_exit(void)
-{
-	platform_driver_unregister(&at91_cf_driver);
-}
-module_exit(at91_cf_exit);
+module_platform_driver_probe(at91_cf_driver, at91_cf_probe);
 
 MODULE_DESCRIPTION("AT91 Compact Flash Driver");
 MODULE_AUTHOR("David Brownell");
-- 
1.8.2.2

