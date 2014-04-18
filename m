Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaDRSaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:30:19 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56165 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaDRSaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:30:16 -0400
X-IronPort-AV: E=Sophos;i="4.97,885,1389772800"; 
   d="scan'208";a="25188477"
From: Tim Kryger <tim.kryger@linaro.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: Allow set voltage on fixed regulators
Date: Fri, 18 Apr 2014 11:30:10 -0700
Message-ID: <1397845810-17002-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a regulator consumer requests a voltage range that can be satisfied,
the return value should indicate success even if that regulator has a
fixed voltage.  Since there is already logic to check if the requested
voltage range overlaps the allowed range, set REGULATOR_CHANGE_VOLTAGE
for regulators with constraints that include a positive voltage.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/regulator/of_regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index ea4f36f..a205d62 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -36,7 +36,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 		constraints->max_uV = be32_to_cpu(*max_uV);
 
 	/* Voltage change possible? */
-	if (constraints->min_uV != constraints->max_uV)
+	if (constraints->max_uV > 0)
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_VOLTAGE;
 	/* Only one voltage?  Then make sure it's set. */
 	if (min_uV && max_uV && constraints->min_uV == constraints->max_uV)
-- 
1.7.9.5

