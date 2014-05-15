Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaEOQNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:13:52 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:28413
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbaEOQNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:13:49 -0400
X-Greylist: delayed 886 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 12:13:48 EDT
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv5 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM controller
Date: Thu, 15 May 2014 11:04:49 -0500
Message-ID: <1400169891-29546-2-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400169891-29546-1-git-send-email-tthayer@altera.com>
References: <1400169891-29546-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(81342001)(76482001)(76176999)(2201001)(97736001)(46102001)(83072002)(99396002)(85852003)(87286001)(86152002)(4396001)(50986999)(50466002)(77156001)(50226001)(79102001)(62966002)(86362001)(93916002)(102836001)(83322001)(20776003)(19580405001)(92726001)(48376002)(92566001)(36756003)(77982001)(88136002)(6806004)(80022001)(19580395003)(81542001)(42186004)(44976005)(47776003)(89996001)(33646001)(87936001)(16796002)(74662001)(74502001)(84676001)(31966008)(921003)(1121002)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB021;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM controller bindings and device
tree changes to the Altera SoC project.

v2: Changes to SoC SDRAM EDAC code.

v3: Implement code suggestions for SDRAM EDAC code.

v4: Remove syscon from SDRAM controller bindings.

v5: No Change, bump version for consistency.

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
 .../bindings/arm/altera/socfpga-sdram.txt          |   11 +++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
 2 files changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
new file mode 100644
index 0000000..8f8746b
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
@@ -0,0 +1,11 @@
+Altera SOCFPGA SDRAM Controller
+
+Required properties:
+- compatible : "altr,sdr-ctl";
+- reg : Should contain 1 register ranges(address and length)
+
+Example:
+	sdrctl@ffc25000 {
+		compatible = "altr,sdr-ctl";
+		reg = <0xffc25000 0x1000>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index df43702..6ce912e 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -676,6 +676,11 @@
 			clocks = <&l4_sp_clk>;
 		};
 
+		sdrctl@ffc25000 {
+			compatible = "altr,sdr-ctl", "syscon";
+			reg = <0xffc25000 0x1000>;
+		};
+
 		rstmgr@ffd05000 {
 			compatible = "altr,rst-mgr";
 			reg = <0xffd05000 0x1000>;
-- 
1.7.9.5

