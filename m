Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3DOHAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:00:34 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:47675 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3DOHAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:00:32 -0400
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
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: si5351: make clk-si5351 depend on CONFIG_OF
Date: Mon, 15 Apr 2013 09:00:14 +0200
Message-Id: <1366009214-32234-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling clk-si5351 driver non-OF ready was too early. This patch
makes clk-si5351 depend on CONFIG_OF again, until things get sorted out.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reported-by: Stephen Rottweil <sfr@canb.auug.org.au>
---
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
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/clk/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 5039e41..6412f55 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -58,6 +58,7 @@ config COMMON_CLK_MAX77686
 config COMMON_CLK_SI5351
 	tristate "Clock driver for SiLabs 5351A/B/C"
 	depends on I2C
+	depends on OF
 	select REGMAP_I2C
 	select RATIONAL
 	---help---
-- 
1.7.10.4

