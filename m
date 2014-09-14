Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaINTV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 15:21:57 -0400
Received: from gloria.sntech.de ([95.129.55.99]:39191 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaINTUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:20:54 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 1/5] regulator: fan53555: enable vin supply
Date: Sun, 14 Sep 2014 21:23:01 +0200
Message-Id: <1410722585-13393-2-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410722585-13393-1-git-send-email-heiko@sntech.de>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator can be supplied by a parent regulator through its vin pin,
so add the supply_name for it.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/fan53555.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 714fd9a..c912ba7 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -207,6 +207,7 @@ static int fan53555_regulator_register(struct fan53555_device_info *di,
 	struct regulator_desc *rdesc = &di->desc;
 
 	rdesc->name = "fan53555-reg";
+	rdesc->supply_name = "vin";
 	rdesc->ops = &fan53555_regulator_ops;
 	rdesc->type = REGULATOR_VOLTAGE;
 	rdesc->n_voltages = FAN53555_NVOLTAGES;
-- 
2.0.1

