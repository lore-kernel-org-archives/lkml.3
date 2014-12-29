Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaL2RGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:06:45 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65013 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaL2RGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:06:44 -0500
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <aniroop.mathur@gmail.com>, <a.mathur@samsung.com>
Subject: [PATCH] regulator: core: Fix format specifier warning
Date: Mon, 29 Dec 2014 22:36:48 +0530
Message-Id: <1419872808-11958-1-git-send-email-aniroop.mathur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b0729ef..f380f04 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3551,7 +3551,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->dev.of_node = of_node_get(config->of_node);
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%lu",
-		     atomic_inc_return(&regulator_no));
+		    (unsigned long) atomic_inc_return(&regulator_no));
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
 		put_device(&rdev->dev);
-- 
1.9.1

