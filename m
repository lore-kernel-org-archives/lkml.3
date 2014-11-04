Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaKDJq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:46:59 -0500
Received: from mail-bn1bn0102.outbound.protection.outlook.com ([157.56.110.102]:5824
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752477AbaKDJq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:46:56 -0500
X-WSS-ID: 0NEID3O-07-75D-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Tony Li <tony.li@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH] usb: dwc3: remove warning of disable scramble check
Date: Tue, 4 Nov 2014 17:29:51 +0800
Message-ID: <1415093391-4569-1-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(189002)(199003)(120916001)(33646002)(46102003)(107046002)(77096003)(106466001)(77156002)(104166001)(62966003)(95666004)(97736003)(99396003)(21056001)(50466002)(105586002)(229853001)(36756003)(89996001)(92726001)(92566001)(84676001)(87286001)(48376002)(68736004)(86362001)(87936001)(2171001)(88136002)(575784001)(93916002)(31966008)(101416001)(102836001)(44976005)(19580405001)(50986999)(53416004)(50226001)(4396001)(64706001)(47776003)(19580395003)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SoC's FPGA platform will need this quirk, but it will complain if
running at true SoC platform. This is a normal case, so remove this
warning.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---

Hi,

This patch is based on balbi/testing/next branch.

Thanks,
Rui

---
 drivers/usb/dwc3/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 8ae42b8..3f1f0ab 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -531,9 +531,6 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dwc->is_fpga = true;
 	}
 
-	WARN_ONCE(dwc->disable_scramble_quirk && !dwc->is_fpga,
-			"disable_scramble cannot be used on non-FPGA builds\n");
-
 	if (dwc->disable_scramble_quirk && dwc->is_fpga)
 		reg |= DWC3_GCTL_DISSCRAMBLE;
 	else
-- 
1.9.1

