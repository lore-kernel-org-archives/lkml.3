Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBSI3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:29:23 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62702 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaBSI3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:29:12 -0500
Message-ID: <1392798543.31957.0.camel@phoenix>
Subject: [PATCH 1/3 v2] regulator: tps65218: Add terminate entry for
 of_device_id table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 19 Feb 2014 16:29:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes below build error:
FATAL: drivers/regulator/tps65218-regulator: struct of_device_id is not terminated with a NULL entry!

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65218-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 958276c..d1c7831 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -96,6 +96,7 @@ static const struct of_device_id tps65218_of_match[] = {
 	TPS65218_OF_MATCH("ti,tps65218-dcdc5", tps65218_pmic_regs[DCDC5]),
 	TPS65218_OF_MATCH("ti,tps65218-dcdc6", tps65218_pmic_regs[DCDC6]),
 	TPS65218_OF_MATCH("ti,tps65218-ldo1", tps65218_pmic_regs[LDO1]),
+	{ }
 };
 MODULE_DEVICE_TABLE(of, tps65218_of_match);
 
-- 
1.8.1.2



