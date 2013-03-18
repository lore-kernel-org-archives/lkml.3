Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3CRJc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:32:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8163 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3CRJcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:32:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Mar 2013 02:32:19 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <lrg@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] regulator: palmas: rename probe/remove callback functions
Date: Mon, 18 Mar 2013 14:59:49 +0530
Message-ID: <1363598989-25112-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1363598989-25112-1-git-send-email-ldewangan@nvidia.com>
References: <1363598989-25112-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When palmas regulator probe creates stack dump during initialization
due to some crash, it prints the call trace as follows:
[3.166321] [<c028fa20>] (_regmap_read+0x5c/0xa8) from [<c028fab0>] (regmap_read+0x44/0x5c)
[3.174669] [<c028fab0>] (regmap_read+0x44/0x5c) from [<c023062c>] (palmas_probe+0x240/0x7d0)
[3.183193] [<c023062c>] (palmas_probe+0x240/0x7d0) from [<c0284064>] (platform_drv_probe+0x14/0x18)
[3.192322] [<c0284064>] (platform_drv_probe+0x14/0x18) from [<c0282ee4>] (driver_probe_device+0x104/0x214)
[3.202055] [<c0282ee4>] (driver_probe_device+0x104/0x214) from [<c028167c>] (bus_for_each_drv+0x5c/0x88)

The palmas_probe is current name but it helps on debugging if the
function name is more appropriate to the sub-module name.

Renaming the palmas_probe() to palmas_regulator_probe() and
palmas_remove() to palams_regulator_remove().

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index a9b558e..4a45942 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -582,7 +582,7 @@ static void palmas_dt_to_pdata(struct device *dev,
 }
 
 
-static int palmas_probe(struct platform_device *pdev)
+static int palmas_regulators_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
 	struct palmas_pmic_platform_data *pdata = pdev->dev.platform_data;
@@ -791,7 +791,7 @@ err_unregister_regulator:
 	return ret;
 }
 
-static int palmas_remove(struct platform_device *pdev)
+static int palmas_regulators_remove(struct platform_device *pdev)
 {
 	struct palmas_pmic *pmic = platform_get_drvdata(pdev);
 	int id;
@@ -819,8 +819,8 @@ static struct platform_driver palmas_driver = {
 		.of_match_table = of_palmas_match_tbl,
 		.owner = THIS_MODULE,
 	},
-	.probe = palmas_probe,
-	.remove = palmas_remove,
+	.probe = palmas_regulators_probe,
+	.remove = palmas_regulators_remove,
 };
 
 static int __init palmas_init(void)
-- 
1.7.1.1

