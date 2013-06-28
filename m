Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3F1OMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:12:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45038 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab3F1OMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:12:31 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Fri, 28 Jun 2013 15:12:23 +0100
Message-Id: <1372428743-31687-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: sec: Remove fields not used since regmap conversion
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

These were all used by the open coded I/O and IRQ implementations and are
no longer referenced now that the regmap core variants are used instead.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/mfd/samsung/core.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index f0f4de3..378ae8a 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -14,8 +14,6 @@
 #ifndef __LINUX_MFD_SEC_CORE_H
 #define __LINUX_MFD_SEC_CORE_H
 
-#define NUM_IRQ_REGS	4
-
 enum sec_device_type {
 	S5M8751X,
 	S5M8763X,
@@ -44,8 +42,6 @@ struct sec_pmic_dev {
 	struct regmap *regmap;
 	struct i2c_client *i2c;
 	struct i2c_client *rtc;
-	struct mutex iolock;
-	struct mutex irqlock;
 
 	int device_type;
 	int irq_base;
@@ -53,8 +49,6 @@ struct sec_pmic_dev {
 	struct regmap_irq_chip_data *irq_data;
 
 	int ono;
-	u8 irq_masks_cur[NUM_IRQ_REGS];
-	u8 irq_masks_cache[NUM_IRQ_REGS];
 	int type;
 	bool wakeup;
 };
-- 
1.8.3.1

