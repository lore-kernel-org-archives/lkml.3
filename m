Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaIIJ3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:29:37 -0400
Received: from mail-bl2on0115.outbound.protection.outlook.com ([65.55.169.115]:4401
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753366AbaIIJ3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:29:35 -0400
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 05:29:35 EDT
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 3/3] ARM: dts: imx6sl: add baud clock and clock-names for ssi
Date: Tue, 9 Sep 2014 17:13:27 +0800
Message-ID: <67953db04c71ff8a7530e3457e8937458e1e246c.1410253534.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1410253534.git.shengjiu.wang@freescale.com>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(199003)(189002)(81542001)(50986999)(80022001)(81342001)(85852003)(88136002)(50226001)(2201001)(87936001)(83072002)(92566001)(89996001)(31966008)(86362001)(97736003)(106466001)(92726001)(79102001)(4396001)(104016003)(36756003)(105606002)(62966002)(19580395003)(44976005)(95666004)(87286001)(83322001)(19580405001)(74502001)(74662001)(33646002)(90102001)(76176999)(118296001)(47776003)(107046002)(99396002)(20776003)(6806004)(104166001)(21056001)(77156001)(64706001)(46102001)(93916002)(26826002)(77982001)(76482001)(50466002)(48376002)(84676001)(229853001)(85306004)(68736004)(102836001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB345;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Baud clock is used for bit clock generation in master mode. Ipg clock
is peripheral clock and peripheral access clock.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 arch/arm/boot/dts/imx6sl.dtsi |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index ba67714..dfd83e6 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -231,7 +231,9 @@
 							"fsl,imx51-ssi";
 					reg = <0x02028000 0x4000>;
 					interrupts = <0 46 IRQ_TYPE_LEVEL_HIGH>;
-					clocks = <&clks IMX6SL_CLK_SSI1>;
+					clocks = <&clks IMX6SL_CLK_SSI1_IPG>,
+						 <&clks IMX6SL_CLK_SSI1>;
+					clock-names = "ipg", "baud";
 					dmas = <&sdma 37 1 0>,
 					       <&sdma 38 1 0>;
 					dma-names = "rx", "tx";
@@ -245,7 +247,9 @@
 							"fsl,imx51-ssi";
 					reg = <0x0202c000 0x4000>;
 					interrupts = <0 47 IRQ_TYPE_LEVEL_HIGH>;
-					clocks = <&clks IMX6SL_CLK_SSI2>;
+					clocks = <&clks IMX6SL_CLK_SSI2_IPG>,
+						 <&clks IMX6SL_CLK_SSI2>;
+					clock-names = "ipg", "baud";
 					dmas = <&sdma 41 1 0>,
 					       <&sdma 42 1 0>;
 					dma-names = "rx", "tx";
@@ -259,7 +263,9 @@
 							"fsl,imx51-ssi";
 					reg = <0x02030000 0x4000>;
 					interrupts = <0 48 IRQ_TYPE_LEVEL_HIGH>;
-					clocks = <&clks IMX6SL_CLK_SSI3>;
+					clocks = <&clks IMX6SL_CLK_SSI3_IPG>,
+						 <&clks IMX6SL_CLK_SSI3>;
+					clock-names = "ipg", "baud";
 					dmas = <&sdma 45 1 0>,
 					       <&sdma 46 1 0>;
 					dma-names = "rx", "tx";
-- 
1.7.9.5

