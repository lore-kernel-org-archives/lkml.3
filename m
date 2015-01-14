Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbbANP5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:57:38 -0500
Received: from mail-by2on0055.outbound.protection.outlook.com ([207.46.100.55]:43819
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751801AbbANP5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:57:37 -0500
From: <dinguyen@opensource.altera.com>
To: <computersforpeace@gmail.com>
CC: <dinh.linux@gmail.com>, <dwmw2@infradead.org>, <yamada.m@jp.panasonic.com>,
        <josh@joshtriplett.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Graham Moore <grmoore@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] mtd: denali: Disable sub-page writes in Denali NAND driver
Date: Wed, 14 Jan 2015 09:38:50 -0600
Message-ID: <1421249930-21229-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR10CA0056.namprd10.prod.outlook.com (10.141.241.24) To
 BN3PR0301MB1188.namprd03.prod.outlook.com (25.160.156.15)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=dinguyen@opensource.altera.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1188;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1188;
X-Forefront-PRVS: 04569283F9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(62966003)(50226001)(66066001)(64706001)(47776003)(122386002)(40100003)(97736003)(46102003)(77156002)(50986999)(19580395003)(86362001)(19580405001)(33646002)(92566002)(86152002)(87976001)(110136001)(229853001)(48376002)(42186005)(2351001)(68736005)(69596002)(81156004)(53416004)(105586002)(50466002)(106356001)(101416001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1188;H:linux-builds1.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1188;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2015 15:43:14.7439 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graham Moore <grmoore@opensource.altera.com>

The Denali Controller IP does not support sub-page writes.

Signed-off-by: Graham Moore <grmoore@opensource.altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/mtd/nand/denali.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index b3b7ca1..b16b040 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1565,6 +1565,9 @@ int denali_init(struct denali_nand_info *denali)
 	denali->nand.options |= NAND_SKIP_BBTSCAN;
 	denali->nand.ecc.mode = NAND_ECC_HW_SYNDROME;
 
+	/* no subpage writes on denali */
+	denali->nand.options |= NAND_NO_SUBPAGE_WRITE;
+
 	/*
 	 * Denali Controller only support 15bit and 8bit ECC in MRST,
 	 * so just let controller do 15bit ECC for MLC and 8bit ECC for
-- 
2.2.1

