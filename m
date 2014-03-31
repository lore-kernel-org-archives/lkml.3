Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaCaWSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:18:30 -0400
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:57724
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbaCaWS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:18:27 -0400
X-Greylist: delayed 893 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Mar 2014 18:18:27 EDT
From: <tthayer@altera.com>
To: <dinguyen@altera.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>
CC: Thor Thayer <tthayer@altera.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/2] dts: socfpga: Add bindings for Altera SoC SDRAM controller
Date: Mon, 31 Mar 2014 17:07:06 -0500
Message-ID: <1396303627-29198-2-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396303627-29198-1-git-send-email-tthayer@altera.com>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(189002)(199002)(47736001)(86362001)(4?=
 =?us-ascii?Q?9866001)(88136002)(80022001)(48376002)(85306002)(65816001)(8?=
 =?us-ascii?Q?1542001)(90146001)(89996001)(92726001)(33646001)(98676001)(4?=
 =?us-ascii?Q?396001)(97186001)(97336001)(74366001)(95666003)(93916002)(93?=
 =?us-ascii?Q?516002)(47976001)(50226001)(69226001)(87286001)(87266001)(50?=
 =?us-ascii?Q?466002)(93136001)(92566001)(74662001)(16796002)(50986001)(22?=
 =?us-ascii?Q?01001)(74876001)(84676001)(36756003)(81686001)(94946001)(771?=
 =?us-ascii?Q?56001)(54316002)(97736001)(76786001)(31966008)(81342001)(538?=
 =?us-ascii?Q?06001)(77982001)(76796001)(42186004)(83072002)(19580405001)(?=
 =?us-ascii?Q?85852003)(86152002)(81816001)(51856001)(76482001)(56776001)(?=
 =?us-ascii?Q?63696002)(74706001)(77096001)(83322001)(87936001)(95416001)(?=
 =?us-ascii?Q?62966002)(47446002)(56816005)(74502001)(44976005)(80976001)(?=
 =?us-ascii?Q?19580395003)(6806004)(46102001)(2009001)(20776003)(59766001)?=
 =?us-ascii?Q?(47776003)(94316002)(79102001);DIR:OUT;SFP:1102;SCL:1;SRVR:B?=
 =?us-ascii?Q?L2FFO11HUB012;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E3B?=
 =?us-ascii?Q?6C42E.ACF0A425.CED1BFB7.5CD6CAB1.2025E;MLV:sfv;PTR:InfoDomai?=
 =?us-ascii?Q?nNonexistent;MX:1;A:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0167DB5752
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM controller bindings and device
tree changes to the Altera SoC project.

Signed-off-by: Thor Thayer <tthayer@altera.com>
To: Rob Herring <rob.herring@calxeda.com>
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
index 0000000..351ab7b
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
@@ -0,0 +1,14 @@
+Altera SOCFPGA SDRAM Controller
+
+Required properties:
+- compatible : "altr,sdr-ctl", "syscon";
+                Note that syscon is invoked for this device to support the FPGA
+		bridge driver and possibly other devices in the future.  See
+		also Documentation/devicetree/bindings/mfd/syscon.txt
+- reg : Should contain 1 register ranges(address and length)
+
+Example:
+	sdrctl@0xffc25000 {
+		compatible = "altr,sdr-ctl", "syscon";
+		reg = <0xffc25000 0x1000>;
+	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 9e78c1d..3634de7 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -528,6 +528,11 @@
 			reg-io-width = <4>;
 		};
 
+		sdrctl@0xffc25000 {
+			compatible = "altr,sdr-ctl", "syscon";
+			reg = <0xffc25000 0x1000>;
+		};
+
 		rstmgr@ffd05000 {
 			compatible = "altr,rst-mgr";
 			reg = <0xffd05000 0x1000>;
-- 
1.7.9.5

