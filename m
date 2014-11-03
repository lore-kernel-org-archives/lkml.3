Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaKCBaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 20:30:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51026 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaKCBav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 20:30:51 -0500
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: hugh.kang@lge.com
From: Hugh Kang <hugh.kang@lge.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        jonghoon.park@lge.com, hugh.kang@lge.com
Subject: [PATCH] regulator: adding disable options for regulator-always-on and regulator-boots-on
Date: Mon,  3 Nov 2014 10:26:43 +0900
Message-Id: <1414978003-20437-1-git-send-email-hugh.kang@lge.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hugh.kang" <hugh.kang@lge.com>

If a regulator is set by always-on option, the regulator will be set forever.
For example, suppose LDO1 is set to always-on at RevA.dts with including of a.dtsi. After that
RevB.dts may wants to include the same a.dtsi but override the LDO1 always-on option. However,
currently there is no way to delete the always-on option, even when we change the LDO1 option value,
the always-on setting is still remains.

Signed-off-by: hugh.kang <hugh.kang@lge.com>
---
 drivers/regulator/of_regulator.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ee5e67b..4178dbd 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -52,7 +52,13 @@ static void of_get_regulation_constraints(struct device_node *np,
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_CURRENT;
 
 	constraints->boot_on = of_property_read_bool(np, "regulator-boot-on");
+	if (of_property_read_bool(np, "regulator-disable-boot-on"))
+		constraints->boot_on = false;
+
 	constraints->always_on = of_property_read_bool(np, "regulator-always-on");
+	if (of_property_read_bool(np, "regulator-disable-always-on"))
+		constraints->always_on = false;
+
 	if (!constraints->always_on) /* status change should be possible. */
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_STATUS;
 
-- 
1.8.3.2

