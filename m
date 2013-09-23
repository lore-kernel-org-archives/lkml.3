Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3IWSPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:15:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34595 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3IWSPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:15:03 -0400
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Mon, 23 Sep 2013 19:14:31 +0100
Message-Id: <1379960073-23245-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/3] mfd: mc13xxx: Don't require lock for simple register I/O
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Since the conversion to regmap there has been no need for device level
locking for I/O as regmap provides locking so remove the locks.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/mc13xxx-core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 2a9b100..dbbf8ee 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -158,8 +158,6 @@ int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 {
 	int ret;
 
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
-
 	if (offset > MC13XXX_NUMREGS)
 		return -EINVAL;
 
@@ -172,8 +170,6 @@ EXPORT_SYMBOL(mc13xxx_reg_read);
 
 int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
 {
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
-
 	dev_vdbg(mc13xxx->dev, "[0x%02x] <- 0x%06x\n", offset, val);
 
 	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
@@ -186,7 +182,6 @@ EXPORT_SYMBOL(mc13xxx_reg_write);
 int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
 		u32 mask, u32 val)
 {
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
 	BUG_ON(val & ~mask);
 	dev_vdbg(mc13xxx->dev, "[0x%02x] <- 0x%06x (mask: 0x%06x)\n",
 			offset, val, mask);
-- 
1.8.4.rc3

