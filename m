Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBNL5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:57:52 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35512 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaBNL4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:56:04 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 10/16] regulator: da9052: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:56 +0530
Message-Id: <1392378602-32302-10-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name walks the allnodes list, and can thus walk
outside of the parent node. Use of_get_child_by_name instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/da9052-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 3adeaeffc485..889c7c9b9f15 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -401,7 +401,7 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 		if (!nproot)
 			return -ENODEV;
 
-		nproot = of_find_node_by_name(nproot, "regulators");
+		nproot = of_get_child_by_name(nproot, "regulators");
 		if (!nproot)
 			return -ENODEV;
 
-- 
1.7.9.5

