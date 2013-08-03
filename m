Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3HCJKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 05:10:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44075 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3HCJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 05:10:49 -0400
Message-ID: <1375521042.3891.1.camel@phoenix>
Subject: [PATCH] regulator: s2mps11: Fix wrong arguments for
 regmap_update_bits() call
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 03 Aug 2013 17:10:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code calls regmap_update_bits() with mask and val arguments swapped.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s2mps11.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index f047d36..89140ae 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -207,8 +207,8 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 				  ramp_val << ramp_shift, 1 << ramp_shift);
 
 ramp_disable:
-	return regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP, 0,
-				  1 << enable_shift);
+	return regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
+				  1 << enable_shift, 0);
 }
 
 static struct regulator_ops s2mps11_ldo_ops = {
-- 
1.8.1.2



