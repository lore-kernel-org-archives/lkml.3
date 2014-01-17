Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaAQNZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:25:01 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34733 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaAQNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:24:59 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: netdev@vger.kernel.org
Cc: Chen-Yu Tsai <wens@csie.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 4/8] blackfin: Update stmmac callback signatures
Date: Fri, 17 Jan 2014 21:24:43 +0800
Message-Id: <1389965087-21971-5-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389965087-21971-1-git-send-email-wens@csie.org>
References: <1389965087-21971-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stmmac callbacks have been extended for better separation.
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

