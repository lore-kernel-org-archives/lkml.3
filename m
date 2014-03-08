Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaCHDzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:55:36 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47733 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaCHDzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:55:35 -0500
Message-ID: <1394250929.3892.1.camel@phoenix>
Subject: [PATCH v2 1/2] regulator: pbias: Fix is_enabled callback
 implementation
From: Axel Lin <axel.lin@ingics.com>
To: Chris Ball <chris@printf.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Date: Sat, 08 Mar 2014 11:55:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_enabled implementation is wrong in some cases:
e.g. for pbias_mmc_omap5: enable_mask is : BIT(27) | BIT(25) | BIT(26)
However, pbias_regulator_enable() only sets BIT(27) | BIT(26) bits.
So is_enabled callback will always return false in this case.
Fix the logic to compare the register value with info->enable rather than
info->enable_mask.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Balaji T K <balajitk@ti.com>
---
v2: Update commit log and add Balaji's Ack.

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



