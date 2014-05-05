Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbaEEWq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:46:56 -0400
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:6016
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757094AbaEEWqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:46:52 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv3 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM controller
Date: Mon, 5 May 2014 17:52:15 -0500
Message-ID: <1399330337-16748-2-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399330337-16748-1-git-send-email-tthayer@altera.com>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(77982001)(19580405001)(81342001)(83322001)(50226001)(50466002)(76482001)(99396002)(87286001)(84676001)(92726001)(2009001)(36756003)(74502001)(76176999)(85852003)(81542001)(89996001)(20776003)(83072002)(79102001)(16796002)(19580395003)(88136002)(86362001)(48376002)(97736001)(50986999)(4396001)(77156001)(62966002)(2201001)(47776003)(80022001)(33646001)(74662001)(86152002)(44976005)(93916002)(92566001)(87936001)(46102001)(6806004)(31966008)(921003)(1121002)(83996005)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB056;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E271E4EE.2BD8A825.CFD49F37.88DEEE38.201F4;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0202D21D2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM controller bindings and device
tree changes to the Altera SoC project. The "syscon" parameter
is included here because the SDRAM EDAC bits are shared with the SDRAM
configuration bits.
---
v2: Changes to SoC SDRAM EDAC code.

V3: Implement code suggestions for SDRAM EDAC code.

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
 .../bindings/arm/altera/socfpga-sdram.txt          |   14 ++++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
 2 files changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
new file mode 100644
index 0000000..525cb76
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
@@ -0,0 +1,14 @@
+Altera SOCFPGA SDRAM Controller
+
+Required properties:
+- compatible : "altr,sdr-ctl", "syscon";
+                Note that syscon is invoked for this device to support the FPGA
+		bridge driver, EDAC driver and other devices that share the
+		registers.
+- reg : Should contain 1 register ranges(address and length)
+
+Example:
+	sdrctl@ffc25000 {
+		compatible = "altr,sdr-ctl", "syscon";
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

