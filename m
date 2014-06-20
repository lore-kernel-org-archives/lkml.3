Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbaFTXQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:16:39 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:57513
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756571AbaFTXQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:16:32 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv6 2/3] devicetree: Addition of the Altera SDRAM EDAC
Date: Fri, 20 Jun 2014 18:22:02 -0500
Message-ID: <1403306523-4174-3-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403306523-4174-2-git-send-email-tthayer@altera.com>
References: <1403306523-4174-2-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(19580405001)(21056001)(19580395003)(31966008)(74662001)(16796002)(74502001)(80022001)(81342001)(50226001)(4396001)(81542001)(46102001)(62966002)(44976005)(6806004)(83322001)(68736004)(87936001)(87286001)(88136002)(104166001)(92726001)(92566001)(86152002)(2201001)(89996001)(85852003)(83072002)(48376002)(84676001)(95666004)(76176999)(50986999)(99396002)(77096002)(86362001)(93916002)(42186005)(50466002)(85306003)(102836001)(105596002)(77982001)(97736001)(76482001)(33646001)(64706001)(36756003)(77156001)(20776003)(47776003)(79102001)(106466001)(921003)(1121002)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB044;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 024847EE92
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM EDAC bindings and device tree changes

v2: Changes to SoC EDAC source code.

v3: Fix typo in device tree documentation.

v4,v5: No changes - bump version for consistency.

v6: Assign ECC registers in SDRAM controller to EDAC

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |    6 ++++++
 2 files changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
new file mode 100644
index 0000000..540c9cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
@@ -0,0 +1,15 @@
+Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
+
+Required properties:
+- compatible : should contain "altr,sdram-edac";
+- reg : should contain the ECC register range in sdram
+        controller (address and length).
+- interrupts : Should contain the SDRAM ECC IRQ in the
+	appropriate format for the IRQ controller.
+
+Example:
+	sdramedac@0 {
+		compatible = "altr,sdram-edac";
+		reg = <0xffc2502C 0x28>;
+		interrupts = <0 39 4>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 310292e..fe9832e 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -687,6 +687,12 @@
 			reg = <0xffc25000 0x4>;
 		};
 
+		sdramedac@0 {
+			compatible = "altr,sdram-edac";
+			reg = <0xffc2502C 0x28>;
+			interrupts = <0 39 4>;
+		};
+
 		rst: rstmgr@ffd05000 {
 			compatible = "altr,rst-mgr";
 			reg = <0xffd05000 0x1000>;
-- 
1.7.9.5

