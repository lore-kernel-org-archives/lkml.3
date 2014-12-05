Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaLETyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:54:04 -0500
Received: from mail-by2on0080.outbound.protection.outlook.com ([207.46.100.80]:63136
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751949AbaLETyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:54:01 -0500
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 14:54:00 EST
From: Graham Moore <grmoore@opensource.altera.com>
To: <linux-mtd@lists.infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Alan Tull <atull@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Graham Moore <grmoore@opensource.altera.com>
Subject: [PATCH 1/2] mtd: spi-nor: Bindings for Cadence Quad SPI Flash Controller driver.
Date: Fri, 5 Dec 2014 13:35:32 -0600
Message-ID: <1417808133-20719-2-git-send-email-grmoore@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417808133-20719-1-git-send-email-grmoore@opensource.altera.com>
References: <1417808133-20719-1-git-send-email-grmoore@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR12CA0038.namprd12.prod.outlook.com (25.160.121.48) To
 BLUPR03MB437.namprd03.prod.outlook.com (10.141.78.147)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB437;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002)(6)(7);SRVR:BLUPR03MB437;
X-Forefront-PRVS: 04163EF38A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(105586002)(106356001)(110136001)(81156004)(107046002)(229853001)(77156002)(21056001)(4396001)(50466002)(48376002)(50226001)(2351001)(40100003)(97736003)(122386002)(46102003)(69596002)(68736005)(77096005)(31966008)(101416001)(19580395003)(19580405001)(551934003)(33646002)(64706001)(20776003)(47776003)(99396003)(66066001)(62966003)(120916001)(76176999)(42186005)(86362001)(87976001)(53416004)(89996001)(50986999)(92566001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB437;H:lava-test-server.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB437;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB165;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Graham Moore <grmoore@opensource.altera.com>
---
 .../devicetree/bindings/mtd/cadence_quadspi.txt    |   50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/cadence_quadspi.txt

diff --git a/Documentation/devicetree/bindings/mtd/cadence_quadspi.txt b/Documentation/devicetree/bindings/mtd/cadence_quadspi.txt
new file mode 100644
index 0000000..3a8ea1c
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/cadence_quadspi.txt
@@ -0,0 +1,50 @@
+* Cadence Quad SPI controller
+
+Required properties:
+- compatible : Should be "cdns,qspi-nor".
+- reg : Contains two entries, each of which is a tuple consisting of a
+	physical address and length.  The first entry is the address and
+	length of the controller register set.  The second entry is the
+	address and length of the QSPI Controller data area.
+- interrupts : Unit interrupt specifier for the controller interrupt.
+- clocks : phandle to the Quad SPI clock.
+- ext-decoder : Value of 0 means no external chipselect decoder is
+	connected, 1 means there is an external chipselect decoder connected.
+- fifo-depth : Size of the data FIFO in words.
+- bus-num : Number of the SPI bus to which the controller is connected.
+
+Optional subnodes:
+Subnodes of the Cadence Quad SPI controller are spi slave nodes with additional
+custom properties:
+- cdns,page-size : Size, in bytes, of the device's write page
+- cdns,block-size : Size of the device's erase block
+- cdns,read-delay : Selay for read capture logic, in clock cycles
+- cdns,tshsl-ns : Delay in master reference clocks for the length that the master mode chip select outputs are de-asserted between transactions.
+- cdns,tsd2d-ns : Delay in master reference clocks between one chip select being de-activated and the activation of another.
+- cdns,tchsh-ns : Delay in master reference clocks between last bit of current transaction and deasserting the device chip select (qspi_n_ss_out).
+- cdns,tslch-ns : Delay in master reference clocks between setting qspi_n_ss_out low and first bit transfer.
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
+		fifo-depth = <128>;
+
+		flash0: n25q00@0 {
+			...
+			cdns,page-size = <256>;
+			cdns,block-size = <16>;
+			cdns,read-delay = <4>;
+			cdns,tshsl-ns = <50>;
+			cdns,tsd2d-ns = <50>;
+			cdns,tchsh-ns = <4>;
+			cdns,tslch-ns = <4>;
+		}
+	}
-- 
1.7.9.5

