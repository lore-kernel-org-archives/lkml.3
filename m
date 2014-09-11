Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaIKJ5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:57:37 -0400
Received: from mail-by2on0079.outbound.protection.outlook.com ([207.46.100.79]:36425
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753923AbaIKJ5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:57:35 -0400
X-Greylist: delayed 2029 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 05:57:34 EDT
From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
To: <davem@davemloft.net>, <jeffrey.t.kirsher@intel.com>,
        <jesse.brandeburg@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <michals@xilinx.com>, <svemula@xilinx.com>, <anirudh@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: [PATCH] net: axienet: remove unnecessary ether_setup after alloc_etherdev
Date: Thu, 11 Sep 2014 14:53:33 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20940.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <78ce1faf-0bf8-41bb-a30d-cecd11d82d94@BY2FFO11FD033.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(81342001)(50466002)(77096002)(19580395003)(19580405001)(90102001)(48376002)(74316001)(70736001)(85306004)(46102001)(83322001)(44976005)(102836001)(53416004)(229853001)(107046002)(1496007)(4396001)(104166001)(95666004)(77156001)(50226001)(106466001)(81542001)(92566001)(74662001)(2201001)(50986999)(92726001)(104016003)(74502001)(31696002)(86362001)(85852003)(99396002)(76482001)(21056001)(77982001)(79102001)(20776003)(93916002)(64706001)(47776003)(6806004)(80022001)(62966002)(31966008)(87286001)(89996001)(87936001)(88136002)(83072002)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB028;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=subbaraya.sundeep.bhatta@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calling ether_setup is redundant since alloc_etherdev calls
it.

Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c8fd941..4ea2d4e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1485,7 +1485,6 @@ static int axienet_of_probe(struct platform_device *op)
 	if (!ndev)
 		return -ENOMEM;
 
-	ether_setup(ndev);
 	platform_set_drvdata(op, ndev);
 
 	SET_NETDEV_DEV(ndev, &op->dev);
-- 
1.7.4

