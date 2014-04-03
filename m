Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162476AbaDCHfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:35:47 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:26663
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162401AbaDCHfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:35:44 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <michals@xilinx.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: [PATCH v2 1/2] usb: doc: udc-xilinx: Add devicetree bindings
Date: Thu, 3 Apr 2014 13:05:18 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <5a9b0116-246c-40a0-b894-3321c74648de@CH1EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree bindings for Xilinx axi udc driver.

Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
---
Changes for v2:
	- replaced xlnx,include-dma with xlnx,has-builtin-dma

 .../devicetree/bindings/usb/udc-xilinx.txt         |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.txt

diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
new file mode 100644
index 0000000..7c24fac
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
@@ -0,0 +1,20 @@
+Xilinx AXI USB2 device controller
+
+Required properties:
+- compatible		: Should be "xlnx,axi-usb2-device-4.00.a"
+- reg			: Physical base address and size of the Axi USB2
+			  device registers map.
+- interrupts		: Property with a value describing the interrupt
+			  number.
+- interrupt-parent	: Must be core interrupt controller
+- xlnx,has-builtin-dma	: if DMA is included
+
+Example:
+ 		axi-usb2-device@42e00000 {
+                        compatible = "xlnx,axi-usb2-device-4.00.a";
+                        interrupt-parent = <0x1>;
+                        interrupts = <0x0 0x39 0x1>;
+                        reg = <0x42e00000 0x10000>;
+                        xlnx,has-builtin-dma;
+                };
+
-- 
1.7.4


