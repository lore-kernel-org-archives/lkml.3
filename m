Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaDBNQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:16:30 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:5171
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071AbaDBNQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:16:29 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz1de098h8275bh1de097hz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: [PATCH v7 2/2] can: Add xilinx CAN device tree bindings documentation
Date: Wed, 2 Apr 2014 18:46:01 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <048cb313-b822-43cc-8280-feec6a3af96b@CH1EHSMHS040.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add xilinx CAN bindings documentation.

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
---
 .../devicetree/bindings/net/can/xilinx_can.txt     |   44 ++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
new file mode 100644
index 0000000..450ee1f
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
+			clocks = <&clkc 0>;
+			clock-names = "can_clk","s_axi_aclk" ;
+			reg = <0x40000000 0x10000>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 59 1>;
+			tx-fifo-depth = <0x40>;
+			rx-fifo-depth = <0x40>;
+		};
-- 
1.7.4


