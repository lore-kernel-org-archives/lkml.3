Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3JHNg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:36:57 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18562 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3JHNgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:36:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Oct 2013 06:32:42 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps65910: get regulators node from parent node only
Date: Tue, 8 Oct 2013 19:31:04 +0530
Message-ID: <1381240864-19639-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1381240864-19639-1-git-send-email-ldewangan@nvidia.com>
References: <1381240864-19639-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the devicetree binding document of TPS65910, the "regulators"
subnode should be under the parent node, not outside of parent node.
Hence to get the regulator node, the correct call is
of_get_child_by_name() rather than of_find_node_by_name() which searches
the "regulators" node from the parent node to end of DTS file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index b8167df..ccde074 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -982,7 +982,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 	}
 
 	np = of_node_get(pdev->dev.parent->of_node);
-	regulators = of_find_node_by_name(np, "regulators");
+	regulators = of_get_child_by_name(np, "regulators");
 	if (!regulators) {
 		dev_err(&pdev->dev, "regulator node not found\n");
 		return NULL;
-- 
1.7.1.1

