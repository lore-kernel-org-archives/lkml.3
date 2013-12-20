Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3LTNmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:42:33 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:54016 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab3LTNmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:42:32 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, b20788@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] regulator: anatop-regulator: Remove unneeded variable
Date: Fri, 20 Dec 2013 11:42:10 -0200
Message-Id: <1387546930-32513-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387546930-32513-1-git-send-email-festevam@gmail.com>
References: <1387546930-32513-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to create a local variable for accessing sreg->name.

Access it directly instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/anatop-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 0a3597b..7d7c05e 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -220,9 +220,8 @@ static int anatop_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 	struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
-	const char *name = sreg->name;
 
-	kfree(name);
+	kfree(sreg->name);
 
 	return 0;
 }
-- 
1.8.1.2

