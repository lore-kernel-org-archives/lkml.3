Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161234Ab3LFSHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:07:34 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:38826 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161126Ab3LFSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:07:31 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 02/10] net: stmmac: Honor DT parameter to force DMA store and forward mode
Date: Sat,  7 Dec 2013 01:29:35 +0800
Message-Id: <1386350983-13281-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386350983-13281-1-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"snps,force_sf_dma_mode" is documented in stmmac device tree bindings,
but is never handled by the driver.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 51c9069..74c7aef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -47,6 +47,7 @@ static int stmmac_probe_config_dt(struct platform_device *pdev,
 		plat->bus_id = 0;
 
 	of_property_read_u32(np, "snps,phy-addr", &plat->phy_addr);
+	plat->force_sf_dma_mode = of_property_read_bool(np, "snps,force_sf_dma_mode");
 
 	plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
 					   sizeof(struct stmmac_mdio_bus_data),
-- 
1.8.5.1

