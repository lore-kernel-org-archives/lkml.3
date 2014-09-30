Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaI3QUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:20:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56806 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbaI3QTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:19:54 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Peter Korsgaard <jacmet@sunsite.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 3/6] hwrng: atmel: add DT support
Date: Tue, 30 Sep 2014 18:19:44 +0200
Message-Id: <1412093987-30241-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT support.

Make the driver depend on CONFIG_OF as at91sam9g45 was the only SoC making
use of the TRNG block and this SoC is now fully migrated to DT.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/char/hw_random/Kconfig     | 2 +-
 drivers/char/hw_random/atmel-rng.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 836b061..a0f5500 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -64,7 +64,7 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
-	depends on ARCH_AT91 && HAVE_CLK
+	depends on ARCH_AT91 && HAVE_CLK && OF
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 644ec48..0bb0b21 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -123,6 +123,12 @@ static const struct dev_pm_ops atmel_trng_pm_ops = {
 };
 #endif /* CONFIG_PM */
 
+static const struct of_device_id atmel_trng_dt_ids[] = {
+	{ .compatible = "atmel,at91sam9g45-trng" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, atmel_trng_dt_ids);
+
 static struct platform_driver atmel_trng_driver = {
 	.probe		= atmel_trng_probe,
 	.remove		= atmel_trng_remove,
@@ -132,6 +138,7 @@ static struct platform_driver atmel_trng_driver = {
 #ifdef CONFIG_PM
 		.pm	= &atmel_trng_pm_ops,
 #endif /* CONFIG_PM */
+		.of_match_table = atmel_trng_dt_ids,
 	},
 };
 
-- 
1.9.1

