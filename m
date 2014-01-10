Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaAJHGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:06:21 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34865 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAJHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:23 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Frysinger <vapier@gentoo.org>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 05/16] blackfin: Update stmmac callback signatures
Date: Fri, 10 Jan 2014 15:00:06 +0800
Message-Id: <1389337217-29032-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stmmac callbacks have been extended for better seperation.
Update them to avoid breakage.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/blackfin/mach-bf609/boards/ezkit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/blackfin/mach-bf609/boards/ezkit.c b/arch/blackfin/mach-bf609/boards/ezkit.c
index 82beedd..05194e9 100644
--- a/arch/blackfin/mach-bf609/boards/ezkit.c
+++ b/arch/blackfin/mach-bf609/boards/ezkit.c
@@ -117,7 +117,7 @@ static struct stmmac_dma_cfg eth_dma_cfg = {
 	.pbl	= 2,
 };
 
-int stmmac_ptp_clk_init(struct platform_device *pdev)
+int stmmac_ptp_clk_init(struct platform_device *pdev, void *priv)
 {
 	bfin_write32(PADS0_EMAC_PTP_CLKSEL, 0);
 	return 0;
-- 
1.8.5.2

