Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab3K3EVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 23:21:13 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45251 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3K3EVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 23:21:12 -0500
Message-ID: <1385785263.24696.2.camel@phoenix>
Subject: [RFT][PATCH] mfd: pcf50633: Correct device name for pcf50633
 regulator
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>
Cc: Balaji Rao <balajirrao@openmoko.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 30 Nov 2013 12:21:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the device name of the regulator function to the one chosen for
MODULE_ALIAS. This fixes kernel auto-module loading for the regulator function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
I don't have the hardware to test, but I think this needs fix.
We have a similar fix in
commit ec8da805c43a "mfd: tps6586x: correct device name of the regulator cell".

 drivers/mfd/pcf50633-core.c            | 2 +-
 drivers/regulator/pcf50633-regulator.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 6841d68..41ab5e3 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -245,7 +245,7 @@ static int pcf50633_probe(struct i2c_client *client,
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
 		struct platform_device *pdev;
 
-		pdev = platform_device_alloc("pcf50633-regltr", i);
+		pdev = platform_device_alloc("pcf50633-regulator", i);
 		if (!pdev) {
 			dev_err(pcf->dev, "Cannot create regulator %d\n", i);
 			continue;
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index d7da1c1..134f90e 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -105,7 +105,7 @@ static int pcf50633_regulator_probe(struct platform_device *pdev)
 
 static struct platform_driver pcf50633_regulator_driver = {
 	.driver = {
-		.name = "pcf50633-regltr",
+		.name = "pcf50633-regulator",
 	},
 	.probe = pcf50633_regulator_probe,
 };
-- 
1.8.1.2



