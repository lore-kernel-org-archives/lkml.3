Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3BCMuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:50:10 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65115 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3BCMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:50:07 -0500
Message-ID: <1359895796.4157.3.camel@phoenix>
Subject: [PATCH] regulator: palmas: Remove a redundant setting for warm_reset
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 03 Feb 2013 20:49:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code read "ti,warm_reset" of property twice, and set
pdata->reg_init[idx]->warm_reset twice. Read and set it once is enough.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index cbaf226..cde13bb 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -568,11 +568,6 @@ static void palmas_dt_to_pdata(struct device *dev,
 			pdata->reg_init[idx]->mode_sleep = prop;
 
 		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,warm_reset", &prop);
-		if (!ret)
-			pdata->reg_init[idx]->warm_reset = prop;
-
-		ret = of_property_read_u32(palmas_matches[idx].of_node,
 				"ti,tstep", &prop);
 		if (!ret)
 			pdata->reg_init[idx]->tstep = prop;
-- 
1.7.9.5



