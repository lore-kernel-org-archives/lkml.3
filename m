Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab3DYDdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 23:33:49 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57442 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3DYDdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 23:33:47 -0400
Message-ID: <1366860822.18788.3.camel@phoenix>
Subject: [PATCH 3/3] regulator: tps6507x: Use regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Date: Thu, 25 Apr 2013 11:33:42 +0800
In-Reply-To: <1366860702.18788.1.camel@phoenix>
References: <1366860702.18788.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All regulators have ascendant voltage list in this driver.
Use regulator_map_voltage_ascend for them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6507x-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 54aa2da..4117ff5 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -356,6 +356,7 @@ static struct regulator_ops tps6507x_pmic_ops = {
 	.get_voltage_sel = tps6507x_pmic_get_voltage_sel,
 	.set_voltage_sel = tps6507x_pmic_set_voltage_sel,
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 };
 
 #ifdef CONFIG_OF
-- 
1.7.10.4



