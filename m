Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbbAIDLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:11:01 -0500
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:57312
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752676AbbAIDK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:10:59 -0500
From: <tthayer@opensource.altera.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv6 5/5] arm: dts: Add Altera L2 Cache and OCRAM EDAC entries
Date: Thu, 8 Jan 2015 20:53:56 -0600
Message-ID: <1420772036-3112-6-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420772036-3112-1-git-send-email-tthayer@opensource.altera.com>
References: <1420772036-3112-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0058.namprd05.prod.outlook.com (10.141.20.28) To
 BY2PR0301MB0629.namprd03.prod.outlook.com (25.160.125.27)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tthayer@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04519BA941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(86362001)(48376002)(40100003)(106356001)(50466002)(50986999)(76176999)(101416001)(2950100001)(97736003)(42186005)(50226001)(4396001)(19300405004)(19580395003)(120916001)(19580405001)(105586002)(122386002)(99396003)(33646002)(229853001)(68736005)(31966008)(107046002)(20776003)(15975445007)(64706001)(66066001)(46102003)(77156002)(2201001)(92566001)(89996001)(21056001)(86152002)(62966003)(47776003)(87976001)(921003)(217873001)(562404015)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR0301MB0629;H:localhost.localdomain;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 02:55:18.7076 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

Adding the device tree entries and bindings needed to support
the Altera L2 cache and On-Chip RAM EDAC. This patch relies upon
an earlier patch to declare and setup On-chip RAM properly.
http://www.spinics.net/lists/devicetree/msg51117.html

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
---
v2: Remove OCRAM declaration and reference prior patch.

v3-5: No Change

v6: Change to nested EDAC device nodes based on community
    feedback. Remove L2 syscon. Use consolidated binding.
---
 .../bindings/arm/altera/socfpga-edac.txt           |   46 ++++++++++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |   20 +++++++++
 2 files changed, 66 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-edac.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-edac.txt
new file mode 100644
index 0000000..4bf32e1
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-edac.txt
@@ -0,0 +1,46 @@
+Altera SoCFPGA Error Detection and Correction [EDAC]
+
+Required Properties:
+- compatible : Should be "altr,edac"
+- #address-cells: must be 1
+- #size-cells: must be 1
+- ranges : standard definition, should translate from local addresses
+
+Subcomponents:
+
+L2 Cache ECC
+Required Properties:
+- compatible : Should be "altr,l2-edac"
+- reg : Address and size for ECC error interrupt clear registers.
+- interrupts : Should be single bit error interrupt, then double bit error
+	interrupt. Note the rising edge type.
+
+On Chip RAM ECC
+Required Properties:
+- compatible : Should be "altr,ocram-edac"
+- reg : Address and size for ECC error interrupt clear registers.
+- iram : phandle to On-Chip RAM definition.
+- interrupts : Should be single bit error interrupt, then double bit error
+	interrupt. Note the rising edge type.
+
+Example:
+
+	soc_ecc {
+		compatible = "altr,edac";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		l2edac@ffd08140 {
+			compatible = "altr,l2-edac";
+			reg = <0xffd08140 0x4>;
+			interrupts = <0 36 1>, <0 37 1>;
+		};
+
+		ocramedac@ffd08144 {
+			compatible = "altr,ocram-edac";
+			reg = <0xffd08144 0x4>;
+			iram = <&ocram>;
+			interrupts = <0 178 1>, <0 179 1>;
+		};
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 252c3d1..e546e47 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -618,6 +618,26 @@
 			interrupts = <0 39 4>;
 		};
 
+		soc_ecc {
+			compatible = "altr,edac";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			l2edac@ffd08140 {
+				compatible = "altr,l2-edac";
+				reg = <0xffd08140 0x4>;
+				interrupts = <0 36 1>, <0 37 1>;
+			};
+
+			ocramedac@ffd08144 {
+				compatible = "altr,ocram-edac";
+				reg = <0xffd08144 0x4>;
+				iram = <&ocram>;
+				interrupts = <0 178 1>, <0 179 1>;
+			};
+		};
+
 		L2: l2-cache@fffef000 {
 			compatible = "arm,pl310-cache";
 			reg = <0xfffef000 0x1000>;
-- 
1.7.9.5

