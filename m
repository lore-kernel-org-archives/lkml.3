Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaIJGeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:34:04 -0400
Received: from mail-bl2on0148.outbound.protection.outlook.com ([65.55.169.148]:47424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbaIJGeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:34:01 -0400
From: Robin Gong <b38343@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on i.mx6dl
Date: Wed, 10 Sep 2014 13:30:12 +0800
Message-ID: <1410327012-31185-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(199003)(189002)(48376002)(229853001)(105606002)(20776003)(88136002)(85852003)(83072002)(87936001)(89996001)(107046002)(47776003)(64706001)(87286001)(50226001)(80022001)(50466002)(92566001)(4396001)(76482001)(93916002)(36756003)(46102001)(85306004)(81542001)(31966008)(97736003)(81342001)(106466001)(90102001)(92726001)(21056001)(95666004)(77156001)(83322001)(33646002)(74662001)(74502001)(104016003)(84676001)(62966002)(26826002)(44976005)(19580395003)(19580405001)(99396002)(50986999)(6806004)(104166001)(102836001)(68736004)(79102001)(77982001)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB338;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB338;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one weird data in rxfifo after one full rx/tx transfer
done sometimes. It looks a design issue and hard to workaround
totally, so disable dma functhion here. And will re-enable it
once the root cause found.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 arch/arm/boot/dts/imx6q.dtsi   | 20 ++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi |  8 --------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index e9f3646..8d5d33b 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -291,6 +291,26 @@
 	};
 };
 
+&ecspi1 {
+	dmas = <&sdma 3 7 1>, <&sdma 4 7 2>;
+	dma-names = "rx", "tx";
+};
+
+&ecspi2 {
+	dmas = <&sdma 5 7 1>, <&sdma 6 7 2>;
+	dma-names = "rx", "tx";
+};
+
+&ecspi3 {
+	dmas = <&sdma 7 7 1>, <&sdma 8 7 2>;
+	dma-names = "rx", "tx";
+};
+
+&ecspi4 {
+	dmas = <&sdma 9 7 1>, <&sdma 10 7 2>;
+	dma-names = "rx", "tx";
+};
+
 &mipi_dsi {
 	port@2 {
 		reg = <2>;
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 70d7207..f696546 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -210,8 +210,6 @@
 					clocks = <&clks IMX6QDL_CLK_ECSPI1>,
 						 <&clks IMX6QDL_CLK_ECSPI1>;
 					clock-names = "ipg", "per";
-					dmas = <&sdma 3 7 1>, <&sdma 4 7 2>;
-					dma-names = "rx", "tx";
 					status = "disabled";
 				};
 
@@ -224,8 +222,6 @@
 					clocks = <&clks IMX6QDL_CLK_ECSPI2>,
 						 <&clks IMX6QDL_CLK_ECSPI2>;
 					clock-names = "ipg", "per";
-					dmas = <&sdma 5 7 1>, <&sdma 6 7 2>;
-					dma-names = "rx", "tx";
 					status = "disabled";
 				};
 
@@ -238,8 +234,6 @@
 					clocks = <&clks IMX6QDL_CLK_ECSPI3>,
 						 <&clks IMX6QDL_CLK_ECSPI3>;
 					clock-names = "ipg", "per";
-					dmas = <&sdma 7 7 1>, <&sdma 8 7 2>;
-					dma-names = "rx", "tx";
 					status = "disabled";
 				};
 
@@ -252,8 +246,6 @@
 					clocks = <&clks IMX6QDL_CLK_ECSPI4>,
 						 <&clks IMX6QDL_CLK_ECSPI4>;
 					clock-names = "ipg", "per";
-					dmas = <&sdma 9 7 1>, <&sdma 10 7 2>;
-					dma-names = "rx", "tx";
 					status = "disabled";
 				};
 
-- 
1.9.1

