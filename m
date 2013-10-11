Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3JKKEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:04:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3JKKEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:04:22 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] regulator: ti-abb: Fix operator precedence typo
Date: Fri, 11 Oct 2013 05:04:12 -0500
Message-ID: <1381485852-18085-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 40b1936e (regulator: Introduce TI Adaptive Body Bias(ABB) on-chip
LDO driver) missed a pair of brackets which cause the wrong vset data to be
picked up from efuse, resulting in bad VBB voltage values.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/ti-abb-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 20c271d..b993ec5 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -615,7 +615,7 @@ static int ti_abb_init_table(struct device *dev, struct ti_abb *abb,
 					pname, *volt_table, vset_mask);
 			continue;
 		}
-		info->vset = efuse_val & vset_mask >> __ffs(vset_mask);
+		info->vset = (efuse_val & vset_mask) >> __ffs(vset_mask);
 		dev_dbg(dev, "[%d]v=%d vset=%x\n", i, *volt_table, info->vset);
 check_abb:
 		switch (info->opp_sel) {
-- 
1.7.9.5

