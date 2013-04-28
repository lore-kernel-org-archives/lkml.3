Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3D1KYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 06:24:55 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55633 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3D1KYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 06:24:51 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Michal Bachraty <michal.bachraty@streamunlimited.com>,
        Marek Belisko <marek.belisko@streamunlimited.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: si5351: Allow to build without CONFIG_OF
Date: Sun, 28 Apr 2013 12:24:41 +0200
Message-Id: <1367144681-14248-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In clk-si5351 there was some dependency to CONFIG_OF that permitted the
use of the driver on !CONFIG_OF platforms. This patch adds proper #ifdef
around of_clk_add_provider and removes the dependency on CONFIG_OF.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Note:
This patch is based upon v3.9-rc8 with clk-si5351 v8 plus two fixes by
Marek Belisko applied. It has been compile-tested on x86_64 allmodconfig.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dom Cobley <popcornmix@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rabeeh Khoury <rabeeh@solid-run.com>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: Marek Belisko <marek.belisko@streamunlimited.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/clk/Kconfig      |    1 -
 drivers/clk/clk-si5351.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 6412f55..5039e41 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -58,7 +58,6 @@ config COMMON_CLK_MAX77686
 config COMMON_CLK_SI5351
 	tristate "Clock driver for SiLabs 5351A/B/C"
 	depends on I2C
-	depends on OF
 	select REGMAP_I2C
 	select RATIONAL
 	---help---
diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 8323c31..91c0f01 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1489,12 +1489,14 @@ static int si5351_i2c_probe(struct i2c_client *client,
 		}
 	}
 
+#ifdef CONFIG_OF
 	ret = of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
 				  &drvdata->onecell);
 	if (ret) {
 		dev_err(&client->dev, "unable to add clk provider\n");
 		return ret;
 	}
+#endif
 
 	return 0;
 }
-- 
1.7.10.4

