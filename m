Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaIIJ36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:29:58 -0400
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:3046
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932301AbaIIJ34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:29:56 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 2/3] ARM: dts: imx6qdl: add baud clock and clock-names for ssi
Date: Tue, 9 Sep 2014 17:13:26 +0800
Message-ID: <821d01a503925fb52fbc17c3ff1a4f5426a9cd1d.1410253534.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1410253534.git.shengjiu.wang@freescale.com>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(199003)(189002)(92566001)(74662001)(31966008)(74502001)(19580395003)(93916002)(19580405001)(83322001)(2201001)(92726001)(83072002)(86362001)(85852003)(44976005)(6806004)(68736004)(77156001)(4396001)(50226001)(88136002)(87936001)(81342001)(81542001)(89996001)(21056001)(76482001)(106466001)(107046002)(229853001)(84676001)(97736003)(80022001)(104016003)(62966002)(46102001)(47776003)(20776003)(85306004)(64706001)(33646002)(36756003)(48376002)(50466002)(26826002)(102836001)(118296001)(90102001)(77982001)(87286001)(79102001)(105606002)(99396002)(76176999)(95666004)(50986999)(104166001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/arm/boot/dts/imx6qdl.dtsi |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 70d7207..0de8806 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -280,7 +280,9 @@
 							"fsl,imx51-ssi";
 					reg = <0x02028000 0x4000>;
 					interrupts = <0 46 IRQ_TYPE_LEVEL_HIGH>;
-					clocks = <&clks IMX6QDL_CLK_SSI1_IPG>;
+					clocks = <&clks IMX6QDL_CLK_SSI1_IPG>,
+						 <&clks IMX6QDL_CLK_SSI1>;
+					clock-names = "ipg", "baud";
 					dmas = <&sdma 37 1 0>,
 					       <&sdma 38 1 0>;
 					dma-names = "rx", "tx";
@@ -294,7 +296,9 @@
 							"fsl,imx51-ssi";
 					reg = <0x0202c000 0x4000>;
 					interrupts = <0 47 IRQ_TYPE_LEVEL_HIGH>;
-					clocks = <&clks IMX6QDL_CLK_SSI2_IPG>;
+					clocks = <&clks IMX6QDL_CLK_SSI2_IPG>,
+						 <&clks IMX6QDL_CLK_SSI2>;
+					clock-names = "ipg", "baud";
 					dmas = <&sdma 41 1 0>,
 					       <&sdma 42 1 0>;
 					dma-names = "rx", "tx";
@@ -308,7 +312,9 @@
 							"fsl,imx51-ssi";
 					reg = <0x02030000 0x4000>;
 					interrupts = <0 48 IRQ_TYPE_LEVEL_HIGH>;
-					clocks = <&clks IMX6QDL_CLK_SSI3_IPG>;
+					clocks = <&clks IMX6QDL_CLK_SSI3_IPG>,
+						 <&clks IMX6QDL_CLK_SSI3>;
+					clock-names = "ipg", "baud";
 					dmas = <&sdma 45 1 0>,
 					       <&sdma 46 1 0>;
 					dma-names = "rx", "tx";
-- 
1.7.9.5

