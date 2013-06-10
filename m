Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3FJV0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:26:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2560 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3FJV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:26:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 10 Jun 2013 14:26:39 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 3/4] power: tps65090-charger: Add dt node to power_supply
Date: Mon, 10 Jun 2013 17:26:41 -0400
Message-ID: <1370899602-22123-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
References: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing in the dt node for this charger enables the logic in the core
to lookup this device, to see if it is supplying another power_supply,
through dt.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/tps65090-charger.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 77ab856..3f4b9cc 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -230,6 +230,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	cdata->ac.num_properties	= ARRAY_SIZE(tps65090_ac_props);
 	cdata->ac.supplied_to		= pdata->supplied_to;
 	cdata->ac.num_supplicants	= pdata->num_supplicants;
+	cdata->ac.of_node		= pdev->dev.of_node;
 
 	ret = power_supply_register(&pdev->dev, &cdata->ac);
 	if (ret) {
-- 
1.7.9.5

