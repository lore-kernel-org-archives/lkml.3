Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaJWX6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:58:25 -0400
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:28667
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754384AbaJWX6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:58:22 -0400
From: <atull@opensource.altera.com>
To: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <mgerlach@opensource.altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Date: Thu, 23 Oct 2014 18:51:06 -0500
Message-ID: <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DB4PR04CA0024.eurprd04.prod.outlook.com (25.160.41.34) To
 BL2PR03MB306.namprd03.prod.outlook.com (10.141.68.14)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB306;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(66066001)(86152002)(92566001)(92726001)(2201001)(33646002)(48376002)(21056001)(50986999)(86362001)(50466002)(93916002)(47776003)(20776003)(105586002)(95666004)(50226001)(4396001)(85306004)(42186005)(53416004)(106356001)(80022003)(229853001)(77096002)(46102003)(81156004)(107046002)(69596002)(85852003)(122386002)(19580405001)(19580395003)(40100003)(89996001)(87976001)(88136002)(87286001)(76482002)(104166001)(99396003)(120916001)(101416001)(102836001)(31966008)(76176999)(77156001)(62966002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB306;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add DTS binding documentation for the Altera FPGA bridges.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 .../bindings/fpga/altera-fpga2sdram-bridge.txt     |   57 ++++++++++++++++++++
 .../bindings/fpga/altera-hps2fpga-bridge.txt       |   53 ++++++++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/fpga/altera-fpga2sdram-bridge.txt
 create mode 100644 Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt

diff --git a/Documentation/devicetree/bindings/fpga/altera-fpga2sdram-bridge.txt b/Documentation/devicetree/bindings/fpga/altera-fpga2sdram-bridge.txt
new file mode 100644
index 0000000..cc8f522
--- /dev/null
+++ b/Documentation/devicetree/bindings/fpga/altera-fpga2sdram-bridge.txt
@@ -0,0 +1,57 @@
+Altera FPGA To SDRAM Bridge Driver
+
+This driver manages a bridge between an FPGA and the SDRAM used by an host
+processor system (HPS). The bridge contains a number read ports, write ports,
+and command ports.  Reconfiguring these ports requires that no SDRAM
+transactions occur during reconfiguration.  In other words, the code
+reconfiguring the ports cannot be run out of SDRAM nor can the FPGA access the
+SDRAM during the reconfiguration.  This driver does not support reconfiguring
+the ports.  Typcially, the ports are configured by code running out of onchip
+ram before Linux is started.
+
+This driver supports enabling and disabling of the configured ports all at
+once, which allows for safe reprogramming of the FPGA from user space, provided
+the new FPGA image uses the same port configuration. User space can enable or
+disable the bridge by writing a "1" or a "0", respectively, to its enable file
+under bridge's entry in /sys/class/fpga-bridge. Typically, one disables the
+bridges before reprogramming the FPGA.  Once the FPGA is reprogrammed, the
+bridges are reenabled.
+
+Required properties:
+
+ - compatible       : "altr,socfpga-fpga2sdram-bridge"
+
+ - read-ports-mask  : Bits 0 to 3 corresponds read ports 0 to 3. A bit set to 1
+                      indicates the corresponding read port should be enabled.
+
+ - write-ports-mask : Bits 0 to 3 corresponds write ports 0 to 3. A bit set
+                      to 1 indicates the corresponding write port should be
+                      enabled.
+
+ - cmd-ports-mask   : Bits 0 to 5 correspond to command ports 0 to 5. A bit set
+                      to 1 indicates the corresponding command port should be
+                      enabled.
+
+ - altr,sdr-syscon  : phandle of the sdr module
+
+Optional properties:
+
+ - label            : name that you want this bridge to show up as under
+                      /sys/class/fpga-bridge. Default is br<device#> if this is
+                      not specified.
+
+ - init-val         : 0 if driver should disable bridge at startup
+                      1 if driver should enable bridge at startup
+                      driver leaves bridge in current state if property not
+		      specified.
+
+Example:
+	fpga2sdram_br: fpgabridge@3 {
+		compatible = "altr,socfpga-fpga2sdram-bridge";
+		label = "fpga2sdram";
+		altr,sdr-syscon = <&sdr>;
+		read-ports-mask = <3>;
+		write-ports-mask = <3>;
+		cmd-ports-mask = <0xd>;
+		init-val = <0>;
+	};
diff --git a/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
new file mode 100644
index 0000000..bc24a2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
@@ -0,0 +1,53 @@
+Altera FPGA/HPS Bridge Driver
+
+This driver manages a bridge between a FPGA and a host processor system (HPS).
+User space can enable or disable the bridge by writing a "1" or a "0",
+respectively, to its enable file under bridge's entry in
+/sys/class/fpga-bridge.  Typically, one disables the bridges before
+reprogramming the FPGA.  Once the FPGA is reprogrammed, the bridges are
+reenabled.
+
+Required properties:
+
+ - compatible     : should contain one of:
+                     "altr,socfpga-hps2fpga-bridge"
+                     "altr,socfpga-lwhps2fpga-bridge"
+                     "altr,socfpga-fpga2hps-bridge"
+
+ - clocks         : clocks used by this module
+
+ - altr,l3-syscon : phandle of the l3 interconnect module
+
+Optional properties:
+ - label          : name that you want this bridge to show up as under
+                    /sys/class/fpga-bridge.  Default is br<device#> if this is
+                    not specified.
+
+ - init-val       : 0 if driver should disable bridge at startup
+                    1 if driver should enable bridge at startup
+                    driver leaves bridge in current state if property not
+                    specified.
+
+Example:
+	hps_fpgabridge0: fpgabridge@0 {
+		compatible = "altr,socfpga-hps2fpga-bridge";
+		label = "hps2fpga";
+		altr,l3-syscon = <&l3regs>;
+		clocks = <&l4_main_clk>;
+		init-val = <1>;
+	};
+
+	hps_fpgabridge1: fpgabridge@1 {
+		compatible = "altr,socfpga-lwhps2fpga-bridge";
+		label = "lwhps2fpga";
+		altr,l3-syscon = <&l3regs>;
+		clocks = <&l4_main_clk>;
+		init-val = <0>;
+	};
+
+	hps_fpgabridge2: fpgabridge@2 {
+		compatible = "altr,socfpga-fpga2hps-bridge";
+		label = "fpga2hps";
+		altr,l3-syscon = <&l3regs>;
+		clocks = <&l4_main_clk>;
+	};
-- 
1.7.9.5

