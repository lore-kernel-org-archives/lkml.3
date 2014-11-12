Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaKLAPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:15:06 -0500
Received: from [207.46.100.98] ([207.46.100.98]:32256 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752544AbaKLAPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:15:01 -0500
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
Subject: [PATCHv5 3/5] edac: altera: Remove SDRAM module compile
Date: Tue, 11 Nov 2014 18:14:21 -0600
Message-ID: <1415751263-1830-4-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA049.namprd06.prod.outlook.com (10.141.250.167) To
 BLUPR03MB118.namprd03.prod.outlook.com (10.255.212.19)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(87286001)(48376002)(101416001)(104166001)(66066001)(87976001)(46102003)(50466002)(64706001)(19580395003)(33646002)(21056001)(19580405001)(69596002)(86362001)(92566001)(89996001)(86152002)(92726001)(2201001)(95666004)(99396003)(81156004)(42186005)(106356001)(97736003)(120916001)(105586002)(31966008)(4396001)(62966003)(77096003)(77156002)(50226001)(76176999)(50986999)(122386002)(107046002)(47776003)(20776003)(102836001)(40100003)(53416004)(229853001)(921003)(1121002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB118;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB358;
X-OriginatorOrg: opensource.altera.com
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

v4/5: No change.
---
 drivers/edac/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 7072c28..1719975 100644
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

