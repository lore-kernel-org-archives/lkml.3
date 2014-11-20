Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbaKTJn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:43:56 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:38813 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbaKTJnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:43:53 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <mpm@selenic.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <peter@korsgaard.com>
Subject: [PATCH RESEND v2 2/4] hwrng: atmel: add DT support
Date: Thu, 20 Nov 2014 10:43:23 +0100
Message-ID: <00278c18b2a70ada33ec1bbc2a05469499c24cc1.1416475860.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1416475860.git.nicolas.ferre@atmel.com>
References: <cover.1416475860.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

Add DT support.

Make the driver depend on CONFIG_OF as at91sam9g45 was the only SoC making
use of the TRNG block and this SoC is now fully migrated to DT.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/char/hw_random/Kconfig     | 2 +-
 drivers/char/hw_random/atmel-rng.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 91a04ae8003c..de57b38809c7 100644
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
index 644ec4882206..0bb0b2120a63 100644
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
2.1.3

