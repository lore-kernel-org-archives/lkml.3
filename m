Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaJ1Xbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:31:33 -0400
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:21570
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755014AbaJ1X3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:29:52 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv6 5/8] usb: dwc2: Add call_gadget functions for perpheral mode interrupts
Date: Tue, 28 Oct 2014 18:25:46 -0500
Message-ID: <1414538749-14735-6-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR12CA0019.namprd12.prod.outlook.com (25.160.137.29) To
 DM2PR0301MB1198.namprd03.prod.outlook.com (25.160.217.148)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1198;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(122386002)(105586002)(33646002)(95666004)(102836001)(101416001)(53416004)(77156001)(77096002)(50226001)(120916001)(106356001)(229853001)(104166001)(107046002)(80022003)(50986999)(81156004)(69596002)(76176999)(46102003)(92566001)(85852003)(99396003)(4396001)(50466002)(19580405001)(19580395003)(76482002)(62966002)(85306004)(66066001)(97736003)(86362001)(575784001)(89996001)(48376002)(86152002)(87286001)(20776003)(87976001)(21056001)(88136002)(40100003)(93916002)(92726001)(47776003)(42186005)(64706001)(31966008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1198;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Update the dwc2 wakeup and suspend interrupt functions to use call_gadget
when the IP is in peripheral mode.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---
 drivers/usb/dwc2/core_intr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index b0c14e0..1240875 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -339,6 +339,7 @@ static void dwc2_handle_wakeup_detected_intr(struct dwc2_hsotg *hsotg)
 		}
 		/* Change to L0 state */
 		hsotg->lx_state = DWC2_L0;
+		call_gadget(hsotg, resume);
 	} else {
 		if (hsotg->lx_state != DWC2_L1) {
 			u32 pcgcctl = readl(hsotg->regs + PCGCTL);
@@ -399,6 +400,7 @@ static void dwc2_handle_usb_suspend_intr(struct dwc2_hsotg *hsotg)
 			"DSTS.Suspend Status=%d HWCFG4.Power Optimize=%d\n",
 			!!(dsts & DSTS_SUSPSTS),
 			hsotg->hw_params.power_optimized);
+		call_gadget(hsotg, suspend);
 	} else {
 		if (hsotg->op_state == OTG_STATE_A_PERIPHERAL) {
 			dev_dbg(hsotg->dev, "a_peripheral->a_host\n");
-- 
2.0.3

