Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaGDJO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:14:28 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:3292
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751198AbaGDJO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:14:26 -0400
From: Liu Ying <Ying.Liu@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@freescale.com>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] bus: imx-weim: populate devices on a simple bus
Date: Fri, 4 Jul 2014 17:00:41 +0800
Message-ID: <1404464441-31755-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(6806004)(31966008)(79102001)(68736004)(4396001)(19580405001)(44976005)(77982001)(77156001)(110136001)(76482001)(2351001)(19580395003)(107046002)(69596002)(80022001)(97736001)(50226001)(46102001)(99396002)(81156004)(50986999)(20776003)(50466002)(106466001)(104166001)(105606002)(26826002)(48376002)(87936001)(102836001)(36756003)(21056001)(74502001)(74662001)(92566001)(83072002)(104016002)(84676001)(64706001)(83322001)(95666004)(62966002)(47776003)(88136002)(85306003)(229853001)(89996001)(92726001)(87286001)(86362001)(85852003)(81542001)(81342001)(93916002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB342;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02622CEF0A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There could be some memory map devices located in
a certain chip select region of the i.MX WEIM.
The devices could be attached to a simple bus(for
example, a AXI bus) whose root node is one child
device tree node of the i.MX WEIM device tree node.
There should be a bridge(very likely, software
transparent) bewteen the i.MX WEIM and the simple bus.
This patch makes the i.MX WEIM driver possible to
populate devices on a simple bus.  In this way, people
may try various IPs(in a FPGA, maybe) outside of i.MX
chips with the i.MX WEIM embedded.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/bus/imx-weim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index f8ee13c..75c9681 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -162,7 +162,9 @@ static int __init weim_parse_dt(struct platform_device *pdev,
 		}
 	}
 
-	ret = of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+	ret = of_platform_populate(pdev->dev.of_node,
+				   of_default_bus_match_table,
+				   NULL, &pdev->dev);
 	if (ret)
 		dev_err(&pdev->dev, "%s fail to create devices.\n",
 			pdev->dev.of_node->full_name);
-- 
1.7.9.5

