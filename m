Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3LWOpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:45:00 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:56520 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3LWOo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:44:58 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, Anson.Huang@freescale.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 2/2] regulator: anatop-regulator: Remove unneeded variable
Date: Mon, 23 Dec 2013 12:44:41 -0200
Message-Id: <1387809881-16092-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387809881-16092-1-git-send-email-festevam@gmail.com>
References: <1387809881-16092-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to create a local variable for accessing sreg->name.

Access it directly instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- None

 drivers/regulator/anatop-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 88d95cd..cc545a0 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -226,9 +226,8 @@ static int anatop_regulator_remove(struct platform_device *pdev)
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

