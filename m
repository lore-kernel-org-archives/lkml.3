Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaFYVJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:09:03 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:11615
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755443AbaFYVJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:09:00 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv7 2/3] devicetree: Addition of the Altera SDRAM EDAC. 
Date: Wed, 25 Jun 2014 16:15:26 -0500
Message-ID: <1403730927-16163-3-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403730927-16163-1-git-send-email-tthayer@altera.com>
References: <1403730927-16163-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(85306003)(87936001)(21056001)(50226001)(6806004)(33646001)(48376002)(81542001)(76482001)(62966002)(4396001)(77982001)(36756003)(46102001)(81342001)(16796002)(102836001)(68736004)(19580405001)(93916002)(99396002)(105596002)(87286001)(77096002)(19580395003)(83322001)(86362001)(83072002)(88136002)(76176999)(89996001)(85852003)(2201001)(50986999)(97736001)(86152002)(95666004)(92566001)(77156001)(84676001)(47776003)(42186005)(74502001)(20776003)(79102001)(92726001)(74662001)(31966008)(64706001)(104166001)(106466001)(80022001)(50466002)(107046001)(44976005)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB026;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
v2: Changes to SoC EDAC source code.

v3: Fix typo in device tree documentation.

v4,v5: No changes - bump version for consistency.

v6: Assign ECC registers in SDRAM controller to EDAC

v7: Fix SDRAM EDAC base address.
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

