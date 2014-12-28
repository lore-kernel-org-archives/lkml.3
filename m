Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaL1Qih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:38:37 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36882 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaL1Qif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:38:35 -0500
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <aniroop.mathur@gmail.com>, <a.mathur@samsung.com>
Subject: [PATCH] regulator: core: Avoid negative regulator no & initialize it to -1
Date: Sun, 28 Dec 2014 22:08:38 +0530
Message-Id: <1419784718-3704-1-git-send-email-aniroop.mathur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes regulator_no to -1 to avoid extra subtraction
operation performed every time we register a regulator and avoid negative
regulator no in its name.

Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
---
 drivers/regulator/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a3c3785..b0729ef 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3481,7 +3481,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 {
 	const struct regulation_constraints *constraints = NULL;
 	const struct regulator_init_data *init_data;
-	static atomic_t regulator_no = ATOMIC_INIT(0);
+	static atomic_t regulator_no = ATOMIC_INIT(-1);
 	struct regulator_dev *rdev;
 	struct device *dev;
 	int ret, i;
@@ -3550,8 +3550,8 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->dev.class = &regulator_class;
 	rdev->dev.of_node = of_node_get(config->of_node);
 	rdev->dev.parent = dev;
-	dev_set_name(&rdev->dev, "regulator.%d",
-		     atomic_inc_return(&regulator_no) - 1);
+	dev_set_name(&rdev->dev, "regulator.%lu",
+		     atomic_inc_return(&regulator_no));
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
 		put_device(&rdev->dev);
-- 
1.9.1

