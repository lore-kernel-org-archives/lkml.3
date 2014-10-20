Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaJTS5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:57:08 -0400
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:23584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532AbaJTS5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:57:04 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 5/7] usb: dwc2: Add call_gadget functions for perpheral mode interrupts
Date: Mon, 20 Oct 2014 13:52:04 -0500
Message-ID: <1413831126-24193-6-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA014.apcprd03.prod.outlook.com (10.141.119.24) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(575784001)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(76176999)(85306004)(101416001)(85852003)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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

