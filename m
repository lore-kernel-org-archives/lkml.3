Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaF0PUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:20:38 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:43750
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246AbaF0PUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:20:33 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv8 2/3] devicetree: Addition of the Altera SDRAM EDAC. Add the
Date: Fri, 27 Jun 2014 10:26:58 -0500
Message-ID: <1403882819-24929-3-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403882819-24929-1-git-send-email-tthayer@altera.com>
References: <1403882819-24929-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(74502001)(74662001)(31966008)(76482001)(89996001)(68736004)(76176999)(84676001)(50986999)(46102001)(6806004)(33646001)(104166001)(86362001)(79102001)(92726001)(102836001)(92566001)(93916002)(86152002)(2201001)(83072002)(64706001)(47776003)(77156001)(20776003)(44976005)(83322001)(62966002)(107046002)(50466002)(87286001)(105596002)(85852003)(81342001)(99396002)(95666004)(97736001)(21056001)(4396001)(81542001)(85306003)(77096002)(42186005)(19580395003)(106466001)(48376002)(77982001)(19580405001)(36756003)(80022001)(88136002)(87936001)(50226001)(921003)(1121002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB134;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
v2: Changes to SoC EDAC source code.

v3: Fix typo in device tree documentation.

v4,v5: No changes - bump version for consistency.

v6: Assign ECC registers in SDRAM controller to EDAC

v7: Fix SDRAM EDAC base address.

v8: No change. Bump version for consistency.
---
 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |    6 ++++++
 2 files changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
new file mode 100644
index 0000000..d68e033
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
+	sdramedac@ffc2502c {
+		compatible = "altr,sdram-edac";
+		reg = <0xffc2502c 0x28>;
+		interrupts = <0 39 4>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 310292e..da0785d 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -687,6 +687,12 @@
 			reg = <0xffc25000 0x4>;
 		};
 
+		sdramedac@ffc2502c {
+			compatible = "altr,sdram-edac";
+			reg = <0xffc2502c 0x28>;
+			interrupts = <0 39 4>;
+		};
+
 		rst: rstmgr@ffd05000 {
 			compatible = "altr,rst-mgr";
 			reg = <0xffd05000 0x1000>;
-- 
1.7.9.5

