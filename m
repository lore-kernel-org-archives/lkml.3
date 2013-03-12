Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3CLPkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:40:32 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44346 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3CLPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:40:31 -0400
Message-ID: <1363102819.3160.1.camel@phoenix>
Subject: [PATCH] regulator: palmas: Use of_property_read_bool to read
 "ti,warm-reset" DT property
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 23:40:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make sense to assign return value of of_property_read_u32() to
pdata->reg_init[idx]->warm_reset. Use of_property_read_bool() to read
"ti,warm-reset" DT property instead which will return correct setting
for pdata->reg_init[idx]->warm_reset.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index b2b1baa..a9b558e 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -554,8 +554,8 @@ static void palmas_dt_to_pdata(struct device *dev,
 				sizeof(struct palmas_reg_init), GFP_KERNEL);
 
 		pdata->reg_init[idx]->warm_reset =
-			of_property_read_u32(palmas_matches[idx].of_node,
-					     "ti,warm-reset", &prop);
+			of_property_read_bool(palmas_matches[idx].of_node,
+					     "ti,warm-reset");
 
 		pdata->reg_init[idx]->roof_floor =
 			of_property_read_bool(palmas_matches[idx].of_node,
-- 
1.7.9.5



