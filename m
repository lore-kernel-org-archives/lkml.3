Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3JCNms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:42:48 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9204 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3JCNmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:42:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Oct 2013 06:42:46 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <lgirdwood@gmail.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: palmas: get regulators node from parent node only
Date: Thu, 3 Oct 2013 19:36:37 +0530
Message-ID: <1380809197-7759-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree binding of Palmas regulator driver says as:

palmas_pmis {
	compatible = "ti,palmas-pmic";
	...
	regulators {
		...
	}
};

In this "regulators" subnode is expected to be part of parent node, not
the outside of parent node. Hence to get the regulator node, the correct
call is of_get_child_by_name() rather than of_find_node_by_name() which
actually searches the "regulators" node from the parent node to end of DTS
file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The same issue exist on other drivers like tps65910, ts6586x, tps65090.
I will post the patches once this is fine.

 drivers/regulator/palmas-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 9d87c30..9c62b1d 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -820,7 +820,7 @@ static void palmas_dt_to_pdata(struct device *dev,
 	int idx, ret;
 
 	node = of_node_get(node);
-	regulators = of_find_node_by_name(node, "regulators");
+	regulators = of_get_child_by_name(node, "regulators");
 	if (!regulators) {
 		dev_info(dev, "regulator node not found\n");
 		return;
-- 
1.7.1.1

