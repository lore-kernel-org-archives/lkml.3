Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbbAID3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:29:08 -0500
Received: from mail-bn1on0096.outbound.protection.outlook.com ([157.56.110.96]:21344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753031AbbAID3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:29:05 -0500
X-Greylist: delayed 2068 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 22:29:04 EST
From: <tthayer@opensource.altera.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv6 3/5] edac: altera: Remove SDRAM module compile
Date: Thu, 8 Jan 2015 20:53:54 -0600
Message-ID: <1420772036-3112-4-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420772036-3112-1-git-send-email-tthayer@opensource.altera.com>
References: <1420772036-3112-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0058.namprd05.prod.outlook.com (10.141.20.28) To
 BY2PR0301MB0629.namprd03.prod.outlook.com (25.160.125.27)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tthayer@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04519BA941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(86362001)(48376002)(40100003)(106356001)(50466002)(50986999)(76176999)(101416001)(2950100001)(97736003)(42186005)(50226001)(4396001)(19580395003)(120916001)(19580405001)(105586002)(122386002)(99396003)(33646002)(229853001)(68736005)(31966008)(107046002)(20776003)(64706001)(66066001)(46102003)(77156002)(2201001)(92566001)(89996001)(21056001)(86152002)(62966003)(47776003)(87976001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR0301MB0629;H:localhost.localdomain;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 02:54:59.3950 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

The SDRAM EDAC requires SDRAM configuration/initialization before
SDRAM is accessed (in the preloader). Having a module compile is
not desired so force to be built into kernel.

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
---
v3: Added in this version as a separate patch.

v4-6: No change.
---
 drivers/edac/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 49c2652..4d7285e 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -377,8 +377,8 @@ config EDAC_OCTEON_PCI
 	  Cavium Octeon family of SOCs.
 
 config EDAC_ALTERA_MC
-	tristate "Altera SDRAM Memory Controller EDAC"
-	depends on EDAC_MM_EDAC && ARCH_SOCFPGA
+	bool "Altera SDRAM Memory Controller EDAC"
+	depends on EDAC_MM_EDAC=y && ARCH_SOCFPGA
 	help
 	  Support for error detection and correction on the
 	  Altera SDRAM memory controller. Note that the
-- 
1.7.9.5

