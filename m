Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaEOP7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:59:10 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:41576
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754180AbaEOP7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:59:07 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv5 2/3] dts: socfpga: Add bindings for Altera SoC SDRAM EDAC
Date: Thu, 15 May 2014 11:04:50 -0500
Message-ID: <1400169891-29546-3-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400169891-29546-1-git-send-email-tthayer@altera.com>
References: <1400169891-29546-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(33646001)(83072002)(102836001)(79102001)(77982001)(50986999)(85852003)(50226001)(84676001)(20776003)(42186004)(19580395003)(92566001)(4396001)(46102001)(31966008)(62966002)(6806004)(81542001)(36756003)(77156001)(89996001)(44976005)(83322001)(74662001)(93916002)(86362001)(19580405001)(99396002)(16796002)(76482001)(2201001)(97736001)(47776003)(88136002)(86152002)(80022001)(87936001)(575784001)(76176999)(48376002)(87286001)(92726001)(81342001)(74502001)(50466002)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB057;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM EDAC bindings and device
tree changes to the Altera SoC project.

v2: Changes to SoC EDAC source code.

v3: Fix typo in device tree documentation.

v4,v5: No changes - bump version for consistency.

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   12 ++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
 2 files changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
new file mode 100644
index 0000000..431e98b
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
@@ -0,0 +1,12 @@
+Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
+
+Required properties:
+- compatible : should contain "altr,sdram-edac";
+- interrupts : Should contain the SDRAM ECC IRQ in the
+	appropriate format for the IRQ controller.
+
+Example:
+	sdramedac@0 {
+		compatible = "altr,sdram-edac";
+		interrupts = <0 39 4>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 6ce912e..a0ea69b 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -681,6 +681,11 @@
 			reg = <0xffc25000 0x1000>;
 		};
 
+		sdramedac@0 {
+			compatible = "altr,sdram-edac";
+			interrupts = <0 39 4>;
+		};
+
 		rstmgr@ffd05000 {
 			compatible = "altr,rst-mgr";
 			reg = <0xffd05000 0x1000>;
-- 
1.7.9.5

