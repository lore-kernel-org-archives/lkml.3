Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaDGVsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:48:43 -0400
Received: from mail-by2on0120.outbound.protection.outlook.com ([207.46.100.120]:44473
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755138AbaDGVsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:48:41 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <dinguyen@altera.com>
CC: Thor Thayer <tthayer@altera.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/3] dts: socfpga: Add bindings for Altera SoC SDRAM EDAC
Date: Mon, 7 Apr 2014 16:54:08 -0500
Message-ID: <1396907649-20212-3-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396907649-20212-1-git-send-email-tthayer@altera.com>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(199002)(189002)(93916002)(31966008)(9?=
 =?us-ascii?Q?3516002)(74502001)(47976001)(46102001)(47776003)(56816005)(6?=
 =?us-ascii?Q?2966002)(99396002)(63696002)(87266001)(50986001)(83322001)(8?=
 =?us-ascii?Q?1542001)(6806004)(2009001)(59766001)(50466002)(81686001)(813?=
 =?us-ascii?Q?42001)(87286001)(79102001)(69226001)(76796001)(89996001)(567?=
 =?us-ascii?Q?76001)(19580395003)(48376002)(80022001)(76786001)(97186001)(?=
 =?us-ascii?Q?85306002)(94316002)(20776003)(74706001)(77982001)(74366001)(?=
 =?us-ascii?Q?80976001)(77156001)(93136001)(33646001)(2201001)(19580405001?=
 =?us-ascii?Q?)(97736001)(86362001)(95416001)(84676001)(47446002)(77096001?=
 =?us-ascii?Q?)(85852003)(16796002)(74876001)(81816001)(44976005)(92566001?=
 =?us-ascii?Q?)(4396001)(98676001)(97336001)(83072002)(50226001)(53806001)?=
 =?us-ascii?Q?(90146001)(94946001)(88136002)(86152002)(87936001)(42186004)?=
 =?us-ascii?Q?(92726001)(36756003)(65816001)(575784001)(54316002)(49866001?=
 =?us-ascii?Q?)(74662001)(76482001)(95666003)(47736001)(1121002)(921003);D?=
 =?us-ascii?Q?IR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11HUB015;H:SJ-ITEXEDGE02.a?=
 =?us-ascii?Q?ltera.priv.altera.com;FPR:5A82E42E.A8DCA408.76E1BF07.5CD26AF?=
 =?us-ascii?Q?8.2022F;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0174BD4BDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM EDAC bindings and device
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

