Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaFYVJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:09:09 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:42393
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756283AbaFYVJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:09:06 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv7 1/3] devicetree: Addition of the Altera SDRAM Controller.
Date: Wed, 25 Jun 2014 16:15:25 -0500
Message-ID: <1403730927-16163-2-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403730927-16163-1-git-send-email-tthayer@altera.com>
References: <1403730927-16163-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(76482001)(86362001)(93916002)(33646001)(104166001)(50986999)(102836001)(95666004)(46102001)(97736001)(87936001)(99396002)(4396001)(85306003)(77096002)(42186005)(2201001)(89996001)(92566001)(85852003)(107046001)(19580395003)(88136002)(105596002)(76176999)(106466001)(44976005)(21056001)(86152002)(83072002)(6806004)(92726001)(84676001)(19580405001)(50226001)(87286001)(79102001)(48376002)(68736004)(50466002)(80022001)(62966002)(16796002)(64706001)(74662001)(83322001)(81342001)(77982001)(81542001)(77156001)(31966008)(47776003)(74502001)(36756003)(20776003)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB010;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Add the Altera SDRAM controller bindings and device tree changes to the Altera SoC project.

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
v2: Changes to SoC SDRAM EDAC code.

v3: Implement code suggestions for SDRAM EDAC code.

v4: Remove syscon from SDRAM controller bindings.

v5: No Change, bump version for consistency.

v6: Only map the ctrlcfg register as syscon.

v7: No change. Bump for consistency.
---
 .../bindings/arm/altera/socfpga-sdram.txt          |   11 +++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
 2 files changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
new file mode 100644
index 0000000..5027026
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
+		reg = <0xffc25000 0x4>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 4676f25..310292e 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -682,6 +682,11 @@
 			clocks = <&l4_sp_clk>;
 		};
 
+		sdrctl@ffc25000 {
+			compatible = "altr,sdr-ctl", "syscon";
+			reg = <0xffc25000 0x4>;
+		};
+
 		rst: rstmgr@ffd05000 {
 			compatible = "altr,rst-mgr";
 			reg = <0xffd05000 0x1000>;
-- 
1.7.9.5

