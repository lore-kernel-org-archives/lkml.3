Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaL1P5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 10:57:16 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57821 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaL1P5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 10:57:15 -0500
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <aniroop.mathur@gmail.com>, <a.mathur@samsung.com>
Subject: [PATCH] regulator: core: Initialize regulator_no to -1
Date: Sun, 28 Dec 2014 21:27:17 +0530
Message-Id: <1419782237-2562-1-git-send-email-aniroop.mathur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aniroop Mathur <a.mathur@samsung.com>

This patch initializes regulator_no to -1 to avoid extra subtraction
operation performed every time we register a regulator.

Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
---
 drivers/regulator/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a3c3785..4da1d98 100644
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
@@ -3551,7 +3551,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->dev.of_node = of_node_get(config->of_node);
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%d",
-		     atomic_inc_return(&regulator_no) - 1);
+		     atomic_inc_return(&regulator_no));
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
 		put_device(&rdev->dev);
-- 
1.9.1

