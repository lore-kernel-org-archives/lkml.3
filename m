Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaJ1MCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:02:43 -0400
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:44032
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754945AbaJ1Lzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:55:55 -0400
X-WSS-ID: 0NE5L50-07-BFN-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH v3 01/19] usb: dwc3: enable hibernation if to be supported
Date: Tue, 28 Oct 2014 19:54:22 +0800
Message-ID: <1414497280-3126-2-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(107046002)(92726001)(19580405001)(77096002)(44976005)(68736004)(4396001)(106466001)(76482002)(92566001)(93916002)(19580395003)(86362001)(50226001)(95666004)(105586002)(229853001)(87286001)(2171001)(84676001)(87936001)(33646002)(88136002)(120916001)(64706001)(89996001)(20776003)(85306004)(104166001)(85852003)(102836001)(31966008)(47776003)(97736003)(53416004)(101416001)(21056001)(48376002)(76176999)(80022003)(46102003)(50986999)(50466002)(62966002)(36756003)(77156001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It enables hibernation if the function is set in coreConsultant.

Suggested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index fa396fc..bf77509 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -449,6 +449,7 @@ static int dwc3_core_init(struct dwc3 *dwc)
 	case DWC3_GHWPARAMS1_EN_PWROPT_HIB:
 		/* enable hibernation here */
 		dwc->nr_scratch = DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(hwparams4);
+		reg |= DWC3_GCTL_GBLHIBERNATIONEN;
 		break;
 	default:
 		dev_dbg(dwc->dev, "No power optimization available\n");
-- 
1.9.1

