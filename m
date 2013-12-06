Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161858Ab3LFNEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:04:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab3LFND6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nishanth Menon <nm@ti.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 198/272] regulator: ti-abb: Fix operator precedence typo
Date: Fri,  6 Dec 2013 12:58:07 +0000
Message-Id: <1386334761-25517-199-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 9a633a2bced158c57b73cf4d8e87be60473de1d2 upstream.

commit 40b1936e (regulator: Introduce TI Adaptive Body Bias(ABB) on-chip
LDO driver) missed a pair of brackets which cause the wrong vset data to be
picked up from efuse, resulting in bad VBB voltage values.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/regulator/ti-abb-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index bec4ff9..c4a2ca4 100644
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
1.8.3.2

