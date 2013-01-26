Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3AZFUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 00:20:00 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45730 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3AZFT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 00:19:58 -0500
Message-ID: <1359177587.9041.1.camel@phoenix>
Subject: [PATCH] regulator: lp8755: Use LP8755_BUCK_MAX instead of magic
 number
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 26 Jan 2013 13:19:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8755.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index 8b1ce0f..f0f6ea0 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -373,7 +373,7 @@ static irqreturn_t lp8755_irq_handler(int irq, void *data)
 		goto err_i2c;
 
 	/* sent power fault detection event to specific regulator */
-	for (icnt = 0; icnt < 6; icnt++)
+	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
 		if ((flag0 & (0x4 << icnt))
 		    && (pchip->irqmask & (0x04 << icnt))
 		    && (pchip->rdev[icnt] != NULL))
@@ -508,7 +508,7 @@ err_irq:
 
 err_regulator:
 	/* output disable */
-	for (icnt = 0; icnt < 0x06; icnt++)
+	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
 		lp8755_write(pchip, icnt, 0x00);
 
 	return ret;
@@ -522,7 +522,7 @@ static int lp8755_remove(struct i2c_client *client)
 	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
 		regulator_unregister(pchip->rdev[icnt]);
 
-	for (icnt = 0; icnt < 0x06; icnt++)
+	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
 		lp8755_write(pchip, icnt, 0x00);
 
 	if (pchip->irq != 0)
-- 
1.7.9.5



