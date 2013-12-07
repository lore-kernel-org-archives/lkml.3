Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3LGJA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 04:00:58 -0500
Received: from smtp36.i.mail.ru ([94.100.177.96]:36675 "EHLO smtp36.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab3LGJA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 04:00:56 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] mfd: mc13xxx: Remove redundant checks
Date: Sat,  7 Dec 2013 13:00:43 +0400
Message-Id: <1386406843-11498-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for maximal register is already provided by regmap API,
so remove redundant checks.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/mc13xxx-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index dbbf8ee..b0c7cb0 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -158,9 +158,6 @@ int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 {
 	int ret;
 
-	if (offset > MC13XXX_NUMREGS)
-		return -EINVAL;
-
 	ret = regmap_read(mc13xxx->regmap, offset, val);
 	dev_vdbg(mc13xxx->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
 
@@ -172,7 +169,7 @@ int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
 {
 	dev_vdbg(mc13xxx->dev, "[0x%02x] <- 0x%06x\n", offset, val);
 
-	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
+	if (val >= BIT(24))
 		return -EINVAL;
 
 	return regmap_write(mc13xxx->regmap, offset, val);
-- 
1.8.3.2

