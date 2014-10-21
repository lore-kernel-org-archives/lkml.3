Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaJUCMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:12:02 -0400
Received: from mail-bl2on0137.outbound.protection.outlook.com ([65.55.169.137]:48743
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbaJUCMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:12:00 -0400
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <andriy.shevchenko@linux.intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <b38343@freescale.com>
Subject: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on i.mx6dl
Date: Tue, 21 Oct 2014 09:06:14 +0800
Message-ID: <1413853584-18325-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(99396003)(84676001)(87286001)(50226001)(95666004)(50466002)(85852003)(89996001)(106466001)(20776003)(229853001)(47776003)(64706001)(107046002)(76482002)(77156001)(120916001)(105606002)(36756003)(4396001)(97736003)(104016003)(31966008)(50986999)(6806004)(68736004)(102836001)(2201001)(44976005)(92566001)(19580405001)(85306004)(92726001)(93916002)(87936001)(19580395003)(33646002)(104166001)(62966002)(48376002)(80022003)(88136002)(26826002)(21056001)(46102003)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB034;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB034;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
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

