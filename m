Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbaJ3Pcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:32:39 -0400
Received: from mail-by2on0072.outbound.protection.outlook.com ([207.46.100.72]:19776
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161103AbaJ3Pce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:32:34 -0400
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
Subject: [PATCHv3 5/5] arm: dts: Add Altera L2 Cache and OCRAM EDAC
Date: Thu, 30 Oct 2014 10:32:11 -0500
Message-ID: <1414683131-20786-6-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
References: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR0201CA0002.namprd02.prod.outlook.com (25.160.191.140)
 To BY2PR03MB127.namprd03.prod.outlook.com (10.242.36.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(101416001)(87286001)(88136002)(15202345003)(50226001)(81156004)(19300405004)(50466002)(106356001)(85306004)(40100003)(33646002)(87976001)(95666004)(21056001)(122386002)(77156001)(76482002)(48376002)(4396001)(86362001)(31966008)(120916001)(93916002)(229853001)(107046002)(102836001)(53416004)(86152002)(47776003)(2201001)(92566001)(97736003)(50986999)(19580395003)(62966002)(19580405001)(76176999)(64706001)(89996001)(85852003)(105586002)(69596002)(104166001)(92726001)(66066001)(77096002)(42186005)(46102003)(15975445006)(20776003)(80022003)(1121002)(921003)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB127;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
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

v3: No Change
---
 .../bindings/arm/altera/socfpga-l2-edac.txt        |   15 +++++++++++++++
 .../bindings/arm/altera/socfpga-ocram-edac.txt     |   16 ++++++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |   15 ++++++++++++++-
 3 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
new file mode 100644
index 0000000..35b19e3
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
@@ -0,0 +1,15 @@
+Altera SoCFPGA L2 cache Error Detection and Correction [EDAC]
+
+Required Properties:
+- compatible : Should be "altr,l2-edac"
+- reg : Address and size for ECC error interrupt clear registers.
+- interrupts : Should be single bit error interrupt, then double bit error
+	interrupt. Note the rising edge type.
+
+Example:
+
+	l2edac@ffd08140 {
+		compatible = "altr,l2-edac";
+		reg = <0xffd08140 0x4>;
+		interrupts = <0 36 1>, <0 37 1>;
+	};
diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
new file mode 100644
index 0000000..31ab205
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
@@ -0,0 +1,16 @@
+Altera SoCFPGA On-Chip RAM Error Detection and Correction [EDAC]
+
+OCRAM ECC Required Properties:
+- compatible : Should be "altr,ocram-edac"
+- reg : Address and size for ECC error interrupt clear registers.
+- iram : phandle to On-Chip RAM definition.
+- interrupts : Should be single bit error interrupt, then double bit error
+	interrupt. Note the rising edge type.
+
+Example:
+	ocramedac@ffd08144 {
+		compatible = "altr,ocram-edac";
+		reg = <0xffd08144 0x4>;
+		iram = <&ocram>;
+		interrupts = <0 178 1>, <0 179 1>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 6af96ed..32c63a3 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -618,8 +618,21 @@
 			interrupts = <0 39 4>;
 		};
 
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
+
 		L2: l2-cache@fffef000 {
-			compatible = "arm,pl310-cache";
+			compatible = "arm,pl310-cache", "syscon";
 			reg = <0xfffef000 0x1000>;
 			interrupts = <0 38 0x04>;
 			cache-unified;
-- 
1.7.9.5

