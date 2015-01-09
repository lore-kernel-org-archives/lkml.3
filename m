Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbbAIQKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:10:44 -0500
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:15456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752200AbbAIQKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:10:43 -0500
X-Greylist: delayed 1136 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2015 11:10:43 EST
From: <dinguyen@opensource.altera.com>
To: <dwmw2@infradead.org>
CC: <dinh.linux@gmail.com>, <computersforpeace@gmail.com>,
        <yamada.m@jp.panasonic.com>, <josh@joshtriplett.org>,
        <shijie8@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Graham Moore <grmoore@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] mtd: denali: fix incorrect bitmask error in denali_setup_dma
Date: Fri, 9 Jan 2015 09:32:35 -0600
Message-ID: <1420817555-22828-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0040.namprd00.prod.outlook.com (25.160.102.50) To
 BN3PR0301MB1185.namprd03.prod.outlook.com (25.160.156.147)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=dinguyen@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1185;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1185;
X-Forefront-PRVS: 04519BA941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(229853001)(86152002)(21056001)(92566001)(81156004)(106356001)(50986999)(87976001)(99396003)(107046002)(120916001)(2351001)(47776003)(68736005)(122386002)(20776003)(46102003)(105586002)(4396001)(53416004)(50226001)(19580405001)(19580395003)(62966003)(77156002)(40100003)(33646002)(110136001)(31966008)(69596002)(101416001)(66066001)(86362001)(42186005)(50466002)(89996001)(48376002)(97736003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1185;H:linux-builds1.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1185;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 15:37:00.7874 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graham Moore <grmoore@opensource.altera.com>

commit "3157d1ed2309 mtd: denali: remove unnecessary casts" introduced
an error by using a wrong bitmask.

A uint16_t cast was replaced with & 0xff, should be & 0xffff.

Signed-off-by: Graham Moore <grmoore@opensource.altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/mtd/nand/denali.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index b3b7ca1..5e397fb 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1041,7 +1041,7 @@ static void denali_setup_dma(struct denali_nand_info *denali, int op)
 	index_addr(denali, mode | ((addr >> 16) << 8), 0x2200);
 
 	/* 3. set memory low address bits 23:8 */
-	index_addr(denali, mode | ((addr & 0xff) << 8), 0x2300);
+	index_addr(denali, mode | ((addr & 0xffff) << 8), 0x2300);
 
 	/* 4. interrupt when complete, burst len = 64 bytes */
 	index_addr(denali, mode | 0x14000, 0x2400);
-- 
1.7.9.5

