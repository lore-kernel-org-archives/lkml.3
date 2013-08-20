Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3HTIjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:39:08 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:23443
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab3HTIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:39:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <kernel@pengutronix.de>
CC: <gregkh@linuxfoundation.org>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 2/3] ARM: dts: imx6q/imx6dl: add necessary clocks for ldb node
Date: Tue, 20 Aug 2013 16:38:51 +0800
Message-ID: <1376987932-5540-3-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds di[0/1]_div_3_5, di[0/1]_div_7 and di[0/1]_div_sel
clocks to the ldb nodes so that the ldb driver may use them to
setup the display clock trees.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 arch/arm/boot/dts/imx6dl.dtsi |    8 ++++++--
 arch/arm/boot/dts/imx6q.dtsi  |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index 9e8ae11..ff0d743 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -75,10 +75,14 @@
 &ldb {
 	clocks = <&clks 33>, <&clks 34>,
 		 <&clks 39>, <&clks 40>,
-		 <&clks 135>, <&clks 136>;
+		 <&clks 135>, <&clks 136>,
+		 <&clks 184>, <&clks 185>, <&clks 203>, <&clks 204>,
+		 <&clks 205>, <&clks 206>;
 	clock-names = "di0_pll", "di1_pll",
 		      "di0_sel", "di1_sel",
-		      "di0", "di1";
+		      "di0", "di1",
+		      "di0_div_3_5", "di1_div_3_5", "di0_div_7", "di1_div_7",
+		      "di0_div_sel", "di1_div_sel";
 
 	lvds-channel@0 {
 		crtcs = <&ipu1 0>, <&ipu1 1>;
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index f024ef2..b078a42 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -146,10 +146,14 @@
 &ldb {
 	clocks = <&clks 33>, <&clks 34>,
 		 <&clks 39>, <&clks 40>, <&clks 41>, <&clks 42>,
-		 <&clks 135>, <&clks 136>;
+		 <&clks 135>, <&clks 136>,
+		 <&clks 184>, <&clks 185>, <&clks 203>, <&clks 204>,
+		 <&clks 205>, <&clks 206>;
 	clock-names = "di0_pll", "di1_pll",
 		      "di0_sel", "di1_sel", "di2_sel", "di3_sel",
-		      "di0", "di1";
+		      "di0", "di1",
+		      "di0_div_3_5", "di1_div_3_5", "di0_div_7", "di1_div_7",
+		      "di0_div_sel", "di1_div_sel";
 
 	lvds-channel@0 {
 		crtcs = <&ipu1 0>, <&ipu1 1>, <&ipu2 0>, <&ipu2 1>;
-- 
1.7.9.5


