Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaE0Fv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:51:58 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64017 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaE0Fvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:51:55 -0400
Message-ID: <1401169909.11231.1.camel@phoenix>
Subject: [PATCH] regulator: ltc3589: Fix module dependency
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 13:51:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this driver depend on I2C and select REGMAP_I2C to fix build failure.
Also allows this driver to be built as module.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 8f5c880..c2fa0b4 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -273,7 +273,9 @@ config REGULATOR_LP8788
 	  This driver supports LP8788 voltage regulator chip.
 
 config REGULATOR_LTC3589
-	bool "LTC3589 8-output voltage regulator"
+	tristate "LTC3589 8-output voltage regulator"
+	depends on I2C
+	select REGMAP_I2C
 	help
 	  This enables support for the LTC3589, LTC3589-1, and LTC3589-2
 	  8-output regulators controlled via I2C.
-- 
1.8.3.2



