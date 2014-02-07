Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaBGNaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:30:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaBGLYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 29/88] mtd: mxc_nand: remove duplicated ecc_stats counting
Date: Fri,  7 Feb 2014 11:22:26 +0000
Message-Id: <1391772205-22239-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 0566477762f9e174e97af347ee9c865f908a5647 upstream.

The ecc_stats.corrected count variable will already be incremented in
the above framework-layer just after this callback.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/nand/mxc_nand.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 6acc790..f4e275a 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -669,7 +669,6 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
 		ecc_stat >>= 4;
 	} while (--no_subpages);
 
-	mtd->ecc_stats.corrected += ret;
 	pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
 
 	return ret;
-- 
1.8.3.2

