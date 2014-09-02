Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaIBAri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:47:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40875 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaIBArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:47:36 -0400
Message-ID: <1409618851.4532.2.camel@phoenix>
Subject: [PATCH] regulator: rk808: Fix n_voltages for DCDC4
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 08:47:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min_sel is 0, max_sel is 15, so n_voltages should be 16.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/rk808-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 0d11df1..0da8867 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -146,7 +146,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.id = RK808_ID_DCDC4,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
-		.n_voltages = 17,
+		.n_voltages = 16,
 		.linear_ranges = rk808_buck4_voltage_ranges,
 		.n_linear_ranges = ARRAY_SIZE(rk808_buck4_voltage_ranges),
 		.vsel_reg = RK808_BUCK4_ON_VSEL_REG,
-- 
1.9.1



