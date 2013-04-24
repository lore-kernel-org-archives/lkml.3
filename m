Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab3DXMmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:42:37 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:62978 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3DXMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:42:36 -0400
Message-ID: <1366807349.16547.1.camel@phoenix>
Subject: [PATCH] regulator: mc13892: Use regulator_map_voltage_ascend for
 mc13892_sw_regulator_ops
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Apr 2013 20:42:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both mc13892_sw1 and mc13892_sw voltage table have ascendant voltage list.
Use regulator_map_voltage_ascend for them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/mc13892-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 9891aec..89d004b 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -485,6 +485,7 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 
 static struct regulator_ops mc13892_sw_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.set_voltage_sel = mc13892_sw_regulator_set_voltage_sel,
 	.get_voltage_sel = mc13892_sw_regulator_get_voltage_sel,
 };
-- 
1.7.10.4



