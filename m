Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119Ab3GSBRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:17:05 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:60151 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3GSBRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:17:03 -0400
Message-ID: <1374196615.8162.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node setting
 for regulator register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 09:16:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/88pm800.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index a7d962f..fc0c352 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -331,6 +331,7 @@ static int pm800_regulator_probe(struct platform_device *pdev)
 		config.init_data = init_data;
 		config.driver_data = info;
 		config.regmap = pm800_data->map;
+		config.of_node = pm800_regulator_matches[i].of_node;
 
 		pm800_data->regulators[i] =
 				regulator_register(&info->desc, &config);
-- 
1.8.1.2



