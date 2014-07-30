Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaG3SRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:17:34 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:38486
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755410AbaG3SQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:16:53 -0400
From: <tthayer@opensource.altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <atull@altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv9 3/3] arm: dts: Add Altera SDRAM controller bindings
Date: Wed, 30 Jul 2014 13:22:53 -0500
Message-ID: <1406744573-609-4-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0028.namprd02.prod.outlook.com (10.141.56.28) To
 BN1PR03MB123.namprd03.prod.outlook.com (10.255.201.27)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0288CD37D9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199002)(189002)(50986999)(76176999)(33646002)(77156001)(21056001)(66066001)(104166001)(99396002)(74662001)(31966008)(92566001)(74502001)(86152002)(77096002)(80022001)(76482001)(83072002)(69596002)(85852003)(48376002)(53416004)(107046002)(87976001)(62966002)(47776003)(83322001)(64706001)(88136002)(20776003)(89996001)(46102001)(79102001)(4396001)(92726001)(87286001)(93916002)(229853001)(2201001)(77982001)(86362001)(42186005)(102836001)(101416001)(19580395003)(95666004)(19580405001)(85306003)(50226001)(81342001)(81156004)(81542001)(50466002)(106356001)(921003)(1121002)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB123;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

Add the Altera SDRAM controller bindings and device tree changes to the Altera SoC project.

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
---
v2: Changes to SoC SDRAM EDAC code.

v3: Implement code suggestions for SDRAM EDAC code.

v4: Remove syscon from SDRAM controller bindings.

v5: No Change, bump version for consistency.

v6: Only map the ctrlcfg register as syscon.

v7: No change. Bump for consistency.

v8: No change. Bump for consistency.

v9: Changes to support a MFD SDRAM controller with nested EDAC.
---
 .../devicetree/bindings/arm/altera/socfpga-sdr.txt |   13 +++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |   10 ++++++++++
 2 files changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
new file mode 100644
index 0000000..2bb1ddf
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
@@ -0,0 +1,13 @@
+Altera SOCFPGA SDRAM Controller
+The SDRAM controller is implemented as a MFD so various drivers may
+nest under this main SDRAM controller binding.
+
+Required properties:
+- compatible : "altr,sdr";
+- reg : Should contain 1 register range(address and length)
+
+Example:
+	sdr@0xffc25000 {
+		compatible = "altr,sdr";
+		reg = <0xffc25000 0x1000>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 4676f25..ecb306d 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -603,6 +603,16 @@
 			};
 		};
 
+		sdr@0xffc25000 {
+			compatible = "altr,sdr";
+			reg = <0xffc25000 0x1000>;
+
+			sdramedac@0 {
+				compatible = "altr,sdram-edac";
+				interrupts = <0 39 4>;
+			};
+		};
+
 		L2: l2-cache@fffef000 {
 			compatible = "arm,pl310-cache";
 			reg = <0xfffef000 0x1000>;
-- 
1.7.9.5

