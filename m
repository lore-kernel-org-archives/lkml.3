Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaCDKUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:20:24 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57711 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbaCDKUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:20:22 -0500
Message-ID: <1393928414.9669.1.camel@phoenix>
Subject: [PATCH] regulator: pfuze100: Add terminate entry for
 [i2c|of]_device_id tables
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2014 18:20:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove PFUZE_NUM to avoid below build warnings:

  CC [M]  drivers/regulator/pfuze100-regulator.o
drivers/regulator/pfuze100-regulator.c:86:2: warning: excess elements in array initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:86:2: warning: (near initialization for 'pfuze_device_id') [enabled by default]
drivers/regulator/pfuze100-regulator.c:93:2: warning: excess elements in array initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:93:2: warning: (near initialization for 'pfuze_dt_ids') [enabled by default]

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 44075f8..f87ec70 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -56,7 +56,7 @@
 #define PFUZE100_VGEN5VOL	0x70
 #define PFUZE100_VGEN6VOL	0x71
 
-enum chips {PFUZE100, PFUZE200, PFUZE_NUM};
+enum chips { PFUZE100, PFUZE200 };
 
 struct pfuze_regulator {
 	struct regulator_desc desc;
@@ -80,15 +80,17 @@ static const int pfuze100_vsnvs[] = {
 	1000000, 1100000, 1200000, 1300000, 1500000, 1800000, 3000000,
 };
 
-static const struct i2c_device_id pfuze_device_id[PFUZE_NUM] = {
+static const struct i2c_device_id pfuze_device_id[] = {
 	{.name = "pfuze100", .driver_data = PFUZE100},
 	{.name = "pfuze200", .driver_data = PFUZE200},
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pfuze_device_id);
 
-static const struct of_device_id pfuze_dt_ids[PFUZE_NUM] = {
+static const struct of_device_id pfuze_dt_ids[] = {
 	{ .compatible = "fsl,pfuze100", .data = (void *)PFUZE100},
 	{ .compatible = "fsl,pfuze200", .data = (void *)PFUZE200},
+	{ }
 };
 MODULE_DEVICE_TABLE(of, pfuze_dt_ids);
 
-- 
1.8.1.2



