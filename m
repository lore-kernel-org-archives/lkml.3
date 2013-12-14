Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3LNMVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:21:46 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43462 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab3LNMVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:21:44 -0500
Date: Sat, 14 Dec 2013 17:51:35 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH v2 4/9] drivers: net: Mark functions as static in
 stmmac_platform.c
Message-ID: <ba057c47177ebc49d3b4a7042c23841a7aef821f.1386911124.git.rashika.kheria@gmail.com>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function stmmac_pltfr_freeze() and
stmmac_pltfr_restore() in stmmac_platform.c as static because they are
not used outside this file.

Thus, it also removes the following warnings in
ethernet/stmicro/stmmac/stmmac_platform.c:

drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:222:5: warning: no previous prototype for ‘stmmac_pltfr_freeze’ [-Wmissing-prototypes]
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:236:5: warning: no previous prototype for ‘stmmac_pltfr_restore’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 51c9069..38bd1f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -219,7 +219,7 @@ static int stmmac_pltfr_resume(struct device *dev)
 	return stmmac_resume(ndev);
 }
 
-int stmmac_pltfr_freeze(struct device *dev)
+static int stmmac_pltfr_freeze(struct device *dev)
 {
 	int ret;
 	struct plat_stmmacenet_data *plat_dat = dev_get_platdata(dev);
@@ -233,7 +233,7 @@ int stmmac_pltfr_freeze(struct device *dev)
 	return ret;
 }
 
-int stmmac_pltfr_restore(struct device *dev)
+static int stmmac_pltfr_restore(struct device *dev)
 {
 	struct plat_stmmacenet_data *plat_dat = dev_get_platdata(dev);
 	struct net_device *ndev = dev_get_drvdata(dev);
-- 
1.7.9.5

