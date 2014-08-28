Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbaH1E77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 00:59:59 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:40475
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751297AbaH1E76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 00:59:58 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Vince Bridgers <vbridger@altera.com>
Subject: [PATCH (net-next) v3] net: stmmac: fix warning from Sparse for socfpga
Date: Thu, 28 Aug 2014 12:59:46 +0800
Message-ID: <1409201986-3514-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(76482001)(92566001)(104166001)(92726001)(95666004)(62966002)(74502001)(77982001)(74662001)(31966008)(50466002)(42186005)(90102001)(68736004)(88136002)(77096002)(89996001)(19580395003)(19580405001)(93916002)(50226001)(6806004)(4396001)(44976005)(83072002)(87936001)(106466001)(48376002)(102836001)(86362001)(79102001)(83322001)(77156001)(87286001)(105596002)(85852003)(33646002)(21056001)(84676001)(36756003)(229853001)(64706001)(97736001)(50986999)(85306004)(107046002)(81342001)(47776003)(99396002)(20776003)(46102001)(80022001)(81542001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB039;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index cd613d7..ddc6115 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -119,8 +119,7 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 			return -EINVAL;
 		}
 
-		dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
-			&res_splitter);
+		dwmac->splitter_base = devm_ioremap_resource(dev, &res_splitter);
 		if (!dwmac->splitter_base) {
 			dev_info(dev, "Failed to mapping emac splitter\n");
 			return -EINVAL;
-- 
1.8.2.1

