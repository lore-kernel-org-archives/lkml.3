Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3A3MzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:55:01 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55305 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3A3My4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:54:56 -0500
Message-ID: <1359550489.3885.8.camel@phoenix>
Subject: [PATCH 2/2] regulator: mc13xxx: Use of_get_child_count()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jan 2013 20:54:49 +0800
In-Reply-To: <1359550369.3885.6.camel@phoenix>
References: <1359550369.3885.6.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
hi Mark,
I generate this patch against for-next branch of regulator tree.
So this patch is on top of commit c92f5dd2c "regulator: Add missing of_node_put()".

Which means it can only be applied to topic/of branch now.
If you prefer apply it to other branch, I can resend and generate the patch against
proper topic branch.

Axel

 drivers/regulator/mc13xxx-regulator-core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 04cf962..5186adc 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -164,17 +164,15 @@ EXPORT_SYMBOL_GPL(mc13xxx_fixed_regulator_ops);
 #ifdef CONFIG_OF
 int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 {
-	struct device_node *parent, *child;
-	int num = 0;
+	struct device_node *parent;
+	int num;
 
 	of_node_get(pdev->dev.parent->of_node);
 	parent = of_find_node_by_name(pdev->dev.parent->of_node, "regulators");
 	if (!parent)
 		return -ENODEV;
 
-	for_each_child_of_node(parent, child)
-		num++;
-
+	num = of_get_child_count(parent);
 	of_node_put(parent);
 	return num;
 }
-- 
1.7.9.5



