Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaCJPaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:30:55 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54200 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaCJPax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:30:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] mfd: tps65218: Fix reported randconfig error
Date: Mon, 10 Mar 2014 15:30:41 +0000
Message-Id: <1394465441-15040-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported error was:

  ERROR: "regmap_del_irq_chip" [drivers/mfd/tps65218.ko] undefined!
    when CONFIG_REGMAP_IRQ is not enabled.

Cc: Mark Brown <broonie@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 7c443f2..456a7e7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -864,6 +864,7 @@ config MFD_TPS65218
 	depends on I2C
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  If you say yes here you get support for the TPS65218 series of
 	  Power Management chips.
-- 
1.8.3.2

