Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaF0DDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:03:36 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:16826
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752469AbaF0DDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:03:16 -0400
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
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH RFC v3 1/2] Devicetree: Add pl353 smc controller devicetree binding information
Date: Fri, 27 Jun 2014 08:32:41 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1403838162-18756-1-git-send-email-punnaia@xilinx.com>
References: <1403838162-18756-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <ab701d63-921a-42a2-b1a8-c450b0e172df@BL2FFO11FD041.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(92726001)(106466001)(53416004)(104166001)(86362001)(87936001)(87286001)(74502001)(83322001)(95666004)(104016002)(77982001)(93916002)(102836001)(19580395003)(31696002)(33646001)(77096002)(46102001)(92566001)(2201001)(89996001)(47776003)(50226001)(77156001)(88136002)(70736001)(85852003)(19580405001)(44976005)(76176999)(74662001)(79102001)(85306003)(20776003)(21056001)(62966002)(50986999)(31966008)(81342001)(81542001)(99396002)(1496007)(4396001)(48376002)(83072002)(76482001)(6806004)(74316001)(80022001)(50466002)(107046002)(921003)(1121002)(23106004)(83996005)(2101003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB038;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pl353 static memory controller devicetree binding information.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
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


