Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3LTNta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:49:30 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:64925 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3LTNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:49:29 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, b20788@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] regulator: anatop-regulator: Remove unneeded check
Date: Fri, 20 Dec 2013 11:42:09 -0200
Message-Id: <1387546930-32513-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

At the 'anatop_probe_end' error path, the variable 'ret' is known to be
non-zero, so there is no need to check it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/anatop-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index c734d09..0a3597b 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -211,8 +211,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rdev);
 
 anatop_probe_end:
-	if (ret)
-		kfree(sreg->name);
+	kfree(sreg->name);
 
 	return ret;
 }
-- 
1.8.1.2

