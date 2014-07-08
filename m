Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaGHTKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:10:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47628 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbaGHTJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:09:47 -0400
From: Felipe Balbi <balbi@ti.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Keerthy <j-keerthy@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3/3] regulators: tps65218: drop order dependency
Date: Tue, 8 Jul 2014 14:09:14 -0500
Message-ID: <1404846554-4095-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-Reply-To: <1404846554-4095-1-git-send-email-balbi@ti.com>
References: <1404846554-4095-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By just using GCC's array initialization extension, we
can easily drop order dependency between tps65218_regulattors
enumeration and tps65218_pmic_regs array.

Signed-of-by: Felipe Balbi <balbi@ti.com>
---
 drivers/regulator/tps65218-regulator.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 7fc8b3a..b5dc314 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -49,7 +49,7 @@ enum tps65218_regulators { DCDC1, DCDC2, DCDC3, DCDC4, DCDC5, DCDC6, LDO1 };
 	}							\
 
 #define TPS65218_INFO(_id, _nm, _min, _max)	\
-	{						\
+	[_id] = {					\
 		.id		= _id,			\
 		.name		= _nm,			\
 		.min_uV		= _min,			\
@@ -72,13 +72,13 @@ static const struct regulator_linear_range dcdc4_ranges[] = {
 };
 
 static struct tps_info tps65218_pmic_regs[] = {
-	TPS65218_INFO(0, "DCDC1", 850000, 167500),
-	TPS65218_INFO(1, "DCDC2", 850000, 1675000),
-	TPS65218_INFO(2, "DCDC3", 900000, 3400000),
-	TPS65218_INFO(3, "DCDC4", 1175000, 3400000),
-	TPS65218_INFO(4, "DCDC5", 1000000, 1000000),
-	TPS65218_INFO(5, "DCDC6", 1800000, 1800000),
-	TPS65218_INFO(6, "LDO1", 900000, 3400000),
+	TPS65218_INFO(DCDC1, "DCDC1", 850000, 167500),
+	TPS65218_INFO(DCDC2, "DCDC2", 850000, 1675000),
+	TPS65218_INFO(DCDC3, "DCDC3", 900000, 3400000),
+	TPS65218_INFO(DCDC4, "DCDC4", 1175000, 3400000),
+	TPS65218_INFO(DCDC5, "DCDC5", 1000000, 1000000),
+	TPS65218_INFO(DCDC6, "DCDC6", 1800000, 1800000),
+	TPS65218_INFO(LDO1, "LDO1", 900000, 3400000),
 };
 
 #define TPS65218_OF_MATCH(comp, label) \
-- 
2.0.0.390.gcb682f8

