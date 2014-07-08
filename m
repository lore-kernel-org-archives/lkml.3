Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaGHTJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:09:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47624 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbaGHTJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:09:46 -0400
From: Felipe Balbi <balbi@ti.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Keerthy <j-keerthy@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/3] regulators: tps65218: fix DCDC4 linear voltage range
Date: Tue, 8 Jul 2014 14:09:12 -0500
Message-ID: <1404846554-4095-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second range of this particular regulator,
starts at 1.60V, not as 1.55V as it was originally
implied by code.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

based on datasheet only. Also boot tested on another,
yet-to-be-released HW. A 50mV difference is probably
not a big deal for any users of DCDC4 but it's still
good to be correct.

 drivers/regulator/tps65218-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 9effe48..8b7a0a9 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -68,7 +68,7 @@ static const struct regulator_linear_range ldo1_dcdc3_ranges[] = {
 
 static const struct regulator_linear_range dcdc4_ranges[] = {
 	REGULATOR_LINEAR_RANGE(1175000, 0x0, 0xf, 25000),
-	REGULATOR_LINEAR_RANGE(1550000, 0x10, 0x34, 50000),
+	REGULATOR_LINEAR_RANGE(1600000, 0x10, 0x34, 50000),
 };
 
 static struct tps_info tps65218_pmic_regs[] = {
-- 
2.0.0.390.gcb682f8

