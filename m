Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaBSGoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:44:30 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:52901
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbaBSGo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:44:28 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux-arm-kernel@lists.infradead.org>, <shawn.guo@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 3/4] ARM: dts: Enable SGTL5000 codec based audio driver node for VF610 TOWER.
Date: Wed, 19 Feb 2014 13:38:42 +0800
Message-ID: <1392788323-6092-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392788323-6092-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392788323-6092-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds and enables SGTL5000 codec support.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/vf610-twr.dts | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 8217854..29790c9 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -34,6 +34,17 @@
 		};
 	};
 
+	regulators {
+		compatible = "simple-bus";
+
+		reg_3p3v: 3p3v {
+			compatible = "regulator-fixed";
+			regulator-name = "3P3V";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+	};
 };
 
 &dspi0 {
@@ -72,6 +83,14 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c0>;
 	status = "okay";
+
+	codec: sgtl5000@0a {
+	       compatible = "fsl,sgtl5000";
+	       reg = <0x0a>;
+	       VDDA-supply = <&reg_3p3v>;
+	       VDDIO-supply = <&reg_3p3v>;
+	       clocks = <&clks VF610_CLK_SAI2>;
+       };
 };
 
 &iomuxc {
-- 
1.8.4


