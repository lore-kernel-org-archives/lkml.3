Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaG1P1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:27:37 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:17407
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752696AbaG1P1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:27:32 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>,
        <arnd@arndb.de>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <artem.bityutskiy@linux.intel.com>, <pekon@ti.com>,
        <jussi.kivilinna@iki.fi>, <acourbot@nvidia.com>,
        <ivan.khoronzhuk@ti.com>, <joern@logfs.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        <anirudh@xilinx.com>, <svemula@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH RFC v4 1/2] Devicetree: Add pl353 smc controller devicetree binding information
Date: Mon, 28 Jul 2014 20:57:15 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1406561236-29207-1-git-send-email-punnaia@xilinx.com>
References: <1406561236-29207-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <f9cb28fc-6a68-42b8-bdc0-9ad0941de977@BN1AFFO11FD013.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(74316001)(50466002)(6806004)(83322001)(48376002)(77096002)(4396001)(85306003)(107046002)(81342001)(50226001)(106466001)(19580405001)(62966002)(19580395003)(74662001)(53416004)(77156001)(74502001)(44976005)(70736001)(46102001)(104016003)(95666004)(92566001)(102836001)(92726001)(33646002)(86362001)(2201001)(99396002)(79102001)(93916002)(50986999)(64706001)(87286001)(88136002)(31696002)(87936001)(77982001)(47776003)(20776003)(83072002)(81542001)(21056001)(76176999)(31966008)(76482001)(229853001)(80022001)(89996001)(104166001)(1496007)(85852003)(921003)(1121002)(107986001)(83996005)(217873001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB038;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pl353 static memory controller devicetree binding information.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v4:
 - none
Changes in v3:
 - none
Changes in v2:
 - modified timing binding info as per onfi timing parameters
 - add suffix nano second as timing unit
 - modified the clock names as per the IP spec
---
 .../bindings/memory-controllers/pl353-smc.txt      |   53 ++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt b/Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
new file mode 100644
index 0000000..c1f011d
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
@@ -0,0 +1,53 @@
+Device tree bindings for ARM PL353 static memory controller
+
+PL353 static memory controller supports two kinds of memory
+interfaces.i.e NAND and SRAM/NOR interfaces.
+The actual devices are instantiated from the child nodes of pl353 smc node.
+
+Required properties:
+- compatible		: Should be "arm,pl353-smc-r2p1"
+- reg			: Controller registers map and length.
+- clock-names		: List of input clock names - "memclk", "aclk"
+			  (See clock bindings for details).
+- clocks		: Clock phandles (see clock bindings for details).
+- address-cells	: Address cells, must be 1.
+- size-cells		: Size cells. Must be 1.
+
+Child nodes:
+ For NAND the "arm,pl353-nand-r2p1" and for NOR the "cfi-flash" drivers are
+supported as child nodes.
+
+Mandatory timing properties for child nodes:
+- nand-tRC-ns	: Read cycle time.
+- nand-tWC-ns	: Write cycle time.
+- nand-tREA-ns	: re_n assertion delay.
+- nand-tWP-ns	: we_n de-assertion delay.
+- nand-tCLR-ns	: Status read time
+- nand-tAR-ns	: ID read time
+- nand-tRR-ns	: busy to re_n
+
+for nand partition information please refer the below file
+Documentation/devicetree/bindings/mtd/partition.txt
+
+Example:
+	pl353smcc_0: pl353smcc@e000e000 {
+			compatible = "arm,pl353-smcc-r2p1"
+			clock-names = "memclk", "aclk";
+			clocks = <&clkc 11>, <&clkc 44>;
+			reg = <0xe000e000 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			nand_0: nand@e1000000 {
+				compatible = "arm,pl353-nand-r2p1"
+				reg = <0xe1000000 0x1000000>;
+				nand-tRC-ns = <40>;
+				nand-tWC-ns = <40>;
+				nand-tREA-ns = <10>;
+				nand-tWP-ns = <20>;
+				nand-tCLR-ns = <20>;
+				nand-tAR-ns = <20>;
+				nand-tRR-ns = <40>;
+				(...)
+			};
+	};
-- 
1.7.4


