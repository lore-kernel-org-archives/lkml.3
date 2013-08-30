Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab3H3ONv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:13:51 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33003 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3H3ONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:13:49 -0400
Message-ID: <1377872024.10551.1.camel@phoenix>
Subject: [PATCH] regulator: lp872x: Make REGULATOR_LP872X depend on I2C
 rather than I2C=y
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 22:13:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lp872x regulator driver can be built a module after commit 631a1fc
"regulator: build: Allow most regulators to be built as modules".
Make REGULATOR_LP872X depend on I2C to allow building lp872x module when I2C=m.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 052e284..dfe5809 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -231,7 +231,7 @@ config REGULATOR_LP3972
 
 config REGULATOR_LP872X
 	tristate "TI/National Semiconductor LP8720/LP8725 voltage regulators"
-	depends on I2C=y
+	depends on I2C
 	select REGMAP_I2C
 	help
 	  This driver supports LP8720/LP8725 PMIC
-- 
1.8.1.2



