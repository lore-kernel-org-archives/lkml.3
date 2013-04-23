Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab3DWQPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:15:03 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53960 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab3DWQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:15:01 -0400
Message-ID: <1366733695.7020.1.camel@phoenix>
Subject: [PATCH] regulator: max8973: Don't override control1 variable when
 set ramp delay bits
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Wed, 24 Apr 2013 00:14:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code overrides control1 variable when setting ramp delay bits.
Fix it by just setting ramp_delay bits.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8973-regulator.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 9a8ea91..adb1414 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -274,15 +274,15 @@ static int max8973_init_dcdc(struct max8973_chip *max,
 	if (pdata->reg_init_data &&
 			pdata->reg_init_data->constraints.ramp_delay) {
 		if (pdata->reg_init_data->constraints.ramp_delay < 25000)
-			control1 = MAX8973_RAMP_12mV_PER_US;
+			control1 |= MAX8973_RAMP_12mV_PER_US;
 		else if (pdata->reg_init_data->constraints.ramp_delay < 50000)
-			control1 = MAX8973_RAMP_25mV_PER_US;
+			control1 |= MAX8973_RAMP_25mV_PER_US;
 		else if (pdata->reg_init_data->constraints.ramp_delay < 200000)
-			control1 = MAX8973_RAMP_50mV_PER_US;
+			control1 |= MAX8973_RAMP_50mV_PER_US;
 		else
-			control1 = MAX8973_RAMP_200mV_PER_US;
+			control1 |= MAX8973_RAMP_200mV_PER_US;
 	} else {
-		control1 = MAX8973_RAMP_12mV_PER_US;
+		control1 |= MAX8973_RAMP_12mV_PER_US;
 		max->desc.ramp_delay = 12500;
 	}
 
-- 
1.7.10.4



