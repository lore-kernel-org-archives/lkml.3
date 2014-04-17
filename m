Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136AbaDQUAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:00:02 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:41249
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbaDQT6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:58:50 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(z551bizzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdch5ck70kz1de098h8275bh1de097hz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
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
Subject: [PATCH RFC v2 1/4] Devicetree: Add pl353 smc controller devicetree binding information
Date: Fri, 18 Apr 2014 01:28:37 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1397764720-29846-1-git-send-email-punnaia@xilinx.com>
References: <1397764720-29846-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <e22f3e3f-1c7f-456d-a1c8-438121fe8469@AM1EHSMHS012.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
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


