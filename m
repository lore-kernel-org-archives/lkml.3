Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaBJTsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:48:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbaBJTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Brian Norris <computersforpeace@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 022/124] mtd: mxc_nand: remove duplicated ecc_stats counting
Date: Mon, 10 Feb 2014 11:39:22 -0800
Message-Id: <1392061264-28124-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 0566477762f9e174e97af347ee9c865f908a5647 upstream.

The ecc_stats.corrected count variable will already be incremented in
the above framework-layer just after this callback.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/nand/mxc_nand.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 45204e4..12346b1 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -665,7 +665,6 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
 		ecc_stat >>= 4;
 	} while (--no_subpages);
 
-	mtd->ecc_stats.corrected += ret;
 	pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
 
 	return ret;
-- 
1.8.3.2

