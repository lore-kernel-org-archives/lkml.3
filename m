Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3CUUdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:33:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5915 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3CUUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:33:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Mar 2013 13:33:04 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/2] power_supply: tps65090: Setup compatible property for dt
Date: Thu, 21 Mar 2013 16:33:05 -0400
Message-ID: <1363897985-19980-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363897985-19980-1-git-send-email-rklein@nvidia.com>
References: <1363897985-19980-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the compatible property so that when this device is registered
through device tree, it can match the expected compatiblity string
used in the tps65090 driver.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/tps65090-charger.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 0c66c66..3b3dafd 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -168,7 +168,7 @@ static struct tps65090_platform_data *
 		tps65090_parse_dt_charger_data(struct platform_device *pdev)
 {
 	struct tps65090_platform_data *pdata;
-	struct device_node *np = pdev->dev.parent->of_node;
+	struct device_node *np = pdev->dev.of_node;
 	unsigned int prop;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
@@ -204,7 +204,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 
 	pdata = dev_get_platdata(pdev->dev.parent);
 
-	if (!pdata && tps65090_mfd->dev->of_node)
+	if (!pdata && pdev->dev.of_node)
 		pdata = tps65090_parse_dt_charger_data(pdev);
 
 	if (!pdata) {
@@ -300,9 +300,15 @@ static int tps65090_charger_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id of_tps65090_charger_match[] = {
+	{ .compatible = "ti,tps65090-charger", },
+	{ /* end */ }
+};
+
 static struct platform_driver tps65090_charger_driver = {
 	.driver	= {
 		.name	= "tps65090-charger",
+		.of_match_table = of_tps65090_charger_match,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= tps65090_charger_probe,
-- 
1.7.9.5

