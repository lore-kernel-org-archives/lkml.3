Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbaKUFI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:08:59 -0500
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:50177
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750784AbaKUFI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:08:57 -0500
From: <dinguyen@opensource.altera.com>
To: <linux@arm.linux.org.uk>
CC: <dinh.linux@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH 1/2] arm: socfpga: update l2 cache settings
Date: Thu, 20 Nov 2014 23:04:39 -0600
Message-ID: <1416546280-12068-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0027.namprd02.prod.outlook.com (10.141.56.27) To
 DM2PR0301MB1197.namprd03.prod.outlook.com (25.160.217.147)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1197;
X-Forefront-PRVS: 0402872DA1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(31966008)(87286001)(102836001)(64706001)(50226001)(50986999)(40100003)(21056001)(229853001)(107046002)(2351001)(104166001)(77096003)(105586002)(101416001)(62966003)(4396001)(46102003)(95666004)(48376002)(19580395003)(88136002)(50466002)(87976001)(69596002)(19580405001)(92726001)(92566001)(106356001)(81156004)(93916002)(86362001)(86152002)(99396003)(97736003)(120916001)(53416004)(20776003)(42186005)(89996001)(77156002)(33646002)(122386002)(66066001)(47776003)(110136001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1197;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1197;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Enable D and I prefetch helps improve SDRAM preformance.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 arch/arm/mach-socfpga/socfpga.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index adbf383..13b1858 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -104,7 +104,8 @@ static const char *altera_dt_match[] = {
 };
 
 DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
-	.l2c_aux_val	= 0,
+	.l2c_aux_val	= L310_AUX_CTRL_DATA_PREFETCH |
+			  L310_AUX_CTRL_INSTR_PREFETCH,
 	.l2c_aux_mask	= ~0,
 	.smp		= smp_ops(socfpga_smp_ops),
 	.map_io		= socfpga_map_io,
-- 
2.0.3

