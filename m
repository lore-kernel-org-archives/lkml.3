Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3HAMAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:00:04 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46742 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3HAMAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:00:01 -0400
Message-ID: <1375358396.15804.1.camel@phoenix>
Subject: [PATCH] regulator: pfuze100: Fix off-by-one for max_register setting
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Aug 2013 19:59:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_register should be register count - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Robin,
I don't have the datasheet, can you check if this patch is correct or not?
If PFUZE_NUMREGS really means register count, I think this fix is required.

Thanks,
Axel
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index bda5561..ba67b2c 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -332,7 +332,7 @@ static int pfuze_identify(struct pfuze_chip *pfuze_chip)
 static const struct regmap_config pfuze_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.max_register = PFUZE_NUMREGS,
+	.max_register = PFUZE_NUMREGS - 1,
 	.cache_type = REGCACHE_RBTREE,
 };
 
-- 
1.8.1.2



