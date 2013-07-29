Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3G2EI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:08:26 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35878 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3G2EII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:08:08 -0400
Message-ID: <1375070881.5721.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: pfuze100: REGULATOR_PFUZE100 needs to select
 REGMAP_I2C
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 12:08:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build errors:

  CC [M]  drivers/regulator/pfuze100-regulator.o
drivers/regulator/pfuze100-regulator.c:342:21: error: variable 'pfuze_regmap_config' has initializer but incomplete type
drivers/regulator/pfuze100-regulator.c:343:2: error: unknown field 'reg_bits' specified in initializer
drivers/regulator/pfuze100-regulator.c:343:2: warning: excess elements in struct initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:343:2: warning: (near initialization for 'pfuze_regmap_config') [enabled by default]
drivers/regulator/pfuze100-regulator.c:344:2: error: unknown field 'val_bits' specified in initializer
drivers/regulator/pfuze100-regulator.c:344:2: warning: excess elements in struct initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:344:2: warning: (near initialization for 'pfuze_regmap_config') [enabled by default]
drivers/regulator/pfuze100-regulator.c:345:2: error: unknown field 'max_register' specified in initializer
drivers/regulator/pfuze100-regulator.c:345:2: warning: excess elements in struct initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:345:2: warning: (near initialization for 'pfuze_regmap_config') [enabled by default]
drivers/regulator/pfuze100-regulator.c:346:2: error: unknown field 'cache_type' specified in initializer
drivers/regulator/pfuze100-regulator.c:346:2: warning: excess elements in struct initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:346:2: warning: (near initialization for 'pfuze_regmap_config') [enabled by default]
drivers/regulator/pfuze100-regulator.c: In function 'pfuze100_regulator_probe':
drivers/regulator/pfuze100-regulator.c:370:2: error: implicit declaration of function 'devm_regmap_init_i2c' [-Werror=implicit-function-declaration]
drivers/regulator/pfuze100-regulator.c:370:21: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[2]: *** [drivers/regulator/pfuze100-regulator.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index b96815d..fe77cd9 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -368,6 +368,7 @@ config REGULATOR_PCF50633
 config REGULATOR_PFUZE100
 	tristate "Support regulators on Freescale PFUZE100 PMIC"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say y here to support the regulators found on the Freescale PFUZE100
 	  PMIC.
-- 
1.8.1.2



