Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3ETJH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:07:56 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:11297
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab3ETJGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:06:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <grant.likely@linaro.org>
CC: <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 2/6] ARM: dts: imx6q{dl}: fix the pin conflict between SPI and WEIM
Date: Mon, 20 May 2013 16:48:58 +0800
Message-ID: <1369039742-10893-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369039742-10893-1-git-send-email-b32955@freescale.com>
References: <1369039742-10893-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the imx6q-sabreauto and imx6dl-sabreauto boards,
the pin MX6Q{DL}_PAD_EIM_D19 is used as a GPIO for SPI NOR, but
it is used as a data pin for the WEIM NOR.

In order to fix the conflict, this patch removes the pin from the hog,
and adds a new pinctrl item: pinctrl_ecspi1_2.

The SPI NOR selects this pinctrl_ecspi1_2 when it is enabled.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 arch/arm/boot/dts/imx6dl-sabreauto.dts   |    9 ++++++++-
 arch/arm/boot/dts/imx6q-sabreauto.dts    |    9 ++++++++-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi |    2 +-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6dl-sabreauto.dts b/arch/arm/boot/dts/imx6dl-sabreauto.dts
index 60f3038..7695f70 100644
--- a/arch/arm/boot/dts/imx6dl-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6dl-sabreauto.dts
@@ -25,7 +25,14 @@
 			fsl,pins = <
 				MX6DL_PAD_NANDF_CS2__GPIO6_IO15 0x80000000
 				MX6DL_PAD_SD2_DAT2__GPIO1_IO13  0x80000000
-				MX6DL_PAD_EIM_D19__GPIO3_IO19 	0x80000000
+			>;
+		};
+	};
+
+	ecspi1 {
+		pinctrl_ecspi1_2: ecspi1grp-2 {
+			fsl,pins = <
+				MX6DL_PAD_EIM_D19__GPIO3_IO19  0x80000000
 			>;
 		};
 	};
diff --git a/arch/arm/boot/dts/imx6q-sabreauto.dts b/arch/arm/boot/dts/imx6q-sabreauto.dts
index 9fb3e99..67a3a6b 100644
--- a/arch/arm/boot/dts/imx6q-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6q-sabreauto.dts
@@ -29,7 +29,14 @@
 			fsl,pins = <
 				MX6Q_PAD_NANDF_CS2__GPIO6_IO15 0x80000000
 				MX6Q_PAD_SD2_DAT2__GPIO1_IO13  0x80000000
-				MX6Q_PAD_EIM_D19__GPIO3_IO19   0x80000000
+			>;
+		};
+	};
+
+	ecspi1 {
+		pinctrl_ecspi1_2: ecspi1grp-2 {
+			fsl,pins = <
+				MX6Q_PAD_EIM_D19__GPIO3_IO19  0x80000000
 			>;
 		};
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index d6baa51..eb293f5 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -20,7 +20,7 @@
 	fsl,spi-num-chipselects = <1>;
 	cs-gpios = <&gpio3 19 0>;
 	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_ecspi1_1>;
+	pinctrl-0 = <&pinctrl_ecspi1_1 &pinctrl_ecspi1_2>;
 	status = "disabled"; /* pin conflict with WEIM NOR */
 
 	flash: m25p80@0 {
-- 
1.7.1


