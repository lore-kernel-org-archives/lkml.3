Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaIEVQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:16:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52200 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaIEVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:16:37 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@kernel.org>
Date: Fri,  5 Sep 2014 22:16:18 +0100
Message-Id: <1409951778-30513-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: tps65217: Tell regmap what registers are valid
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow regmap to provide debugfs access to the register map by telling it
what registers are valid.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/mfd/tps65217.c       | 2 ++
 include/linux/mfd/tps65217.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 3cc4c7084b92..a8ee52c95f2f 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -146,6 +146,8 @@ EXPORT_SYMBOL_GPL(tps65217_clear_bits);
 static struct regmap_config tps65217_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
+
+	.max_register = TPS65217_REG_MAX,
 };
 
 static const struct of_device_id tps65217_of_match[] = {
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
index 95d6938737fd..ac7fba44d7e4 100644
--- a/include/linux/mfd/tps65217.h
+++ b/include/linux/mfd/tps65217.h
@@ -60,6 +60,8 @@
 #define TPS65217_REG_SEQ5		0X1D
 #define TPS65217_REG_SEQ6		0X1E
 
+#define TPS65217_REG_MAX		TPS65217_REG_SEQ6
+
 /* Register field definitions */
 #define TPS65217_CHIPID_CHIP_MASK	0xF0
 #define TPS65217_CHIPID_REV_MASK	0x0F
-- 
2.1.0

