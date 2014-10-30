Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161183AbaJ3PcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:32:20 -0400
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:29344
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932947AbaJ3PcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:32:16 -0400
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
Subject: [PATCHv3 3/5] edac: altera: Remove SDRAM module compile
Date: Thu, 30 Oct 2014 10:32:09 -0500
Message-ID: <1414683131-20786-4-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
References: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR0201CA0002.namprd02.prod.outlook.com (25.160.191.140)
 To BY2PR03MB127.namprd03.prod.outlook.com (10.242.36.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(101416001)(87286001)(88136002)(50226001)(81156004)(50466002)(106356001)(85306004)(40100003)(33646002)(87976001)(95666004)(21056001)(122386002)(77156001)(76482002)(48376002)(4396001)(86362001)(31966008)(120916001)(93916002)(229853001)(107046002)(102836001)(53416004)(86152002)(47776003)(2201001)(92566001)(97736003)(50986999)(19580395003)(62966002)(19580405001)(76176999)(64706001)(89996001)(85852003)(105586002)(69596002)(104166001)(92726001)(66066001)(77096002)(42186005)(46102003)(20776003)(80022003)(1121002)(921003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB127;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
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

