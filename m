Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaJXTLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:11:05 -0400
Received: from mail-bn1bon0098.outbound.protection.outlook.com ([157.56.111.98]:24352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751102AbaJXTLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:11:03 -0400
From: Graham Moore <grmoore@opensource.altera.com>
To: <linux-mtd@lists.infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Alan Tull <atull@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        Graham Moore <grmoore@opensource.altera.com>
Subject: [RFC 1/2] This is the documentation of the device tree bindings for the Cadence QSPI Flash Controller driver.
Date: Fri, 24 Oct 2014 13:34:20 -0500
Message-ID: <1414175661-9249-2-git-send-email-grmoore@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414175661-9249-1-git-send-email-grmoore@opensource.altera.com>
References: <1414175661-9249-1-git-send-email-grmoore@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR04CA0031.eurprd04.prod.outlook.com (10.242.87.149) To
 BL2PR03MB435.namprd03.prod.outlook.com (10.141.92.24)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB435;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(104166001)(86362001)(93916002)(50466002)(92566001)(66066001)(92726001)(21056001)(102836001)(48376002)(76176999)(50986999)(101416001)(64706001)(20776003)(47776003)(69596002)(19580395003)(19580405001)(50226001)(62966002)(4396001)(85852003)(89996001)(31966008)(87976001)(88136002)(87286001)(76482002)(33646002)(53416004)(2351001)(107046002)(105586002)(95666004)(110136001)(99396003)(77096002)(106356001)(97736003)(85306004)(81156004)(40100003)(42186005)(80022003)(229853001)(46102003)(122386002)(120916001)(77156001)(49413001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB435;H:lava-test-server.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Graham Moore <grmoore@opensource.altera.com>
---
 .../devicetree/bindings/mtd/cadence_quadspi.txt    |   30 ++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/cadence_quadspi.txt

diff --git a/Documentation/devicetree/bindings/mtd/cadence_quadspi.txt b/Documentation/devicetree/bindings/mtd/cadence_quadspi.txt
new file mode 100644
index 0000000..0064fc3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/cadence_quadspi.txt
@@ -0,0 +1,30 @@
+* Cadence Quad SPI controller
+
+Required properties:
+- compatible : Should be "cdns,qspi-nor".
+- reg : Contains two entries, each of which is a tuple consisting of a
+	physical address and length.  The first entry is the address and
+	length of the controller register set.  The second entry is the
+	address and length of the QSPI Controller data area.
+- interrupts : Unit interrupt specifier for the controller interrupt.
+- ext-decoder : Value of 0 means no external chipselect decoder is
+	connected, 1 means there is an external chipselect decoder connected.
+- num-chipselect : Number of chip select lines.
+- fifo-depth : Size of the data FIFO in words.
+- bus-num : Number of the SPI bus to which the controller is connected.
+
+Example:
+
+	qspi: spi@ff705000 {
+		compatible = "cdns,qspi-nor";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0xff705000 0x1000>,
+			<0xffa00000 0x1000>;
+		interrupts = <0 151 4>;
+		clocks = <&qspi_clk>;
+		ext-decoder = <0>;
+		num-chipselect = <4>;
+		fifo-depth = <128>;
+		bus-num = <2>;
+	}
-- 
1.7.9.5

