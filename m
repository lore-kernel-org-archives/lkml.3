Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbaHZHLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:11:30 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:27975
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752889AbaHZHL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:11:29 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Vince Bridgers <vbridger@altera.com>
Subject: [PATCH] net: stmmac: fix warning from Sparse for socfpga
Date: Tue, 26 Aug 2014 15:11:16 +0800
Message-ID: <1409037076-14775-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(77982001)(87936001)(86362001)(36756003)(77096002)(95666004)(74502001)(76482001)(31966008)(62966002)(74662001)(50466002)(88136002)(50986999)(79102001)(229853001)(85852003)(93916002)(107046002)(81542001)(48376002)(83072002)(92566001)(92726001)(97736001)(89996001)(50226001)(21056001)(44976005)(80022001)(4396001)(81342001)(104166001)(84676001)(77156001)(68736004)(83322001)(19580405001)(6806004)(19580395003)(33646002)(20776003)(105596002)(99396002)(47776003)(87286001)(106466001)(42186005)(90102001)(46102001)(102836001)(64706001)(85306004);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB036;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning:
drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c:122:41:
sparse: cast removes address space of expression
drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c:122:38:
sparse: incorrect type in assignment (different address spaces)

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index cd613d7..c1addce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -119,7 +119,8 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 			return -EINVAL;
 		}
 
-		dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
+		dwmac->splitter_base =
+			(void __iomem *)devm_ioremap_resource(dev,
 			&res_splitter);
 		if (!dwmac->splitter_base) {
 			dev_info(dev, "Failed to mapping emac splitter\n");
-- 
1.8.2.1

