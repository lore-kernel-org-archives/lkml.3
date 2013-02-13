Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab3BMBez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 20:34:55 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:35225 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3BMBey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 20:34:54 -0500
Message-ID: <1360719288.14930.5.camel@phoenix>
Subject: [PATCH] regulator: as3711: Fix checking if no platform
 initialization data
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 09:34:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To skip registering regulator if no platform initialization data,
we should check reg_data rather than ri->desc.name.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3711-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 2f1341d..f0ba8c4 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -303,7 +303,7 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 		reg_data = pdata ? pdata->init_data[id] : NULL;
 
 		/* No need to register if there is no regulator data */
-		if (!ri->desc.name)
+		if (!reg_data)
 			continue;
 
 		reg = &regs[id];
-- 
1.7.9.5



