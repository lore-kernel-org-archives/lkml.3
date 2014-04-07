Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaDGWDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:03:44 -0400
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:63679
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755316AbaDGWDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:03:42 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <dinguyen@altera.com>
CC: Thor Thayer <tthayer@altera.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM controller
Date: Mon, 7 Apr 2014 16:54:07 -0500
Message-ID: <1396907649-20212-2-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396907649-20212-1-git-send-email-tthayer@altera.com>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(199002)(189002)(47776003)(2009001)(47?=
 =?us-ascii?Q?446002)(46102001)(99396002)(97336001)(85306002)(33646001)(83?=
 =?us-ascii?Q?322001)(56776001)(87936001)(81342001)(81542001)(74876001)(48?=
 =?us-ascii?Q?376002)(20776003)(93916002)(44976005)(93136001)(87286001)(74?=
 =?us-ascii?Q?366001)(6806004)(93516002)(59766001)(65816001)(98676001)(195?=
 =?us-ascii?Q?80405001)(76482001)(88136002)(19580395003)(83072002)(7709600?=
 =?us-ascii?Q?1)(50986001)(90146001)(97736001)(97186001)(89996001)(7466200?=
 =?us-ascii?Q?1)(92726001)(84676001)(87266001)(2201001)(80022001)(50226001?=
 =?us-ascii?Q?)(31966008)(47736001)(95416001)(4396001)(94316002)(16796002)?=
 =?us-ascii?Q?(92566001)(54316002)(49866001)(69226001)(62966002)(63696002)?=
 =?us-ascii?Q?(76786001)(86152002)(94946001)(81686001)(47976001)(42186004)?=
 =?us-ascii?Q?(85852003)(74706001)(80976001)(50466002)(77982001)(53806001)?=
 =?us-ascii?Q?(77156001)(56816005)(95666003)(81816001)(86362001)(79102001)?=
 =?us-ascii?Q?(36756003)(76796001)(74502001)(921003)(1121002);DIR:OUT;SFP:?=
 =?us-ascii?Q?1102;SCL:1;SRVR:BN1BFFO11HUB005;H:SJ-ITEXEDGE02.altera.priv.?=
 =?us-ascii?Q?altera.com;FPR:E271C42E.A8D8A429.CED1BF37.48D2EA38.20252;MLV?=
 =?us-ascii?Q?:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0174BD4BDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM controller bindings and device
tree changes to the Altera SoC project.

Signed-off-by: Thor Thayer <tthayer@altera.com>
To: Rob Herring <robherring2@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>
To: Kumar Gala <galak@codeaurora.org>
To: Rob Landley <rob@landley.net>
To: Russell King <linux@arm.linux.org.uk>
To: Dinh Nguyen <dinguyen@altera.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
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

