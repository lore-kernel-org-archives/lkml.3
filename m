Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaDOX0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:26:14 -0400
Received: from [157.56.111.144] ([157.56.111.144]:46579 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750901AbaDOXZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:25:12 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>
CC: <tthayer.linux@gmail.com>, Thor Thayer <tthayer@altera.com>,
        "Borislav Petkov" <bp@alien8.de>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 2/3] dts: socfpga: Add bindings for Altera SoC SDRAM EDAC
Date: Tue, 15 Apr 2014 18:30:09 -0500
Message-ID: <1397604610-20931-4-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397604610-20931-1-git-send-email-tthayer@altera.com>
References: <1397604610-20931-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(19580395003)(97736001)(79102001)(36756003)(99396002)(84676001)(2009001)(86152002)(77156001)(44976005)(77982001)(89996001)(2201001)(92726001)(81342001)(92566001)(88136002)(85852003)(50226001)(83322001)(19580405001)(81542001)(83072002)(76482001)(4396001)(16796002)(76176999)(48376002)(80022001)(42186004)(33646001)(93916002)(31966008)(74502001)(62966002)(575784001)(6806004)(87936001)(74662001)(80976001)(50466002)(47776003)(86362001)(50986999)(20776003)(87286001)(46102001)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB008;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:5AB2E4ED.A8DCA408.7AE3BF07.5CD26AF8.2027F;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0182DBBB05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM EDAC bindings and device
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
 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   12 ++++++++++++
 arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
 2 files changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt

diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
new file mode 100644
index 0000000..9348c53
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
@@ -0,0 +1,12 @@
+Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
+
+Required properties:
+- compatible : should contain "altr,sdr-edac";
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

