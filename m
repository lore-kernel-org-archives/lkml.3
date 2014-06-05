Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaFEAoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:44:09 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56103 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaFEAoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:44:05 -0400
Message-ID: <1401929039.16832.1.camel@phoenix>
Subject: [PATCH] regulator: ltc3589: Use of_get_child_by_name
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 05 Jun 2014 08:43:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() walks the allnodes list, and can thus walk
outside of the parent node. Use of_get_child_by_name() instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ltc3589.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ltc3589.c b/drivers/regulator/ltc3589.c
index 110a99e..c810518 100644
--- a/drivers/regulator/ltc3589.c
+++ b/drivers/regulator/ltc3589.c
@@ -255,7 +255,7 @@ static int ltc3589_parse_regulators_dt(struct ltc3589 *ltc3589)
 	struct device_node *node;
 	int i, ret;
 
-	node = of_find_node_by_name(dev->of_node, "regulators");
+	node = of_get_child_by_name(dev->of_node, "regulators");
 	if (!node) {
 		dev_err(dev, "regulators node not found\n");
 		return -EINVAL;
-- 
1.8.3.2



