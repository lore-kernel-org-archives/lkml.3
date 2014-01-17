Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaAQN0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:26:38 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34752 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaAQNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:25:01 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: netdev@vger.kernel.org
Cc: Chen-Yu Tsai <wens@csie.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 5/8] net: stmmac: Honor DT parameter to force DMA store and forward mode
Date: Fri, 17 Jan 2014 21:24:44 +0800
Message-Id: <1389965087-21971-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389965087-21971-1-git-send-email-wens@csie.org>
References: <1389965087-21971-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"snps,force_sf_dma_mode" is documented in stmmac device tree bindings,
but is never handled by the driver.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 704a5e0..634260e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -56,6 +56,8 @@ static int stmmac_probe_config_dt(struct platform_device *pdev,
 					   sizeof(struct stmmac_mdio_bus_data),
 					   GFP_KERNEL);
 
+	plat->force_sf_dma_mode = of_property_read_bool(np, "snps,force_sf_dma_mode");
+
 	/*
 	 * Currently only the properties needed on SPEAr600
 	 * are provided. All other properties should be added
-- 
1.8.5.2

