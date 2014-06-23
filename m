Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaFWUxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:53:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41783 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaFWUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:53:37 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Alex Courbot <gnurou@gmail.com>, Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH] regulator: palmas: fix typo in enable_reg calculation
Date: Mon, 23 Jun 2014 14:53:25 -0600
Message-Id: <1403556805-22824-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

When setting up .enable_reg for an SMPS regulator, presumably we should
call PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, ...) rather than using
LDO_BASE. This change makes the LCD panel and HDMI work again on the
NVIDIA Dalmore board anyway.

Cc: Alex Courbot <gnurou@gmail.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Fixes: 318dbb02b50c ("regulator: palmas: Fix SMPS enable/disable/is_enabled")
Fixes: dbabd624d4eec50b6 ("regulator: palmas: Reemove open coded functions with helper functions")
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/regulator/palmas-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 3c861d5f9245..93b4ad842901 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -970,7 +970,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 
 			pmic->desc[id].enable_reg =
-					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
 						palmas_regs_info[id].ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
-- 
1.8.1.5

