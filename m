Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab3B0OLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:11:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2840 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760086Ab3B0OLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:11:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 27 Feb 2013 06:10:58 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <gg@slimlogic.co.uk>, <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <ian@slimlogic.co.uk>, <lrg@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: palmas: use correct device node for DT parsing
Date: Wed, 27 Feb 2013 19:40:24 +0530
Message-ID: <1361974224-18180-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device is registered through the DT then regulators node
exist in the parent device node of regulator driver. Hence passing
parent device node for parsing DT in place of self-device node
which is typically NULL.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index e915629..f07501d 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -591,7 +591,7 @@ static int palmas_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
 	struct palmas_pmic_platform_data *pdata = pdev->dev.platform_data;
-	struct device_node *node = pdev->dev.of_node;
+	struct device_node *node = pdev->dev.parent->of_node;
 	struct regulator_dev *rdev;
 	struct regulator_config config = { };
 	struct palmas_pmic *pmic;
-- 
1.7.1.1

