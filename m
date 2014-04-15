Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072AbaDOXZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:25:15 -0400
Received: from [157.56.111.141] ([157.56.111.141]:18614 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750866AbaDOXZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:25:10 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>
CC: <tthayer.linux@gmail.com>, Thor Thayer <tthayer@altera.com>,
        "Borislav Petkov" <bp@alien8.de>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM controller
Date: Tue, 15 Apr 2014 18:30:08 -0500
Message-ID: <1397604610-20931-3-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397604610-20931-1-git-send-email-tthayer@altera.com>
References: <1397604610-20931-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(4396001)(46102001)(50466002)(76176999)(50226001)(81342001)(93916002)(86362001)(80022001)(50986999)(80976001)(62966002)(81542001)(97736001)(48376002)(33646001)(99396002)(2009001)(16796002)(74662001)(89996001)(31966008)(74502001)(88136002)(87286001)(87936001)(47776003)(20776003)(79102001)(42186004)(84676001)(36756003)(77982001)(92726001)(19580395003)(6806004)(2201001)(83072002)(86152002)(44976005)(92566001)(19580405001)(83322001)(76482001)(85852003)(77156001)(921003)(1121002)(2101003)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB036;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E271C4ED.A8D8A429.CEE3BF37.48D2EA38.202A0;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0182DBBB05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM controller bindings and device
tree changes to the Altera SoC project.

---
v2: Update the mailing list to include the EDAC mailing list.

Signed-off-by: Thor Thayer <tthayer@altera.com>
To: Rob Herring <robherring2@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>
To: Kumar Gala <galak@codeaurora.org>
To: Rob Landley <rob@landley.net>
To: Russell King <linux@arm.linux.org.uk>
To: Dinh Nguyen <dinguyen@altera.com>
To: Doug Thompson <dougthompson@xmission.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
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

