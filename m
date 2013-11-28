Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3K1LKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:10:50 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18260 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3K1LKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:10:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Nov 2013 03:04:26 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <ldewangan@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <vinceh@nvidia.com>
Subject: [PATCH] regulator: as3722: set the correct current limit
Date: Thu, 28 Nov 2013 19:10:42 +0800
Message-ID: <1385637042-33201-1-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple fix to set the correct current limit for SD0/1/6.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drivers/regulator/as3722-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 5917fe3dc983..b9f1d24c6812 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -590,8 +590,8 @@ static int as3722_sd016_set_current_limit(struct regulator_dev *rdev,
 	default:
 		return -EINVAL;
 	}
+	ret <<= ffs(mask) - 1;
 	val = ret & mask;
-	val <<= ffs(mask) - 1;
 	return as3722_update_bits(as3722, reg, mask, val);
 }
 
-- 
1.8.1.5

