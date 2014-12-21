Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaLUVWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:22:44 -0500
Received: from sauhun.de ([89.238.76.85]:52895 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbaLUVPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:31 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org
Subject: [PATCH 10/28] net: ethernet: stmicro: stmmac: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:31 +0100
Message-Id: <1419196495-9626-11-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 4032b170fe24..3039de2465ba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -430,7 +430,6 @@ static struct platform_driver stmmac_pltfr_driver = {
 	.remove = stmmac_pltfr_remove,
 	.driver = {
 		   .name = STMMAC_RESOURCE_NAME,
-		   .owner = THIS_MODULE,
 		   .pm = &stmmac_pltfr_pm_ops,
 		   .of_match_table = of_match_ptr(stmmac_dt_ids),
 	},
-- 
2.1.3

