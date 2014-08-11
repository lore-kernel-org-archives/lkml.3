Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaHKPLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:11:54 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:42424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754039AbaHKPLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:11:51 -0400
From: <tthayer@opensource.altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <bp@alien8.de>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings & devicetree entries.
Date: Mon, 11 Aug 2014 10:18:13 -0500
Message-ID: <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA059.namprd06.prod.outlook.com (10.242.160.49) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03008837BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009004)(6009001)(199002)(189002)(106356001)(50986999)(2201001)(89996001)(92726001)(81156004)(42186005)(105586002)(76176999)(77156001)(101416001)(88136002)(85852003)(229853001)(79102001)(81342001)(77096002)(104166001)(50226001)(83072002)(107046002)(4396001)(53416004)(77982001)(575784001)(93916002)(74502001)(47776003)(66066001)(86362001)(76482001)(21056001)(85306004)(69596002)(48376002)(20776003)(95666004)(74662001)(31966008)(102836001)(83322001)(86152002)(80022001)(92566001)(81542001)(19580395003)(19580405001)(46102001)(99396002)(87976001)(87286001)(62966002)(64706001)(50466002)(33646002)(1121002)(921003)(217873001)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.

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

v10: Revert to using syscon based on feedback.
---
 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |   11 +++++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
new file mode 100644
index 0000000..d0ce01d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
@@ -0,0 +1,15 @@
+Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
+The EDAC accesses a range of registers in the SDRAM controller.
+
+Required properties:
+- compatible : should contain "altr,sdram-edac";
+- altr,sdr-syscon : phandle of the sdr module
+- interrupts : Should contain the SDRAM ECC IRQ in the
+	appropriate format for the IRQ controller.
+
+Example:
+	sdramedac {
+		compatible = "altr,sdram-edac";
+		altr,sdr-syscon = <&sdr>;
+		interrupts = <0 39 4>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 4676f25..45b361e 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -603,6 +603,17 @@
 			};
 		};
 
+		sdr: sdr@ffc25000 {
+			compatible = "syscon";
+			reg = <0xffc25000 0x1000>;
+		};
+
+		sdramedac {
+			compatible = "altr,sdram-edac";
+			altr,sdr-syscon = <&sdr>;
+			interrupts = <0 39 4>;
+		};
+
 		L2: l2-cache@fffef000 {
 			compatible = "arm,pl310-cache";
 			reg = <0xfffef000 0x1000>;
-- 
1.7.9.5

