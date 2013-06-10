Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3FJUJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:09:04 -0400
Received: from mout.gmx.net ([212.227.17.21]:53353 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3FJUJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:09:02 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1915GgLPuV1RJD0syB4Q/w+KXhZ7m1JW3rpLvRiwe
	sik07Blfwj3Dwo
From: Marc Dietrich <marvin24@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org
Subject: [PATCH] mfd: tps6586x: correct device name of the regulator cell
Date: Mon, 10 Jun 2013 22:06:01 +0200
Message-Id: <89e4451e14f324d8bd480f843fa5960b481e3188.1370894247.git.marvin24@gmx.de>
X-Mailer: git-send-email 1.7.9.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the device name of the regulator function to the one chosed for
MODULE_ALIAS. This fixes kernel module loading for the regulator function.
Also change the name of the platform driver to make everything consistent.

Signed-off-by: Marc Dietrich <marvin24@gmx.de>
---
I don't think this "fix" can still go into 3.10, but I would love to see
it there because otherwise many distro kernels supporting tegra2 would have
to force load the driver.

 drivers/mfd/tps6586x.c                 |    2 +-
 drivers/regulator/tps6586x-regulator.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 721b918..4b93ed4 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -107,7 +107,7 @@ static struct mfd_cell tps6586x_cell[] = {
 		.name = "tps6586x-gpio",
 	},
 	{
-		.name = "tps6586x-pmic",
+		.name = "tps6586x-regulator",
 	},
 	{
 		.name = "tps6586x-rtc",
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index d8fa37d..2c9155b 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -439,7 +439,7 @@ static int tps6586x_regulator_remove(struct platform_device *pdev)
 
 static struct platform_driver tps6586x_regulator_driver = {
 	.driver	= {
-		.name	= "tps6586x-pmic",
+		.name	= "tps6586x-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= tps6586x_regulator_probe,
-- 
1.7.9.5
