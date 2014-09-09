Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaIILIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:08:09 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41520 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaIILIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:08:06 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: broonie@kernel.org, lgirdwood@gmail.com, shawn.guo@linaro.org,
        axel.lin@ingics.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH] regulator: mc13xxx: add missing of_node_get()
Date: Tue,  9 Sep 2014 19:07:05 +0800
Message-Id: <1410260825-21667-1-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13xxx_parse_regulators_dt() goes through dt tree to search for regulator
sub-nodes. For each matched node, later on it will be used and registered
into a regulator_dev.

of_node_get() should be called to increase its refcount.

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 drivers/regulator/mc13xxx-regulator-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index afba024..ebc8ff1 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -195,7 +195,7 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 				p->id = i;
 				p->init_data = of_get_regulator_init_data(
 							&pdev->dev, child);
-				p->node = child;
+				p->node = of_node_get(child);
 				p++;
 
 				parsed++;
-- 
1.9.1

