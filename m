Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaF0D4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:56:50 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:13364
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751733AbaF0D4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:56:47 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <Peter.Chen@freescale.com>,
        <gregkh@linuxfoundation.org>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kpc528@gmail.com>,
        <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH 1/2] usb: chipidea: zynq: Add device tree binding information
Date: Fri, 27 Jun 2014 09:10:08 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <e6fe1dae-c6ce-41d7-a7ee-3e4f12625564@BN1BFFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(79102001)(81342001)(77096002)(31966008)(64706001)(99396002)(77156001)(81542001)(104166001)(50466002)(80022001)(95666004)(70736001)(104016002)(20776003)(106466001)(77982001)(74502001)(53416004)(76482001)(47776003)(89996001)(33646001)(87286001)(31696002)(85852003)(50986999)(92726001)(2201001)(92566001)(83072002)(19580405001)(19580395003)(88136002)(83322001)(6806004)(102836001)(87936001)(21056001)(85306003)(74316001)(44976005)(50226001)(1496007)(48376002)(86362001)(46102001)(93916002)(4396001)(74662001)(62966002)(107046002)(107986001)(2101003)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB039;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
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

Document device tree binding information as required by
the ZYNQ USB controller.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
 .../devicetree/bindings/usb/ci-hdrc-zynq.txt       |   23 ++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt
new file mode 100644
index 0000000..54bb3b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-zynq.txt
@@ -0,0 +1,23 @@
+Xilinx Zynq usb controller based on synopsys usb IP(v2.20a)
+
+Required properties:
+- compatible:   should contain "xlnx,zynq-usb-2.20a"
+- clocks:       clock provider specifier
+- reg:          offset and length of the register set in the memory map
+- interrupt-parent: the phandle for the interrupt controller that services
+                    interrupts for this device.
+- interrupts:   interrupt-specifier for the controller interrupt.
+- phy_type:     should be "ulpi"
+- dr_mode:      should be "peripheral" or "host"
+
+Examples:
+
+	usb@e0002000 {
+		clocks = <&clkc 28>;
+		compatible = "xlnx,zynq-usb-2.20a";
+		dr_mode = "host";
+		interrupt-parent = <&ps7_scugic_0>;
+		interrupts = <0 21 4>;
+		phy_type = "ulpi";
+		reg = <0xe0002000 0x1000>;
+	} ;
-- 
1.7.4


