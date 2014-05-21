Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaEUHOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:14:44 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:49047
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751005AbaEUHOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:14:42 -0400
From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: [PATCH v8 1/2] can: Add xilinx CAN device tree bindings documentation.
Date: Wed, 21 May 2014 12:29:16 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <59325214-bd7e-4b98-bc0f-c38a9104203b@BL2FFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(199002)(189002)(87936001)(88136002)(21056001)(93916002)(74662001)(87286001)(47776003)(92566001)(20776003)(64706001)(76482001)(33646001)(77156001)(74502001)(86362001)(31696002)(62966002)(31966008)(83072002)(50466002)(89996001)(53416003)(19580395003)(102836001)(80022001)(99396002)(4396001)(70736001)(81342001)(46102001)(85852003)(50986999)(48376002)(81542001)(92726001)(77982001)(50226001)(2201001)(74316001)(44976005)(19580405001)(83322001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB066;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add xilinx CAN bindings documentation.

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
---
Changes for v8:
- None.
Changes for v7:
- Split the devicetree bindings doc as a seperate patch
---
 .../devicetree/bindings/net/can/xilinx_can.txt     |   44 ++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
new file mode 100644
index 0000000..fe38847
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
@@ -0,0 +1,44 @@
+Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
+---------------------------------------------------------
+
+Required properties:
+- compatible		: Should be "xlnx,zynq-can-1.0" for Zynq CAN
+			  controllers and "xlnx,axi-can-1.00.a" for Axi CAN
+			  controllers.
+- reg			: Physical base address and size of the Axi CAN/Zynq
+			  CANPS registers map.
+- interrupts		: Property with a value describing the interrupt
+			  number.
+- interrupt-parent	: Must be core interrupt controller
+- clock-names		: List of input clock names - "can_clk", "pclk"
+			  (For CANPS), "can_clk" , "s_axi_aclk"(For AXI CAN)
+			  (See clock bindings for details).
+- clocks		: Clock phandles (see clock bindings for details).
+- tx-fifo-depth		: Can Tx fifo depth.
+- rx-fifo-depth		: Can Rx fifo depth.
+
+
+Example:
+
+For Zynq CANPS Dts file:
+	zynq_can_0: can@e0008000 {
+			compatible = "xlnx,zynq-can-1.0";
+			clocks = <&clkc 19>, <&clkc 36>;
+			clock-names = "can_clk", "pclk";
+			reg = <0xe0008000 0x1000>;
+			interrupts = <0 28 4>;
+			interrupt-parent = <&intc>;
+			tx-fifo-depth = <0x40>;
+			rx-fifo-depth = <0x40>;
+		};
+For Axi CAN Dts file:
+	axi_can_0: axi-can@40000000 {
+			compatible = "xlnx,axi-can-1.00.a";
+			clocks = <&clkc 0>, <&clkc 1>;
+			clock-names = "can_clk","s_axi_aclk" ;
+			reg = <0x40000000 0x10000>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 59 1>;
+			tx-fifo-depth = <0x40>;
+			rx-fifo-depth = <0x40>;
+		};
-- 
1.7.4


