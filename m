Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3JHNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:36:47 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18537 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3JHNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:36:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Oct 2013 06:36:46 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps65090: get regulators node from parent node only
Date: Tue, 8 Oct 2013 19:31:02 +0530
Message-ID: <1381240864-19639-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the devicetree binding document of TPS65090, the "regulators"
subnode should be under the parent node, not outside of parent node.
Hence to get the regulator node, the correct call is
of_get_child_by_name() rather than of_find_node_by_name() which searches
the "regulators" node from the parent node to end of DTS file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65090-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index bd611cd..676f755 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -180,7 +180,7 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	regulators = of_find_node_by_name(np, "regulators");
+	regulators = of_get_child_by_name(np, "regulators");
 	if (!regulators) {
 		dev_err(&pdev->dev, "regulator node not found\n");
 		return ERR_PTR(-ENODEV);
-- 
1.7.1.1

