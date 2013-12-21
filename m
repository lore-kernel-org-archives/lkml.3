Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3LUT1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 14:27:46 -0500
Received: from mail-gg0-f169.google.com ([209.85.161.169]:38639 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3LUT1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 14:27:43 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, Anson.Huang@freescale.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 2/2] regulator: anatop-regulator: Remove unneeded variable
Date: Sat, 21 Dec 2013 17:27:26 -0200
Message-Id: <1387654046-30997-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387654046-30997-1-git-send-email-festevam@gmail.com>
References: <1387654046-30997-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to create a local variable for accessing sreg->name.

Access it directly instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- None

 drivers/regulator/anatop-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 53e6048..8fee74d 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -222,9 +222,8 @@ static int anatop_regulator_remove(struct platform_device *pdev)
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

