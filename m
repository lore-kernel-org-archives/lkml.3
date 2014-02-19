Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaBSCqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:46:32 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:51367 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaBSCqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:46:31 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] pfuze100-regulator: Fix of_node_get() parameter
Date: Tue, 18 Feb 2014 23:46:14 -0300
Message-Id: <1392777974-26254-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we get
the following probe failure:

pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0                       
pfuze100-regulator 1-0008: FAB: 0, FIN: 0                                      
pfuze100-regulator 1-0008: regulators node not found                           
pfuze100-regulator: probe of 1-0008 failed with error -22 

Now that of_get_child_by_name() is used we should adjust the device_node pointer
'np' to not get the parent node anymore. 

Suggested-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index c1cb202..dcb03ce 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -250,7 +250,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	struct device_node *np, *parent;
 	int ret;
 
-	np = of_node_get(dev->parent->of_node);
+	np = of_node_get(dev->of_node);
 	if (!np)
 		return 0;
 
-- 
1.8.1.2

