Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaKGQzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:55:54 -0500
Received: from mail-bl2on0092.outbound.protection.outlook.com ([65.55.169.92]:23361
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751459AbaKGQzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:55:51 -0500
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
Subject: [PATCHv4 5/5] arm: dts: Add Altera L2 Cache and OCRAM EDAC
Date: Fri, 7 Nov 2014 10:54:22 -0600
Message-ID: <1415379263-12391-6-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com>
References: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: GRUPR80CA004.lamprd80.prod.outlook.com (10.242.28.14) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB121;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(76176999)(19580405001)(19300405004)(19580395003)(102836001)(40100003)(105586002)(106356001)(21056001)(107046002)(81156004)(77096003)(97736003)(101416001)(33646002)(62966003)(50226001)(4396001)(69596002)(48376002)(86152002)(93916002)(92566001)(77156002)(92726001)(86362001)(104166001)(2201001)(31966008)(20776003)(99396003)(64706001)(53416004)(120916001)(89996001)(42186005)(15975445006)(47776003)(15202345003)(50986999)(229853001)(66066001)(50466002)(88136002)(122386002)(46102003)(87286001)(87976001)(1121002)(921003)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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

v3/4: No Change
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

