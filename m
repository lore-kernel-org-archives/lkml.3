Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab3DZG0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:26:02 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60492 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3DZGZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:25:59 -0400
Message-ID: <1366957552.22992.1.camel@phoenix>
Subject: [PATCH] regulator: tps6524x: Use regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Apr 2013 14:25:52 +0800
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
 drivers/regulator/tps6524x-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 843ee0a..18b67d2 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -572,6 +572,7 @@ static struct regulator_ops regulator_ops = {
 	.get_voltage_sel	= get_voltage_sel,
 	.set_voltage_sel	= set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage		= regulator_map_voltage_ascend,
 	.set_current_limit	= set_current_limit,
 	.get_current_limit	= get_current_limit,
 };
-- 
1.7.10.4



