Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966AbaJOFfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:35:53 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:41169 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaJOFfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:35:52 -0400
From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
To: <netdev@vger.kernel.org>
Cc: <davem@davemloft.net>, <sfr@canb.auug.org.au>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH (net.git) 1/1] stmmac: fix sti compatibililies
Date: Wed, 15 Oct 2014 07:30:41 +0200
Message-ID: <1413351041-11369-1-git-send-email-peppe.cavallaro@st.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [164.130.129.175]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-15_02:2014-10-14,2014-10-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is to fix the stmmac data compatibilities for
all the SoCs inside the platform file.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    3 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 4452889..c3c4065 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -144,7 +144,8 @@ extern const struct stmmac_of_data meson6_dwmac_data;
 extern const struct stmmac_of_data sun7i_gmac_data;
 #endif
 #ifdef CONFIG_DWMAC_STI
-extern const struct stmmac_of_data sti_gmac_data;
+extern const struct stmmac_of_data stih4xx_dwmac_data;
+extern const struct stmmac_of_data stid127_dwmac_data;
 #endif
 #ifdef CONFIG_DWMAC_SOCFPGA
 extern const struct stmmac_of_data socfpga_gmac_data;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 0d6b9ad..db56fa7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -37,10 +37,10 @@ static const struct of_device_id stmmac_dt_ids[] = {
 	{ .compatible = "allwinner,sun7i-a20-gmac", .data = &sun7i_gmac_data},
 #endif
 #ifdef CONFIG_DWMAC_STI
-	{ .compatible = "st,stih415-dwmac", .data = &sti_gmac_data},
-	{ .compatible = "st,stih416-dwmac", .data = &sti_gmac_data},
-	{ .compatible = "st,stid127-dwmac", .data = &sti_gmac_data},
-	{ .compatible = "st,stih407-dwmac", .data = &sti_gmac_data},
+	{ .compatible = "st,stih415-dwmac", .data = &stih4xx_dwmac_data},
+	{ .compatible = "st,stih416-dwmac", .data = &stih4xx_dwmac_data},
+	{ .compatible = "st,stid127-dwmac", .data = &stid127_dwmac_data},
+	{ .compatible = "st,stih407-dwmac", .data = &stih4xx_dwmac_data},
 #endif
 #ifdef CONFIG_DWMAC_SOCFPGA
 	{ .compatible = "altr,socfpga-stmmac", .data = &socfpga_gmac_data },
-- 
1.7.4.4

