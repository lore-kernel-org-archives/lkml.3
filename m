Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaCGPlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:41:45 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49367 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaCGPln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:41:43 -0500
Message-ID: <1394206897.17867.1.camel@phoenix>
Subject: [PATCH 1/3] regulator: pbias: Fix is_enabled callback implementation
From: Axel Lin <axel.lin@ingics.com>
To: Chris Ball <chris@printf.net>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: Balaji T K <balajitk@ti.com>, Florian Vaussard <florian.vaussard@epfl.ch>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Fri, 07 Mar 2014 23:41:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_enabled implementation is wrong in some cases:
e.g. for pbias_mmc_omap5: emable_mask is : BIT(27) | BIT(25) | BIT(26)
However, pbias_regulator_enable() only sets BIT(26) | BIT(22) bits.
So is_enabled callback will always return false in this case.
Fix the logic to compare the register value with info->enable rather than
info->enable_mask.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pbias-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pbias-regulator.c b/drivers/regulator/pbias-regulator.c
index ded3b35..d89a1d8 100644
--- a/drivers/regulator/pbias-regulator.c
+++ b/drivers/regulator/pbias-regulator.c
@@ -108,7 +108,7 @@ static int pbias_regulator_is_enable(struct regulator_dev *rdev)
 
 	regmap_read(data->syscon, data->pbias_reg, &value);
 
-	return (value & info->enable_mask) == info->enable_mask;
+	return (value & info->enable_mask) == info->enable;
 }
 
 static struct regulator_ops pbias_regulator_voltage_ops = {
-- 
1.8.1.2



