Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3ETJGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:06:41 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:56019
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731Ab3ETJGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:06:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <grant.likely@linaro.org>
CC: <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 6/6] ARM: dts: imx6qdl: enable the WEIM NOR
Date: Mon, 20 May 2013 16:49:02 +0800
Message-ID: <1369039742-10893-7-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369039742-10893-1-git-send-email-b32955@freescale.com>
References: <1369039742-10893-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the WEIM NOR for imx6q{dl} boards.

For the pin conflict with SPI NOR, its status is set to "disabled".

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index eb293f5..9ce7c1d 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -58,3 +58,24 @@
 	wp-gpios = <&gpio1 13 0>;
 	status = "okay";
 };
+
+&weim {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_weim_nor_1>;
+	#address-cells = <2>;
+	#size-cells = <1>;
+	ranges = <0 0 0x08000000 0x08000000>;
+	status = "disabled"; /* pin conflict with SPI NOR */
+
+	nor@0,0 {
+		compatible = "cfi-flash";
+		reg = <0 0 0x02000000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		bank-width = <2>;
+
+		weim-cs-index = <0>;
+		weim-cs-timing = <0x00620081 0x00000001 0x1C022000
+				0x0000C000 0x1404a38e 0x00000000>;
+	};
+};
-- 
1.7.1


