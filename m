Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaKDRZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:25:16 -0500
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:35364
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbaKDRZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:25:10 -0500
X-WSS-ID: 0NEIZ1H-07-CFE-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <dougthompson@xmission.com>, <bp@alien8.de>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] edac, mce_amd: Add decoding table for MC6 xec
Date: Tue, 4 Nov 2014 11:41:08 -0600
Message-ID: <1415122868-10969-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(31966008)(53416004)(86362001)(107046002)(46102003)(64706001)(50466002)(106466001)(20776003)(95666004)(99396003)(47776003)(62966003)(120916001)(92726001)(4396001)(50226001)(48376002)(19580405001)(19580395003)(68736004)(84676001)(102836001)(93916002)(44976005)(33646002)(104166001)(97736003)(88136002)(89996001)(77156002)(2201001)(50986999)(21056001)(229853001)(92566001)(36756003)(87286001)(77096003)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=temperror (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Extended error code meanings are tabulated for other banks.
Extending that tradition for MC6 in this patch.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/edac/mce_amd.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index f78c1c5..5d4efae 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -138,6 +138,15 @@ static const char * const mc5_mce_desc[] = {
 	"Retire status queue"
 };
 
+static const char * const mc6_mce_desc[] = {
+	"Hardware Assertion",
+	"Free List",
+	"Physical Register File",
+	"Retire Queue",
+	"Scheduler table",
+	"Status Register File",
+};
+
 static bool f12h_mc0_mce(u16 ec, u8 xec)
 {
 	bool ret = false;
@@ -672,38 +681,10 @@ static void decode_mc6_mce(struct mce *m)
 
 	pr_emerg(HW_ERR "MC6 Error: ");
 
-	switch (xec) {
-	case 0x0:
-		pr_cont("Hardware Assertion");
-		break;
-
-	case 0x1:
-		pr_cont("Free List");
-		break;
-
-	case 0x2:
-		pr_cont("Physical Register File");
-		break;
-
-	case 0x3:
-		pr_cont("Retire Queue");
-		break;
-
-	case 0x4:
-		pr_cont("Scheduler table");
-		break;
-
-	case 0x5:
-		pr_cont("Status Register File");
-		break;
-
-	default:
+	if (xec > 0x5)
 		goto wrong_mc6_mce;
-		break;
-	}
-
-	pr_cont(" parity error.\n");
 
+	pr_cont("%s parity error.\n", mc6_mce_desc[xec]);
 	return;
 
  wrong_mc6_mce:
-- 
2.0.1

