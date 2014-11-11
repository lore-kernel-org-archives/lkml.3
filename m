Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaKKRTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:19:03 -0500
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:49862
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751913AbaKKRSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:18:09 -0500
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv7 6/8] usb: dwc2: gadget: Do not fail probe if there isn't a clock node
Date: Tue, 11 Nov 2014 11:13:38 -0600
Message-ID: <1415726020-19238-7-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR07CA079.namprd07.prod.outlook.com (25.160.24.34) To
 CY1PR0301MB1196.namprd03.prod.outlook.com (25.160.165.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(20776003)(47776003)(66066001)(53416004)(33646002)(40100003)(101416001)(50466002)(48376002)(122386002)(97736003)(42186005)(102836001)(50226001)(4396001)(105586002)(107046002)(19580395003)(19580405001)(95666004)(21056001)(229853001)(106356001)(86152002)(88136002)(92726001)(104166001)(31966008)(62966003)(87976001)(92566001)(77096003)(87286001)(77156002)(99396003)(89996001)(46102003)(69596002)(120916001)(81156004)(93916002)(86362001)(50986999)(76176999);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1196;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Since the dwc2 hcd driver is currently not looking for a clock node during
init, we should not completely fail if there isn't a clock provided.
By assigning clk = NULL, this allows the driver, when configured for dual-role
mode, to be able to continue loading the host portion of the driver when
a clock node is not specified.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
v7: Reworked to use clk=NULL and remove the need to is IS_ERR(clk)
v6: none
v5: reworked to not access gadget functions from the hcd.
---
 drivers/usb/dwc2/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 37c7916..367689b 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3431,6 +3431,7 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 
 	hsotg->clk = devm_clk_get(dev, "otg");
 	if (IS_ERR(hsotg->clk)) {
+		hsotg->clk = NULL;
 		dev_err(dev, "cannot get otg clock\n");
 		return PTR_ERR(hsotg->clk);
 	}
-- 
2.0.3

