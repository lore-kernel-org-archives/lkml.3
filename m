Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbaHZJsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:48:12 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:21814
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932560AbaHZJsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:48:10 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Vince Bridgers <vbridger@altera.com>
Subject: [PATCH (net-next) v2] net: stmmac: fix warning from Sparse for socfpga
Date: Tue, 26 Aug 2014 17:47:59 +0800
Message-ID: <1409046479-18546-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(19580405001)(87936001)(95666004)(46102001)(62966002)(88136002)(83322001)(50466002)(77156001)(77982001)(106466001)(85306004)(64706001)(48376002)(80022001)(6806004)(229853001)(44976005)(89996001)(19580395003)(20776003)(74502001)(33646002)(68736004)(50226001)(85852003)(42186005)(47776003)(92726001)(84676001)(107046002)(21056001)(36756003)(81542001)(79102001)(105596002)(87286001)(86362001)(83072002)(90102001)(104166001)(81342001)(77096002)(4396001)(92566001)(99396002)(76482001)(31966008)(97736001)(74662001)(102836001)(50986999)(93916002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB033;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index cd613d7..ff54a1f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -119,7 +119,7 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 			return -EINVAL;
 		}
 
-		dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
+		dwmac->splitter_base = devm_ioremap_resource(dev,
 			&res_splitter);
 		if (!dwmac->splitter_base) {
 			dev_info(dev, "Failed to mapping emac splitter\n");
-- 
1.8.2.1

