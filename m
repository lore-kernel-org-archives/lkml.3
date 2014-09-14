Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaINTU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 15:20:58 -0400
Received: from gloria.sntech.de ([95.129.55.99]:39183 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbaINTUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:20:53 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 2/5] regulator: fan53555: set regulator name from constraints name
Date: Sun, 14 Sep 2014 21:23:02 +0200
Message-Id: <1410722585-13393-3-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410722585-13393-1-git-send-email-heiko@sntech.de>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a high potential of more than one of those regulators existing
on a board, so name the regulator according to the name provided in the
initdata instead of statically.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/fan53555.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index c912ba7..d143790 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -206,7 +206,12 @@ static int fan53555_regulator_register(struct fan53555_device_info *di,
 {
 	struct regulator_desc *rdesc = &di->desc;
 
-	rdesc->name = "fan53555-reg";
+	rdesc->name = devm_kstrdup(di->dev,
+				   di->regulator->constraints.name,
+				   GFP_KERNEL);
+	if (!rdesc->name)
+		return -ENOMEM;
+
 	rdesc->supply_name = "vin";
 	rdesc->ops = &fan53555_regulator_ops;
 	rdesc->type = REGULATOR_VOLTAGE;
-- 
2.0.1

