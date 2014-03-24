Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaCXMpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:45:45 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41632 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCXMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:45:44 -0400
Message-ID: <1395665138.4779.1.camel@phoenix>
Subject: [PATCH] regulator: aat2870: Use regulator_map_voltage_ascend
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Mar 2014 20:45:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltages in aat2870_ldo_voltages table are in ascendant order, so use
regulator_map_voltage_ascend.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/aat2870-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index f70a9bf..c873ee0 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -99,6 +99,7 @@ static int aat2870_ldo_is_enabled(struct regulator_dev *rdev)
 
 static struct regulator_ops aat2870_ldo_ops = {
 	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
 	.set_voltage_sel = aat2870_ldo_set_voltage_sel,
 	.get_voltage_sel = aat2870_ldo_get_voltage_sel,
 	.enable = aat2870_ldo_enable,
-- 
1.8.3.2



