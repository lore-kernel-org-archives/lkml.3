Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3FJV1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:27:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2813 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3FJV1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:27:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 10 Jun 2013 14:25:37 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/4] power: sbs-battery: Add dt to power_supply struct
Date: Mon, 10 Jun 2013 17:26:40 -0400
Message-ID: <1370899602-22123-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
References: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By passing in the dt node of this device, we enable the logic for
linking power_supplies together from dt. This is specified by adding
a "power-supplies" property with a phandle to the charger for a
given supply.

Enable this logic now for the sbs-battery driver.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/sbs-battery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index c8c78a7..b5f2a76 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -704,6 +704,7 @@ static int sbs_probe(struct i2c_client *client,
 	chip->power_supply.properties = sbs_properties;
 	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
 	chip->power_supply.get_property = sbs_get_property;
+	chip->power_supply.of_node = client->dev.of_node;
 	/* ignore first notification of external change, it is generated
 	 * from the power_supply_register call back
 	 */
-- 
1.7.9.5

