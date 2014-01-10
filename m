Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbaAJHGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:06:39 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34866 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAJHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:23 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 06/16] net: stmmac: Honor DT parameter to force DMA store and forward mode
Date: Fri, 10 Jan 2014 15:00:07 +0800
Message-Id: <1389337217-29032-7-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
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
index 86ee903..92627e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -52,6 +52,8 @@ static int stmmac_probe_config_dt(struct platform_device *pdev,
 					   sizeof(struct stmmac_mdio_bus_data),
 					   GFP_KERNEL);
 
+	plat->force_sf_dma_mode = of_property_read_bool(np, "snps,force_sf_dma_mode");
+
 	/*
 	 * Currently only the properties needed on SPEAr600
 	 * are provided. All other properties should be added
-- 
1.8.5.2

