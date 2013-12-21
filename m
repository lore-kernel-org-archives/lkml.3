Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3LUT1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 14:27:43 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:36401 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3LUT1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 14:27:42 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, Anson.Huang@freescale.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/2] regulator: anatop-regulator: Only jump to 'anatop_probe_end' on error
Date: Sat, 21 Dec 2013 17:27:25 -0200
Message-Id: <1387654046-30997-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Currently 'anatop_probe_end' path is executed on both succesfull and error paths
of anatop_regulator_probe().

To let the code a bit clearer, make 'anatop_probe_end' to be executed only when
an error happens.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/anatop-regulator.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index c734d09..53e6048 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -210,9 +210,10 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rdev);
 
+	return 0;
+
 anatop_probe_end:
-	if (ret)
-		kfree(sreg->name);
+	kfree(sreg->name);
 
 	return ret;
 }
-- 
1.8.1.2

