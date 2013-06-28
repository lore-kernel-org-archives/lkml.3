Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3F1Ncm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:32:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49517 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3F1Ncl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:32:41 -0400
Message-ID: <1372426354.28529.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node setting
 for regulator register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 28 Jun 2013 21:32:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
Seems current code also needs this patch:
	mfd: 88pm800: add regulator sub device [1]

Otherwise, I got build error:
  CC      drivers/regulator/88pm800.o
drivers/regulator/88pm800.c: In function 'pm800_regulator_probe':
drivers/regulator/88pm800.c:356:21: error: 'struct pm80x_platform_data' has no member named 'num_regulators'
drivers/regulator/88pm800.c:364:18: error: 'struct pm80x_platform_data' has no member named 'num_regulators'
drivers/regulator/88pm800.c:367:20: error: 'struct pm80x_platform_data' has no member named 'regulators'
drivers/regulator/88pm800.c:369:21: error: 'struct pm80x_platform_data' has no member named 'num_regulators'
drivers/regulator/88pm800.c:388:22: error: 'struct pm80x_platform_data' has no member named 'num_regulators'
drivers/regulator/88pm800.c:391:21: error: 'struct pm80x_platform_data' has no member named 'regulators'
make[2]: *** [drivers/regulator/88pm800.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

[1] https://lkml.org/lkml/2013/6/14/21.

 drivers/regulator/88pm800.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index ed704ca..afa3762 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -396,6 +396,7 @@ static int pm800_regulator_probe(struct platform_device *pdev)
 		config.init_data = init_data;
 		config.driver_data = info;
 		config.regmap = pm800_data->map;
+		config.of_node = pm800_regulator_matches[i].of_node;
 
 		pm800_data->regulators[i] =
 				regulator_register(&info->desc, &config);
-- 
1.8.1.2



