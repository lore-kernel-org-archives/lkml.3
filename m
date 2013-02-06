Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3BFDK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:10:59 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37917 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3BFDK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:10:57 -0500
Message-ID: <1360120251.8965.9.camel@phoenix>
Subject: [PATCH 2/2] regulator: max8998: Let regulator core handle the case
 selector == old_selector
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 11:10:51 +0800
In-Reply-To: <1360120188.8965.8.camel@phoenix>
References: <1360120188.8965.8.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8998.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 0a8dd1c..b588f07 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -311,25 +311,13 @@ static int max8998_set_voltage_buck_sel(struct regulator_dev *rdev,
 		dev_get_platdata(max8998->iodev->dev);
 	struct i2c_client *i2c = max8998->iodev->i2c;
 	int buck = rdev_get_id(rdev);
-	int reg, shift = 0, mask, ret;
-	int j, previous_sel;
+	int reg, shift = 0, mask, ret, j;
 	static u8 buck1_last_val;
 
 	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
 
-	previous_sel = max8998_get_voltage_sel(rdev);
-
-	/* Check if voltage needs to be changed */
-	/* if previous_voltage equal new voltage, return */
-	if (previous_sel == selector) {
-		dev_dbg(max8998->dev, "No voltage change, old:%d, new:%d\n",
-			regulator_list_voltage_linear(rdev, previous_sel),
-			regulator_list_voltage_linear(rdev, selector));
-		return ret;
-	}
-
 	switch (buck) {
 	case MAX8998_BUCK1:
 		dev_dbg(max8998->dev,
-- 
1.7.9.5



